From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 3/4] mm/memcg: retrieve parent memcg from css.parent
Date: Tue, 11 Jan 2022 09:43:07 +0100
Message-ID: <Yd1DG99LPXDmDvvs@dhcp22.suse.cz>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641890588; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dvrQ8GpbOEr2tVquDL+ClTqdyZ22DJTvcyRoTEm2Few=;
        b=ZftksyPgJPdT1KN4Z0rpqdtOyK4aKsDM/AVcFvWWvEN/iE+DBT7/aePu9rel4KYi+UcjUF
        SOkLBQYNQZttG7U2AZdMQAV7CVBm/qAPiniQ2xtZwscP7phAtfbUK6rRGk7L6wCU52ttlG
        lVsVdKoJdFyAVDsVPS7feqxfuMGLcnI=
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-3-richard.weiyang@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang@gmail.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, vbabka@suse.cz, willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com, surenb@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue 11-01-22 01:03:01, Wei Yang wrote:
> The parent we get from page_counter is correct, while this is two
> different hierarchy.
> 
> Let's retrieve the parent memcg from css.parent just like parent_cs(),
> blkcg_parent(), etc.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/memcontrol.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0c5c403f4be6..12bf443f7b14 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -886,9 +886,7 @@ static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
>   */
>  static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
>  {
> -	if (!memcg->memory.parent)
> -		return NULL;
> -	return mem_cgroup_from_counter(memcg->memory.parent, memory);
> +	return mem_cgroup_from_css(memcg->css.parent);
>  }
>  
>  static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
> -- 
> 2.33.1

-- 
Michal Hocko
SUSE Labs
