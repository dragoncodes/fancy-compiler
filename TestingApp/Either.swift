struct Either<E, T> {
    let left: E?

    let right: T?

    init(_ left: E?, _ right: T?) {
        self.left = left
        self.right = right
    }

    func fold(_ leftHandler: (E) -> Any?, _ rightHandler: (T?) -> Any) {

        guard let error = left else {
            rightHandler(right)

            return
        }

        leftHandler(error)
    }

    func foldRight<R>(rightHandler: (T?) -> R) -> R? {
        if (left == nil) {
            return rightHandler(right)
        }

        return nil
    }

    func foldLeft<R>(leftHandler: (E?) -> R) -> R? {
        if (left != nil) {
            return leftHandler(left)
        }

        return nil
    }

    static func fromRight(_ right: T?) -> Either<E, T> {
        return Either(nil, right)
    }

    static func fromLeft(_ left: E?) -> Either<E, T> {
        return Either(left, nil)
    }
}
