From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 19:22:26 -0700
Message-ID: <YwQ54pvNwy0/5u3C@P9FQF9L96D>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
 <YwPM6o1+pZ2kRyy3@P9FQF9L96D>
 <YwPZ1lpJ98pZSLmw@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661221352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TZOqb9ioXhJDay90SUSTe6Atr/mSmzrNsQskOLmcTw4=;
        b=jI0qftCBqUXZ/ZlfsIX0UQLffYq89HNRsd9OT0MrXYVBD4YWNdLsaPUXLt1Nt8conY9VNu
        Our9SMBCO6MRU92nM4eMoAvX1Z8XNGtZscdF3oPd/WL6APpO+wU/shrYeBfxkhKV2gs4cB
        8Ikj1k7/usuDTGr3ZyOp6n5d4u0jScI=
Content-Disposition: inline
In-Reply-To: <YwPZ1lpJ98pZSLmw-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 22, 2022 at 09:34:59PM +0200, Michal Hocko wrote:
> On Mon 22-08-22 11:37:30, Roman Gushchin wrote:
> [...]
> > I wonder only if we want to make it configurable (Idk a sysctl or maybe
> > a config option) and close the topic.
> 
> I do not think this is a good idea. We have other examples where we have
> outsourced internal tunning to the userspace and it has mostly proven
> impractical and long term more problematic than useful (e.g.
> lowmem_reserve_ratio, percpu_pagelist_high_fraction, swappiness just to
> name some that come to my mind). I have seen more often these to be used
> incorrectly than useful.

A agree, not a strong opinion here. But I wonder if somebody will
complain on Shakeel's change because of the reduced accuracy.
I know some users are using memory cgroups to track the size of various
workloads (including relatively small) and 32->64 pages per cpu change
can be noticeable for them. But we can wait for an actual bug report :)

> 
> In this case, I guess we should consider either moving to per memcg
> charge batching and see whether the pcp overhead x memcg_count is worth
> that or some automagic tuning of the batch size depending on how
> effectively the batch is used. Certainly a lot of room for
> experimenting.

I'm not a big believer into the automagic tuning here because it's a fundamental
trade-off of accuracy vs performance and various users might make a different
choice depending on their needs, not on the cpu count or something else.

Per-memcg batching sounds interesting though. For example, we can likely
batch updates on leaf cgroups and have a single atomic update instead of
multiple most of the times. Or do you mean something different?

Thanks!
