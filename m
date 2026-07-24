Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02DB353A89;
	Fri, 24 Jul 2026 09:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886123; cv=none; b=LCxSsFKNt86/nk2CSAAXoKyycGYZk49fWtOzGzrP8N1tTdoZGEUIjQcd/d0czLmjIwWh4ZyflM9Dc9KHbiK49TdvPIJdosStatOxdDXvknuWw3QsmGakGj60C0Z+GDQFSIXcUOwSappKac2pT+qYfwb9WvXF3IguFJJRxbET1is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886123; c=relaxed/simple;
	bh=RNkuio2LL2Nc30zjeKwe+1C7Rs23SB5prtaVUYCMtMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0Kp7PFMn2hkrun6uF82DhY5b/UyXNfYBF8jWPO59Io66OHyHz1qDQLvReMDE68c7CgmFY21kPgpD3ywZ/DUWED5sy+0OmrxTbhN6PUEupLyQCw9D0Dfsf8bRknbEgzPxa/SkNBBUKEP0XRmHM6Hryrmw/hmanagYPvHH+tA7aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=lG5SXxU7; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="lG5SXxU7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784886124; x=1816422124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RNkuio2LL2Nc30zjeKwe+1C7Rs23SB5prtaVUYCMtMo=;
  b=lG5SXxU7Cga6Op1XFbqwMZdv2ex0F1bSvsB+i9tTl13PoP3e/Gm+Frqc
   TFwwvajCrQqLQI0uRD40tVZuRMX4+E3bhHEJkTRIQDkpk9QbZiO4ReYr0
   8bBz/n8KApLoAUOY7/CViImxrsMd5InOBzCXy5Xhr/VVO9jXY3qoBcbJd
   ILu2pCIGHX7oEFNFrBZkYSgjTeL/I+Ty02f51Btdt8Bw5P6/AJLBPXxAz
   3DGzcmaZqmw28XoOC5Rmw7if7OkmuhfrU0kc4339O8J1+cx4UAM92AM+N
   +JA2M09sccBTIb7qpkQbTqU/vE2PyqGrWwsr9bINoaa0nvc/omIQsgNT+
   Q==;
X-CSE-ConnectionGUID: v0DSeQeDQ1eCErNitH9H0Q==
X-CSE-MsgGUID: NV9by4xPTTuAjs+CnkQJ1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="234661678"
X-IronPort-AV: E=Sophos;i="6.25,182,1779116400"; 
   d="scan'208";a="234661678"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 18:41:57 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 7088CC0158C;
	Fri, 24 Jul 2026 09:41:54 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 2B02B149CEE8;
	Fri, 24 Jul 2026 09:41:54 +0000 (UTC)
Received: from sm-arm-grace07.ssoft.mng.com (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id 7801A405AB7;
	Fri, 24 Jul 2026 09:41:48 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Steven Price <steven.price@arm.com>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [RFC PATCH v1 2/2] cgroup/misc: Add support for Arm CCA MECIDs
Date: Fri, 24 Jul 2026 18:40:56 +0900
Message-ID: <20260724094120.166536-3-enju.kohei@fujitsu.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724094120.166536-1-enju.kohei@fujitsu.com>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 arch/arm64/kvm/rmi.c             | 44 +++++++++++++++++++++++++++++++-
 drivers/firmware/arm_rmm/rmi.c   |  4 +++
 include/linux/misc_cgroup.h      |  4 +++
 kernel/cgroup/misc.c             |  4 +++
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 721033b132e1..182bdd22014f 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -61,6 +61,7 @@ enum realm_state {
  * @stage2_unmapped: The Realm stage-2 mappings have been removed
  * @rtts_destroyed: The non-root RTTs have been torn down
  * @mec_policy: MEC policy for the Realm VM
+ * @misc_cg: Misc cgroup charged while the Realm owns a private MECID
  */
 struct realm {
 	void *rd;
@@ -78,6 +79,7 @@ struct realm {
 	bool stage2_unmapped;
 	bool rtts_destroyed;
 	unsigned int mec_policy;
+	struct misc_cg *misc_cg;
 };
 
 /**
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 629dea5e8c47..505fa80f635d 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -5,6 +5,7 @@
 
 #include <uapi/linux/psci.h>
 #include <linux/kvm_host.h>
+#include <linux/misc_cgroup.h>
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
@@ -525,6 +526,36 @@ static int realm_init_sve_param(struct kvm *kvm, struct realm_params *params)
 	return 0;
 }
 
+static int realm_mec_charge(struct realm *realm)
+{
+	struct misc_cg *misc_cg;
+	int ret;
+
+	if (realm->mec_policy != ARM_RMI_MEC_POLICY_PRIVATE)
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
@@ -579,11 +610,15 @@ static int realm_create_rd(struct kvm *kvm)
 	if (r)
 		goto out_undelegate_tables;
 
+	r = realm_mec_charge(realm);
+	if (r)
+		goto out_undelegate_tables;
+
 	params_phys = virt_to_phys(params);
 
 	if (rmi_realm_create(rd_phys, params_phys, realm->sro)) {
 		r = -ENXIO;
-		goto out_undelegate_tables;
+		goto out_uncharge_misc_cg;
 	}
 
 	realm->rd = rd;
@@ -594,6 +629,8 @@ static int realm_create_rd(struct kvm *kvm)
 
 	return 0;
 
+out_uncharge_misc_cg:
+	realm_mec_uncharge(realm);
 out_undelegate_tables:
 	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys, top_delegated - kvm->arch.mmu.pgd_phys))) {
 		/* Leak the pages if they cannot be returned */
@@ -1478,10 +1515,15 @@ void kvm_destroy_realm(struct kvm *kvm)
 		if (WARN_ON(realm_destroy_rtts(kvm)))
 			return;
 
+		/*
+		 * Keep the misc cgroup charge if RMI_REALM_DESTROY fails, as
+		 * the corresponding MECID may still be allocated by the RMM.
+		 */
 		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
 			return;
 		free_delegated_page(rd_phys);
 		realm->rd = NULL;
+		realm_mec_uncharge(realm);
 	}
 
 	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index e9632c35e7db..85a7e6686d2b 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -6,6 +6,7 @@
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
 #include <linux/arm-rmi-cmds.h>
+#include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/slab.h>
 
@@ -714,6 +715,9 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_CCA_MEC,
+					  rmi_mec_count()));
+
 	arm64_rmi_is_available = true;
 	pr_info("RMI configured");
 
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 0cb36a3ffc47..b542502dc52a 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -21,6 +21,10 @@ enum misc_res_type {
 #ifdef CONFIG_INTEL_TDX_HOST
 	/** @MISC_CG_RES_TDX: Intel TDX HKIDs resource */
 	MISC_CG_RES_TDX,
+#endif
+#ifdef CONFIG_ARM_RMM
+	/** @MISC_CG_RES_CCA_MEC: ARM64 CCA MECIDs resource */
+	MISC_CG_RES_CCA_MEC,
 #endif
 	/** @MISC_CG_RES_TYPES: count of enum misc_res_type constants */
 	MISC_CG_RES_TYPES
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 4a9e2557141c..69259085115e 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -28,6 +28,10 @@ static const char *const misc_res_name[] = {
 	/* Intel TDX HKIDs resource */
 	"tdx",
 #endif
+#ifdef CONFIG_ARM_RMM
+	/* ARM64 CCA MECIDs resource */
+	"cca_mec",
+#endif
 };
 
 /* Root misc cgroup */
-- 
2.43.0

