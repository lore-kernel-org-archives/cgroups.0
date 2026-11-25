Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.61.253
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795576668;
	b=lZ5GGnZvx5aJg6A0ytsle5CouOEXZFltC+n2zhaCqoECxGv8l9obYLexNncC3zH08yg6
	 fdClzeIU8UJmCOJcPUbOWwB0eBytWe1PBC3pdblMUyOu+EtbxXrEaO05dgsoBNqMahwBw
	 CCVMrkJ5UH5PmKon1CqfAm+HA5BLobh486jKOKQ8q4wbmQSuIOucZcWU5H0Ce0eQohiqc
	 wIMVFSypxNbDRTSEIKqb+4mMU5OWSHZ9Vj0k3GJ7Cgq+LFczU5/ZJILPJZ781jvl038EO
	 3ETwthVRg2dQxYxPmAMkrX7Ko8kTrmaY69DxmTEHmSmfxq2U3LlCPZ7SUp0MMFHRqgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576668;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=23fFU0O+rXserzO3o7D7RV3GbnE7B9R3sHZLTrVXSyk=;
	b=Mf6hgWaMrKQyA3Kcz2s02zB37R0u0us8w1B4yJdpH/ebcPy3kNtkmcpZotPNCbXhtQ3u
	 FUrO+19w6sQNMieQ9/q/urS7kLsNQJ4eAFzkNpGH7sBTrg6y02dPvtnhPLOsMoCcre8mR
	 jo3NzxQ+OxjVmubFVDN+TTtU9BZ33LOGRYVeBjQzkUdfncSiw8adluox4llLzhtvF3rgv
	 Cqian1vO7qP+xy/ihAIu94fn9HAZlLpvpimEuEH2/TGIxXzfbMSZICYCppMJppwbU4drJ
	 VITljOXcoyd+eSiH/5udRK0SFSwgh20P4IcJYiwPcYM+eopLCyYh0HpqKwYy2k2UlBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=FxrXQtku;
	arc=none smtp.remote-ip=139.138.61.253
Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC45606A31E;
	Wed, 25 Nov 2026 03:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DC45606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=FxrXQtku
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795576667; x=1827112667;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P+2esJNoADXhVcXnXeX/GpZHHYhnsn3OGqjyBJ5lLUY=;
  b=FxrXQtkutOy5HAwzrVtWfYW7/flD3E/bwKTN+DxiT4eQwJC0VFws3jQw
   FZT/tgEEgNm/rHWViHoBSA/hxHtWh78OtPSd2PH3h5xOK3MfcR9ggWcLS
   VCyPvuPt1xmV0FEdQ3b9Ni/mQGDOAvgEfg80iOC3RId0rOHagN+wOZosW
   CM1hqmzwxLOEZdvqNF/ODI8UkuxvbPCRKJYLCI7R60kI0oWBK7uNYSlXp
   Mi+QH6LEHr8/E3JBEVAEpRjY3yWJfBjy1U8VzCGmx2EbDO1dybR9+G5f1
   +5Kxkqe1of2bgGrC8SDexMYH0pgNA1IEgOz2KPglRmnP3A53brPL3s6Yr
   g==;
X-CSE-ConnectionGUID: XhmH1+lUReq5XiOqAEfXFw==
X-CSE-MsgGUID: nU2ZqNcSRzawTvNxkpIX4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="250959921"
X-IronPort-AV: E=Sophos;i="6.27,232,1786978800"; 
   d="scan'208";a="250959921"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 12:17:45 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id BB91C1C0067F;
	Wed, 25 Nov 2026 03:17:45 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 6F6D4C013FB;
	Wed, 25 Nov 2026 03:17:45 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.162.75])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id 6E08D18021BD;
	Wed, 25 Nov 2026 03:17:39 +0000 (UTC)
Date: Wed, 25 Nov 2026 12:17:38 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Steven Price <steven.price@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
Message-ID: <awZR98W3sP9g12wh@FCCLS0092175.localdomain>
References: <20261112-mm-v1-mec-v2-0-0d1dd260a588@fujitsu.com>
 <20261112-mm-v1-mec-v2-1-0d1dd260a588@fujitsu.com>
 <090662ee-0d8d-48b5-83f2-8a4d225bef08@arm.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <090662ee-0d8d-48b5-83f2-8a4d225bef08@arm.com>

Hi Suzuki,
Thank you for reviewing.

On 11/24 15:08, Suzuki K Poulose wrote:
> On 12/11/2026 03:36, Kohei Enju wrote:
> > Introduce the KVM_ARM_VM_RMI_CTRL device attribute group to allow
> > userspace to configure Realm VM parameters before the Realm is created
> > using KVM_SET_DEVICE_ATTR.
> > 
> > Currently, KVM_ARM_VM_RMI_CTRL_MEC_POLICY is the only supported
> > attribute. Its value can be KVM_ARM_VM_RMI_MEC_POLICY_SHARED or
> > KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE. Reject the private policy if the
> > platform does not support private MECs.
> > 
> > If userspace does not explicitly configure the MEC policy,
> > KVM_ARM_VM_RMI_MEC_POLICY_SHARED is used by default.
> > 
> > Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> > ---
> >   Documentation/virt/kvm/devices/vm.rst   | 25 +++++++++++++++
> >   arch/arm64/include/asm/kvm_rmi.h        |  5 +++
> >   arch/arm64/include/uapi/asm/kvm.h       |  4 +++
> >   arch/arm64/kvm/arm.c                    |  4 +++
> >   arch/arm64/kvm/rmi.c                    | 57 +++++++++++++++++++++++++++++++++
> >   drivers/firmware/arm_rmm/rmi.c          |  6 ++++
> >   include/linux/arm-rmi-cmds.h            |  1 +
> >   tools/arch/arm64/include/uapi/asm/kvm.h |  4 +++
> >   8 files changed, 106 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
> > index 78e63eb9994e..b0bd30750aa1 100644
> > --- a/Documentation/virt/kvm/devices/vm.rst
> > +++ b/Documentation/virt/kvm/devices/vm.rst
> > @@ -418,3 +418,28 @@ will reject attempts to define a filter for any portion of these ranges:
> >           0x8000_0000 0x8000_FFFF
> >           0xC000_0000 0xC000_FFFF
> >           =========== ===============
> > +
> > +7. GROUP: KVM_ARM_VM_RMI_CTRL
> > +=============================
> > +
> > +:Architectures: arm64
> > +
> > +7.1. ATTRIBUTE: KVM_ARM_VM_RMI_CTRL_MEC_POLICY (w/o)
> > +----------------------------------------------------
> > +
> > +:Parameters: Pointer to a ``__u8`` value
> > +
> > +:Returns:
> > +
> > +  =========  ===========================================================
> > +  ENXIO      The VM is not a Realm VM
> > +  EBUSY      The Realm has already been created
> > +  EINVAL     Invalid MEC policy value
> > +  EOPNOTSUPP Private MEC policy is not supported by the platform
> > +  EFAULT     The value could not be copied from userspace
> > +  =========  ===========================================================
> > +
> > +Configures the MEC policy for a Realm VM before the Realm is created. The value
> > +must be either ``KVM_ARM_VM_RMI_MEC_POLICY_SHARED`` or
> > +``KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE``. If userspace does not explicitly set the
> > +MEC policy, ``KVM_ARM_VM_RMI_MEC_POLICY_SHARED`` is used by default.
> > diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> > index 3933f8d834b8..08c1f6d0671d 100644
> > --- a/arch/arm64/include/asm/kvm_rmi.h
> > +++ b/arch/arm64/include/asm/kvm_rmi.h
> > @@ -59,6 +59,7 @@ enum realm_state {
> >    * @state: The lifetime state machine for the realm
> >    * @ia_bits: Number of valid Input Address bits in the IPA
> >    * @stage2_unmapped: The Realm stage-2 mappings have been removed
> > + * @mec_policy: MEC policy for the Realm VM
> >    */
> >   struct realm {
> >   	void *rd;
> > @@ -73,6 +74,7 @@ struct realm {
> >   	enum realm_state state;
> >   	unsigned int ia_bits;
> >   	bool stage2_unmapped;
> > +	unsigned int mec_policy;
> >   };
> >   /**
> > @@ -109,9 +111,12 @@ int kvm_realm_teardown_stage2(struct kvm *kvm);
> >   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
> >   struct kvm_arm_rmi_populate;
> > +struct kvm_device_attr;
> >   int kvm_arm_rmi_populate(struct kvm *kvm,
> >   			 struct kvm_arm_rmi_populate *arg);
> > +int kvm_vm_rmi_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
> > +int kvm_vm_rmi_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
> >   enum kvm_gfn_range_filter;
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 65ee09bd1463..aa1e6fe6192e 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -403,6 +403,10 @@ enum {
> >   /* Device Control API on vm fd */
> >   #define KVM_ARM_VM_SMCCC_CTRL		0
> >   #define   KVM_ARM_VM_SMCCC_FILTER	0
> > +#define KVM_ARM_VM_RMI_CTRL		1
> > +#define   KVM_ARM_VM_RMI_CTRL_MEC_POLICY	0
> > +#define     KVM_ARM_VM_RMI_MEC_POLICY_SHARED	0
> > +#define     KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE	1
> >   /* Device Control API: ARM VGIC */
> >   #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 8e94f1bff830..be676c13e219 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2329,6 +2329,8 @@ static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> >   	switch (attr->group) {
> >   	case KVM_ARM_VM_SMCCC_CTRL:
> >   		return kvm_vm_smccc_has_attr(kvm, attr);
> > +	case KVM_ARM_VM_RMI_CTRL:
> > +		return kvm_vm_rmi_has_attr(kvm, attr);
> >   	default:
> >   		return -ENXIO;
> >   	}
> > @@ -2339,6 +2341,8 @@ static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> >   	switch (attr->group) {
> >   	case KVM_ARM_VM_SMCCC_CTRL:
> >   		return kvm_vm_smccc_set_attr(kvm, attr);
> > +	case KVM_ARM_VM_RMI_CTRL:
> > +		return kvm_vm_rmi_set_attr(kvm, attr);
> >   	default:
> >   		return -ENXIO;
> >   	}
> > diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> > index 0d254fb80cde..01ac8d4fec7c 100644
> > --- a/arch/arm64/kvm/rmi.c
> > +++ b/arch/arm64/kvm/rmi.c
> > @@ -7,6 +7,7 @@
> >   #include <linux/arm-rmi-cmds.h>
> >   #include <linux/kvm_host.h>
> >   #include <linux/overflow.h>
> > +#include <linux/uaccess.h>
> >   #include <asm/daifflags.h>
> >   #include <asm/kvm_emulate.h>
> > @@ -586,6 +587,9 @@ static int realm_create_rd(struct kvm *kvm)
> >   		params->flags0 |= RMI_REALM_PARAM_FLAG_PMU;
> >   	}
> > +	params->flags0 |= FIELD_PREP(RMI_REALM_PARAM_FLAG_MEC_POLICY_MASK,
> > +				    realm->mec_policy);
> > +
> >   	r = realm_init_sve_param(kvm, params);
> >   	if (r)
> >   		goto out_undelegate_tables;
> > @@ -1481,6 +1485,57 @@ int kvm_arm_rmi_populate(struct kvm *kvm,
> >   	return ret;
> >   }
> > +static int kvm_vm_rmi_set_mec_policy(struct kvm *kvm, u8 policy)
> > +{
> > +	guard(mutex)(&kvm->arch.config_lock);
> > +
> > +	if (!kvm_vm_is_realm(kvm))
> > +		return -ENXIO;
> > +
> > +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
> > +		return -EBUSY;
> > +
> > +	if (policy != KVM_ARM_VM_RMI_MEC_POLICY_SHARED &&
> > +	    policy != KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE)
> > +		return -EINVAL;
> > +
> > +	if (policy == KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE &&
> > +	    rmi_mec_count() == 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	kvm->arch.realm.mec_policy = policy;
> > +	return 0;
> > +}
> > +
> > +int kvm_vm_rmi_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	if (!kvm_vm_is_realm(kvm))
> > +		return -ENXIO;
> > +
> > +	switch (attr->attr) {
> > +	case KVM_ARM_VM_RMI_CTRL_MEC_POLICY:
> 
> minor nit: Could we reject this if the rmi_mec_count() == 0 ?
> Default policy is "shared" mec, as long as it is documented, this
> would work only on a system that supports Private MEC.

With SHARED as the default, how about making this a boolean attribute
named KVM_ARM_VM_RMI_CTRL_MEC_PRIVATE? Then gating its availability on
rmi_mec_count() > 0 would make sense to me.

Thanks,
Kohei

> 
> 
> Suzuki
