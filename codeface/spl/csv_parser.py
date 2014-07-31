'''
CSV parser support
'''
import csv
import re

def read_data_per_file(path):
  """
  Read CSV file with file-level data.
  """
  data = read_data(path, delimiter=',')
  for line in data:
    line['FILENAME'] = extract_relative_file_path(line)
  return data

def read_data_per_release(path):
  """
  Read CSV file with release-level data.
  """
  data = read_data(path, delimiter=',')[0]
  del data['FILENAME']
  return data

def read_data_per_project(path):
  """
  Read CSV file with project-level data.
  """
  data = read_data(path)
  release = extract_release_from_data(data)

def extract_relative_file_path(line):
  pattern = re.compile('_cppstats/(.*)\.xml$')
  path = line['FILENAME']
  result = pattern.search(path)
  if (result != None and result.group(1) != None):
    return result.group(1)
  else:
    return None

def extract_release_from_data(data):
  item = data[0]
  return extract_release_from_path(item['version'])

def extract_release_from_path(path):
  pattern = re.compile('/([a-zA-Z0-9-.]+)$')
  result = pattern.search(path)
  if (result != None and result.group(1) != None):
    return result.group(1)
  else:
    return None

def lookup_replace_key(pair):
  """
  Lookup a replacement for the column name (key) given in the (key, value) pair.
  Return the pair with replaced key.
  """
  return pair

def read_data(path, delimiter=';'):
  """
  Returns the content of a CSV file as a List of (key, value) pairs.
  """
  with open(path, 'rb') as file:
    reader = csv.reader(file, delimiter=delimiter)
    current_row = 0
    file_content = []
    for row in reader:
      if current_row == 0:
        header = row
      else:
        current_column = 0
        row_content = {}
        for column in row:
          row_content[ header[current_column] ] = column
          current_column += 1
        file_content.append(row_content)
      current_row += 1
  return file_content
