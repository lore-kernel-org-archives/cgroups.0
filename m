Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794454638;
	b=igAbzyu9uIhkfmnq+/8BNRhupWK9iXQvxuy2g5/+hDEzTFZsMmswCVHf9Kfm7ELa6dd9
	 wOdElmUAu4qLcXHEg84SxPc8sAMGzRDgqNDurB9RBm0s4X5s0cbJ3NYR9/LD3TvOlUtPd
	 iOjGoM5tyuTan8qGAmC91FIxrljrA86NCAmCjfnFEW6p5VL1A0xtBFn/1FheaoFBh49Pj
	 OV6D6yB1wmQG/qX6B+JIbHhachJxPp9kHUHH2kFfJtlwjwGQn0sVPWx4bpFzxFQMmiVym
	 caY66S79bmRvHTrmy1KvYJCnBmQuC3p9Bv5jcfFZ5D+eGE/OQzCfh9AjoyLpHGMraRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794454638;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=1Nv3P0rBxt+X7FNoz0t7xO1dEq4B/fAsbmp8MpKzm1Y=;
	b=hXAPwpaYcrdMi1q5D3/FSrpamrx0arRbibF2yeJ0ttof12as1/p6JwoMqi5bbf8DMnze
	 x8CwvzAj8iRi275GXWWGwJ50Y/XrcvPb3ECNzW086h0zIncvwahb9Umt4jwhm/DtnHlzY
	 Xfxfm3tNhPBxT1z1VDthC9uqhZrcgOBLnuU7V6HWLTfbGCVFLfX7cHSOJ6ETt+3ua+hny
	 h8zXyV3fLbpdOMErlK7xKl7QvgPgmp9AP3xhnkquaqAmF8ajMeikP8YfraED51JSbRZWn
	 GpSml4Jpx0pJKO5PZ3qWPMLWo6sUaniRpUEfOqj50fhCxUAHQwf5CglH9syCrxPCNvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b="cHn/qXMj";
	arc=none smtp.remote-ip=207.54.90.47
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE704606A321;
	Thu, 12 Nov 2026 03:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE704606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=cHn/qXMj
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1794454646; x=1825990646;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=0SteMvw4TRI2EB8EQNbS5PdGg2z2O/XHauoovYaYej4=;
  b=cHn/qXMjsau/GjDJ5sSFHj+fxRprj7bodRSTAcJgM5kIyFY4rsq2icCs
   V0PSjda6fMnzMfqajo3E6eaKI6sJYNOMTkroaMnfup2GxQWM1iCHeHr4V
   +feqbNXOffpFOQxkV+4+RYis7D7fMusEvkH6cY5JTF2Z3EfKZdxlGACTM
   IemyBE8Hq4COJElzsia+lsZ4NDS4JaQBI2pqasV6MNcVEseMGzFCVTlmT
   L+MBVJo8fts3mjMb+0ymRAQYDSxGGIqh/mwHpcYlw4C2juMcUaQ5gLIjo
   IzBO0SERRfnOTCIP8+tHXAaIk+MUgq9pEnvBsaZIgY261xpjemaTicvsC
   Q==;
X-CSE-ConnectionGUID: IQFhykPmSZqBx6fHg9CQ6g==
X-CSE-MsgGUID: fE/Haf4CR0+mM/i2v/qdLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="261506764"
X-IronPort-AV: E=Sophos;i="6.27,208,1786978800"; 
   d="scan'208";a="261506764"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:37:24 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 354B51C04FB1;
	Thu, 12 Nov 2026 03:37:16 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id DB8301000275;
	Thu, 12 Nov 2026 03:37:15 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTP id D5B5818002CF;
	Thu, 12 Nov 2026 03:37:09 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
Date: Thu, 12 Nov 2026 12:36:21 +0900
Subject: [PATCH RFC v2 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
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
Message-Id: <20261112-mm-v1-mec-v2-1-0d1dd260a588@fujitsu.com>
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

Introduce the KVM_ARM_VM_RMI_CTRL device attribute group to allow
userspace to configure Realm VM parameters before the Realm is created
using KVM_SET_DEVICE_ATTR.

Currently, KVM_ARM_VM_RMI_CTRL_MEC_POLICY is the only supported
attribute. Its value can be KVM_ARM_VM_RMI_MEC_POLICY_SHARED or
KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE. Reject the private policy if the
platform does not support private MECs.

If userspace does not explicitly configure the MEC policy,
KVM_ARM_VM_RMI_MEC_POLICY_SHARED is used by default.

Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
---
 Documentation/virt/kvm/devices/vm.rst   | 25 +++++++++++++++
 arch/arm64/include/asm/kvm_rmi.h        |  5 +++
 arch/arm64/include/uapi/asm/kvm.h       |  4 +++
 arch/arm64/kvm/arm.c                    |  4 +++
 arch/arm64/kvm/rmi.c                    | 57 +++++++++++++++++++++++++++++++++
 drivers/firmware/arm_rmm/rmi.c          |  6 ++++
 include/linux/arm-rmi-cmds.h            |  1 +
 tools/arch/arm64/include/uapi/asm/kvm.h |  4 +++
 8 files changed, 106 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 78e63eb9994e..b0bd30750aa1 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -418,3 +418,28 @@ will reject attempts to define a filter for any portion of these ranges:
         0x8000_0000 0x8000_FFFF
         0xC000_0000 0xC000_FFFF
         =========== ===============
+
+7. GROUP: KVM_ARM_VM_RMI_CTRL
+=============================
+
+:Architectures: arm64
+
+7.1. ATTRIBUTE: KVM_ARM_VM_RMI_CTRL_MEC_POLICY (w/o)
+----------------------------------------------------
+
+:Parameters: Pointer to a ``__u8`` value
+
+:Returns:
+
+  =========  ===========================================================
+  ENXIO      The VM is not a Realm VM
+  EBUSY      The Realm has already been created
+  EINVAL     Invalid MEC policy value
+  EOPNOTSUPP Private MEC policy is not supported by the platform
+  EFAULT     The value could not be copied from userspace
+  =========  ===========================================================
+
+Configures the MEC policy for a Realm VM before the Realm is created. The value
+must be either ``KVM_ARM_VM_RMI_MEC_POLICY_SHARED`` or
+``KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE``. If userspace does not explicitly set the
+MEC policy, ``KVM_ARM_VM_RMI_MEC_POLICY_SHARED`` is used by default.
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 3933f8d834b8..08c1f6d0671d 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -59,6 +59,7 @@ enum realm_state {
  * @state: The lifetime state machine for the realm
  * @ia_bits: Number of valid Input Address bits in the IPA
  * @stage2_unmapped: The Realm stage-2 mappings have been removed
+ * @mec_policy: MEC policy for the Realm VM
  */
 struct realm {
 	void *rd;
@@ -73,6 +74,7 @@ struct realm {
 	enum realm_state state;
 	unsigned int ia_bits;
 	bool stage2_unmapped;
+	unsigned int mec_policy;
 };
 
 /**
@@ -109,9 +111,12 @@ int kvm_realm_teardown_stage2(struct kvm *kvm);
 void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
 struct kvm_arm_rmi_populate;
+struct kvm_device_attr;
 
 int kvm_arm_rmi_populate(struct kvm *kvm,
 			 struct kvm_arm_rmi_populate *arg);
+int kvm_vm_rmi_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+int kvm_vm_rmi_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
 
 enum kvm_gfn_range_filter;
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 65ee09bd1463..aa1e6fe6192e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -403,6 +403,10 @@ enum {
 /* Device Control API on vm fd */
 #define KVM_ARM_VM_SMCCC_CTRL		0
 #define   KVM_ARM_VM_SMCCC_FILTER	0
+#define KVM_ARM_VM_RMI_CTRL		1
+#define   KVM_ARM_VM_RMI_CTRL_MEC_POLICY	0
+#define     KVM_ARM_VM_RMI_MEC_POLICY_SHARED	0
+#define     KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE	1
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8e94f1bff830..be676c13e219 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2329,6 +2329,8 @@ static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	switch (attr->group) {
 	case KVM_ARM_VM_SMCCC_CTRL:
 		return kvm_vm_smccc_has_attr(kvm, attr);
+	case KVM_ARM_VM_RMI_CTRL:
+		return kvm_vm_rmi_has_attr(kvm, attr);
 	default:
 		return -ENXIO;
 	}
@@ -2339,6 +2341,8 @@ static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	switch (attr->group) {
 	case KVM_ARM_VM_SMCCC_CTRL:
 		return kvm_vm_smccc_set_attr(kvm, attr);
+	case KVM_ARM_VM_RMI_CTRL:
+		return kvm_vm_rmi_set_attr(kvm, attr);
 	default:
 		return -ENXIO;
 	}
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 0d254fb80cde..01ac8d4fec7c 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -7,6 +7,7 @@
 #include <linux/arm-rmi-cmds.h>
 #include <linux/kvm_host.h>
 #include <linux/overflow.h>
+#include <linux/uaccess.h>
 
 #include <asm/daifflags.h>
 #include <asm/kvm_emulate.h>
@@ -586,6 +587,9 @@ static int realm_create_rd(struct kvm *kvm)
 		params->flags0 |= RMI_REALM_PARAM_FLAG_PMU;
 	}
 
+	params->flags0 |= FIELD_PREP(RMI_REALM_PARAM_FLAG_MEC_POLICY_MASK,
+				    realm->mec_policy);
+
 	r = realm_init_sve_param(kvm, params);
 	if (r)
 		goto out_undelegate_tables;
@@ -1481,6 +1485,57 @@ int kvm_arm_rmi_populate(struct kvm *kvm,
 	return ret;
 }
 
+static int kvm_vm_rmi_set_mec_policy(struct kvm *kvm, u8 policy)
+{
+	guard(mutex)(&kvm->arch.config_lock);
+
+	if (!kvm_vm_is_realm(kvm))
+		return -ENXIO;
+
+	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
+		return -EBUSY;
+
+	if (policy != KVM_ARM_VM_RMI_MEC_POLICY_SHARED &&
+	    policy != KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE)
+		return -EINVAL;
+
+	if (policy == KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE &&
+	    rmi_mec_count() == 0)
+		return -EOPNOTSUPP;
+
+	kvm->arch.realm.mec_policy = policy;
+	return 0;
+}
+
+int kvm_vm_rmi_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	if (!kvm_vm_is_realm(kvm))
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_RMI_CTRL_MEC_POLICY:
+		return 0;
+	default:
+		return -ENXIO;
+	}
+}
+
+int kvm_vm_rmi_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	void __user *uaddr = (void __user *)attr->addr;
+	u8 policy;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_RMI_CTRL_MEC_POLICY:
+		if (copy_from_user(&policy, uaddr, sizeof(policy)))
+			return -EFAULT;
+
+		return kvm_vm_rmi_set_mec_policy(kvm, policy);
+	default:
+		return -ENXIO;
+	}
+}
+
 static int kvm_create_rec(struct kvm_vcpu *vcpu)
 {
 	struct user_pt_regs *vcpu_regs = &vcpu->arch.ctxt.regs;
@@ -1695,6 +1750,8 @@ int kvm_init_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
 
+	realm->mec_policy = KVM_ARM_VM_RMI_MEC_POLICY_SHARED;
+
 	realm->sro = kmalloc_obj(*realm->sro);
 	if (!realm->sro)
 		return -ENOMEM;
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 77255a90e0a6..27edf060d2d9 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -793,6 +793,12 @@ unsigned long rmi_feat_reg(unsigned int index)
 }
 EXPORT_SYMBOL_GPL(rmi_feat_reg);
 
+u64 rmi_mec_count(void)
+{
+	return u64_get_bits(rmi_feat_reg(4), RMI_FEATURE_REGISTER_4_MEC_COUNT);
+}
+EXPORT_SYMBOL_GPL(rmi_mec_count);
+
 static int rmi_rmm_config_set(unsigned long cfg_ptr)
 {
 	struct arm_smccc_1_2_regs regs = {
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index c13e8775898e..530136ccb791 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -68,6 +68,7 @@ static __always_inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *reg
 }
 
 unsigned long rmi_feat_reg(unsigned int index);
+u64 rmi_mec_count(void);
 
 int rmi_delegate_range(phys_addr_t phys, unsigned long size,
 		       phys_addr_t *out_phys);
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 65ee09bd1463..aa1e6fe6192e 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -403,6 +403,10 @@ enum {
 /* Device Control API on vm fd */
 #define KVM_ARM_VM_SMCCC_CTRL		0
 #define   KVM_ARM_VM_SMCCC_FILTER	0
+#define KVM_ARM_VM_RMI_CTRL		1
+#define   KVM_ARM_VM_RMI_CTRL_MEC_POLICY	0
+#define     KVM_ARM_VM_RMI_MEC_POLICY_SHARED	0
+#define     KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE	1
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0

-- 
2.43.0

