From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: make threshold index in the right position
Date: Fri, 3 Feb 2012 10:35:30 +0900
Message-ID: <20120203103530.417b7d9c.kamezawa.hiroyu@jp.fujitsu.com>
References: <1328175919-11209-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328175919-11209-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

On Thu,  2 Feb 2012 17:45:19 +0800
Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> Index current_threshold may point to threshold that just equal to
> usage after __mem_cgroup_threshold is triggerd. But after registering
> a new event, it will change (pointing to threshold just below usage).
> So make it consistent here.
> 
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Could you add the explanation you did to Kirill into the patch description ?

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Thanks,
-Kame


> ---
>  mm/memcontrol.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22d94f5..79f4a58 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -183,7 +183,7 @@ struct mem_cgroup_threshold {
>  
>  /* For threshold */
>  struct mem_cgroup_threshold_ary {
> -	/* An array index points to threshold just below usage. */
> +	/* An array index points to threshold just below or equal to usage. */
>  	int current_threshold;
>  	/* Size of entries[] */
>  	unsigned int size;
> @@ -4319,14 +4319,15 @@ static int mem_cgroup_usage_register_event(struct cgroup *cgrp,
>  	/* Find current threshold */
>  	new->current_threshold = -1;
>  	for (i = 0; i < size; i++) {
> -		if (new->entries[i].threshold < usage) {
> +		if (new->entries[i].threshold <= usage) {
>  			/*
>  			 * new->current_threshold will not be used until
>  			 * rcu_assign_pointer(), so it's safe to increment
>  			 * it here.
>  			 */
>  			++new->current_threshold;
> -		}
> +		} else
> +			break;
>  	}
>  
>  	/* Free old spare buffer and save old primary buffer as spare */
> -- 
> 1.7.4.1
> 
> 
