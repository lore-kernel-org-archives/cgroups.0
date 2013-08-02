From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V5 7/8] memcg: don't account root memcg page stats if only
 root exists
Date: Fri, 2 Aug 2013 12:32:17 +0800
Message-ID: <CAFj3OHUxir9kUXgHfOb1m6LDzO8HBG68CDi3MzV54sC0jdP=iQ@mail.gmail.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
	<1375358407-10777-1-git-send-email-handai.szj@taobao.com>
	<20130801162012.GA23319@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=NFnG3DQpUVGDzzmkfeyiPNk0ytm00PC/mDAvIYWr1/c=;
        b=wWNpKLV4gsenwD9u2q9502Agw00jfxcMV0x5QxKmeXskm1rfPDhRLI9g+tmH9vuiLf
         q4KB6j8QVGS+Yhpabuj1stbVdgfZDB2QAI2CEHKm2jpUSMl8J/3rfVJU5vCTren9FMe5
         fYx470r0Q9sPQxfrG+12/C5h4oIAuBkkGVslDpv+x9vrjL0zJq9bxmqOUZIs6WhjsOXN
         s7daoaVNGYa28CD/qFaCIr77MB/PJjRqI0OT7rqgwQM3r2TltPrCsi39z6uKnK3fUKq4
         Klfm03sv7j2QGWFnL/VwaPUOhWrYTY6QE76Td+xYvBX+FpwMN1b8XmwlgqFhrBXda+QI
         kBsg==
In-Reply-To: <20130801162012.GA23319-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, Aug 2, 2013 at 12:20 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> On Thu, Aug 01, 2013 at 08:00:07PM +0800, Sha Zhengju wrote:
>> @@ -6303,6 +6360,49 @@ mem_cgroup_css_online(struct cgroup *cont)
>>       }
>>
>>       error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
>> +     if (!error) {
>> +             if (!mem_cgroup_in_use()) {
>> +                     /* I'm the first non-root memcg, move global stats to root memcg.
>> +                      * Memcg creating is serialized by cgroup locks(cgroup_mutex),
>> +                      * so the mem_cgroup_in_use() checking is safe.
>> +                      *
>> +                      * We use global_page_state() to get global page stats, but
>> +                      * because of the optimized inc/dec functions in SMP while
>> +                      * updating each zone's stats, We may lose some numbers
>> +                      * in a stock(zone->pageset->vm_stat_diff) which brings some
>> +                      * inaccuracy. But places where kernel use these page stats to
>> +                      * steer next decision e.g. dirty page throttling or writeback
>> +                      * also use global_page_state(), so here it's enough too.
>> +                      */
>> +                     spin_lock(&root_mem_cgroup->pcp_counter_lock);
>> +                     root_mem_cgroup->stats_base.count[MEM_CGROUP_STAT_FILE_MAPPED] =
>> +                                             global_page_state(NR_FILE_MAPPED);
>> +                     root_mem_cgroup->stats_base.count[MEM_CGROUP_STAT_FILE_DIRTY] =
>> +                                             global_page_state(NR_FILE_DIRTY);
>> +                     root_mem_cgroup->stats_base.count[MEM_CGROUP_STAT_WRITEBACK] =
>> +                                             global_page_state(NR_WRITEBACK);
>> +                     spin_unlock(&root_mem_cgroup->pcp_counter_lock);
>> +             }
>
> If inaccuracies in these counters are okay, why do we go through an
> elaborate locking scheme that sprinkles memcg callbacks everywhere
> just to be 100% reliable in the rare case somebody moves memory
> between cgroups?

IMO they are not the same thing. Moving between cgroups may happen
many times, if we ignore the inaccuracy between moving, then the
cumulative inaccuracies caused by this back and forth behavior can
become very large.

But the transferring above occurs only once since we do it only when
the first non-root memcg creating, so the error is at most
zone->pageset->stat_threshold. This threshold depends on the amount of
zone memory and  the number of processors, and its maximum value is
125, so I thought using global_page_state() is enough. Of course we
can add the stock to seek for greater perfection, but there are also
possibilities of inaccuracy because of racy.


-- 
Thanks,
Sha
