From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC][PATCH 2/3] memcg: reduce size of struct page_cgroup.
Date: Thu, 22 Mar 2012 14:11:12 +0100
Message-ID: <20120322131112.GC18665@tiehlicka.suse.cz>
References: <4F66E6A5.10804@jp.fujitsu.com>
 <4F66E7D7.4040406@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F66E7D7.4040406-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon 19-03-12 17:01:27, KAMEZAWA Hiroyuki wrote:
> Now, page_cgroup->flags has only 3bits. Considering alignment of
> struct mem_cgroup, which is allocated by kmalloc(), we can encode
> pointer to mem_cgroup and flags into a word.
                                  into a single word.

> 
> After this patch, pc->flags is encoded as
> 
>  63                           2     0
>   | pointer to memcg..........|flags|

Looks good.
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  include/linux/page_cgroup.h |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 92768cb..bca5447 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -1,6 +1,10 @@
>  #ifndef __LINUX_PAGE_CGROUP_H
>  #define __LINUX_PAGE_CGROUP_H
>  
> +/*
> + * Because these flags are encoded into ->flags with a pointer,
> + * we cannot have too much flags.
                     ^^^^^^^^^^^^^^ 
cannot have too many flags 
but an explicit BUILD_BUG_ON would be much more precise than a comment I
guess.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
