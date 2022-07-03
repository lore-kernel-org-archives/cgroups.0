From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v6 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Sun, 3 Jul 2022 16:23:40 -0700
Message-ID: <20220703162340.cb90924355dacbb7437ab595@linux-foundation.org>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656890621;
        bh=EDIwVumbRS+j2biW/LWEapjenLtWMcKX8aj62iSrHFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UGoty1uxOxulUsQC/avpz8A7yZpRuf7BdzfbceCmcdN+XaD+urZDeSlb6tyAxPZfO
         K+dIpKI3tvnIYwdfDirzlucGlozflAtVanLk5BUjPWntuAOYGjHdgLNk2BtL9kDtrk
         IJ+i8dgF7XEGChVK7VyVarTJ4q9rqmJJCYvnN130=
In-Reply-To: <20220621125658.64935-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, 21 Jun 2022 20:56:47 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:

> This version is rebased on mm-unstable. Hopefully, Andrew can get this series
> into mm-unstable which will help to determine whether there is a problem or
> degradation. I am also doing some benchmark tests in parallel.
> 
> Since the following patchsets applied. All the kernel memory are charged
> with the new APIs of obj_cgroup.
> 
> 	commit f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects instead of pages")
> 	commit b4e0b68fbd9d ("mm: memcontrol: use obj_cgroup APIs to charge kmem pages")
> 
> But user memory allocations (LRU pages) pinning memcgs for a long time -
> it exists at a larger scale and is causing recurring problems in the real
> world: page cache doesn't get reclaimed for a long time, or is used by the
> second, third, fourth, ... instance of the same job that was restarted into
> a new cgroup every time. Unreclaimable dying cgroups pile up, waste memory,
> and make page reclaim very inefficient.
> 
> We can convert LRU pages and most other raw memcg pins to the objcg direction
> to fix this problem, and then the LRU pages will not pin the memcgs.
> 
> This patchset aims to make the LRU pages to drop the reference to memory
> cgroup by using the APIs of obj_cgroup. Finally, we can see that the number
> of the dying cgroups will not increase if we run the following test script.
> 
> ...
>

I don't have reviewer or acker tags on a couple of these, but there is
still time - I plan to push this series into mm-stable around July 8.

