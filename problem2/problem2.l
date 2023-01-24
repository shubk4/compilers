/*definations section*/

%{
    #include<bits/stdc++.h>
    using namespace std;
    vector<pair<string,string>> vec;
    map<pair<string,string>,int> mp;   
    int line=1; 
%}

ws      [ \t\f]+
keyword "abstract"|"continue"|"for"|"new"|"switch"|"assert"|"default"|"if"|"package"|"synchronized"|"boolean"|"do"|"goto"|"private"|"this"|"break"|"double"|"implements"|"protected"|"throw"|"byte"|"else"|"import"|"public"|"throws"|"case"|"enum"|"instanceof"|"return"|"transient"|"catch"|"extends"|"int"|"short"|"try"|"char"|"final"|"interface"|"static"|"void"|"class"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"while"|"_"|"exports"|"opens"|"requires"|"uses"|"module"|"permits"|"sealed"|"var"|"non-sealed"|"provides"|"to"|"with"|"open"|"record"|"transitive"|"yield"
operator "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="
char \'([\']*[^\n']*)*\'
str \"([\"]*[^\n"]*)*\"
bool "true"|"false"
dec [-+]?[0-9]+|[-+]?[1-9][0-9_]*[0-9]
oct [0][0-7_]*[0-7]
hex ("0x"|"0X")(([0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F])|([0-9a-fA-F]+))
bin ("0b"|"0B")(([0-1][0-1_]*[0-1])|([0-1]+))
floatd ([-+]?[0-9][0-9_]*[0-9](\.?([eE][-+]?[0-9][0-9_][0-9])?))|([-+]?([0-9]*|[0-9][0-9_]*[0-9])\.[0-9][0-9_]*[0-9]([eE][-+]?[0-9][0-9_]*[0-9])?)|([-+]?([0-9]+|[-+]?[1-9][0-9_]*[0-9])(\.([0-9]+|[-+]?[1-9][0-9_]*[0-9]))?[lL])
floath (("0x"|"0X")[0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F](\.?([pP][-+][0-9a-fA-F][0-9a-fA-F_][0-9a-fA-F])?)|[fF])|(("0x"|"0X")([0-9a-fA-F]*|([0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F]))\.[0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F]([pP][-+][0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F])+)|(([0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F])|([0-9a-fA-F]+)\.([0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F])|([0-9a-fA-F]+)[fF])
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

"/*"    {
        int c;

        while((c = yyinput()) != 0)
            {
            if(c == '\n')
                ++line;

            else if(c == '*')
                {
                if((c = yyinput()) == '/')
                    break;
                else
                    unput(c);
                }
            }
        }

"//".*  /*comments ignored*/

\n|\r  {
    line++;
}

{keyword}   {
    /*keywords*/
    mp[{yytext,"keyword"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"keyword"});
    }
}

{operator} {
    /*operators*/
    mp[{yytext,"operator"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"operator"});
    }
}

"("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::" {
    /*delimiters*/
    mp[{yytext,"separators"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"separators"});
    }
}

{char}|{str}|{bool}|{dec}|{bin}|{hex}|{oct}|{floatd}|{floath}|"null"   {
    /*string*/
    mp[{yytext,"literals"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"literals"});
    }
}

[a-zA-Z$][0-9a-zA-Z$_]*|[_][0-9a-zA-Z$_]+ {
    /*identifiers*/
    mp[{yytext,"identifiers"}]++;
    if(ranges::find(vec,yytext,&pair<string,string>::first)==vec.end()){
        vec.push_back({yytext,"identifiers"});
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
