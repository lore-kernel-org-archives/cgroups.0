From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [6/6] mm: memcontrol: account slab stats per lruvec
Date: Mon, 5 Jun 2017 09:52:03 -0700
Message-ID: <20170605165203.GA20603@roeck-us.net>
References: <20170530181724.27197-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CPz5Liiwl8MabxyQE6p5hwNq27NTVb5+kmEj2Scp6Go=; b=F27Til74BsWO0JCINEd/l1HKga
	+4WjqzCd+R6W/vjYf+af+EcNdw0iJHPPt+ZjfYbpCGZkxW9gteK1XqGpAxOKFK55uCsifOeac1siC
	Pt8/8TrM3Y+4YYNa5/qW+fXd14f3A6aG/+6zWlc2JUf5TPOHQE/WpPmXOA0u27My0scCgNiN3QV3Q
	Qk/1gWjpYg8Ig8JBaKrNWpoIx0bxQ1vBa5OT6MM0Ubgdx1qPoUu3u9xryDlSaTi2Jnu/aPWULoX+F
	f0mMv9vMjPUZEX6YIHAeraNrIV2iu6JTOWKzgqry8bW24Ocw5KKSP0NS4PvUaOwuqFUo7Wqi+2Uvw
	ePHLTx3A==;
Content-Disposition: inline
In-Reply-To: <20170530181724.27197-7-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, May 30, 2017 at 02:17:24PM -0400, Johannes Weiner wrote:
> Josef's redesign of the balancing between slab caches and the page
> cache requires slab cache statistics at the lruvec level.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

Presumably this is already known, but a remarkable number of crashes
in next-20170605 bisects to this patch.

Guenter

---
Qemu test results:
	total: 122 pass: 51 fail: 71
Failed tests:
	arm:vexpress-a9:vexpress_defconfig:vexpress-v2p-ca9
	arm:vexpress-a15:vexpress_defconfig:vexpress-v2p-ca15-tc1
	arm:kzm:imx_v6_v7_defconfig
	arm:sabrelite:imx_v6_v7_defconfig:imx6dl-sabrelite
	arm:beagle:multi_v7_defconfig:omap3-beagle
	arm:beaglexm:multi_v7_defconfig:omap3-beagle-xm
	arm:overo:multi_v7_defconfig:omap3-overo-tobi
	arm:sabrelite:multi_v7_defconfig:imx6dl-sabrelite
	arm:vexpress-a9:multi_v7_defconfig:vexpress-v2p-ca9
	arm:vexpress-a15:multi_v7_defconfig:vexpress-v2p-ca15-tc1
	arm:vexpress-a15-a7:multi_v7_defconfig:vexpress-v2p-ca15_a7
	arm:xilinx-zynq-a9:multi_v7_defconfig:zynq-zc702
	arm:xilinx-zynq-a9:multi_v7_defconfig:zynq-zc706
	arm:xilinx-zynq-a9:multi_v7_defconfig:zynq-zed
	arm:midway:multi_v7_defconfig:ecx-2000
	arm:smdkc210:multi_v7_defconfig:exynos4210-smdkv310
	arm:smdkc210:exynos_defconfig:exynos4210-smdkv310
	arm:beagle:omap2plus_defconfig:omap3-beagle
	arm:beaglexm:omap2plus_defconfig:omap3-beagle-xm
	arm:overo:omap2plus_defconfig:omap3-overo-tobi
	arm:realview-pb-a8:realview_defconfig:arm-realview-pba8
	arm:realview-pbx-a9:realview_defconfig:arm-realview-pbx-a9
	arm:realview-eb:realview_defconfig:arm-realview-eb
	arm:realview-eb-mpcore:realview_defconfig:arm-realview-eb-11mp-ctrevb
	arm64:virt:smp:defconfig
	arm64:xlnx-ep108:smp:defconfig:zynqmp-ep108
	arm64:virt:nosmp:defconfig
	arm64:xlnx-ep108:nosmp:defconfig:zynqmp-ep108
	mips:malta_defconfig:smp
	mipsel:24Kf:malta_defconfig:smp
	powerpc:mac99:nosmp:ppc_book3s_defconfig
	powerpc:g3beige:nosmp:ppc_book3s_defconfig
	powerpc:mac99:smp:ppc_book3s_defconfig
	powerpc:mpc8548cds:smpdev:85xx/mpc85xx_cds_defconfig
	powerpc:mac99:ppc64_book3s_defconfig:nosmp
	powerpc:mac99:ppc64_book3s_defconfig:smp4
	powerpc:pseries:pseries_defconfig
	powerpc:mpc8544ds:ppc64_e5500_defconfig:smp
	sparc32:SPARCClassic:smp:sparc32_defconfig
	sparc32:SPARCbook:smp:sparc32_defconfig
	sparc32:SS-4:smp:sparc32_defconfig
	sparc32:SS-5:smp:sparc32_defconfig
	sparc32:SS-10:smp:sparc32_defconfig
	sparc32:SS-20:smp:sparc32_defconfig
	sparc32:SS-600MP:smp:sparc32_defconfig
	sparc32:LX:smp:sparc32_defconfig
	sparc32:Voyager:smp:sparc32_defconfig
	x86:Broadwell:q35:x86_pc_defconfig
	x86:Skylake-Client:q35:x86_pc_defconfig
	x86:SandyBridge:q35:x86_pc_defconfig
	x86:Haswell:pc:x86_pc_defconfig
	x86:Nehalem:q35:x86_pc_defconfig
	x86:phenom:pc:x86_pc_defconfig
	x86:core2duo:q35:x86_pc_nosmp_defconfig
	x86:Conroe:isapc:x86_pc_nosmp_defconfig
	x86:Opteron_G1:pc:x86_pc_nosmp_defconfig
	x86:n270:isapc:x86_pc_nosmp_defconfig
	x86_64:q35:Broadwell-noTSX:x86_64_pc_defconfig
	x86_64:q35:IvyBridge:x86_64_pc_defconfig
	x86_64:q35:SandyBridge:x86_64_pc_defconfig
	x86_64:q35:Haswell:x86_64_pc_defconfig
	x86_64:pc:core2duo:x86_64_pc_defconfig
	x86_64:q35:Nehalem:x86_64_pc_defconfig
	x86_64:pc:phenom:x86_64_pc_defconfig
	x86_64:q35:Opteron_G1:x86_64_pc_defconfig
	x86_64:pc:Opteron_G4:x86_64_pc_nosmp_defconfig
	x86_64:q35:IvyBridge:x86_64_pc_nosmp_defconfig
	xtensa:dc232b:lx60:generic_kc705_defconfig
	xtensa:dc232b:kc705:generic_kc705_defconfig
	xtensa:dc233c:ml605:generic_kc705_defconfig
	xtensa:dc233c:kc705:generic_kc705_defconfig

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
