Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795532911;
	b=Gy3+lyBvuMXLgizr+d7hMJu9RHF90zMk+wg/zrfY2u+IeKXU9EAF9m9TXSh9nhmMVUBW
	 JTNWSiGY6MlFH8xqLS/BiuMFzm9wlelKGCiExCGe+qVkLrlwDtlB8j5o6CuQ8s0A9XEho
	 99P2mj4D9NS7/ALUkRicr2OJv5GBM6NPfRDvd080vLU1xRCwcPBdj0/m+nlSEE5cgUCYB
	 aGgIsPYLyl6njAmrpuXrCDSoGlpppArtFT8ffExYUpMOurozWT5aUA/UrwXrTiKsD9pJW
	 dN27tlvgw9Vm+ICNKEYzFBefFJHBlCFYiuf4qhln7o0+B2CJSLtOylkYPF73rkqAWXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795532911;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=wq60eIxGFtR5MCIfyvCnDnihf6Q7VyfR4aAjbX1daU8=;
	b=vSUVjEi+QTW3ltIJQy5W4jc7V/Rc/5VF5lJL0OH8y7tQyP/qLG6DIwXmbEx46ZyC7vmK
	 B5hwqjbkvZ+76vTKQvQpflFFZdxM93D7sotUdS1kjy5akR0LMfV9UvGoVjGhsr+dcsEhz
	 uzhrMNAE2p+8FBvU+APi0DXtUS72kPNwnjaDg0s634M7i8DEdZqbOpwSqEIPqHlAhuOgM
	 em1AV4XAqiGOz16Js4WYTbAA5NxgyMl8IWL/l7c1JZ1DsF44k8rgmORXwcLSrFi9+B53G
	 ruDd5ELjWe+EXX7bUF/qBChy0ICAdf/luFnfNpylu/c78y2kD2qt8/joQKl75UywZmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LTQHz82v;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A10606A321;
	Tue, 24 Nov 2026 15:08:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39A10606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LTQHz82v
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A4C4339;
	Tue, 24 Nov 2026 07:08:26 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD8013F763;
	Tue, 24 Nov 2026 07:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795532909; bh=iRlHeZwlJBUmCWo6yrgiKKtkerHyE2dksVsYRvvTjXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LTQHz82v2MMhRZa2+kkNDv3Dm80KyUhpVlFfWiQhnEiLCftSAmOBBSjtRCK7bheBA
	 Me1w2DvhHEPrwKhkI0Px3LCTTKLeMh36O60GtvpxUHI5mXMHEeIPP8T2g7MVKnevA3
	 r6CSDoDpkzlGFnZ9KJYr+ap3IP7r/ghNKtx5Sj+8=
Message-ID: <090662ee-0d8d-48b5-83f2-8a4d225bef08@arm.com>
Date: Tue, 24 Nov 2026 15:08:25 +0000
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/2] KVM: arm64: CCA: Add support for configuring
 the Realm MEC policy
To: Kohei Enju <enju.kohei@fujitsu.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 cgroups@vger.kernel.org
References: <20261112-mm-v1-mec-v2-0-0d1dd260a588@fujitsu.com>
 <20261112-mm-v1-mec-v2-1-0d1dd260a588@fujitsu.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261112-mm-v1-mec-v2-1-0d1dd260a588@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/2026 03:36, Kohei Enju wrote:
> Introduce the KVM_ARM_VM_RMI_CTRL device attribute group to allow
> userspace to configure Realm VM parameters before the Realm is created
> using KVM_SET_DEVICE_ATTR.
> 
> Currently, KVM_ARM_VM_RMI_CTRL_MEC_POLICY is the only supported
> attribute. Its value can be KVM_ARM_VM_RMI_MEC_POLICY_SHARED or
> KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE. Reject the private policy if the
> platform does not support private MECs.
> 
> If userspace does not explicitly configure the MEC policy,
> KVM_ARM_VM_RMI_MEC_POLICY_SHARED is used by default.
> 
> Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> ---
>   Documentation/virt/kvm/devices/vm.rst   | 25 +++++++++++++++
>   arch/arm64/include/asm/kvm_rmi.h        |  5 +++
>   arch/arm64/include/uapi/asm/kvm.h       |  4 +++
>   arch/arm64/kvm/arm.c                    |  4 +++
>   arch/arm64/kvm/rmi.c                    | 57 +++++++++++++++++++++++++++++++++
>   drivers/firmware/arm_rmm/rmi.c          |  6 ++++
>   include/linux/arm-rmi-cmds.h            |  1 +
>   tools/arch/arm64/include/uapi/asm/kvm.h |  4 +++
>   8 files changed, 106 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
> index 78e63eb9994e..b0bd30750aa1 100644
> --- a/Documentation/virt/kvm/devices/vm.rst
> +++ b/Documentation/virt/kvm/devices/vm.rst
> @@ -418,3 +418,28 @@ will reject attempts to define a filter for any portion of these ranges:
>           0x8000_0000 0x8000_FFFF
>           0xC000_0000 0xC000_FFFF
>           =========== ===============
> +
> +7. GROUP: KVM_ARM_VM_RMI_CTRL
> +=============================
> +
> +:Architectures: arm64
> +
> +7.1. ATTRIBUTE: KVM_ARM_VM_RMI_CTRL_MEC_POLICY (w/o)
> +----------------------------------------------------
> +
> +:Parameters: Pointer to a ``__u8`` value
> +
> +:Returns:
> +
> +  =========  ===========================================================
> +  ENXIO      The VM is not a Realm VM
> +  EBUSY      The Realm has already been created
> +  EINVAL     Invalid MEC policy value
> +  EOPNOTSUPP Private MEC policy is not supported by the platform
> +  EFAULT     The value could not be copied from userspace
> +  =========  ===========================================================
> +
> +Configures the MEC policy for a Realm VM before the Realm is created. The value
> +must be either ``KVM_ARM_VM_RMI_MEC_POLICY_SHARED`` or
> +``KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE``. If userspace does not explicitly set the
> +MEC policy, ``KVM_ARM_VM_RMI_MEC_POLICY_SHARED`` is used by default.
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 3933f8d834b8..08c1f6d0671d 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -59,6 +59,7 @@ enum realm_state {
>    * @state: The lifetime state machine for the realm
>    * @ia_bits: Number of valid Input Address bits in the IPA
>    * @stage2_unmapped: The Realm stage-2 mappings have been removed
> + * @mec_policy: MEC policy for the Realm VM
>    */
>   struct realm {
>   	void *rd;
> @@ -73,6 +74,7 @@ struct realm {
>   	enum realm_state state;
>   	unsigned int ia_bits;
>   	bool stage2_unmapped;
> +	unsigned int mec_policy;
>   };
>   
>   /**
> @@ -109,9 +111,12 @@ int kvm_realm_teardown_stage2(struct kvm *kvm);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
>   struct kvm_arm_rmi_populate;
> +struct kvm_device_attr;
>   
>   int kvm_arm_rmi_populate(struct kvm *kvm,
>   			 struct kvm_arm_rmi_populate *arg);
> +int kvm_vm_rmi_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
> +int kvm_vm_rmi_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
>   
>   enum kvm_gfn_range_filter;
>   
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 65ee09bd1463..aa1e6fe6192e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -403,6 +403,10 @@ enum {
>   /* Device Control API on vm fd */
>   #define KVM_ARM_VM_SMCCC_CTRL		0
>   #define   KVM_ARM_VM_SMCCC_FILTER	0
> +#define KVM_ARM_VM_RMI_CTRL		1
> +#define   KVM_ARM_VM_RMI_CTRL_MEC_POLICY	0
> +#define     KVM_ARM_VM_RMI_MEC_POLICY_SHARED	0
> +#define     KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE	1
>   
>   /* Device Control API: ARM VGIC */
>   #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8e94f1bff830..be676c13e219 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2329,6 +2329,8 @@ static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>   	switch (attr->group) {
>   	case KVM_ARM_VM_SMCCC_CTRL:
>   		return kvm_vm_smccc_has_attr(kvm, attr);
> +	case KVM_ARM_VM_RMI_CTRL:
> +		return kvm_vm_rmi_has_attr(kvm, attr);
>   	default:
>   		return -ENXIO;
>   	}
> @@ -2339,6 +2341,8 @@ static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>   	switch (attr->group) {
>   	case KVM_ARM_VM_SMCCC_CTRL:
>   		return kvm_vm_smccc_set_attr(kvm, attr);
> +	case KVM_ARM_VM_RMI_CTRL:
> +		return kvm_vm_rmi_set_attr(kvm, attr);
>   	default:
>   		return -ENXIO;
>   	}
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 0d254fb80cde..01ac8d4fec7c 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -7,6 +7,7 @@
>   #include <linux/arm-rmi-cmds.h>
>   #include <linux/kvm_host.h>
>   #include <linux/overflow.h>
> +#include <linux/uaccess.h>
>   
>   #include <asm/daifflags.h>
>   #include <asm/kvm_emulate.h>
> @@ -586,6 +587,9 @@ static int realm_create_rd(struct kvm *kvm)
>   		params->flags0 |= RMI_REALM_PARAM_FLAG_PMU;
>   	}
>   
> +	params->flags0 |= FIELD_PREP(RMI_REALM_PARAM_FLAG_MEC_POLICY_MASK,
> +				    realm->mec_policy);
> +
>   	r = realm_init_sve_param(kvm, params);
>   	if (r)
>   		goto out_undelegate_tables;
> @@ -1481,6 +1485,57 @@ int kvm_arm_rmi_populate(struct kvm *kvm,
>   	return ret;
>   }
>   
> +static int kvm_vm_rmi_set_mec_policy(struct kvm *kvm, u8 policy)
> +{
> +	guard(mutex)(&kvm->arch.config_lock);
> +
> +	if (!kvm_vm_is_realm(kvm))
> +		return -ENXIO;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
> +		return -EBUSY;
> +
> +	if (policy != KVM_ARM_VM_RMI_MEC_POLICY_SHARED &&
> +	    policy != KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE)
> +		return -EINVAL;
> +
> +	if (policy == KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE &&
> +	    rmi_mec_count() == 0)
> +		return -EOPNOTSUPP;
> +
> +	kvm->arch.realm.mec_policy = policy;
> +	return 0;
> +}
> +
> +int kvm_vm_rmi_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	if (!kvm_vm_is_realm(kvm))
> +		return -ENXIO;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VM_RMI_CTRL_MEC_POLICY:

minor nit: Could we reject this if the rmi_mec_count() == 0 ?
Default policy is "shared" mec, as long as it is documented, this
would work only on a system that supports Private MEC.


Suzuki


> +		return 0;
> +	default:
> +		return -ENXIO;
> +	}
> +}
> +
> +int kvm_vm_rmi_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	void __user *uaddr = (void __user *)attr->addr;
> +	u8 policy;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VM_RMI_CTRL_MEC_POLICY:
> +		if (copy_from_user(&policy, uaddr, sizeof(policy)))
> +			return -EFAULT;
> +
> +		return kvm_vm_rmi_set_mec_policy(kvm, policy);
> +	default:
> +		return -ENXIO;
> +	}
> +}
> +
>   static int kvm_create_rec(struct kvm_vcpu *vcpu)
>   {
>   	struct user_pt_regs *vcpu_regs = &vcpu->arch.ctxt.regs;
> @@ -1695,6 +1750,8 @@ int kvm_init_realm(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
>   
> +	realm->mec_policy = KVM_ARM_VM_RMI_MEC_POLICY_SHARED;
> +
>   	realm->sro = kmalloc_obj(*realm->sro);
>   	if (!realm->sro)
>   		return -ENOMEM;
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 77255a90e0a6..27edf060d2d9 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -793,6 +793,12 @@ unsigned long rmi_feat_reg(unsigned int index)
>   }
>   EXPORT_SYMBOL_GPL(rmi_feat_reg);
>   
> +u64 rmi_mec_count(void)
> +{
> +	return u64_get_bits(rmi_feat_reg(4), RMI_FEATURE_REGISTER_4_MEC_COUNT);
> +}
> +EXPORT_SYMBOL_GPL(rmi_mec_count);
> +
>   static int rmi_rmm_config_set(unsigned long cfg_ptr)
>   {
>   	struct arm_smccc_1_2_regs regs = {
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index c13e8775898e..530136ccb791 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -68,6 +68,7 @@ static __always_inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *reg
>   }
>   
>   unsigned long rmi_feat_reg(unsigned int index);
> +u64 rmi_mec_count(void);
>   
>   int rmi_delegate_range(phys_addr_t phys, unsigned long size,
>   		       phys_addr_t *out_phys);
> diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
> index 65ee09bd1463..aa1e6fe6192e 100644
> --- a/tools/arch/arm64/include/uapi/asm/kvm.h
> +++ b/tools/arch/arm64/include/uapi/asm/kvm.h
> @@ -403,6 +403,10 @@ enum {
>   /* Device Control API on vm fd */
>   #define KVM_ARM_VM_SMCCC_CTRL		0
>   #define   KVM_ARM_VM_SMCCC_FILTER	0
> +#define KVM_ARM_VM_RMI_CTRL		1
> +#define   KVM_ARM_VM_RMI_CTRL_MEC_POLICY	0
> +#define     KVM_ARM_VM_RMI_MEC_POLICY_SHARED	0
> +#define     KVM_ARM_VM_RMI_MEC_POLICY_PRIVATE	1
>   
>   /* Device Control API: ARM VGIC */
>   #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> 

