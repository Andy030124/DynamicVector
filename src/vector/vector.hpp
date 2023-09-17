#pragma once
#include <memory>
#include <cstdint>
#include <any>
#include <type_traits>
#include <string>

namespace nstd{

struct __Vec_Element_t {

    template<typename T>
    T& set(T&& _val){
        __elmnt = _val; 
        return ( std::any_cast<T>(__elmnt) );
    }

    template<typename T>
    T& set(T const& _val){
        T __val{_val};
        return set(std::move(__val));
    }

    template<typename T>
    T get() const { return std::any_cast<T>(__elmnt); }

    template<typename T>
    bool is() const {
        try{
            this->template get<T>();
            return true;
        }catch(std::bad_any_cast&){
            return false;
        }
    }

    private:
        std::any __elmnt{};
};

struct Vector{
    using data_type = __Vec_Element_t;
    using ptr_t = data_type*;
    using cptr_t = const data_type*;
    using iter_t = data_type*;
    using citer_t = const data_type*;
    using ref_t = data_type&;
    using rval_t = data_type&&;

    explicit Vector() = default;
    explicit Vector(std::size_t initial_capacity)
    : _Capacity(initial_capacity)
    {}

    ~Vector(){ delete[] _data; }

    const ptr_t data() const noexcept;
    ptr_t data() noexcept;

    std::size_t size() const noexcept;
    std::size_t capacity() const noexcept;

    template<typename Types, typename __Callback>
    void foreach(__Callback&& proc){
        for(auto& elmnt: (*this)) {
            if( elmnt.is<std::remove_cvref_t<Types>>() )
                proc(elmnt.get<std::remove_cvref_t<Types>>());
        }
    }

    citer_t begin() const noexcept;
    citer_t end() const noexcept;

    iter_t begin() noexcept;
    iter_t end() noexcept;

    citer_t operator[](std::size_t idx)const{
        if(
            (capacity() < idx) ||
            (size()     < idx)
        ) return nullptr;
        return &_data[idx];
    }

    iter_t operator[](std::size_t idx){
        return (
            const_cast<iter_t>(
                (*const_cast<const Vector*>(this))[idx]
            )
        );
    }


    auto push_back(auto&& _obj){
        if( !haveCapacity() )
        { addSpace( capacity() ); }

        insertElement(std::move(_obj));
        return (_end - 1)->template get<
            std::remove_cvref_t<decltype(_obj)>
        >();
    }

    std::string push_back(const char* _obj){ return push_back(std::string{_obj}); }

    template<typename T, typename... __Args>
    auto emplace_back(__Args&&... argvs)
    { return this->push_back(
            T{std::forward<__Args>(argvs)...}
        );
    }



    private:

        bool haveCapacity(){ return size() < capacity(); }

        void recalculateEnd() { _end = (_begin + _sizeOfContains); }

        void addSpace(std::size_t space2add) {
            _Capacity += space2add;
            
            ptr_t _mem{ new data_type[_Capacity] };
            std::copy(_data, (_data + size()), _mem);
            delete[] _data;

            _data = std::move(_mem);

            _begin = _data;
            recalculateEnd();
        }

        void insertElement(auto&& obj){
            (_data + _sizeOfContains)->set(obj);
            _sizeOfContains += 1;
            recalculateEnd();
        }

        std::size_t _sizeOfContains{0}, _Capacity{1};
        ptr_t _data{ new data_type[_Capacity] };
        iter_t _begin{ _data }, _end{ _begin + _sizeOfContains };
};

}

