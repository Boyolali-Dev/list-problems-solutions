var twoSum = function(nums, target) {
    const catatan = {}; 

    for (let i = 0; i < nums.length; i++) {
        let angka = nums[i];
        let pasangannya = target - angka;

        if (pasangannya in catatan) {
        return [catatan[pasangannya], i]; 
        }

        catatan[angka] = i; 
    }
};