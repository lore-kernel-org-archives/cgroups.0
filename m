From: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Thu, 7 Jul 2022 20:59:41 +0000
Message-ID: <YsdJPeVOqlj4cf2a@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A5MhBcXf8LVQ9gbV4fE8wcZW4gjzBdDH9411SgBm9nA=;
        b=JZQC6m6xR5sT0Jada7pN2ctPDZoVBgPNmsmVFV9xaOD0K1VcjdaDGI+Dbb9m6z+j0M
         HQZao2MwdnxdUCyFyWlgXqE0vhn5k0x3cFJEqeUSkVEsaLaami6rP5dYbVbdIFtecFK0
         bszrtlQ/BBq6HtrtoG8nU1E+PvhE0lLr6U7Movo+h1ZN1VwhTvdz1ZHCpBxehT1XrGLp
         ldw665ro4GytFHnalr0o9hUTUOKVZe4kPdeCD4oNOEE/cifAyBR7BH7HyjVvjpbMGLv/
         wuBFBMUf1JFMK20mDchKuifuX9NzhPRD+zMlfMD3Uo00M9pihW0RWuo1fPBLXJlg8Qnc
         EHBQ==
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>, Huang@google.com, Shaoqin <shaoqin.huang@intel.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infr

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> We keep track of several kernel memory stats (total kernel memory, page
> tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> per-memcg, etc). These stats give insights to users to how much memory
> is used by the kernel and for what purposes.
> 
> Currently, memory used by kvm mmu is not accounted in any of those

Nit, capitalize KVM (mainly to be consistent).

> @@ -1085,6 +1086,9 @@ KernelStack
>                Memory consumed by the kernel stacks of all tasks
>  PageTables
>                Memory consumed by userspace page tables
> +SecPageTables
> +              Memory consumed by secondary page tables, this currently
> +	      currently includes KVM mmu allocations on x86 and arm64.

Nit, this line has a tab instead of eight spaces.  Not sure if it actually matters,
there are plenty of tabs elsewhere in the file, but all the entries in this block
use only spaces.

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index aab70355d64f3..13190d298c986 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -216,6 +216,7 @@ enum node_stat_item {
>  	NR_KERNEL_SCS_KB,	/* measured in KiB */
>  #endif
>  	NR_PAGETABLE,		/* used for pagetables */
> +	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */

Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
is messy, so I totally understand why you included it, but in this case it's unnecessary
and potentially confusing.

And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
(using IS_ENABLED() because KVM can be built as a module)?  That could be removed
if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
stats the depend on a single feature seems to be the status quo for this code.

>  #ifdef CONFIG_SWAP
>  	NR_SWAPCACHE,
>  #endif
