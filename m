From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: effective memory.high reclaim for remote charging
Date: Mon, 11 May 2020 11:56:46 -0400
Message-ID: <20200511155646.GB306292@cmpxchg.org>
References: <20200507163301.229070-1-shakeelb@google.com>
 <20200507164653.GM6345@dhcp22.suse.cz>
 <CALvZod5TmAnDoueej1nu5_VV9rQa6VYVRXqCYuh63P5HN-o9Sw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0mkmAQYTPxUwTzaufmQ28FUE0wAOW0XuP/PajjBfBuI=;
        b=oj6nl8Etq+Cp7D5OexjUrLRZfJ6Boh1fr3GR6ETsCeQgMNybVUKDK0SlyrXGit3FGs
         Kk4Yshjf2ZNzTx3DiZrm/f03A9DD5twUHxDzBbOQtkSX+qhqGRELd8hPWbxYR6XcP7c3
         AqZYcLK6CdIjDSO+xG1LoDdPVgEkch+Eb627llInyJOkzFEe2tTFHu4jBztuP60v8bx+
         EY2XURnrX3zUqwtOy1Iu5TwM6uN1XpzGxwBv+RXpvyYam2nJ8ocqSqgbtTUnSltdPVTU
         gEXP2FC/T77cVQ2cXgLbdF4X+1qS94vQvbOEXrkDdjbjGNU59A7GMlhFsW8TmO0UPNM1
         4WDg==
Content-Disposition: inline
In-Reply-To: <CALvZod5TmAnDoueej1nu5_VV9rQa6VYVRXqCYuh63P5HN-o9Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, May 07, 2020 at 10:00:07AM -0700, Shakeel Butt wrote:
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

If reclaim was weak and failed to bring the child back in line, we
still do set_notify_resume(). We should do that for ancestors too.

But it seems we keep adding hierarchy walks and it's getting somewhat
convoluted: page_counter does it, then we check high overage
recursively, and now we add the call to reclaim which itself is a walk
up the ancestor line.

Can we hitchhike on the page_counter_try_charge() walk, which already
has the concept of identifying counters with overage? Rename the @fail
to @limited and return the first counter that is in excess of its high
as well, even when the function succeeds?

Then we could ditch the entire high checking loop here and simply
replace it with

done_restock:
	...

	if (*limited) {
		if (gfpflags_allow_blocking())
			reclaim_over_high(memcg_from_counter(limited));
		/* Reclaim may not be able to do much, ... */
		set_notify_resume(); // or schedule_work()
	};

In the long-term, the best thing might be to integrate memory.high
reclaim with the regular reclaim that try_charge() is already
doing. Especially the part where it retries several times - we
currently give up on memory.high unnecessarily early. Make
page_counter_try_charge() fail on high and max equally, and after
several reclaim cycles, instead of invoking the OOM killer, inject the
penalty sleep and force the charges. OOM killing and throttling is
supposed to be the only difference between the two, anyway, and yet
the code diverges far more than that for no apparent reason.

But I also appreciate that this is a cleanup beyond the scope of this
patch here, so it's up to you how far you want to take it.
