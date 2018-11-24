
import csv
import datetime
from opensubmitexec import exceptions

def validate(job):
	try:
		do_validate(job)
	except exceptions.NestedException as e:
		e = e.real_exception
		job.send_fail_result("The validation of your submission has failed ({}): {}".format(type(e), e))
	except Exception as e:
		job.send_fail_result("The validation of your submission has failed ({}): {}".format(type(e), e))
	except:
		job.send_fail_result("The validation of your submission has failed with an unknown error")

csv_files = ["ec2-cpu.csv", "ec2-disk-random.csv", "ec2-disk-sequential.csv", "ec2-mem.csv",\
	"google-cpu.csv", "google-disk-random.csv", "google-disk-sequential.csv", "google-mem.csv"]
script_files = ["measure-cpu.sh", "measure-mem.sh", "measure-disk-sequential.sh", "measure-disk-random.sh"]
listing_files = ["listing-google.txt", "listing-ec2.txt"]
answers_files = [ "answers.txt" ]
required_files = answers_files + csv_files + script_files + listing_files

assignment_start = datetime.datetime(2018, 11, 12)
assignment_end = datetime.datetime(2018, 11, 29, 23, 59, 59)
expected_values = 48
min_timestamp_diff = datetime.timedelta(0, 60*45) # 45 minutes
max_timestamp_diff = datetime.timedelta(0, 60*75) # 75 minutes

def do_validate(job):
	if not job.ensure_files(required_files):
		job.send_fail_result("Missing one or more of the following required files: {}".format(required_files))
		return
	
	def full_name(name):
		return job.working_dir + name
	
	for name in csv_files:
		validate_csv(job, name, full_name(name))
	for name in script_files:
		validate_script(job, name, full_name(name))
	for name in listing_files:
		validate_listing(job, name, full_name(name))
	for name in answers_files:
		validate_answer(job, name, full_name(name))

def validate_csv(job, name, full_name):
	row_num = 0
	with open(full_name, newline='') as content_file:
		rdr = csv.reader(content_file, delimiter=',')
		previous_date = None
		for row in rdr:
			row_num += 1
			if len(row) != 2:
				job.send_fail_result("Row {} of input file {} contains {} column(s) instead of 2: {}".format(row_num, name, len(row), ",".join(row)))
				return
			if row_num == 1:
				if row[0] != "time" or row[1] != "value":
					job.send_fail_result("Input file {} has invalid CSV header '{}' (need 2 columns: 'time' and 'value')".format(name, ",".join(row)))
					return
			else:
				try:
					unix_time = int(row[0])
					d = datetime.datetime.utcfromtimestamp(unix_time)
					if d < assignment_start or d > assignment_end:
						job.send_fail_result("Row {} of input file {} contains timestamp out of the range of this assignment: {} = {}".format(row_num, name, row[0], d.isoformat(' ')))
						return
					if previous_date is not None:
						if d < previous_date:
							job.send_fail_result("Row {} of input file {} contains timestamp that is not after its predecessor".format(row_num, name))
							return
						diff = d - previous_date
						if diff < min_timestamp_diff:
							job.send_fail_result("Row {} of input file {} contains timestamp that is too close to its predecessor ({})".format(row_num, name, diff))
							return
						if diff > max_timestamp_diff:
							job.send_fail_result("Row {} of input file {} contains timestamp that is too far from its predecessor".format(row_num, name))
							return
					previous_date = d
				except ValueError as e:
					job.send_fail_result("Row {} of input file {} contains invalid unix timestamp '{}': {}".format(row_num, name, row[0], e))
					return
				try:
					value = float(row[1])
					# TODO check value range?
				except ValueError as e:
					job.send_fail_result("Row {} of input file {} contains invalid float value '{}': {}".format(row_num, name, row[1], e))
					return
	if row_num - 1 != expected_values:
		job.send_fail_result("Input file {} contains {} values instead of {}".format(name, row_num - 1, expected_values))
		return

def validate_script(job, name, full_name):
	exit_code, output = job.run_program("bash", [ "-f", full_name ], timeout=20)
	if exit_code != 0:
		job.send_fail_result("Script {} exited with a non-zero exit code ({}). Script output: {}".format(name, exit_code, output))
		return
	lines = output.splitlines()
	if len(lines) == 0:
		job.send_fail_result("Script {} produced no output".format(name))
		return
	line = lines[0].strip()
	try:
		val = float(line)
	except ValueError as e:
		job.send_fail_result("Script {} returned output that could not be parsed as float ({}): {}".format(name, line, e))
		return

def validate_listing(job, name, full_name):
	exit_code, output = job.run_program("file", [ full_name ], timeout=5)
	output = output.strip()
	if not output.endswith("ASCII text"):
		job.send_fail_result("Listing file {} is not a plain-text ASCII file, but: {}".format(name, output))
		return
	with open(full_name, newline='') as listing_file:
		lines = listing_file.read().splitlines()
		for line in lines:
			if line.startswith("#"):
				break
		else:
			job.send_fail_result("Listing file {} does not contain any comment lines (starting with '#').".format(name, output))
			return
	# TODO check for minimum number of lines

def validate_answer(job, name, full_name):
	exit_code, output = job.run_program("file", [ full_name ], timeout=5)
	output = output.strip()
	if not output.endswith("ASCII text"):
		job.send_fail_result("Question answer file {} is not a plain-text ASCII file, but: {}".format(name, output))
		return
	# TODO check for minimum number of lines
