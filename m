From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: per-cpu statistics
Date: Fri, 1 Mar 2013 21:48:44 +0800
Message-ID: <CAFj3OHXJckvDPWSnq9R8nZ00Sb0Juxq9oCrGCBeO0UZmgH6OzQ@mail.gmail.com>
References: <512F0E76.2020707@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=jazkp4k9AGhdJgS88KVzpKdcxd4p4qgDLVUzsuMBG9U=;
        b=nzvenJQDSY5S5V/p9sAcrrmyfvJApE0y0R4zXxldopUqAgv8TCtj4Xm4oMVpoZCHQ4
         nfnK+/Hv6XihQ9AsojokjHHiR/ac9Jf63OBgD1wgidTOvlFioCYYDTXbPcl1K3ALT4j3
         GSWEkQCBxMf5UDfkTFp2EQpGbKQzqo7/Qc/tM2cuUfXt1E6O3yM/iuhDM6OV19gzDJpd
         SMuUTkVNhD6HpM+KgZ4TBBtWv86LJTpxTrw9o/D9+5LPQ9rdRPkiYWUjPrtsqC7XBLJm
         ifdMTgRevGY1qSxtiI0NaWo/Hf/LAbx0XTY8nmoBS6BWrQTs2PIn1ETewYuGo63nn8bN
         npDw==
In-Reply-To: <512F0E76.2020707-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

Hi Glauber,

Forgive me, I'm replying not because I know the reason of current
per-cpu implementation but that I notice you're mentioning something
I'm also interested in. Below is the detail.

On Thu, Feb 28, 2013 at 3:59 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
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
>         get_online_cpus();
>         for_each_online_cpu(cpu)
>                 val += per_cpu(memcg->stat->count[idx], cpu);
> #ifdef CONFIG_HOTPLUG_CPU
>         spin_lock(&memcg->pcp_counter_lock);
>         val += memcg->nocpu_base.count[idx];
>         spin_unlock(&memcg->pcp_counter_lock);
> #endif
>         put_online_cpus();
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

I'm not sure I fully understand your points, root memcg now don't
charge page already and only do some page stat
accounting(CACHE/RSS/SWAP).  Now I'm also trying to do some
optimization specific to the overhead of root memcg stat accounting,
and the first attempt is posted here:
https://lkml.org/lkml/2013/1/2/71 . But it only covered
FILE_MAPPED/DIRTY/WRITEBACK(I've add the last two accounting in that
patchset) and Michal Hock accepted the approach (so did Kame) and
suggested I should handle all the stats in the same way including
CACHE/RSS. But I do not handle things related to memcg LRU where I
notice you have done some work.

It's possible that we may take different ways to bypass root memcg
stat accounting. The next round of the part will be sent out in
following few days(doing some tests now), and for myself any comments
and collaboration are welcome. (Glad to cc to you of course if you're
also interest in it. :) )

Many thanks!


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
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Sha
