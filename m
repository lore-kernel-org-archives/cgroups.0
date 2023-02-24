From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add memory.peak in cgroup root
Date: Fri, 24 Feb 2023 09:23:54 +0100
Message-ID: <Y/h0GlmeSQ735DxK@dhcp22.suse.cz>
References: <AM5PR0202MB25167BFBBE892630A2EE3B7DE1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
 <Y/eizTVo8LM70flh@P9FQF9L96D.corp.robot.car>
 <AM5PR0202MB2516BD45CFBC033F9EA3B0A4E1AB9@AM5PR0202MB2516.eurprd02.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677227035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AL9X1+yNh4TnR5INv6zRDMmmyJRq44OTuNAoJX2NvEw=;
        b=mr3Ky5jeFRjUgdY6dWt7rZesi83ypE+9L4yARacUWa/Kcq+CP9K7kdFUzIlaB3BC5pl3eX
        r/zrBqwCYEAHmsSa3pPf6706wmMpxxT6ptA0LDGOzH6P0TWwiZO34r/4Ia3wb8ngm5oQSw
        E/Ep32+6vsnuzjqeRYsGj2oEwkR8dsM=
Content-Disposition: inline
In-Reply-To: <AM5PR0202MB2516BD45CFBC033F9EA3B0A4E1AB9-y8SMVMhlxwlZMxuguPlqCOmQVOPts17knBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Chae <Matthew.Chae-VrBV9hrLPhE@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel <kernel-VrBV9hrLPhE@public.gmane.org>, Christopher Wong <Christopher.Wong-VrBV9hrLPhE@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu 23-02-23 19:00:57, Matthew Chae wrote:
> Hi Roman,
> 
> I'd like to get the peak memory usage recorded overall time, rather than at a certain time.

Sampling /proc/vmstat should have a minimal overhead and you will get
not only a single value but also a break down to broad cathegory users
(LRU, slab, page tables etc.). Unfortunatelly this doesn't cover all the
users (e.g. direct users of the page allocator are not accounted to any
specific counter) but it should give you a reasonable idea how is memory
utilized. Specific metrics really depend on what you are interested in.

Another approach that might give you a different angle to the memory
consumption is to watch PSI metrics. This will not tell you the peak
memory usage but it will give you an useful cost model for the memory
usage. Being low on free memory itself is not a bad thing, i.e. you are
paying for the amount of memory so it would be rather sub-optimal to not
use it whole, right? If the memory can be reclaimed easily (e.g. by
reclaiming idle caches) then the overhead of a high memory utilization
should be reasonably low so the overal price of the reclaim is worth it.
On the other hand an over utilized system with a working set size larger
than the available memory would spend a lot of time reclaiming so the
performance would drop down.

All that being said the primary question is what is your usecase.
-- 
Michal Hocko
SUSE Labs
