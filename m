From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V5 3/8] memcg: check for proper lock held in mem_cgroup_update_page_stat
Date: Sun, 04 Aug 2013 11:48:18 -0700
Message-ID: <xr93a9kxwavh.fsf@gthelen.mtv.corp.google.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
	<1375357946-10228-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:message-id:user-agent
         :mime-version:content-type;
        bh=ALycO9BgO3mIUzX6i5vvAdJDBccBA0pjkglwMgP1ThA=;
        b=E6+oA6Kmig9vSAB/hN2gjIgIUnYqtCcsPdOPgahQYJqG28106mhEzoLDQqoU/6Yiu2
         +rq1A+rHeiQ/JnCJ4jzr42EyABKShLwydja6GZG6d+NCNUDQrTiCGyG1+Q3wWqeP/aPs
         gr/BnEXEiOW9VWObMh7StEqGm4m6yzyRvzJYPMRzOxZq73udxN+/OzejJm9AZHMii0+5
         HvYgzRX2tp378RNEut+rx/vWMKFUdcqxInPSy+SbDrsQi4eseVOoFIYu49hkggdcgqYd
         00rqWUmhIQRZKwtGxOCvcRdJtNGUj//7gqKuf4NqwOxPQ7NBbdIuJo30cxErvoQeJBEA
         yvWA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu, Aug 01 2013, Sha Zhengju wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> We should call mem_cgroup_begin_update_page_stat() before
> mem_cgroup_update_page_stat() to get proper locks, however the
> latter doesn't do any checking that we use proper locking, which
> would be hard. Suggested by Michal Hock we could at least test for
                                     ^^ Hocko
> rcu_read_lock_held() because RCU is held if !mem_cgroup_disabled().
>
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  mm/memcontrol.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7691cef..4a55d46 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2301,6 +2301,7 @@ void mem_cgroup_update_page_stat(struct page *page,
>  	if (mem_cgroup_disabled())
>  		return;
>  
> +	VM_BUG_ON(!rcu_read_lock_held());
>  	memcg = pc->mem_cgroup;
>  	if (unlikely(!memcg || !PageCgroupUsed(pc)))
>  		return;
