From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Free percpu stats memory of dying memcg's
Date: Thu, 21 Apr 2022 09:33:36 -0700
Message-ID: <YmGHYNuAp8957ouq@carbon>
References: <20220421145845.1044652-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650558823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2j4GtVd07DMMzhasl57D24rZquXEpncLF4sks2SC8Tg=;
        b=RzjnYy6yqwp7ePlZWOGy4zJ7p9tV7LrQaNicdlcEY3otLSxF2tbfcewQc9CCnxrqW1twUV
        PjfdmRGXTs8IcJWhdFuts+UCnSa5O7u1XeW3jZzhif5rGQE0fMuGg6v+TLoMZC6988/yR4
        Ru8kP7QTO3rUc1mNC/uroAU8bT28HyM=
Content-Disposition: inline
In-Reply-To: <20220421145845.1044652-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

On Thu, Apr 21, 2022 at 10:58:45AM -0400, Waiman Long wrote:
> For systems with large number of CPUs, the majority of the memory
> consumed by the mem_cgroup structure is actually the percpu stats
> memory. When a large number of memory cgroups are continuously created
> and destroyed (like in a container host), it is possible that more
> and more mem_cgroup structures remained in the dying state holding up
> increasing amount of percpu memory.
> 
> We can't free up the memory of the dying mem_cgroup structure due to
> active references in some other places. However, the percpu stats memory
> allocated to that mem_cgroup is a different story.
> 
> This patch adds a new percpu_stats_disabled variable to keep track of
> the state of the percpu stats memory. If the variable is set, percpu
> stats update will be disabled for that particular memcg. All the stats
> update will be forward to its parent instead. Reading of the its percpu
> stats will return 0.
> 
> The flushing and freeing of the percpu stats memory is a multi-step
> process. The percpu_stats_disabled variable is set when the memcg is
> being set to offline state. After a grace period with the help of RCU,
> the percpu stats data are flushed and then freed.
> 
> This will greatly reduce the amount of memory held up by dying memory
> cgroups.
> 
> By running a simple management tool for container 2000 times per test
> run, below are the results of increases of percpu memory (as reported
> in /proc/meminfo) and nr_dying_descendants in root's cgroup.stat.

Hi Waiman!

I've been proposing the same idea some time ago:
https://lore.kernel.org/all/20190312223404.28665-7-guro-b10kYP2dOMg@public.gmane.org/T/ .

However I dropped it with the thinking that with many other fixes
preventing the accumulation of the dying cgroups it's not worth the added
complexity and a potential cpu overhead.

I think it ultimately comes to the number of dying cgroups. If it's low,
memory savings are not worth the cpu overhead. If it's high, they are.
I hope long-term to drive it down significantly (with lru-pages reparenting
being the first major milestone), but it might take a while.

I don't have a strong opinion either way, just want to dump my thoughts
on this.

Thanks!
