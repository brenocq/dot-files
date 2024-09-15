" Vim syntax file
" Language: Basm
" Author:  Breno Cunha Queiroz 
" Date:  28 mar 2020 

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=-
syntax case ignore

syntax match basmComment /--.*/
syntax region basmString start=/"/ skip=/\\"/ end=/"/
syntax region basmChar start=/'/ end=/'/
syntax match basmLabelColon /:/ contained
syntax match basmLabel /\w\+:/ contains=icmcLabelColon
syntax match basmNumber /\<[-]\?\d\+\>/ " Decimal numbers

syntax match basmMainLabel "\.define"
syntax match basmMainLabel "\.code"

" Registers
syntax keyword basmRegister t0
syntax keyword basmRegister t1
syntax keyword basmRegister t2
syntax keyword basmRegister t3
syntax keyword basmRegister t4
syntax keyword basmRegister t5
syntax keyword basmRegister t6
syntax keyword basmRegister t7

syntax keyword basmRegister a0
syntax keyword basmRegister a1
syntax keyword basmRegister a2
syntax keyword basmRegister a3

syntax keyword basmRegister v0
syntax keyword basmRegister v1
syntax keyword basmRegister v2
syntax keyword basmRegister v3

syntax keyword basmRegister sp

" Directives
syntax match basmDirective "\.int"
syntax match basmDirective "\.char"
syntax match basmDirective "\.string"

" Arithmetic and Logical Instructions
syntax keyword basmInstruction add addc
syntax keyword basmInstruction sub subc
syntax keyword basmInstruction mul mulc
syntax keyword basmInstruction div divc
syntax keyword basmInstruction sftl
syntax keyword basmInstruction sftr

" Jump Instructions
syntax keyword basmInstruction j
syntax keyword basmInstruction jmp 
syntax keyword basmInstruction jeq
syntax keyword basmInstruction jne
syntax keyword basmInstruction jgt
syntax keyword basmInstruction jge
syntax keyword basmInstruction jlt
syntax keyword basmInstruction jle

" Memory Access Instructions
syntax keyword basmInstruction store storec
syntax keyword basmInstruction load loadc

" Data Movement Instructions
syntax keyword basmInstruction move

" Stack Instructions
syntax keyword basmInstruction push
syntax keyword basmInstruction pop

" Terminal Instructions
syntax keyword basmInstructionT printc
syntax keyword basmInstructionT printstr
syntax keyword basmInstructionT printint
syntax keyword basmInstructionT printnl

" Window Instructions
syntax keyword basmInstructionW write
syntax keyword basmInstructionW read
syntax keyword basmInstructionW input

hi def link basmComment        Comment
hi def link basmNumber         Number
hi def link basmString         String
hi def link basmChar           Char
hi def link basmLabel          Label
hi def link basmMainLabel      MainLabel
hi def link basmRegister       Identifier
hi def link basmDirective      Type
hi def link basmInstruction    Statement
hi def link basmInstructionT   StatementT
hi def link basmInstructionW   StatementW

hi Comment ctermfg    = Gray
hi Label ctermfg      = LightCyan 
hi MainLabel ctermfg  = Cyan 
hi Identifier ctermfg = Green  
hi Number ctermfg     = White
hi Char ctermfg       = White
hi Statement ctermfg  = Magenta
hi StatementT ctermfg = LightMagenta
hi StatementW ctermfg =	LightMagenta 

let b:current_syntax = "basm"

