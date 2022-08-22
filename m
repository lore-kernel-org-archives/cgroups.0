From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 21:34:59 +0200
Message-ID: <YwPZ1lpJ98pZSLmw@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
 <YwPM6o1+pZ2kRyy3@P9FQF9L96D>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661196900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LOpaT2Q971EUbjBeeWliYNilDBmmPl4LkCkk2UWfDk=;
        b=pGEsQUrii2Ffpmtr8KAOdRMqyQVwo8KxxpKgeV2D/hGy/FAz5HnnGfP7IbIGRpYoALy/83
        Z0JgiA3PYFUqXzFCRRTdOyzmioQ6Bv6y4aiwX2z9ik5cMyyYrSK5ef31rrS/qDgN6JTj/9
        FKohA1XnzPJ/oDg92mSqV9HH3EYkttw=
Content-Disposition: inline
In-Reply-To: <YwPM6o1+pZ2kRyy3@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 22-08-22 11:37:30, Roman Gushchin wrote:
[...]
> I wonder only if we want to make it configurable (Idk a sysctl or maybe
> a config option) and close the topic.

I do not think this is a good idea. We have other examples where we have
outsourced internal tunning to the userspace and it has mostly proven
impractical and long term more problematic than useful (e.g.
lowmem_reserve_ratio, percpu_pagelist_high_fraction, swappiness just to
name some that come to my mind). I have seen more often these to be used
incorrectly than useful.

In this case, I guess we should consider either moving to per memcg
charge batching and see whether the pcp overhead x memcg_count is worth
that or some automagic tuning of the batch size depending on how
effectively the batch is used. Certainly a lot of room for
experimenting.

-- 
Michal Hocko
SUSE Labs
