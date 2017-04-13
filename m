From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Thu, 13 Apr 2017 13:30:47 +0900
Message-ID: <20170413043047.GA16783@bbox>
References: <20170317231636.142311-1-timmurray@google.com>
 <20170330155123.GA3929@cmpxchg.org>
 <CAEe=SxmpXD=f9N_i+xe6gFUKKUefJYvBd8dSwxSM+7rbBBTniw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEe=SxmpXD=f9N_i+xe6gFUKKUefJYvBd8dSwxSM+7rbBBTniw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patrik Torstensson <totte-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

On Thu, Mar 30, 2017 at 12:40:32PM -0700, Tim Murray wrote:
> On Thu, Mar 30, 2017 at 8:51 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > In cgroup2, we've added a memory.low knob, where groups within their
> > memory.low setting are not reclaimed.
> >
> > You can set that knob on foreground groups to the amount of memory
> > they need to function properly, and set it to 0 on background groups.
> >
> > Have you tried doing that?
> 
> I have not, but I'm trying to get that working now to evaluate it on Android.
> 
> However, based on other experiences, I don't think it will work well.
> We've experimented a lot with different limits in different places
> (Java heap limits, hard_reclaim, soft_reclaim) at different times in
> the process lifecycle, and the problem has always been that there's no
> way for us to know what limit is reasonable. memory.low will have the
> same problem. If memory.low is higher than the actual working set of a
> foreground process, the system wastes memory (eg, file pages loaded
> during app startup that are never used again won't be reclaimed under
> pressure). If memory.low is less than the actual working set,
> foreground processes will still get hit by thrashing.
> 
> Another issue is that the working set varies tremendously from app to
> app. An email client's working set may be 1/10 or 1/20 of a camera
> running a computational photography pipeline with multiple captures in
> flight. I can imagine a case where it makes sense for a foreground
> application to take 50-75% of a device's physical memory (the camera
> case or something similar), but I hope that's an extreme outlier
> compared to most apps on the system. However, high-memory apps are
> often the most performance-sensitive, so reclaim is more likely to
> cause problems.
> 
> As a result, I think there's still a need for relative priority
> between mem cgroups, not just an absolute limit.
> 
> Does that make sense?

I agree with it.

Recently, embedded platform's workload for smart things would be much
diverse(from game to alarm) so it's hard to handle the absolute limit
proactively and userspace has more hints about what workloads are
more important(ie, greedy) compared to others although it would be
harmful for something(e.g., it's not visible effect to user)

As a such point of view, I support this idea as basic approach.
And with thrashing detector from Johannes, we can do fine-tune of
LRU balancing and vmpressure shooting time better.

Johannes,

Do you have any concern about this memcg prority idea?
Or
Do you think the patchset you are preparing solve this situation?

> 
> > Both vmpressure and priority levels are based on reclaim efficiency,
> > which is problematic on solid state storage because page reads have
> > very low latency. It's rare that pages are still locked from the
> > read-in by the time reclaim gets to them on the LRU, so efficiency
> > tends to stay at 100%, until the system is essentially livelocked.
> >
> > On solid state storage, the bigger problem when you don't have enough
> > memory is that you can reclaim just fine but wait a significant amount
> > of time to refault the recently evicted pages, i.e. on thrashing.
> >
> > A more useful metric for memory pressure at this point is quantifying
> > that time you spend thrashing: time the job spends in direct reclaim
> > and on the flipside time the job waits for recently evicted pages to
> > come back. Combined, that gives you a good measure of overhead from
> > memory pressure; putting that in relation to a useful baseline of
> > meaningful work done gives you a portable scale of how effictively
> > your job is running.
> 
> This sounds fantastic, and it matches the behavior I've seen around
> pagecache thrashing on Android.
> 
> On Android, I think there are three different times where userspace
> would do something useful for memory:
> 
> 1. scan priority is creeping up, scanned/reclaim ratio is getting
> worse, system is exhibiting signs of approaching severe memory
> pressure. userspace should probably kill something if it's got
> something it can kill cheaply.
> 2. direct reclaim is happening, system is thrashing, things are bad.
> userspace should aggressively kill non-critical processes because
> performance has already gotten worse.
> 3. something's gone horribly wrong, oom_killer is imminent: userspace
> should kill everything it possibly can to keep the system stable.
> 
> My vmpressure experiments have focused on #1 because it integrates
> nicely with memcg priorities. However, it doesn't seem like a good
> approach for #2 or #3. Time spent thrashing sounds ideal for #2. I'm
> not sure what to do for #3. The current critical vmpressure event
> hasn't been that successful in avoiding oom-killer (on 3.18, at
> least)--I've been able to get oom-killer to trigger without a
> vmpressure event.
> 
> Assuming that memcg priorities are reasonable, would you be open to
> using scan priority info as a vmpressure signal for a low amount of
> memory pressure?
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
