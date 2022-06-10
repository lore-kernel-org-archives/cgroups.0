From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Fri, 10 Jun 2022 12:55:31 -0700
Message-ID: <CALvZod4XtEfdSjq=Jq51tvwXkpv-TKr32G6aeyjzcwxvdPv9SQ@mail.gmail.com>
References: <20220606222058.86688-1-yosryahmed@google.com> <20220606222058.86688-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QBy6NjH2ouB9J4AcBo7wTpbSKkOShDZoTHSArfldiUw=;
        b=sklHbZakJDBBoAiTpjSD5q4HxK1etfA1WIC7E1GGXxranlMwDMPGy/uz2sJhGgVhFh
         PsuwAc1Kvt+JrVxUxoIbUT41GO80lUj3bVmOMXx/EiCDoPrvSZTi5VA6KlhM0oySyOuR
         +tYZA59GVkAhi7mk0TAsOWGswz98wriVH5TPC/c2Qf2YokWtgLtStUvjfTvamYaneEGH
         bzvkFbDMtZuEKw/jnULBvxk8zwbsM2bB87HtefiubybLbL+H3NdXdw9PHE9MFa1uwCCh
         tyZDjrUVtcAARyszAW1G5DhaCKiwkKolBeX5R2/hKBE7ytxWxLfuo/5GEb1KHAlQavBv
         Z93A==
In-Reply-To: <20220606222058.86688-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

On Mon, Jun 6, 2022 at 3:21 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> KVM mmu. This provides more insights on the kernel memory used
> by a workload.
>
> This stat will be used by subsequent patches to count KVM mmu
> memory usage.
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
