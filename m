Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794454643;
	b=TfNYhB8AliRZxNPyvwAh8xPlsE7Mm7Co4iARVZ3k6Ao/oz+bi2H4T7uj8Ey2hwJXs1iy
	 R7v9v2mSPoQAiJTZ3k94HGdAViIo+kj5W3+xNiEXkDzJzd7Vp1nsRjqJwIlbt19mIzeaL
	 FfQnmc2w2eBpFCWGrZkQdrFxdtMEH3sjXrUGD8vtaqK1lnMrctYZkENhq3Ppvbfz4jNpd
	 Sk8Xi4KQ+m2JaB+kILlsrOWx3qFaI0QXir3tcI/oia7i1rHckN/i1IUu4j/N/l4gmn7/z
	 qFuoueTCO4w3dyE1T5pBaEx150CftumaT4h5FLgOnq8XfDmpzH7oo6bbhGIYonHbnpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794454643;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=dNj8Yd/9RCqTsai/mMDRldXnsFtI1EFpZ2mNGrB/CQk=;
	b=F42VQLJO29saRCxOxlGfX6Yt2y4vqeUSbWuYnmFV/xFSgy9XaBk7R3MFYv28Ca5w2kYb
	 yzK5ry/wxjj3z8D2nd3h6KgkUCbd7k3N5272NO5LIWYLpxfm3E5yTInizPWw1x48V5kbN
	 75NPmbLoHdKWmwPbSb/He0BC0ixQD7PyzWj9F+vZDsiKhuNg9VNoUOrT40X58Fea598LS
	 +g/XbDOW7jlnRJap8QbhSN5GdoMteSCyRYKGkJZl5SFeRH6FFzkV31bwLRRSp9NVOnyGU
	 VDZZImrs5z9woitdpUSd1sMMGS0vSbitq8y+nTYPBgcUDHn4nGZ8utx8gnxk7SiWA2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=Y9GLONnc;
	arc=none smtp.remote-ip=207.54.90.47
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F3D606A884;
	Thu, 12 Nov 2026 03:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78F3D606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=Y9GLONnc
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1794454650; x=1825990650;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=mCMmdFehXj9Yk21VBRWrrvPCjVt9jTpcT09zRI/0xpc=;
  b=Y9GLONncuOEhbfbJm8ZVJPjfS+R9yiZonqy5YjSeCpFq5E42zOZWdAL5
   aAFM604jSvNgrsM+APcRVJjdlvCxZ8zjQimFOTM+cGB4fa8yyWyt6F21v
   s/0TSSdqqVMgpBLVH8WsAQQ//QrHntdFRlB/TpxKsjz9n1OV8MXdnh42z
   kTuVe7VvBoAO2NRQIv57ncX66MItazP7qXJ4ZuW+Yq2K1DMV/VdCFwO2r
   cDxsa8rvr9zUg2aSvfhak5isKEOtpUgOpImv0QBfoKOZh46Zxd1tFrss7
   B1UkNbrAREleTamI17kD2hJ6Nu195I3jDYt2EfAd1HgJxyr6OaWOjmqdo
   A==;
X-CSE-ConnectionGUID: C0dB4gT4QzS2XNw+lA6FVQ==
X-CSE-MsgGUID: FO3SmjLmSfOwLUGEBhSP3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="261506772"
X-IronPort-AV: E=Sophos;i="6.27,208,1786978800"; 
   d="scan'208";a="261506772"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:37:30 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id F207D1000261;
	Thu, 12 Nov 2026 03:37:21 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 9D5E4C0089C;
	Thu, 12 Nov 2026 03:37:21 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTP id 87A6E1801921;
	Thu, 12 Nov 2026 03:37:15 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
Date: Thu, 12 Nov 2026 12:36:22 +0900
Subject: [PATCH RFC v2 2/2] cgroup/misc: Add support for Arm CCA MECIDs
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-mm-v1-mec-v2-2-0d1dd260a588@fujitsu.com>
References: <20261112-mm-v1-mec-v2-0-0d1dd260a588@fujitsu.com>
In-Reply-To: <20261112-mm-v1-mec-v2-0-0d1dd260a588@fujitsu.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Steven Price <steven.price@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 cgroups@vger.kernel.org, Kohei Enju <enju.kohei@fujitsu.com>
X-Mailer: b4 0.16.0

Arm CCA MECIDs are limited platform resources. Add a misc cgroup
resource to allow the system administrator to account for and limit
their use.

The cca_mec resource represents the number of Realm VMs using the
private MEC policy. Each such Realm consumes one MECID. Charge the
resource when the Realm is created, and uncharge it when the Realm is
successfully destroyed.

Realms using the shared MEC policy don't consume this resource.

Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
---
 arch/arm64/include/asm/kvm_rmi.h |  2 ++
 arch/arm64/kvm/rmi.c             | 44 +++++++++++++++++++++++++++++++++++++++-
 drivers/firmware/arm_rmm/rmi.c   |  4 ++++
 include/linux/misc_cgroup.h      |  4 ++++
 kernel/cgroup/misc.c             |  4 ++++
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 08c1f6d0671d..658e65454282 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -60,6 +60,7 @@ enum realm_state {
  * @ia_bits: Number of valid Input Address bits in the IPA
  * @stage2_unmapped: The Realm stage-2 mappings have been removed
  * @mec_policy: MEC policy for the Realm VM
+ * @misc_cg: Misc cgroup charged while the Realm owns a private MECID
  */
 struct realm {
 	void *rd;
@@ -75,6 +76,7 @@ struct realm {
 	unsigned int ia_bits;
 	bool stage2_unmapped;
 	unsigned int mec_policy;
+	struct misc_cg *misc_cg;
 };
 
 /**
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 01ac8d4fec7c..d25d75744042 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -6,6 +6,7 @@
 #include <uapi/linux/psci.h>
 #include <linux/arm-rmi-cmds.h>
 #include <linux/kvm_host.h>
+#include <linux/misc_cgroup.h>
 #include <linux/overflow.h>
 #include <linux/uaccess.h>
 
@@ -538,6 +539,36 @@ static int realm_init_sve_param(struct kvm *kvm, struct realm_params *params)
 	return 0;
 }
 
+static int realm_mec_charge(struct realm *realm)
+{
+	struct misc_cg *misc_cg;
+	int ret;
+
+	if (realm->mec_policy != KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE)
+		return 0;
+
+	misc_cg = get_current_misc_cg();
+
+	ret = misc_cg_try_charge(MISC_CG_RES_CCA_MEC, misc_cg, 1);
+	if (ret) {
+		put_misc_cg(misc_cg);
+		return ret;
+	}
+
+	realm->misc_cg = misc_cg;
+	return 0;
+}
+
+static void realm_mec_uncharge(struct realm *realm)
+{
+	if (!realm->misc_cg)
+		return;
+
+	misc_cg_uncharge(MISC_CG_RES_CCA_MEC, realm->misc_cg, 1);
+	put_misc_cg(realm->misc_cg);
+	realm->misc_cg = NULL;
+}
+
 static int realm_create_rd(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
@@ -594,12 +625,16 @@ static int realm_create_rd(struct kvm *kvm)
 	if (r)
 		goto out_undelegate_tables;
 
+	r = realm_mec_charge(realm);
+	if (r)
+		goto out_undelegate_tables;
+
 	params_phys = virt_to_phys(params);
 
 	rmi_ret = rmi_realm_create(rd_phys, params_phys, realm->sro);
 	if (rmi_ret) {
 		r = rmi_ret < 0 ? rmi_ret : -ENXIO;
-		goto out_undelegate_tables;
+		goto out_uncharge_misc_cg;
 	}
 
 	realm->rd = rd;
@@ -607,6 +642,8 @@ static int realm_create_rd(struct kvm *kvm)
 
 	return 0;
 
+out_uncharge_misc_cg:
+	realm_mec_uncharge(realm);
 out_undelegate_tables:
 	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
 					 top_delegated - kvm->arch.mmu.pgd_phys))) {
@@ -1727,10 +1764,15 @@ void kvm_destroy_realm(struct kvm *kvm)
 		if (WARN_ON(realm_destroy_rtts(kvm)))
 			return;
 
+		/*
+		 * Keep the misc cgroup charge if RMI_REALM_DESTROY fails, as
+		 * the corresponding MECID may still be allocated by the RMM.
+		 */
 		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
 			return;
 		rmi_free_delegated_page(rd_phys);
 		realm->rd = NULL;
+		realm_mec_uncharge(realm);
 	}
 
 	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 27edf060d2d9..ba8a3e9a2603 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -7,6 +7,7 @@
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
 #include <linux/memory.h>
+#include <linux/misc_cgroup.h>
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 
@@ -1126,6 +1127,9 @@ static int __init arm64_init_rmi(void)
 		return ret;
 	}
 
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_CCA_MEC,
+					  rmi_mec_count()));
+
 	/* Mark the RMM is usable */
 	WRITE_ONCE(arm64_rmi_is_available, true);
 	pr_info("RMI configured\n");
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 0cb36a3ffc47..26131677170a 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -21,6 +21,10 @@ enum misc_res_type {
 #ifdef CONFIG_INTEL_TDX_HOST
 	/** @MISC_CG_RES_TDX: Intel TDX HKIDs resource */
 	MISC_CG_RES_TDX,
+#endif
+#ifdef CONFIG_ARM_RMM_RMI
+	/** @MISC_CG_RES_CCA_MEC: ARM64 CCA MECIDs resource */
+	MISC_CG_RES_CCA_MEC,
 #endif
 	/** @MISC_CG_RES_TYPES: count of enum misc_res_type constants */
 	MISC_CG_RES_TYPES
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 4a9e2557141c..989316bcb5f0 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -28,6 +28,10 @@ static const char *const misc_res_name[] = {
 	/* Intel TDX HKIDs resource */
 	"tdx",
 #endif
+#ifdef CONFIG_ARM_RMM_RMI
+	/* ARM64 CCA MECIDs resource */
+	"cca_mec",
+#endif
 };
 
 /* Root misc cgroup */

-- 
2.43.0

