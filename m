Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9C114A60F;
	Fri, 31 Jul 2026 05:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785474563; cv=none; b=E3JI1dwv3gObv//JRptqDx+TzBG8hpLigq6xOHJFhvPKuSVMIKUzHQ4/FSHLrFtZ+bOoZHQ0CO0ZB7ZXceZd7VrVHPXUG4HvRReyXB8CBPa0ICZWyQCjVWVRbQMkPs3f27VXqmF0eXxiP3x9sYvTDK3bfPpNNOSEOmVC3OPA4yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785474563; c=relaxed/simple;
	bh=rrV1ZuArq7jUJFUzuZdIkzToe/yL0yOxpBMWNWx//uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnZSZh5VaLYGAMHCCvyzpzRjZbSDK9WcTkkeNVaxfNEHCiG4/ZUFXy5Y+/bGXZK2TS25Gl62BAtd6BdVRkv8JWqWhIqT3XLDTibjbWOPNzEBiNzxiOvnGREnjFr3kJjWD9GSzUgvR3EopC/Tt65gu8lB0Njo3NFhJyqWVEgZmks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=evVm/y1P; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="evVm/y1P"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1785474562; x=1817010562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rrV1ZuArq7jUJFUzuZdIkzToe/yL0yOxpBMWNWx//uc=;
  b=evVm/y1PjNCm0gxVrbIjI1JVPIR89Zv/GDKJQG8SB8SNL/YdXzyGVxiW
   Fw7R7DNEKgHU2K1cxM3zwRUkqy8ypvTWclHm5Rsew4GMtbDZgHkIBMCus
   SH6seatLur+mvqDjnyhZF0zgCuOqfG6BzwephpD8A+eZXwFgHUGlF58d0
   Q2Xdy6eT2RDrcMLodaMWH1v9ZSrKzKS6lj0Hs3Z/LstodimihI3PhJvJ7
   0sSWVkZjhANJBAErW6yBUq0yOmsl5QZU/8HA3AltgVA3rAfIjJyxWRV1m
   LaujC4m+WrzMvC3pq8JpOTw6rP26h2TuB9i7cdl62wWeuA3aiduODqNcf
   g==;
X-CSE-ConnectionGUID: yH42wcAZQaiKKohLJN9P+g==
X-CSE-MsgGUID: /Nrcb/4ETVewslEacfl+eA==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="235399180"
X-IronPort-AV: E=Sophos;i="6.25,195,1779116400"; 
   d="scan'208";a="235399180"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 14:09:14 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 439B810000C2;
	Fri, 31 Jul 2026 05:09:14 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id EABED1C17444;
	Fri, 31 Jul 2026 05:09:13 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.10.122.81])
	by az2uksmom3.o.css.fujitsu.com (Postfix) with SMTP id BBE931005AEA;
	Fri, 31 Jul 2026 05:09:07 +0000 (UTC)
Date: Fri, 31 Jul 2026 14:09:06 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH v1 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
Message-ID: <amwrnJ1KhllC-gVu@FCCLS0092175.localdomain>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-2-enju.kohei@fujitsu.com>
 <46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com>

On 07/29 12:47, Suzuki K Poulose wrote:
> Hello
> 
> Thanks for sending the patch. Please find my comments inline below.
> 
> 
> On 24/07/2026 10:40, Kohei Enju wrote:
> > Introduce the KVM_ARM_RMI_CONFIG ioctl to allow userspace to configure
> > Realm VM parameters before the Realm is created.
> 
> This approach is something we tried in the past. Another option is to
> add these as kvm_device_attr for the KVM VM, under a new group, e.g.,
> KVM_ARM_VM_RMI_CTRL and add the following attributes :
> 
> KVM_ARM_VM_RMI_CTRL_RPV 		-> Realm Personalization Value
> KVM_ARM_VM_RMI_CTRL_MEASUREMENT_ALGO	-> Measuerment algo
> KVM_ARM_VM_RMI_CTRL_MEC_PRIVATE		-> Private MEC Policy. By default to shared
> ?

Hi Suzuki, thanks for suggesting another option. That looks good to me,
and I'd be happy with either approach.
Anyway I'd like to wait for feedback from the maintainers and other
reviewers.

Thanks,
Kohei

> 
> 
> Marc, Oliver, thoughts ?
> 
> Cheers
> Suzuki
> 
> > 
> > Currently, ARM_RMI_CFG_MEC_POLICY is the only supported configuration
> > item. Its value can be ARM_RMI_MEC_POLICY_SHARED or
> > ARM_RMI_MEC_POLICY_PRIVATE. Reject the private policy if the platform
> > does not support private MECs.
> > 
> > If userspace does not explicitly configure the MEC policy,
> > ARM_RMI_MEC_POLICY_SHARED is used by default.
> 
> 
> 
> > 
> > Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> > ---
> >   Documentation/virt/kvm/api.rst   | 29 +++++++++++++++++++++++++++++
> >   arch/arm64/include/asm/kvm_rmi.h |  4 ++++
> >   arch/arm64/kvm/arm.c             |  9 +++++++++
> >   arch/arm64/kvm/rmi.c             | 29 +++++++++++++++++++++++++++++
> >   drivers/firmware/arm_rmm/rmi.c   |  8 ++++++--
> >   include/linux/arm-rmi-cmds.h     |  1 +
> >   include/uapi/linux/kvm.h         | 17 +++++++++++++++++
> >   7 files changed, 95 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 85bec9b4f021..e1c660e5eb34 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6690,6 +6690,35 @@ populated data is hashed and added to the guest's Realm Initial Measurement
> >   (RIM) stored by the RMM. This can then be retrieved by the guest (using the RSI
> >   interface) to present to an attestation server.
> > +4.147 KVM_ARM_RMI_CONFIG
> > +------------------------
> > +
> > +:Capability: KVM_CAP_ARM_RMI
> > +:Architectures: arm64
> > +:Type: vm ioctl
> > +:Parameters: struct kvm_arm_rmi_config (in)
> > +:Returns: 0 on success, < 0 on error
> > +
> > +::
> > +
> > +  struct kvm_arm_rmi_config {
> > +       __u32 cfg;
> > +       union {
> > +               /* cfg == ARM_RMI_CFG_MEC_POLICY */
> > +               __u8 mec_policy;
> > +
> > +               /* Fix the size of the union */
> > +               __u8 reserved[256];
> > +       };
> > +  };
> > +
> > +Configures parameters of a Realm VM before the Realm is created.
> > +
> > +Currently, `ARM_RMI_CFG_MEC_POLICY` is the only supported configuration item.
> > +`mec_policy` must be either `ARM_RMI_MEC_POLICY_SHARED` or
> > +`ARM_RMI_MEC_POLICY_PRIVATE`. `ARM_RMI_MEC_POLICY_PRIVATE` is not supported if
> > +no private MEC is available on the platform.
> > +
> >   .. _kvm_run:
> >   5. The kvm_run structure
> > diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> > index 420e99fca07e..721033b132e1 100644
> > --- a/arch/arm64/include/asm/kvm_rmi.h
> > +++ b/arch/arm64/include/asm/kvm_rmi.h
> > @@ -60,6 +60,7 @@ enum realm_state {
> >    * @ia_bits: Number of valid Input Address bits in the IPA
> >    * @stage2_unmapped: The Realm stage-2 mappings have been removed
> >    * @rtts_destroyed: The non-root RTTs have been torn down
> > + * @mec_policy: MEC policy for the Realm VM
> >    */
> >   struct realm {
> >   	void *rd;
> > @@ -76,6 +77,7 @@ struct realm {
> >   	unsigned int ia_bits;
> >   	bool stage2_unmapped;
> >   	bool rtts_destroyed;
> > +	unsigned int mec_policy;
> >   };
> >   /**
> > @@ -115,6 +117,8 @@ struct kvm_arm_rmi_populate;
> >   int kvm_arm_rmi_populate(struct kvm *kvm,
> >   			 struct kvm_arm_rmi_populate *arg);
> > +struct kvm_arm_rmi_config;
> > +int kvm_arm_rmi_config(struct kvm *kvm, struct kvm_arm_rmi_config *arg);
> >   void kvm_realm_unmap_range(struct kvm *kvm,
> >   			   unsigned long ipa,
> >   			   unsigned long size,
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3862db30779f..17302ba2844c 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2169,6 +2169,15 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> >   			return -EFAULT;
> >   		return ret;
> >   	}
> > +	case KVM_ARM_RMI_CONFIG: {
> > +		struct kvm_arm_rmi_config cfg;
> > +
> > +		if (!kvm_is_realm(kvm))
> > +			return -ENXIO;
> > +		if (copy_from_user(&cfg, argp, sizeof(cfg)))
> > +			return -EFAULT;
> > +		return kvm_arm_rmi_config(kvm, &cfg);
> > +	}
> >   	default:
> >   		return -EINVAL;
> >   	}
> > diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> > index 06cc85fb5092..629dea5e8c47 100644
> > --- a/arch/arm64/kvm/rmi.c
> > +++ b/arch/arm64/kvm/rmi.c
> > @@ -572,6 +572,9 @@ static int realm_create_rd(struct kvm *kvm)
> >   	if (kvm_lpa2_is_enabled())
> >   		params->flags0 |= RMI_REALM_PARAM_FLAG_LPA2;
> > +	params->flags0 |= FIELD_PREP(RMI_REALM_PARAM_FLAG_MEC_POLICY,
> > +				     realm->mec_policy);
> > +
> >   	r = realm_init_sve_param(kvm, params);
> >   	if (r)
> >   		goto out_undelegate_tables;
> > @@ -1155,6 +1158,30 @@ int kvm_arm_rmi_populate(struct kvm *kvm,
> >   	return ret;
> >   }
> > +int kvm_arm_rmi_config(struct kvm *kvm, struct kvm_arm_rmi_config *cfg)
> > +{
> > +	guard(mutex)(&kvm->arch.config_lock);
> > +
> > +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
> > +		return -EBUSY;
> > +
> > +	switch (cfg->cfg) {
> > +	case ARM_RMI_CFG_MEC_POLICY:
> > +		if (cfg->mec_policy != ARM_RMI_MEC_POLICY_SHARED &&
> > +		    cfg->mec_policy != ARM_RMI_MEC_POLICY_PRIVATE)
> > +			return -EINVAL;
> > +
> > +		if (cfg->mec_policy == ARM_RMI_MEC_POLICY_PRIVATE &&
> > +		    rmi_mec_count() == 0)
> > +			return -EOPNOTSUPP;
> > +
> > +		kvm->arch.realm.mec_policy = cfg->mec_policy;
> > +		return 0;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> >   static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
> >   {
> >   	struct kvm *kvm = vcpu->kvm;
> > @@ -1474,6 +1501,8 @@ int kvm_init_realm(struct kvm *kvm)
> >   {
> >   	struct realm *realm = &kvm->arch.realm;
> > +	realm->mec_policy = ARM_RMI_MEC_POLICY_SHARED;
> > +
> >   	realm->params = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> >   	realm->sro = kmalloc_obj(*realm->sro);
> >   	if (!realm->params || !realm->sro) {
> > diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> > index d0c083bdf251..e9632c35e7db 100644
> > --- a/drivers/firmware/arm_rmm/rmi.c
> > +++ b/drivers/firmware/arm_rmm/rmi.c
> > @@ -14,8 +14,7 @@
> >   static bool arm64_rmi_is_available;
> > -/* Currently only the first 2 registers are used by Linux */
> > -#define RMI_FEAT_REG_COUNT	2
> > +#define RMI_FEAT_REG_COUNT	5
> >   static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
> >   unsigned long rmi_feat_reg(unsigned long id)
> > @@ -27,6 +26,11 @@ unsigned long rmi_feat_reg(unsigned long id)
> >   }
> >   EXPORT_SYMBOL_GPL(rmi_feat_reg);
> > +u64 rmi_mec_count(void)
> > +{
> > +	return u64_get_bits(rmi_feat_reg(4), RMI_FEATURE_REGISTER_4_MEC_COUNT);
> > +}
> > +
> >   int rmi_delegate_range(phys_addr_t phys,
> >   		       unsigned long size,
> >   		       phys_addr_t *out_phys)
> > diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> > index 138983ab4e3c..5236600421c6 100644
> > --- a/include/linux/arm-rmi-cmds.h
> > +++ b/include/linux/arm-rmi-cmds.h
> > @@ -28,6 +28,7 @@ struct rmi_sro_state {
> >   };
> >   unsigned long rmi_feat_reg(unsigned long id);
> > +u64 rmi_mec_count(void);
> >   int rmi_delegate_range(phys_addr_t phys, unsigned long size,
> >   		       phys_addr_t *out_phys);
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index adee3936d6ae..46e62327957c 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1704,4 +1704,21 @@ struct kvm_arm_rmi_populate {
> >   	__u32 reserved;
> >   };
> > +#define KVM_ARM_RMI_CONFIG     _IOW(KVMIO, 0xd8, struct kvm_arm_rmi_config)
> > +
> > +#define ARM_RMI_CFG_MEC_POLICY		0
> > +#define ARM_RMI_MEC_POLICY_SHARED	0
> > +#define ARM_RMI_MEC_POLICY_PRIVATE	1
> > +
> > +struct kvm_arm_rmi_config {
> > +	__u32 cfg;
> > +	union {
> > +		/* cfg == ARM_RMI_CFG_MEC_POLICY */
> > +		__u8 mec_policy;
> > +
> > +		/* Reserve space for future configuration payloads. */
> > +		__u8 reserved[256];
> > +	};
> > +};
> > +
> >   #endif /* __LINUX_KVM_H */
> 
