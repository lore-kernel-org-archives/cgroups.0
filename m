From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: refill_stock for kmem uncharging too
Date: Fri, 19 Apr 2019 14:14:29 -0700
Message-ID: <CALvZod4N7XJ5Zxd-0pO0_tpnnmGHyY=6PMVcvCg49virdp=6SA@mail.gmail.com>
References: <20190418214224.61900-1-shakeelb@google.com> <20190419200733.GB31878@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ep33f62HX3AzUBDcVwFjTp0Z/qGrzWSSxgy6irC3Dwc=;
        b=TN+lD0YxK8/Z39tQFNeng7o7MdFoxCJhCMdqBA3VkWcQCiVs/XYz7qebhQCkvh98UL
         QYtk4dk9C4miikKW7ebUyVThbhx3xOBfed7dosNc80MVG1HOVIEDJwbCgFx4BBOxXmuZ
         9BJC9skhYCCPRcDFlVoAk1wWJi5QPd3x7bV9nZrQOdhbYWEdfxh+qFEzSbhjh2zcF+Qk
         nEUxMY1lIEric7Sr22cPqLby1FKEYg8H2b/hKJaehzG2Bhsi5DI8SaX8kUlMXuKmwFZp
         2fucI4cAXY9cXKu/jqmNdiuJqUHmBHXRYYAbiFf+Wwhsg2U7d7P+0QNi3h2mwT28yPuy
         9j6Q==
In-Reply-To: <20190419200733.GB31878@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Apr 19, 2019 at 1:07 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Apr 18, 2019 at 02:42:24PM -0700, Shakeel Butt wrote:
> > The commit 475d0487a2ad ("mm: memcontrol: use per-cpu stocks for socket
> > memory uncharging") added refill_stock() for skmem uncharging path to
> > optimize workloads having high network traffic. Do the same for the kmem
> > uncharging as well. However bypass the refill for offlined memcgs to not
> > cause zombie apocalypse.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
>
> Hello, Shakeel!
>
> > ---
> >  mm/memcontrol.c | 17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 2535e54e7989..7b8de091f572 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -178,6 +178,7 @@ struct mem_cgroup_event {
> >
> >  static void mem_cgroup_threshold(struct mem_cgroup *memcg);
> >  static void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
> > +static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
> >
> >  /* Stuffs for move charges at task migration. */
> >  /*
> > @@ -2097,10 +2098,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
> >       struct mem_cgroup *old = stock->cached;
> >
> >       if (stock->nr_pages) {
> > -             page_counter_uncharge(&old->memory, stock->nr_pages);
> > -             if (do_memsw_account())
> > -                     page_counter_uncharge(&old->memsw, stock->nr_pages);
> > -             css_put_many(&old->css, stock->nr_pages);
> > +             cancel_charge(old, stock->nr_pages);
> >               stock->nr_pages = 0;
> >       }
> >       stock->cached = NULL;
> > @@ -2133,6 +2131,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >       struct memcg_stock_pcp *stock;
> >       unsigned long flags;
> >
> > +     if (unlikely(!mem_cgroup_online(memcg))) {
> > +             cancel_charge(memcg, nr_pages);
> > +             return;
> > +     }
>
> I'm slightly concerned about this part. Do we really need it?
> The number of "zombies" which we can pin is limited by the number of CPUs,
> and it will drop fast if there is any load on the machine.
>
> If we skip offline memcgs, it can slow down charging/uncharging of skmem,
> which might be a problem, if the socket is in active use by an other cgroup.
> Honestly, I'd drop this part.
>

Sure, I will wait for comments from others and then send the v2 without this.

Shakeel
