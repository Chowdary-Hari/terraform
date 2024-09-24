### 1. **Converting a List to a String (StringList) using `join` function**

The `join` function combines elements of a list into a single string, separating each element by a specified delimiter. In your case, the delimiter is a comma (`,`).

#### Example:
```hcl
locals {
  names = ["hari", "prasad"]
}

output "joined_string" {
  value = join(",", local.names)
}
```

#### Explanation:
- The list `["hari", "prasad"]` is converted into the string `"hari,prasad"`.
- The `join(",", local.names)` will result in the string `hari,prasad`, because the comma separates the elements.

### 2. **Converting a String to a List using `split` function**

The `split` function does the opposite of `join`. It takes a string and a delimiter, and splits the string into a list based on that delimiter.

#### Example:
```hcl
locals {
  subnet_string = "hari,prasad"
}

output "split_list" {
  value = split(",", local.subnet_string)
}
```

#### Explanation:
- The string `"hari,prasad"` is split into the list `["hari", "prasad"]` using the comma as a delimiter.
- The `split(",", local.subnet_string)` will result in a list with two elements: `["hari", "prasad"]`.

### 3. **Using `element` to Get a Specific Element from a List**

The `element` function is used to retrieve a specific element from a list by its index.

#### Example:
```hcl
locals {
  subnet_list = split(",", "hari,prasad")
}

output "first_element" {
  value = element(local.subnet_list, 0)  # Gets the first element (0th index)
}

output "second_element" {
  value = element(local.subnet_list, 1)  # Gets the second element (1st index)
}
```

#### Explanation:
- The string `"hari,prasad"` is split into the list `["hari", "prasad"]`.
- `element(local.subnet_list, 0)` retrieves the element at index `0`, which is `"hari"`.
- `element(local.subnet_list, 1)` retrieves the element at index `1`, which is `"prasad"`.

### 4. **Practical Example: Working with AWS SSM Parameter Values**

In the context of your AWS setup, if you have stored the `private_subnet_id` as a `StringList` in AWS SSM, and you want to retrieve and work with individual elements, here's an example:

#### Writing the List to AWS SSM:
```hcl
resource "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.project}/${var.env}/private_subnet_id"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}
```
Here, you are storing the list of subnet IDs as a comma-separated string in SSM.

#### Retrieving and Using Specific Subnets:
```hcl
data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.project}/${var.env}/private_subnet_id"
}

output "first_subnet" {
  value = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 0)
}

output "second_subnet" {
  value = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 1)
}
```

- **Step 1:** Use `split(",", data.aws_ssm_parameter.private_subnet_id.value)` to convert the comma-separated string back into a list.
- **Step 2:** Use `element()` to extract the specific subnet by its index.

This way, `element(split(",", ...))` is effectively used to retrieve specific subnet IDs from a stored string list in AWS SSM.

### Summary:
- **`join()`** combines list elements into a single string.
- **`split()`** splits a string into a list.
- **`element()`** extracts an item from a list by index.



##### if apply
```shell
for i in 1-vpc/ 02-sg/ 03-bastion/ 04.rds/ 05-apps/ ; do cd $i ; make apply ; cd .. ; done
```
```shell
for i in $(ls -d */ ) ; do echo ${i} ; cd ${i} ; make apply ; cd .. ; done
```

##### if destroy
```shell
for i in 05-apps/ 04.rds/ 03-bastion/ 02-sg/ 01-vpc/ ; do cd $i ; make destroy ; cd .. ; done
```
```shell
for i in $(ls -dr */ ) ; do echo ${i} ; cd ${i} ; make destroy ; cd .. ; done
```