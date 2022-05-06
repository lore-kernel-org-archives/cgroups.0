From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Fri, 6 May 2022 15:41:50 +0200
Message-ID: <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651844512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pXZ/Mip46MPK94udG6dn0vA9jCul4KfitQH0YKOCKlo=;
        b=VV80UgGUua9ByI5dnKDgazpxk/aupgxGDKd9KoBkpD9krA/NR1XXVh6kgSKaZ7FUzsf8f0
        zkBRcq08cNuw+WGzG+8vRnfHpT3IQstg+wTRO7clRbPhs6BBEHLo0KCBFeEKzSE5o9Tl3z
        hIkEaaxexMDzsfw5D/nqLKWqnK7j/Zw=
Content-Disposition: inline
In-Reply-To: <20220505033814.103256-1-xu.xin16-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Thu 05-05-22 03:38:15, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org> 
> 
> Using THP may promote the performance of memory, but increase memory
> footprint. Applications may use madvise to decrease footprint, but
> not all applications support using madvise, and it takes much costs
> to re-code all the applications. And we notice container becomes more
> and more popular to manage a set of tasks.

Could you be more specific about the actual usecase? When do you group
processes based on their general THP reqirements? You are mentioning
containers but those are usually bags of different processes that just
share a common objective.
 
> So add support for cgroup to control THP behaviour will provide much
> convenience, administrator may only enable THP for important containers,
> and disable it for other containers.

Why would that be a matter of importance?

Also what is actual semantic when processes living inside those cgroups
explicitly state their THP requirements?

-- 
Michal Hocko
SUSE Labs
