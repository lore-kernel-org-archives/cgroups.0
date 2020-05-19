From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v3 3/3] mm: automatically penalize tasks with high swap use
Date: Mon, 18 May 2020 18:10:33 -0700
Message-ID: <CALvZod5G=ZG2DeGGxPD8vhqmeLz4_cxS5GUaTdOiGKLkgk9s6g@mail.gmail.com>
References: <20200515202027.3217470-1-kuba@kernel.org> <20200515202027.3217470-4-kuba@kernel.org>
 <CALvZod5Dcee8CaNfkhQQbvC1OuOTO7qE9bJw9NAa8nd2Cru6hA@mail.gmail.com> <20200518174249.745e66d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B2h6KEery4DV64pghw/Hx8NR4tW7hYF1jzYkIKgyqtY=;
        b=dGNrtd1l1ltG3c1HYSawMUrarOg9vPFevkjYgf5ZqEOz/RFCHgmLOPi0xuzrahF4CD
         obwX++9C4JOfIDaITvGasXg0MgbGrlbBO4SEtpt/Ud5eQZoGxcJJ0CeGE8NAHftQ3zg5
         6PjTx8qXm3+Oyp8253JLyQxJoLUIW4EFUyuOK0P2z0KzLtFMhM5WWm9W1e8TeAXp/FoS
         dqu7Xx7sFMpzWnCWVGDDqB+hrBxXUb1BuHJB/YVrFyl61gB6v2wxiRoxsi0EuQv92FFu
         BSgc5f0uOl771PWB2t38NXIhaNwIekiNG7WOqDMNMxXdhXa9XE8XUcVPnMg2Gs1DbiEQ
         aPqg==
In-Reply-To: <20200518174249.745e66d1-CbGlpYbfshD2+ikPA6JUzH8MC5kE+Go+7OQnqPW8cmTNHmdVIy2bbWItS4zQEDct@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, May 18, 2020 at 5:42 PM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Sun, 17 May 2020 06:44:52 -0700 Shakeel Butt wrote:
> > > @@ -2583,12 +2606,23 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >          * reclaim, the cost of mismatch is negligible.
> > >          */
> > >         do {
> > > -               if (page_counter_read(&memcg->memory) > READ_ONCE(memcg->high)) {
> > > -                       /* Don't bother a random interrupted task */
> > > -                       if (in_interrupt()) {
> > > +               bool mem_high, swap_high;
> > > +
> > > +               mem_high = page_counter_read(&memcg->memory) >
> > > +                       READ_ONCE(memcg->high);
> > > +               swap_high = page_counter_read(&memcg->swap) >
> > > +                       READ_ONCE(memcg->swap_high);
> > > +
> > > +               /* Don't bother a random interrupted task */
> > > +               if (in_interrupt()) {
> > > +                       if (mem_high) {
> > >                                 schedule_work(&memcg->high_work);
> > >                                 break;
> > >                         }
> > > +                       continue;
> >
> > break?
>
> On a closer look I think continue is correct. In irq we only care
> about mem_high, because there's nothing we can do in a work context
> to penalize swap. So the loop is shortened.
>

Yes, you are right.
