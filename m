From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: effective memory.high reclaim for remote charging
Date: Thu, 7 May 2020 19:49:49 +0200
Message-ID: <20200507174949.GN6345@dhcp22.suse.cz>
References: <20200507163301.229070-1-shakeelb@google.com>
 <20200507164653.GM6345@dhcp22.suse.cz>
 <CALvZod5TmAnDoueej1nu5_VV9rQa6VYVRXqCYuh63P5HN-o9Sw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod5TmAnDoueej1nu5_VV9rQa6VYVRXqCYuh63P5HN-o9Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu 07-05-20 10:00:07, Shakeel Butt wrote:
> On Thu, May 7, 2020 at 9:47 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Thu 07-05-20 09:33:01, Shakeel Butt wrote:
> > [...]
> > > @@ -2600,8 +2596,23 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >                               schedule_work(&memcg->high_work);
> > >                               break;
> > >                       }
> > > -                     current->memcg_nr_pages_over_high += batch;
> > > -                     set_notify_resume(current);
> > > +
> > > +                     if (gfpflags_allow_blocking(gfp_mask))
> > > +                             reclaim_over_high(memcg, gfp_mask, batch);
> > > +
> > > +                     if (page_counter_read(&memcg->memory) <=
> > > +                         READ_ONCE(memcg->high))
> > > +                             break;
> >
> > I am half way to a long weekend so bear with me. Shouldn't this be continue? The
> > parent memcg might be still in excess even the child got reclaimed,
> > right?
> >
> 
> The reclaim_high() actually already does this walk up to the root and
> reclaim from ones who are still over their high limit. Though having
> 'continue' here is correct too.

Ohh, right. As I've said weekend brain. I will have a proper look next
week. This just hit my eyes.

-- 
Michal Hocko
SUSE Labs
