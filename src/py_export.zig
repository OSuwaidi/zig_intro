// To include the Python header files, you need to provide the Python "include path" in the compilation process via: "$python3-config --includes"
// On my machine it's: "-I/opt/homebrew/opt/python@3.12/Frameworks/Python.framework/Versions/3.12/include/python3.12"

// To link the C library: "$... -lc"

// To link the Python library: "$... -lpython3.12" while specifying the path to the ".dylib" file via: "$... -L path/to/Python/library"
// On my machine it's: "-L/opt/homebrew/opt/python@3.12/Frameworks/Python.framework/Versions/3.12/lib"

const py = @cImport({
    @cInclude("Python.h");
});

export fn binary_search(pylist: *py.PyObject, target: c_int) c_long {
    const length: c_long = py.PyList_Size(pylist); // "PyList_Size()" returns "isize"
    var upper_bound = length;
    var lower_bound: c_long = 0;
    var middle = @divFloor(upper_bound, 2);
    var middle_num: c_long = py.PyLong_AsLong(py.PyList_GetItem(pylist, middle));

    while ((middle_num != target) and (upper_bound != lower_bound) and (lower_bound != length) and (upper_bound != 0)) {
        if (middle_num > target) {
            upper_bound = middle;
        } else {
            lower_bound = middle + 1;
        }

        middle = @divFloor(upper_bound + lower_bound, 2);
        middle_num = py.PyLong_AsLong(py.PyList_GetItem(pylist, middle));
    }

    if (middle_num == target) {
        return middle;
    }
    return -1;
}
