from prettytable import PrettyTable

def display_logs(logs):
    table = PrettyTable()
    table.field_names = ["Timestamp", "Event", "Details"]
    for row in logs:
        table.add_row(row)
    print(table)
