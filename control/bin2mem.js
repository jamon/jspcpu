const fs = require("fs");
const util = require("util");
const path = require("path");
const Transform = require("stream").Transform;

class Bin2MemTransform extends Transform {
    constructor(options) {
        super(options);
        this.header = false;
    }
    _transform(data, encoding, callback) {
        if(encoding !== "buffer") throw "Bin2MemTransformer expects Buffer";
        const buf = Array.from(data.values()).map(value => value.toString(16).padStart(2, "0") + "\n").join("");
        if(this.header) callback(null, buf);
        this.header = true;
        callback(null, buf);
    }
}
function convertToMem(inFile, outFile) {
    return new Promise((resolve, reject) => {
        const source = fs.createReadStream(inFile);
        const transform = new Bin2MemTransform();
        const dest = fs.createWriteStream(outFile);
        source
            .pipe(transform)
            .pipe(dest)
            .on("finish", () => {
                console.log("finished\n");
                resolve();
            });    
    });
}
async function updatemicrocodeCommand() {
    const microcodeFiles = ["pipeline-stage1-rom1", "pipeline-stage1-rom2", "pipeline-stage2-rom1", "pipeline-stage2-rom2"];
    for(basefilename of microcodeFiles) {
        const binFile = path.join(basefilename + ".bin");
        // const outFile = path.join(argv.dest, basefilename + ".hex");
        const outFileMem = path.join(basefilename + ".mem");
        // console.log(`converting to hex... ${binFile} => ${outFile}`);
        // await convertToHex(binFile, outFile);
        console.log(`converting to mem (verilog)... ${binFile} => ${outFileMem}`);
        await convertToMem(binFile, outFileMem);
    };
    // console.log("argv.out", argv.out);
    // console.log("argv.dest", argv.dest); 
}
updatemicrocodeCommand().then(() => {
    process.exit();
});