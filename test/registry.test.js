const Land = artifacts.require("Registry");
let catchRevert = require("../execption").catchRevert;
contract("LandRegistry",(accounts)=>{
    let admin = accounts[0];
    let user = accounts[1];
    let user1 = accounts[2];

    it("Should deploy successfully",async()=>{
        const alpha = await Land.deployed();
        const address = await alpha.address;
        console.log("The deployed address is :",address.toString());
        assert(address != "");
    });
    it("User can acquire land",async()=>{
        const alpha = await Land.deployed();
        const beta = await alpha.AcquireLand("JUSTAWAY",100,43);
        const gamma = await alpha.isLandOwner();
        assert(gamma == true);
    });
    it("Should return false when non owner tries to Use is landowner function",async()=>{
        const alpha = await Land.deployed();
        const gamma = await alpha.isLandOwner({from:user});
        assert(gamma == false);
    });
    it("Can Show Land ID",async()=>{
        const alpha = await Land.deployed();
        const beta = await alpha.AcquireLand("JUSTAWAY",1000,43);
        const beta2 = await alpha.AcquireLand("JUSTAWAY",10000,43);
        const gamma = await alpha.ShowIDLand();
        assert(gamma != "");
    });
    it("Should Revert when non land owner tries to check LandID",async()=>{
        const alpha = await Land.deployed();
       await catchRevert(alpha.ShowIDLand({from:user}));
    });
    it("Can Show Land Hash",async()=>{
        const alpha = await Land.deployed();
        const gamma = await alpha.ShowLandHash(1);
        assert(gamma != "");
    });
    it("Should when non owner tries to check LandHash",async()=>{
        const alpha = await Land.deployed();
        await catchRevert(alpha.ShowLandHash(1,{from:user}));
    });
    it("Should revert when user tries to check LandHash with id 0",async()=>{
        const alpha = await Land.deployed();
       await catchRevert(alpha.ShowLandHash(0,{from:user}));
    });
    it("Should revert when user tries to check LandHash unassigned id",async()=>{
        const alpha = await Land.deployed();
       await catchRevert(alpha.ShowLandHash(78,{from:user}));
    });
    it("Should revert when non owner uses LandVerifier",async()=>{
        const alpha = await Land.deployed();
        await catchRevert(alpha.LandVerifier(1,{from:user}));
    });
    it("Can Verify Ownership of land",async()=>{
        const alpha = await Land.deployed();
        const beta = await alpha.LandVerifier(1);
        assert(beta == true);
    });
    it("Should revert when user tries to check LandVerifier with id 0",async()=>{
        const alpha = await Land.deployed();
       await catchRevert(alpha.LandVerifier(0));
    });
    it("Can reveal Hashes",async()=>{
        const alpha = await Land.deployed();
        const beta = await alpha.RevealHashes();
        assert(beta != "");
    })
   
   




});




  
