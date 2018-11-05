const a = [1, 2, 3, 4, 5]

// [1, [2, 3, 4, 5]]
// [1, [2, [3, 4, 5]]]
// [1, [2, [3, [4, 5]]]]

    const nestRecursively = (array) => {
        if (Array.isArray(array[1])) {
            return nestRecursively(array[1])
        } else {
            if (array.length <= 2) {
                return
            } else {
                const head = array[0]
                const tail = array.slice(1, array.length)

                array[1] = [...tail]
                array.splice(2)
                return nestRecursively(array)
            }
        }
    }

nestRecursively(a)
console.log(JSON.stringify(a))
