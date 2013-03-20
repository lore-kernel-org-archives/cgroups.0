From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 3/5] memcg: make it suck faster
Date: Wed, 20 Mar 2013 11:13:24 +0400
Message-ID: <51496194.7020508@parallels.com>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com> <1362489058-3455-4-git-send-email-glommer@parallels.com> <CAFj3OHU6f3o5GmbFyUsqtSWqHruSS4Yyodx=s=Vh8mO7GfTE8w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFj3OHU6f3o5GmbFyUsqtSWqHruSS4Yyodx=s=Vh8mO7GfTE8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

On 03/13/2013 12:08 PM, Sha Zhengju wrote:
>> +static void memcg_update_root_statistics(void)
>> > +{
>> > +       int cpu;
>> > +       u64 pgin, pgout, faults, mjfaults;
>> > +
>> > +       pgin = pgout = faults = mjfaults = 0;
>> > +       for_each_online_cpu(cpu) {
>> > +               struct vm_event_state *ev = &per_cpu(vm_event_states, cpu);
>> > +               struct mem_cgroup_stat_cpu *memcg_stat;
>> > +
>> > +               memcg_stat = per_cpu_ptr(root_mem_cgroup->stat, cpu);
>> > +
>> > +               memcg_stat->events[MEM_CGROUP_EVENTS_PGPGIN] =
>> > +                                                       ev->event[PGPGIN];
>> > +               memcg_stat->events[MEM_CGROUP_EVENTS_PGPGOUT] =
>> > +                                                       ev->event[PGPGOUT];
> ev->event[PGPGIN/PGPGOUT] is counted in block layer(submit_bio()) and
> represents the exactly number of pagein/pageout, but memcg
> PGPGIN/PGPGOUT events only count it as an event and ignore the page
> size. So here we can't straightforward take the ev->events for use.
> 
You are right about that. Although I can't think of a straightforward
way to handle this. Well, except for the obvious of adding another
global statistic.

>> > +               memcg_stat->events[MEM_CGROUP_EVENTS_PGFAULT] =
>> > +                                                       ev->event[PGFAULT];
>> > +               memcg_stat->events[MEM_CGROUP_EVENTS_PGMAJFAULT] =
>> > +                                                       ev->event[PGMAJFAULT];
>> > +
>> > +               memcg_stat->nr_page_events = ev->event[PGPGIN] +
>> > +                                            ev->event[PGPGOUT];
> There's no valid memcg->nr_page_events until now, so the threshold
> notifier, but some people may use it even only root memcg exists.
> Moreover, using PGPGIN + PGPGOUT(exactly number of pagein + pageout)
> as nr_page_events is also inaccurate IMHO.
> 
Humm, I believe I can zero out this. Looking at the code again, this is
not imported to userspace. It is just used to activate the thresholds
and the delta of nr_page_events is a lot more important than nr_page_events.
