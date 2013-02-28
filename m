From: Glauber Costa <glommer@parallels.com>
Subject: per-cpu statistics
Date: Thu, 28 Feb 2013 11:59:50 +0400
Message-ID: <512F0E76.2020707@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Cgroups <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>

Hi guys

Please enlighten me regarding some historic aspect of memcg before I go
changing something I shouldn't...

Regarding memcg stats, is there any reason for us to use the current
per-cpu implementation we have instead of a percpu_counter?

We are doing something like this:

        get_online_cpus();
        for_each_online_cpu(cpu)
                val += per_cpu(memcg->stat->count[idx], cpu);
#ifdef CONFIG_HOTPLUG_CPU
        spin_lock(&memcg->pcp_counter_lock);
        val += memcg->nocpu_base.count[idx];
        spin_unlock(&memcg->pcp_counter_lock);
#endif
        put_online_cpus();

It seems to me that we are just re-implementing whatever percpu_counters
already do, handling the complication ourselves.

It surely is an array, and this keeps the fields together. But does it
really matter? Did it come from some measurable result?

I wouldn't touch it if it wouldn't be bothering me. But the reason I
ask, is that I am resurrecting the patches to bypass the root cgroup
charges when it is the only group in the system. For that, I would like
to transfer charges from global, to our memcg equivalents.

Things like MM_ANONPAGES are not percpu, though, and when I add it to
the memcg percpu structures, I would have to somehow distribute them
around. When we uncharge, that can become negative.

percpu_counters already handle all that, and then can cope well with
temporary negative charges in the percpu data, that is later on
withdrawn from the main base counter.

We are counting pages, so the fact that we're restricted to only half of
the 64-bit range in percpu counters doesn't seem to be that much of a
problem.

If this is just a historic leftover, I can replace them all with
percpu_counters. Any words on that ?



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
