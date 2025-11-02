#!/usr/bin/env python3
import json, sys, yaml

def main():
    data = json.load(sys.stdin)

    inventory = {
        "all": {"hosts": {}, "children": {"vms": {"hosts": {}}, "lxcs": {"hosts": {}}}}
    }

    for name, info in data.items():
        value = info["value"]
        hostname = value["ansible_host"]
        res_type = value["type"]

        # Add to "all" group
        inventory["all"]["hosts"][name] = {"ansible_host": hostname}

        # Add to type-based subgroup
        if res_type == "vm":
            inventory["all"]["children"]["vms"]["hosts"][name] = None
        elif res_type == "lxc":
            inventory["all"]["children"]["lxcs"]["hosts"][name] = None

    yaml.dump(inventory, sys.stdout, sort_keys=False)

if __name__ == "__main__":
    main()
