/*definations section*/

%{
    #include<bits/stdc++.h>
    using namespace std;
    vector<pair<string,string>> vec;
    map<pair<string,string>,int> mp;   
    int line=1; 
%}

ws      [ \t\f]+



        /*!!!!!!!LOGIC!!!!!!!*/
        /*1 Match the lexeme with it regular expression*/
        /*2 use of vector is to maintain the input order*/
        /*3 if the lexeme is already present in the vector(std::range::find), no need to insert*/
        /*4 otherwise insert it*/
        /*5 use of map is to find the number of counts of particular lexeme*/
        /*6 traverse the vector, push it to csv file and the corresponding count using map*/

        /*Compilation commands*/
        /* $flex problem1.l */
        /* $g++-11 --std=c++20 lex.yy.c */      /*you need to install g++ version 11*/
        /* $./a.out < file name */




/*rules section*/

%%

{ws}    /* skip blanks and tabs */

"{"[^}]*"}"   /*comments ignored*/

\n   {
    line++;
}

"array"|"begin"|"case"|"const"|"do"|"downto"|"else"|"end"|"file"|"for"|"function"|"goto"|"if"|"label"|"nil"|"of"|"packed"|"procedure"|"program"|"record"|"repeat"|"set"|"then"|"to"|"type"|"until"|"var"|"while"|"with"   {
    /*keywords*/
    mp[{yytext,"keyword"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"keyword"});
    }
}

"+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"ˆ"|"or"|"not"|"and"|"div"|"mod"|"in" {
    /*operators*/
    mp[{yytext,"operator"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"operator"});
    }
}

","|";"|":"|"("|")"|"["|"]"|".." {
    /*delimiters*/
    mp[{yytext,"delimiters"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"delimiters"});
    }
}

[a-zA-Z][0-9a-zA-Z]* {
    /*identifiers*/
    mp[{yytext,"identifiers"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"identifiers"});
    }
}

\"[^\n"]*\" {
    /*string*/
    mp[{yytext,"string"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"string"});
    }
}

([-+]?[0-9]+\.?([eE][-+]?[0-9]+)?)|([-+]?[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?) {
    /*numeric literals*/
    mp[{yytext,"numeric"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"numeric"});
    }
}

. {
    ofstream f;
    f.open("error.csv", ios::app);
    f<<yytext<<" "<<"!!!ERROR "<<line<<"\n";
    f.close();
}

%%

int yywrap(){return(1);}

int main() {

    ofstream fout;
    fout.open("data.csv", ios::out | ios::trunc);
    yylex();
    for(auto i : vec){
        fout<<i.first<<" "<<i.second<<" "<<mp[i]<<endl;
    }
    fout.close();
    return 0;

}