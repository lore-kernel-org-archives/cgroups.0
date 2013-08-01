From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V5 3/8] memcg: check for proper lock held in
 mem_cgroup_update_page_stat
Date: Thu, 1 Aug 2013 16:34:59 +0200
Message-ID: <20130801143459.GH5198@dhcp22.suse.cz>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
 <1375357946-10228-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375357946-10228-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu 01-08-13 19:52:26, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> We should call mem_cgroup_begin_update_page_stat() before
> mem_cgroup_update_page_stat() to get proper locks, however the
> latter doesn't do any checking that we use proper locking, which
> would be hard. Suggested by Michal Hock we could at least test for
> rcu_read_lock_held() because RCU is held if !mem_cgroup_disabled().
> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

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
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
