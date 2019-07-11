import sys
import csv

for line in sys.stdin:
    csv_reader = csv.reader([line], quotechar='"', delimiter=',', quoting=csv.QUOTE_ALL, skipinitialspace=True)
    fields = None
    for row in csv_reader:
        fields = row
    print('|'.join(fields))

# import csv

# line = 'value1,"oh look, an embedded comma",value3'
# csv_reader = csv.reader( [ line ] )
# fields = None
# for row in csv_reader:
#     fields = row

# print(fields[1])