var huxleyReference = huxleyReference || {};

huxleyReference.limit = 0;
huxleyReference.problemName = '';
huxleyReference.name = '';

huxleyReference.changeFunction = function(){};
huxleyReference.setChangeFunction = function(newFunction,initArg){
    huxleyReference.initArg = initArg;
    huxleyReference.changeFunction = newFunction;
};

huxleyReference.setValues = function(limit){
    huxleyReference.limit = limit;
};

huxleyReference.setName = function(value){
    huxleyReference.name = value;
    huxleyReference.changeFunction(huxleyReference.initArg);
};

