From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 18 Jul 2022 11:26:01 -0700
Message-ID: <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com> <Ys3+UTTC4Qgbm7pQ@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WVvDU2AL8s0vVVLudVvrgZ7AYHAWM81ym6o0jyabuV4=;
        b=NQ0Qe4cWnPa0u8OvVOwy8y1gQzlLdYgCBimHOn9YHa4Latcfsm8LyZWdrE80LvfLNc
         tXy9exDSQ3Y8+XgnPNrfrHKHIK7WHqJjLLs4ZKL3zqZf6W5Xlj4yqoBEvXm+WpLrm0JK
         nc+V6DOQP5AGz2bXTOdUzCzQ1YAp4XOyOvKRo9GvABDJSc2/Y2J3ShxELHCOlHxEUJpo
         ti2ZhHov/v/Po0RulIPBMJvjoIktisJSzAOhmFKMTwaSDEisYz9bQgmq4q0t8npT63yx
         Y3MItMbE+E1nY/7Zk0F2qpNd3Q0ouCIublcith4nRKDQch7WB3I3FYuxo2LIS7fvtbtL
         9RXA==
In-Reply-To: <Ys3+UTTC4Qgbm7pQ-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel>

On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > Thanks for taking another look at this!
> >
> > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > index aab70355d64f3..13190d298c986 100644
> > > > --- a/include/linux/mmzone.h
> > > > +++ b/include/linux/mmzone.h
> > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > >  #endif
> > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > >
> > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > and potentially confusing.
> > >
> > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > stats the depend on a single feature seems to be the status quo for this code.
> > >
> >
> > I will #ifdef the stat, but I will emphasize in the docs that is
> > currently *only* used for KVM so that it makes sense if users without
> > KVM don't see the stat at all. I will also remove the stat from
> > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > #ifdefed stats show up there.
>
> It's might be worth getting someone from mm/ to weigh in before going through the
> trouble, my suggestion/question is based purely on the existing code.

Any mm folks with an opinion about this?

Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
with #ifdef CONFIG_KVM for now as it is currently the only source for
this stat?
