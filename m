From: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
Date: Tue, 26 Apr 2022 07:34:56 +0000
Message-ID: <YmegoB/fBkfwaE5z@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T6uVKqz/bxBh0XcbvcuRA0UyoUPF9VXe65F1cQD8y4Q=;
        b=ObEunFSl4crRLGfpGD9vb4uNjucdcW+SwMC5wjs68ErQM98eX2dd/1bhFqvb4MQrUZ
         aNBQiYOEZs6DAFrjwy4GxIX9P710BE5dNtb9ren8SoNbyoDCq1JSrqMW6bcxyN3g457u
         /+gBpA8szyFlMBKjZqPcqtIcg53tpCAgbfmBRZ+EQiSDL0bYkiLUkJAuAA+ESILGYbW5
         jVcb61+A+66M7v7MKaJKTdQY27E/r9amtlm20dB0rHCxpqld0qjq5eRsqvCmPNleg1uA
         MTGwgfxKApBNNdQAeaBp8qoeybFa8FJ6gos+fYTUTeB4wg78apx7w8FkSb2oMxvxLXSe
         mDTA==
Content-Disposition: inline
In-Reply-To: <20220426053904.3684293-5-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Marc Zyngier <maz@kernel.org>

Hi Yosry,

On Tue, Apr 26, 2022 at 05:39:02AM +0000, Yosry Ahmed wrote:
> Count the pages used by KVM in arm64 for page tables in pagetable stats.
> 
> Account pages allocated for PTEs in pgtable init functions and
> kvm_set_table_pte().
> 
> Since most page table pages are freed using put_page(), add a helper
> function put_pte_page() that checks if this is the last ref for a pte
> page before putting it, and unaccounts stats accordingly.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  arch/arm64/kernel/image-vars.h |  3 ++
>  arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
>  2 files changed, 34 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 241c86b67d01..25bf058714f6 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -143,6 +143,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
>  /* pKVM static key */
>  KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
>  
> +/* Called by kvm_account_pgtable_pages() to update pagetable stats */
> +KVM_NVHE_ALIAS(__mod_lruvec_page_state);
> +
>  #endif /* CONFIG_KVM */
>  
>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 2cb3867eb7c2..53e13c3313e9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -152,6 +152,7 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
>  
>  	WARN_ON(kvm_pte_valid(old));
>  	smp_store_release(ptep, pte);
> +	kvm_account_pgtable_pages((void *)childp, +1);

What page tables do we want to account? KVM on ARM manages several page
tables.

For regular KVM, the host kernel manages allocations for the hyp stage 1
tables in addition to the stage 2 tables used for a particular VM. The
former is system overhead whereas the latter could be attributed to a
guest VM.

I imagine protected KVM is out of scope, since it actually manages its
own allocations outside of the host kernel.

Given this, I would recommend adding the accounting hooks to mmu.c as
that is where we alloc/free table pages and it is in the host address
space. kvm_s2_mm_ops and kvm_hyp_mm_ops point to all the relevant
functions, though the latter is only relevant if we want to count system
page tables too.

--
Thanks,
Oliver
