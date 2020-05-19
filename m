From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v3 3/3] mm: automatically penalize tasks with high
 swap use
Date: Mon, 18 May 2020 17:42:49 -0700
Message-ID: <20200518174249.745e66d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200515202027.3217470-1-kuba@kernel.org>
        <20200515202027.3217470-4-kuba@kernel.org>
        <CALvZod5Dcee8CaNfkhQQbvC1OuOTO7qE9bJw9NAa8nd2Cru6hA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589848971;
        bh=qxboCEg4hi3CXOBVgmrK9TNH02/9r/BNCIXuD89A5Sw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zZ1dJXEoHkeudQYpl+ZCYadBNd3ECVvJt9fa5tm7bHJKpYFJ0cEHRzCZ6ZTWW4R82
         IpjwI5a97klaxsC+8kgRLXKVuyQtAlQxOwqWoSXAXdio7I7RWBOh+JLEycI1cJDC6i
         FZWr8BmJDeTO3aSzoAedmHKYKgllbObVJYvUxMt0=
In-Reply-To: <CALvZod5Dcee8CaNfkhQQbvC1OuOTO7qE9bJw9NAa8nd2Cru6hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Sun, 17 May 2020 06:44:52 -0700 Shakeel Butt wrote:
> > @@ -2583,12 +2606,23 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >          * reclaim, the cost of mismatch is negligible.
> >          */
> >         do {
> > -               if (page_counter_read(&memcg->memory) > READ_ONCE(memcg->high)) {
> > -                       /* Don't bother a random interrupted task */
> > -                       if (in_interrupt()) {
> > +               bool mem_high, swap_high;
> > +
> > +               mem_high = page_counter_read(&memcg->memory) >
> > +                       READ_ONCE(memcg->high);
> > +               swap_high = page_counter_read(&memcg->swap) >
> > +                       READ_ONCE(memcg->swap_high);
> > +
> > +               /* Don't bother a random interrupted task */
> > +               if (in_interrupt()) {
> > +                       if (mem_high) {
> >                                 schedule_work(&memcg->high_work);
> >                                 break;
> >                         }
> > +                       continue;  
> 
> break?

On a closer look I think continue is correct. In irq we only care 
about mem_high, because there's nothing we can do in a work context 
to penalize swap. So the loop is shortened.

> > +               }
> > +
> > +               if (mem_high || swap_high) {
> >                         current->memcg_nr_pages_over_high += batch;
> >                         set_notify_resume(current);
> >                         break;

