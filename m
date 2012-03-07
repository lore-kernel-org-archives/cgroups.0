From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH] memcg: Free spare array to avoid memory leak
Date: Thu, 8 Mar 2012 01:08:19 +0200
Message-ID: <20120307230819.GA10238@shutemov.name>
References: <1331036004-7550-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1331036004-7550-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue, Mar 06, 2012 at 08:13:24PM +0800, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> When the last event is unregistered, there is no need to keep the spare
> array anymore. So free it to avoid memory leak.

It's not a leak. It will be freed on next event register.

Yeah, we don't have to keep spare if primary is empty. But is it worth to
make code more complicated to save few bytes of memory?

> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  mm/memcontrol.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22d94f5..3c09a84 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>  swap_buffers:
>  	/* Swap primary and spare array */
>  	thresholds->spare = thresholds->primary;
> +	/* If all events are unregistered, free the spare array */
> +	if (!new) {
> +		kfree(thresholds->spare);
> +		thresholds->spare = NULL;
> +	}
> +
>  	rcu_assign_pointer(thresholds->primary, new);
>  
>  	/* To be sure that nobody uses thresholds */
> -- 
> 1.7.4.1
> 

-- 
 Kirill A. Shutemov
