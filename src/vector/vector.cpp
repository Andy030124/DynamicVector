#include "./vector.hpp"

namespace nstd{

const Vector::ptr_t 
Vector::data() const noexcept { return _data; }

Vector::ptr_t 
Vector::data() noexcept {
    return const_cast<ptr_t>(
        const_cast<const Vector*>(this)->data()
    );
}

std::size_t
Vector::size() const noexcept { return _sizeOfContains; }
std::size_t
Vector::capacity() const noexcept { return _Capacity; }

Vector::citer_t
Vector::begin() const noexcept { return _begin; }
Vector::citer_t
Vector::end() const noexcept { return _end; }

Vector::iter_t
Vector::begin() noexcept { return _begin; }
Vector::iter_t
Vector::end() noexcept { return _end; }

}
