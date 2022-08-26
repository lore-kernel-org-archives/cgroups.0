From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Date: Fri, 26 Aug 2022 20:20:00 +0000
Message-ID: <Ywkq8HYyTI1eStSO@google.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-4-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Yy3h91/LZL0yMN3Y+gPnYCc8uzqqu6+PEMw/uYOkvrQ=;
        b=QI2iqRq9/94E6zl7r9mZw4F+7Daqhq8WErAzs7MCXRZvrz4GpEbY7Dstc+ZZ2JEyb2
         q0xcA8xKqPk01eYmQLRlBIm9I9enL9gle1pvxTgv3hEVqdUw5C4cSi7lwuKtIjcxf5KZ
         MNemfeMqo0zzfRvxEdPkaXJq+V0CXBJoNhrKZhmH2a/6fEvyddf2Pci6F7c3hz5Uh2KZ
         p9XfmAZB3QDZNhI51WLuUsrX5a34H43X0h0MgNESMM7lb3mZRO5lRiW8QfXtTjK0Iio8
         Bx/faeNKIHAHpdLZt2Qt47/Jnw19TxwGoB6eZJ5V4qbulyod0s+zhEZ6nWzqexbUBQl1
         6MGQ==
Content-Disposition: inline
In-Reply-To: <20220823004639.2387269-4-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWNGWvitb5QawA@public.gmane.org

On Tue, Aug 23, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 in memory stats under secondary
> pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> visibility into the memory consumption of KVM mmu in a similar way to
> how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e418ef3ecfcb..4d38e4eba772 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1665,6 +1665,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
>  	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
>  }
>  
> +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, +1);
> +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> +}
> +
> +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, -1);
> +	kvm_account_pgtable_pages((void *)sp->spt, -1);
> +}

Hrm, this is causing build on x86 issues for me.  AFAICT, modpost doesn't detect
that this creates a new module dependency on __mod_lruvec_page_state() and so doesn't
refresh vmlinux.symvers.

  ERROR: modpost: "__mod_lruvec_page_state" [arch/x86/kvm/kvm.ko] undefined!
  make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
  make[1]: *** [Makefile:1769: modules] Error 2
  make[1]: *** Waiting for unfinished jobs....
  Kernel: arch/x86/boot/bzImage is ready  (#128)
  make[1]: Leaving directory '/usr/local/google/home/seanjc/build/kernel/vm'
  make: *** [Makefile:222: __sub-make] Error 2

Both gcc and clang yield the same behavior, so I doubt it's the compiler doing
something odd.  Cleaning the build makes the problem go away, but that's a poor
band-aid.

If I squash this with the prior patch that adds kvm_account_pgtable_pages() to
kvm_host.h, modpost detects the need to refresh and all is well.

Given that ARM doesn't support building KVM as a module, i.e. can't run afoul
of whatever modpost weirdness I'm hitting, I'm inclined to squash this with the
previous patch and punt on the modpost issue so that we can get this merged.

Any objections?  Or thoughts on what's going wrong?
