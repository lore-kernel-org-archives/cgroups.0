From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/4] mm: memcontrol: remove memcg check from
 memcg_oom_recover
Date: Mon, 15 Feb 2021 10:24:45 +0100
Message-ID: <YCo93axI0xUMbM4I@dhcp22.suse.cz>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613381086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xB5MBNbB1QLYYTbvCj1weox/L1QyvBLNycXdZJ/J33s=;
        b=msIiFaMGkdJ4pDCv0zyVzZbaNCFRTvzOfXRSNRzqy3NRtv9ZBePOOmmS5Aicny13IwoBJR
        cOnnBmTXrlauKa0ifYK8IfQd8C24XTIjw4Y7qX0E0tuRGrIu60sL/0UThYl+CsPbdYZWsm
        sfYS0TqbdIhAmdfPROvuM5Tk0ePE4OU=
Content-Disposition: inline
In-Reply-To: <20210212170159.32153-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 13-02-21 01:01:56, Muchun Song wrote:
> The memcg_oom_recover() almost never do anything but the test (because
> oom_disabled is a rarely used) is just waste of cycles in some hot
> paths (e.g. kmem uncharge). And it is very small, so it is better to
> make it inline. Also, the parameter of memcg cannot be NULL, so removing
> the check can reduce useless check.

You probably wanted to make this patch follow the second one in the
series. As there is no oom recover form the kmem uncharge path now. Also
I believe that I've asked you to split the memcg check to its separate
patch.

Regarding the inlining, I would add it along with a static key check in
memcg_oom_recover.

> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8c035846c7a4..7afca9677693 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1925,7 +1925,7 @@ static int memcg_oom_wake_function(wait_queue_entry_t *wait,
>  	return autoremove_wake_function(wait, mode, sync, arg);
>  }
>  
> -static void memcg_oom_recover(struct mem_cgroup *memcg)
> +static inline void memcg_oom_recover(struct mem_cgroup *memcg)
>  {
>  	/*
>  	 * For the following lockless ->under_oom test, the only required
> @@ -1935,7 +1935,7 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
>  	 * achieved by invoking mem_cgroup_mark_under_oom() before
>  	 * triggering notification.
>  	 */
> -	if (memcg && memcg->under_oom)
> +	if (memcg->under_oom)
>  		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
>  }
>  
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
