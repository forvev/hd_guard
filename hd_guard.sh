#! /bin/bash

function oddzielenie(){
    echo "------------------------------------------------------------"
}

function powitanie(){
    printf "############################################################
############################################################
######################## HD GUARD ##########################
############################################################
############################################################\n\n"
}

function bubblesort(){ 
    local temp
    local temp1
    for ((i=0; i<"${#tab[@]}"; i++))
    do
        for ((j=1; j<("${#tab[@]}"-$i); j++))
        do
            if [[ tab_size[j-1] -gt tab_size[j] ]]
            then
                temp="${tab[j-1]}"
                temp1="${tab_size[j-1]}"
                tab[j-1]=${tab[j]}
                tab_size[j-1]=${tab_size[j]}
                tab[j]=$temp
                tab_size[j]=$temp1
            fi
        done
    done
}

function dopasowanie_tablicy(){
    oddzielenie
    printf "\nProposed elements to delete/archive:\n" 

    local pom=0
    local pom1=0 #exit from the while loop
    
    while [[ $pom1 == 0 ]]
    do
        for i in "${tab_propozycja[@]}" 
        do
            printf "[$pom] - size: ${tab_propozycja_size[pom]}k,   $i\n"
            let pom++
        done
        pom=0 #next dispaly from 0
        printf "\nIf you want to delete some element, just choose it from the filed [x]. Otherwise put "-1"\n" 
        read wybor
        
        if [[ $wybor -ge 0 ]] && [[ $wybor -lt 10 ]] 
        then
            unset tab[$wybor]
            unset tab_propozycja[$wybor]
            tab=("${tab[@]}")
            tab_propozycja=("${tab_propozycja[@]}")

            unset tab_size[$wybor]
            unset tab_propozycja_size[$wybor]
            tab_size=("${tab_size[@]}")
            tab_propozycja_size=("${tab_propozycja_size[@]}")

            if [[ "${#tab_propozycja[@]}" -eq 0 ]] && [[ "${#tab[@]}" -ne 0 ]] 
            then
                proponowane_pliki
            
            elif [[ "${#tab[@]}" -eq 0 ]] 
            then
                echo "There are no files which match the criteria"
                exit 3
            fi
        elif [[ $wybor == -1 ]]
        then
            pom1=-1
        else 
            echo "Unvalid data!"
        fi
    done
}

function usuwanie(){
    local check=0
    for i in "${tab_propozycja[@]}" 
    do
        rm -r "$i"
        unset tab[$check]
        unset tab_propozycja[$check]
        tab=("${tab[@]}")
        tab_propozycja=("${tab_propozycja[@]}")
        unset tab_size[$check]
        unset tab_propozycja_size[$check]
        tab_size=("${tab_size[@]}")
        tab_propozycja_size=("${tab_propozycja_size[@]}")
    done
}

function archiwizacja(){
    local pom1=0
    local pom=0
    local check=0

    if [[ $raz_tworzymy_arch -gt 0 ]]
    then
        gunzip hd_guard_$data\_$godzina.tar.gz
        for i in "${tab_propozycja[@]}"
                do
                    tar -rf hd_guard_$data\_$godzina.tar "$i" 2> /dev/null 
                    rm -r "$i"
                    unset tab[$check]
                    unset tab_propozycja[$check]
                    tab=("${tab[@]}")
                    tab_propozycja=("${tab_propozycja[@]}")
                    unset tab_size[$check]
                    unset tab_propozycja_size[$check]
                    tab_size=("${tab_size[@]}")
                    tab_propozycja_size=("${tab_propozycja_size[@]}")
                let check++
                done
    gzip hd_guard_$data\_$godzina.tar
    let pom1++

    fi

    while [[ $pom == 0 ]] && [[ $pom1 == 0 ]] 
    do
        oddzielenie
        printf "\nProvide the place where you want to create an archive: "
        read katalog_docelowy

        if [[ -d /home/$USER/$katalog_docelowy ]]
        then
            printf "\nYOu provided the name of catalog: $katalog_docelowy\nDO you confirm that?\n->[1]-Sure!\n->[2]-No!\n->[3]-Exit\n"
            read decyzja

            raz_tworzymy_arch=0 

            if [[ $decyzja == 1 ]]
            then
                if [[ $raz_tworzymy_arch == 0 ]]
                then 
                    data=$(date +%d-%b-%Y)
                    godzina=$(date +"%H-%M")
                    tar -cf hd_guard_$data\_$godzina.tar -T /dev/null
                    let raz_tworzymy_arch++
                fi
                
                for i in "${tab_propozycja[@]}"
                do
                    tar -rf hd_guard_$data\_$godzina.tar "$i" 2> /dev/null 
                    warunek_wyjscia=0 
                    rm -r "$i"
                done
                gzip hd_guard_$data\_$godzina.tar
                pom=1
            elif [[ $decyzja == 3 ]]
            then
                pom=1
            fi
        else
            echo "Catalog with the name $katalog_docelowy doesn't exist"
        fi
    done

}


function czyszczenie_partycji(){ 
    local p=0

    while read i
    do

        if [[ -f "$i" ]] && [[ ! -L "$i" ]] #&& [[ $p -lt 11 ]] # in case when we want to speed up the program we should limit p
        then
            tab_size[$p]=$(du -k "$i" | awk '{ print $1 }')
            echo "Size: ${tab_size[$p]}"
            tab[$p]="$i"
            printf "\nArray:${tab[$p]}"
            echo $p
            let p++
        fi

    done < <(find /home/$USER -type d \( -name ".*" \) -prune -o -type f -size +10k -user "$USER" -writable) > /dev/null

    
    bubblesort 

    proponowane_pliki 

    dopasowanie_tablicy
 
}
function wybor_archwizacji_usuniecia(){
    local wyb=0
    while [[ $wyb == 0 ]] 
    do
        oddzielenie     
        printf "\nWhat do you want to do with choosen files?\n->[1]-Remove\n->[2]-Archive\n"
        read wybor

        if [[ $wybor == 1 ]]
        then
            usuwanie
            wyb=1
        elif [[ $wybor == 2 ]]
        then
            archiwizacja
            wyb=1
        fi
    done
}

function proponowane_pliki(){ 
    local check=0
    while [[ $check -lt ${#tab[@]} ]] && [[ $check -lt 10 ]]  
    do
        tab_propozycja[$check]=${tab[$check]}
        tab_propozycja_size[$check]=${tab_size[$check]}
        let check++
    done
}

function main(){
    if [[ $1 -le 10 ]] 
    then
        echo "Too small value!"
        exit 1
    elif [[ $1 -gt 100 ]]
    then
        echo "Too high vale!"
        exit 2
    
    fi

    limit=$1
    
    powitanie

    while [[ true ]] 
    do
        
        local nazwa=$( df -h /home/$USER | awk 'substr($1,1,5)=="/dev/" { print $1 } ')
        local rozmiar=$(df -h /home/$USER | awk 'substr($1,1,5)=="/dev/" { print $2 } ')
        local uzycie=$(df -h /home/$USER | awk 'substr($1,1,5)=="/dev/" { print $3 } ')
        local dostepne=$(df -h /home/$USER | awk 'substr($1,1,5)=="/dev/" { print $4 } ')
        local use=$(df -h /home/$USER | awk 'substr($1,1,5)=="/dev/" { print substr($5,1,length($5)-1) }')

        oddzielenie

        printf "Name:|$nazwa \nSize:|$rozmiar \nUse:|$uzycie \nAvailable:|$dostepne\nUse(%):|$use%%\nBorder value:|$limit%%\n" | column -t -s '|'

        oddzielenie

        #spr=0
        local pom=0
        while [[ $use -ge $limit ]]
        do
            printf "\nYour disk is overfilled!\n\nWhat do you want to do?\n->[1]-Clear the partition.\n->[2]-Ignore.\n"
            read tryb

            if [[ $tryb == 1 ]]
            then
                czyszczenie_partycji
                wybor_archwizacji_usuniecia

            elif [[ $tryb == 2 ]]
            then
                sleep 60
            else
                printf "\nIncorrect choice!\Choose [1] lub [2]\n"
            fi

            use=$(df -h /home/$USER | awk 'substr($1,1,5)=="/dev/" { print substr($5,1,length($5)-1) }')
            let pom++
        done

        if [[ $pom -gt 0 ]] 
        then
            printf "The border value has been achived!"
            pom=0
        fi

        sleep 60
    done

}

main "$@" 
