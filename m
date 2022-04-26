From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
Date: Tue, 26 Apr 2022 12:33:28 -0700
Message-ID: <CAJD7tkZ-mrhCXoR0ZONjJ7kuAuzWED8Dcjkw6mv812-3uSo_Cg@mail.gmail.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com> <874k2falbk.wl-maz@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HdglKt24ulKLWyX0LsILT516ozly9pUWvxRymOVkqGI=;
        b=D9ihhOYCzfSq6PHe75gU3OheUI3W9iH7N3JyrClUp6au/zHYy/RjIQ+jFjvmiw3I9o
         uU7o/2RsJb0OvTjqDki2JlEYfTgugeTS76dPfA3259nEGmWh42vCXrHa6/5V7/2johUN
         +QaWhuSllkcd3/yIwhHQc0dL4v+1u2xt3a0+X1HNRFS3ddbQntWN7TwV79pXNZP4tjWY
         q9oDYLmA6GmRpsibkQ3SJm8PJsmjU0ySPtDfndPYlEEAFXG22uifNwS/0VoF2zqchWyZ
         YeBZmMfcWMAOzmPfGY/zoiJYCO20nTusS/8yz+ffjxEMcUZ2DMbLY7V/1myPVVFJC4B1
         X+8g==
In-Reply-To: <874k2falbk.wl-maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huacai Chen <chenhuacai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksandar Markovic <aleksandar.qemu.devel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anup Patel <anup-aa5cPYPs4nSSZfiimGR9Ow@public.gmane.org>, Atish Patra <atishp-WKKQYwWt7ev9JmXXK+q4OQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Shameer Kolothum <shameerali.kolothum.thodi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Alexandru Elisei <alexandru.elisei@arm.>

Thanks a lot for taking the time to look at this!

On Tue, Apr 26, 2022 at 8:58 AM Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Tue, 26 Apr 2022 06:39:02 +0100,
> Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Count the pages used by KVM in arm64 for page tables in pagetable stats.
> >
> > Account pages allocated for PTEs in pgtable init functions and
> > kvm_set_table_pte().
> >
> > Since most page table pages are freed using put_page(), add a helper
> > function put_pte_page() that checks if this is the last ref for a pte
> > page before putting it, and unaccounts stats accordingly.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/arm64/kernel/image-vars.h |  3 ++
> >  arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
> >  2 files changed, 34 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 241c86b67d01..25bf058714f6 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -143,6 +143,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
> >  /* pKVM static key */
> >  KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
> >
> > +/* Called by kvm_account_pgtable_pages() to update pagetable stats */
> > +KVM_NVHE_ALIAS(__mod_lruvec_page_state);
>
> This cannot be right. It means that this function will be called
> directly from the EL2 code when in protected mode, and will result in
> extreme fireworks.  There is no way you can call core kernel stuff
> like this from this context.
>
> Please do not add random symbols to this list just for the sake of
> being able to link the kernel.

Excuse my ignorance, this is my first time touching kvm code. Thanks a
lot for pointing this out.

>
> > +
> >  #endif /* CONFIG_KVM */
> >
> >  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 2cb3867eb7c2..53e13c3313e9 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -152,6 +152,7 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> >
> >       WARN_ON(kvm_pte_valid(old));
> >       smp_store_release(ptep, pte);
> > +     kvm_account_pgtable_pages((void *)childp, +1);
>
> Why the + sign?

I am following conventions in other existing stat accounting hooks
(e.g. kvm_mod_used_mmu_pages(vcpu->kvm, +1) call in
arch/x86/kvm/mmu/mmu.c), but I can certainly remove it if you think
this is better.

>
> >  }
> >
> >  static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
> > @@ -326,6 +327,14 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
> >       return ret;
> >  }
> >
> > +static void put_pte_page(kvm_pte_t *ptep, struct kvm_pgtable_mm_ops *mm_ops)
> > +{
> > +     /* If this is the last page ref, decrement pagetable stats first. */
> > +     if (!mm_ops->page_count || mm_ops->page_count(ptep) == 1)
> > +             kvm_account_pgtable_pages((void *)ptep, -1);
> > +     mm_ops->put_page(ptep);
> > +}
> > +
> >  struct hyp_map_data {
> >       u64                             phys;
> >       kvm_pte_t                       attr;
> > @@ -488,10 +497,10 @@ static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >
> >       dsb(ish);
> >       isb();
> > -     mm_ops->put_page(ptep);
> > +     put_pte_page(ptep, mm_ops);
> >
> >       if (childp)
> > -             mm_ops->put_page(childp);
> > +             put_pte_page(childp, mm_ops);
> >
> >       return 0;
> >  }
> > @@ -522,6 +531,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
> >       pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
> >       if (!pgt->pgd)
> >               return -ENOMEM;
> > +     kvm_account_pgtable_pages((void *)pgt->pgd, +1);
> >
> >       pgt->ia_bits            = va_bits;
> >       pgt->start_level        = KVM_PGTABLE_MAX_LEVELS - levels;
> > @@ -541,10 +551,10 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >       if (!kvm_pte_valid(pte))
> >               return 0;
> >
> > -     mm_ops->put_page(ptep);
> > +     put_pte_page(ptep, mm_ops);
> >
> >       if (kvm_pte_table(pte, level))
> > -             mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
> > +             put_pte_page(kvm_pte_follow(pte, mm_ops), mm_ops);
>
> OK, I see the pattern. I don't think this workable as such. I'd rather
> the callbacks themselves (put_page, zalloc_page*) call into the
> accounting code when it makes sense, rather than spreading the
> complexity and having to special case the protected case.
>

This makes sense. I am working on moving calls to
kvm_account_pgtable_pages to callbacks in mmu.c in the next version
(stage2_memcache_zalloc_page, kvm_host_put_page, etc).


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
