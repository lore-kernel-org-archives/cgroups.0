From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 15 Aug 2022 08:39:23 -0700
Message-ID: <CAJD7tkYJcsSvCUCkNgcWvi2Xoa3GDZk81p5GUptZzkOkrhrTWQ@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com> <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
 <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com> <Yvpir0nWuTsXz322@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VP31WSY65QEYHmGKkheHdJtit2IxlAC3C/GTNPT6J3M=;
        b=KDR20vjhDq0om+BbSpgVjbjIEfKyM9hzqellnZMBbjPYhKfqx8ikJsySttFwFlY2Hw
         oiDxEt4RpXxN6hUaJW8OuaENfYZOafXkSDkX1vb9dg7V/aG4QsRJ6TYY0F9WUlTLn6Vf
         NHF+LgUaJFpui1g9qC+Rv3LypInoC1lE1hsrJ8BiNxbEAPP6tn3XdJyY/w0KbBw7PpJD
         oH77RjEzfa5ost8upGE9k1u6DJriI0mcBtWbmFcq9KC94GZZe4EqzVQ4aUBaXW6zABOk
         ZIGRqcpIb5HIHOLH2gv1bH3WqUBDiCE5BvLQ/x7yySs3uf1w5ktkzspTtUNcCnzYJQEj
         8w1w==
In-Reply-To: <Yvpir0nWuTsXz322-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-ker>

On Mon, Aug 15, 2022 at 8:13 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Mon, Aug 08, 2022 at 01:06:15PM -0700, Yosry Ahmed wrote:
> > On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > > > Thanks for taking another look at this!
> > > > >
> > > > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > >
> > > > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > > > index aab70355d64f3..13190d298c986 100644
> > > > > > > --- a/include/linux/mmzone.h
> > > > > > > +++ b/include/linux/mmzone.h
> > > > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > > > >  #endif
> > > > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > > > >
> > > > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > > > and potentially confusing.
> > > > > >
> > > > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > > > stats the depend on a single feature seems to be the status quo for this code.
> > > > > >
> > > > >
> > > > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > > > currently *only* used for KVM so that it makes sense if users without
> > > > > KVM don't see the stat at all. I will also remove the stat from
> > > > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > > > #ifdefed stats show up there.
> > > >
> > > > It's might be worth getting someone from mm/ to weigh in before going through the
> > > > trouble, my suggestion/question is based purely on the existing code.
> > >
> > > Any mm folks with an opinion about this?
> > >
> > > Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> > > with #ifdef CONFIG_KVM for now as it is currently the only source for
> > > this stat?
> >
> > Any input here?
> >
> > Johannes, you have been involved in discussions in earlier versions of
> > this series, any thoughts here?
>
> No super strong feelings here. Most major distros have CONFIG_KVM=y/n,
> so it'll be a common fixture anyway, and the ifdef is proooobably not
> worth it for hiding it from people. OTOH, the ifdef is useful for
> documenting the code.
>
> If you've already ifdeffed it now, I'd say go ahead with
> it. Otherwise, don't :) My 2c.

Thanks a lot, Johannes! I haven't ifdeffed it yet so I'll send a v7
with a few nits and collect ACKs. Andrew, would you prefer me to
rebase on top of mm-unstable? Or will this go in through the kvm tree?
(currently it's based on an old-ish kvm/queue).
