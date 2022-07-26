From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Date: Tue, 26 Jul 2022 18:03:57 +0000
Message-ID: <YuAsjZbnCN/PrNKw@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-4-yosryahmed@google.com>
 <YtsPk5+hZNMEwT0c@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jhdzRZUAOMTnCV/vW7pBqgsIJIfjNF/pYz/pr69nELI=;
        b=ptd/st7Qx1CEBd6nXVmofsETHlqEG5YHpXzAHoHWMHaxaLqLQRwhFD8DrqTGh313HP
         IhmbQkRu0orlHojxKg773kXGBU90oYKT/i2R8RIWnvFI/6XWjOJwk/NLwViv8Eohzc71
         0u1CxuXzpRO+SKGj4rghNIk24TUgiK6N5EMVsSWyZucFXHEwqrREOemBmRGcO21GlJv+
         BHPELPoCCxRkiXuj0q4tx3KOjfEFuVK8aaztJ92oE13l2AqbgmCf3A+ZhaLe8cNklHQ/
         gZtTgJkayqLParwE71HzxpR93H5vfYmTwDBbX/RNcN9pr066yekhsOaOlX87QwoQCIMQ
         U+yA==
Content-Disposition: inline
In-Reply-To: <YtsPk5+hZNMEwT0c-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mingwei Zhang <mizhang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

On Fri, Jul 22, 2022, Mingwei Zhang wrote:
> On Fri, Apr 29, 2022, Yosry Ahmed wrote:
> > Count the pages used by KVM mmu on x86 for in secondary pagetable stats.
> > 
> > For the legacy mmu, accounting pagetable stats is combined KVM's
> > existing for mmu pages in newly introduced kvm_[un]account_mmu_page()
> > helpers.
> > 
> > For tdp mmu, introduce new tdp_[un]account_mmu_page() helpers. That
> > combines accounting pagetable stats with the tdp_mmu_pages counter
> > accounting.
> > 
> > tdp_mmu_pages counter introduced in this series [1]. This patch was
> > rebased on top of the first two patches in that series.
> > 
> > [1]https://lore.kernel.org/lkml/20220401063636.2414200-1-mizhang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> > 
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> 
> It looks like there are two metrics for mmu in x86: one for shadow mmu
> and the other for TDP mmu. Is there any plan to merge them together?

There aren't two _separate_ metrics per se, rather that the TDP MMU (intentionally)
doesn't honor KVM_SET_NR_MMU_PAGES, nor does it play nice the the core mm shrinkers.
Thus, the TDP MMU doesn't udpate kvm_mod_used_mmu_pages(), which feeds into both of
those things.

Long term, I don't think the TDP MMU will ever honor KVM_SET_NR_MMU_PAGES.  That
particular knob predates proper integration with memcg and probably should be
deprecated.

As for supporting shrinkers in the TDP MMU, it's unclear whether or not that's truly
necessary.  And until mmu_shrink_scan() is made a _lot_ smarter, it's somewhat of a
moot point because KVM's shrinker implementation is just too naive for it to be a net
positive, e.g. it tends to zap upper level entries and wipe out large swaths of KVM's
page tables.  KVM_SET_NR_MMU_PAGES uses the same naive algorithm, so it's not any better.
