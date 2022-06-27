From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 27 Jun 2022 09:23:55 -0700
Message-ID: <CAJD7tkaMYhG7_AQgn6fLGFVuSB4wDpY_GzcvSS99tSzTUKFkTw@mail.gmail.com>
References: <20220606222058.86688-1-yosryahmed@google.com> <20220606222058.86688-2-yosryahmed@google.com>
 <YrnVxM/5KjVhkOnn@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3xCqZKogDypv6eypnWAIX07mm+p6TcVFKXGmBz5uwGo=;
        b=EFJ93YBppveZN8tb8RoZSuAH5W5SG1LiH1nd2yGt5BUolxb7x2ATW1Kz7biQm14+S1
         UM+Fp8eufEM8rSzaN98Vxy+yjs/rNMirq3kcwGggDlKitVyql4aB21ps9KcBglapj9Ua
         1W4ZjfHFR1OX+l2hu2sbJa8kLFx8xcw+LngOMpTPoS5at+/yURveHnzp5IGPSJMu7ZvB
         x275CN6l1938KDghGgk+NqN925rKkvVMXE8N/H2EY4ZUpwt+isaWFqtc66lQKg5sW1P0
         qe563ZBGvDzi6k6E6WBMqiK4kFc+qfzpLTjoypM7LjJTmsiLm26bxb/pjD6ij7bCgcHB
         9Yqw==
In-Reply-To: <YrnVxM/5KjVhkOnn-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XWGXanvQGlWp@public.gmane.org

On Mon, Jun 27, 2022 at 9:07 AM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > KVM mmu. This provides more insights on the kernel memory used
> > by a workload.
>
> Please provide more justification for NR_SECONDARY_PAGETABLE in the changelog.
> Specially, answer the questions that were asked in the previous version:
>
>   1. Why not piggyback NR_PAGETABLE?
>   2. Why a "generic" NR_SECONDARY_PAGETABLE instead of NR_VIRT_PAGETABLE?
>
> It doesn't have to be super long, but provide enough info so that reviewers and
> future readers don't need to go spelunking to understand the motivation for the
> new counter type.

I added such justification in the cover letter, is it better to
include it here alternatively?
or do you think the description in the cover letter is lacking?

>
> And it's probably worth an explicit Link to Marc's question that prompted the long
> discussion in the previous version, that way if someone does want the gory details
> they have a link readily available.
>
> Link: https://lore.kernel.org/all/87ilqoi77b.wl-maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

I will include the link in the next version.
Thanks!
