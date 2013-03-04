From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: per-cpu statistics
Date: Mon, 04 Mar 2013 09:55:25 +0900
Message-ID: <5133F0FD.3040501@jp.fujitsu.com>
References: <512F0E76.2020707@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512F0E76.2020707-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

(2013/02/28 16:59), Glauber Costa wrote:
> Hi guys
>
> Please enlighten me regarding some historic aspect of memcg before I go
> changing something I shouldn't...
>
> Regarding memcg stats, is there any reason for us to use the current
> per-cpu implementation we have instead of a percpu_counter?
>
> We are doing something like this:
>
>          get_online_cpus();
>          for_each_online_cpu(cpu)
>                  val += per_cpu(memcg->stat->count[idx], cpu);
> #ifdef CONFIG_HOTPLUG_CPU
>          spin_lock(&memcg->pcp_counter_lock);
>          val += memcg->nocpu_base.count[idx];
>          spin_unlock(&memcg->pcp_counter_lock);
> #endif
>          put_online_cpus();
>
> It seems to me that we are just re-implementing whatever percpu_counters
> already do, handling the complication ourselves.
>
> It surely is an array, and this keeps the fields together. But does it
> really matter? Did it come from some measurable result?
>
> I wouldn't touch it if it wouldn't be bothering me. But the reason I
> ask, is that I am resurrecting the patches to bypass the root cgroup
> charges when it is the only group in the system. For that, I would like
> to transfer charges from global, to our memcg equivalents.
>
> Things like MM_ANONPAGES are not percpu, though, and when I add it to
> the memcg percpu structures, I would have to somehow distribute them
> around. When we uncharge, that can become negative.
>
> percpu_counters already handle all that, and then can cope well with
> temporary negative charges in the percpu data, that is later on
> withdrawn from the main base counter.
>
> We are counting pages, so the fact that we're restricted to only half of
> the 64-bit range in percpu counters doesn't seem to be that much of a
> problem.
>
> If this is just a historic leftover, I can replace them all with
> percpu_counters. Any words on that ?
>

An reason I didn't like percpu_counter *was* its memory layout.

==
struct percpu_counter {
         raw_spinlock_t lock;
         s64 count;
#ifdef CONFIG_HOTPLUG_CPU
         struct list_head list;  /* All percpu_counters are on a list */
#endif
         s32 __percpu *counters;
};
==

Assume we have counters in an array, then, we'll have

    lock
    count
    list
    pointer
    lock
    count
    list
    pointer
    ....

An counter's lock ops will invalidate pointers in the array.
We tend to update several counters at once.

If you measure performance on enough large SMP and it looks good,
I think it's ok to go with lib/percpu_counter.c.

Thanks,
-Kame















