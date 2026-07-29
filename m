Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBE3476060;
	Wed, 29 Jul 2026 11:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325668; cv=none; b=qhiFSRJ+pOD91nlk1u3VSLkaN1rNWPXy7R2lPpSqW5XnRVfklQYTY4S7jLWzgLF1VdZcfi5UCWnerQeUBjHhnaMqJ1i7DEHIGo3U3NXuHc0mvQBK6kRMajvSPn2Lyx636l4ETCra6hddedEIUuOTHPa1ubZnTYvLi9tJ6DirBqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325668; c=relaxed/simple;
	bh=HkMBCAbmrFXEE9kGoDxmwgXunRUkZppUwPpF/BM2mLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bUvF+cV2y20TPqRArRtbFZXhC64y+fOwIsTGdpUZyq6Q05xBMuXvDuyBnzXigXSwmjAx3pSgWO7cR984YdQujQhgCH1TJsBzIpehp2gJwbgR+xwrXRQlr/F7IaJcJUO3ubBOg6qmrc0FvjjQMc94FiChXyPhAmUk4OarSmIa34U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=foOyvk/Y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="foOyvk/Y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8E451688;
	Wed, 29 Jul 2026 04:47:38 -0700 (PDT)
Received: from [10.57.41.95] (unknown [10.57.41.95])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D41B3F86F;
	Wed, 29 Jul 2026 04:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785325662; bh=HkMBCAbmrFXEE9kGoDxmwgXunRUkZppUwPpF/BM2mLc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=foOyvk/YD/P95lT4XBdQFEDSgKrdW1PrQdmQte8+Y35jd52iLmQuPsHa0I04DfSf3
	 yi4Fav4yfIXUVnjQe94RgJknoDy3rZA2Z/wsaxmWL4A2FqTGl0Ss7YDQefTBxG7Pko
	 FN0P5I3VJuZsYk/v0ht6CwjWiMuM25bgL1xmchfo=
Message-ID: <46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com>
Date: Wed, 29 Jul 2026 12:47:38 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
Content-Language: en-GB
To: Kohei Enju <enju.kohei@fujitsu.com>,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Steven Price <steven.price@arm.com>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-2-enju.kohei@fujitsu.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260724094120.166536-2-enju.kohei@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello

Thanks for sending the patch. Please find my comments inline below.


On 24/07/2026 10:40, Kohei Enju wrote:
> Introduce the KVM_ARM_RMI_CONFIG ioctl to allow userspace to configure
> Realm VM parameters before the Realm is created.

This approach is something we tried in the past. Another option is to
add these as kvm_device_attr for the KVM VM, under a new group, e.g.,
KVM_ARM_VM_RMI_CTRL and add the following attributes :

KVM_ARM_VM_RMI_CTRL_RPV 		-> Realm Personalization Value
KVM_ARM_VM_RMI_CTRL_MEASUREMENT_ALGO	-> Measuerment algo
KVM_ARM_VM_RMI_CTRL_MEC_PRIVATE		-> Private MEC Policy. By default to 
shared ?


Marc, Oliver, thoughts ?

Cheers
Suzuki

> 
> Currently, ARM_RMI_CFG_MEC_POLICY is the only supported configuration
> item. Its value can be ARM_RMI_MEC_POLICY_SHARED or
> ARM_RMI_MEC_POLICY_PRIVATE. Reject the private policy if the platform
> does not support private MECs.
> 
> If userspace does not explicitly configure the MEC policy,
> ARM_RMI_MEC_POLICY_SHARED is used by default.



> 
> Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> ---
>   Documentation/virt/kvm/api.rst   | 29 +++++++++++++++++++++++++++++
>   arch/arm64/include/asm/kvm_rmi.h |  4 ++++
>   arch/arm64/kvm/arm.c             |  9 +++++++++
>   arch/arm64/kvm/rmi.c             | 29 +++++++++++++++++++++++++++++
>   drivers/firmware/arm_rmm/rmi.c   |  8 ++++++--
>   include/linux/arm-rmi-cmds.h     |  1 +
>   include/uapi/linux/kvm.h         | 17 +++++++++++++++++
>   7 files changed, 95 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 85bec9b4f021..e1c660e5eb34 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6690,6 +6690,35 @@ populated data is hashed and added to the guest's Realm Initial Measurement
>   (RIM) stored by the RMM. This can then be retrieved by the guest (using the RSI
>   interface) to present to an attestation server.
>   
> +4.147 KVM_ARM_RMI_CONFIG
> +------------------------
> +
> +:Capability: KVM_CAP_ARM_RMI
> +:Architectures: arm64
> +:Type: vm ioctl
> +:Parameters: struct kvm_arm_rmi_config (in)
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_arm_rmi_config {
> +       __u32 cfg;
> +       union {
> +               /* cfg == ARM_RMI_CFG_MEC_POLICY */
> +               __u8 mec_policy;
> +
> +               /* Fix the size of the union */
> +               __u8 reserved[256];
> +       };
> +  };
> +
> +Configures parameters of a Realm VM before the Realm is created.
> +
> +Currently, `ARM_RMI_CFG_MEC_POLICY` is the only supported configuration item.
> +`mec_policy` must be either `ARM_RMI_MEC_POLICY_SHARED` or
> +`ARM_RMI_MEC_POLICY_PRIVATE`. `ARM_RMI_MEC_POLICY_PRIVATE` is not supported if
> +no private MEC is available on the platform.
> +
>   .. _kvm_run:
>   
>   5. The kvm_run structure
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 420e99fca07e..721033b132e1 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -60,6 +60,7 @@ enum realm_state {
>    * @ia_bits: Number of valid Input Address bits in the IPA
>    * @stage2_unmapped: The Realm stage-2 mappings have been removed
>    * @rtts_destroyed: The non-root RTTs have been torn down
> + * @mec_policy: MEC policy for the Realm VM
>    */
>   struct realm {
>   	void *rd;
> @@ -76,6 +77,7 @@ struct realm {
>   	unsigned int ia_bits;
>   	bool stage2_unmapped;
>   	bool rtts_destroyed;
> +	unsigned int mec_policy;
>   };
>   
>   /**
> @@ -115,6 +117,8 @@ struct kvm_arm_rmi_populate;
>   
>   int kvm_arm_rmi_populate(struct kvm *kvm,
>   			 struct kvm_arm_rmi_populate *arg);
> +struct kvm_arm_rmi_config;
> +int kvm_arm_rmi_config(struct kvm *kvm, struct kvm_arm_rmi_config *arg);
>   void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long ipa,
>   			   unsigned long size,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3862db30779f..17302ba2844c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2169,6 +2169,15 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   			return -EFAULT;
>   		return ret;
>   	}
> +	case KVM_ARM_RMI_CONFIG: {
> +		struct kvm_arm_rmi_config cfg;
> +
> +		if (!kvm_is_realm(kvm))
> +			return -ENXIO;
> +		if (copy_from_user(&cfg, argp, sizeof(cfg)))
> +			return -EFAULT;
> +		return kvm_arm_rmi_config(kvm, &cfg);
> +	}
>   	default:
>   		return -EINVAL;
>   	}
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 06cc85fb5092..629dea5e8c47 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -572,6 +572,9 @@ static int realm_create_rd(struct kvm *kvm)
>   	if (kvm_lpa2_is_enabled())
>   		params->flags0 |= RMI_REALM_PARAM_FLAG_LPA2;
>   
> +	params->flags0 |= FIELD_PREP(RMI_REALM_PARAM_FLAG_MEC_POLICY,
> +				     realm->mec_policy);
> +
>   	r = realm_init_sve_param(kvm, params);
>   	if (r)
>   		goto out_undelegate_tables;
> @@ -1155,6 +1158,30 @@ int kvm_arm_rmi_populate(struct kvm *kvm,
>   	return ret;
>   }
>   
> +int kvm_arm_rmi_config(struct kvm *kvm, struct kvm_arm_rmi_config *cfg)
> +{
> +	guard(mutex)(&kvm->arch.config_lock);
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
> +		return -EBUSY;
> +
> +	switch (cfg->cfg) {
> +	case ARM_RMI_CFG_MEC_POLICY:
> +		if (cfg->mec_policy != ARM_RMI_MEC_POLICY_SHARED &&
> +		    cfg->mec_policy != ARM_RMI_MEC_POLICY_PRIVATE)
> +			return -EINVAL;
> +
> +		if (cfg->mec_policy == ARM_RMI_MEC_POLICY_PRIVATE &&
> +		    rmi_mec_count() == 0)
> +			return -EOPNOTSUPP;
> +
> +		kvm->arch.realm.mec_policy = cfg->mec_policy;
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>   static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm *kvm = vcpu->kvm;
> @@ -1474,6 +1501,8 @@ int kvm_init_realm(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
>   
> +	realm->mec_policy = ARM_RMI_MEC_POLICY_SHARED;
> +
>   	realm->params = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>   	realm->sro = kmalloc_obj(*realm->sro);
>   	if (!realm->params || !realm->sro) {
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index d0c083bdf251..e9632c35e7db 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -14,8 +14,7 @@
>   
>   static bool arm64_rmi_is_available;
>   
> -/* Currently only the first 2 registers are used by Linux */
> -#define RMI_FEAT_REG_COUNT	2
> +#define RMI_FEAT_REG_COUNT	5
>   static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
>   
>   unsigned long rmi_feat_reg(unsigned long id)
> @@ -27,6 +26,11 @@ unsigned long rmi_feat_reg(unsigned long id)
>   }
>   EXPORT_SYMBOL_GPL(rmi_feat_reg);
>   
> +u64 rmi_mec_count(void)
> +{
> +	return u64_get_bits(rmi_feat_reg(4), RMI_FEATURE_REGISTER_4_MEC_COUNT);
> +}
> +
>   int rmi_delegate_range(phys_addr_t phys,
>   		       unsigned long size,
>   		       phys_addr_t *out_phys)
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index 138983ab4e3c..5236600421c6 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -28,6 +28,7 @@ struct rmi_sro_state {
>   };
>   
>   unsigned long rmi_feat_reg(unsigned long id);
> +u64 rmi_mec_count(void);
>   
>   int rmi_delegate_range(phys_addr_t phys, unsigned long size,
>   		       phys_addr_t *out_phys);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index adee3936d6ae..46e62327957c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1704,4 +1704,21 @@ struct kvm_arm_rmi_populate {
>   	__u32 reserved;
>   };
>   
> +#define KVM_ARM_RMI_CONFIG     _IOW(KVMIO, 0xd8, struct kvm_arm_rmi_config)
> +
> +#define ARM_RMI_CFG_MEC_POLICY		0
> +#define ARM_RMI_MEC_POLICY_SHARED	0
> +#define ARM_RMI_MEC_POLICY_PRIVATE	1
> +
> +struct kvm_arm_rmi_config {
> +	__u32 cfg;
> +	union {
> +		/* cfg == ARM_RMI_CFG_MEC_POLICY */
> +		__u8 mec_policy;
> +
> +		/* Reserve space for future configuration payloads. */
> +		__u8 reserved[256];
> +	};
> +};
> +
>   #endif /* __LINUX_KVM_H */

