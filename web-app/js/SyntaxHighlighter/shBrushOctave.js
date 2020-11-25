;(function()
{
    // CommonJS
    typeof(require) != 'undefined' ? SyntaxHighlighter = require('shCore').SyntaxHighlighter : null;

    function Brush()
    {
        var keywords = 'break endfunction endif case catch classdef continue else elseif end for function global if otherwise parfor persistent return spmd switch try while';
        var functions = ' ';
        this.regexList = [
            { regex: /%.*$/gm, css: 'comments' }, // one line comments
            { regex: /##.*$/gm, css: 'comments' }, // one line comments
            { regex: /\%\{[\s\S]*?\%\}/gm, css: 'comments'}, // multiline comments
            { regex: SyntaxHighlighter.regexLib.singleQuotedString, css: 'string' },
            { regex: SyntaxHighlighter.regexLib.doubleQuotedString, css: 'string'},
            { regex: new RegExp(this.getKeywords(keywords), 'gm'), 	css: 'keyword' }
        ];
        this.forHtmlScript(SyntaxHighlighter.regexLib.aspScriptTags);
    };
    Brush.prototype	= new SyntaxHighlighter.Highlighter();
    Brush.aliases	= ['octave'];

    SyntaxHighlighter.brushes.Octave = Brush;

    // CommonJS
    typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();