From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] memcg: make memcg_update_cache_sizes() static
Date: Fri, 29 Nov 2013 10:45:49 +0100
Message-ID: <20131129094549.GE25893@dhcp22.suse.cz>
References: <1385567162-14973-1-git-send-email-vdavydov@parallels.com>
 <1385567162-14973-2-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fM2yaBH15y1h3zbiYvNh525Z9/jjapm5ETljg7QAhhs=;
        b=COO1RRzuHkh3csgP/y2ITHubazcPQ0HqhK4JPNigppe4lfO04QNYV0Zzhloh8GrRJS
         umuqW34MQenq91ewMgKrV8MoEiM0kcYxVzPa6LvM+f3nD5mQI4Ip2Pqa/tg79XDJn5HR
         1tY0TWRYVuc9d0CEn2MFgj5YJfST8gV0o2vyiXquvtKzV8gv0Z5M+OFDmreWVEyEG+jN
         fEjpPbwU1k/u1BDq93PpggXIyhLTgYGFI9Q0taJ9lKRZTr9kWoFiWe6fydnOD6etXJSm
         zVOvavQaFJrAlG1HD318WYOYb1Lk1QlGNojWRoS9EW+emz5F1hkC0pdRHexzdJKsdkhq
         Yaiw==
Content-Disposition: inline
In-Reply-To: <1385567162-14973-2-git-send-email-vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Wed 27-11-13 19:46:02, Vladimir Davydov wrote:
> This function is not used outside of memcontrol.c so make it static.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 40efb9d..b20b915 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3084,7 +3084,7 @@ int memcg_cache_id(struct mem_cgroup *memcg)
>   * But when we create a new cache, we can call this as well if its parent
>   * is kmem-limited. That will have to hold set_limit_mutex as well.
>   */
> -int memcg_update_cache_sizes(struct mem_cgroup *memcg)
> +static int memcg_update_cache_sizes(struct mem_cgroup *memcg)
>  {
>  	int num, ret;
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
