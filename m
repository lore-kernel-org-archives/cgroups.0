From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is
 done
Date: Mon, 25 Sep 2023 09:57:48 +0200
Message-ID: <ZRE9fAf1dId2U4cu@dhcp22.suse.cz>
References: <20230922070529.362202-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695628669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=878uZwZWbWAa9WLyZURZrcUcT1iIEeDeTu8lVz1v0Rk=;
        b=GGSnKBycveNXuhvySz5Lw/xh2lozc1ZmzaQDsxf5W5dyn6hUclOjeLkrKuIqtqO6I2wXG4
        706kpSTT1iyYaW+01rawFVNd0/Q7oqVIwcBPhvtVNGw9q7AjKxEhgEajXimZrZR6zQBZnR
        ze4hHML9wJSp8x6JjkgH6cIFhwQLfe4=
Content-Disposition: inline
In-Reply-To: <20230922070529.362202-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 22-09-23 07:05:28, Haifeng Xu wrote:
> When application in userland receives oom notification from kernel
> and reads the oom_control file, it's confusing that under_oom is 0
> though the omm killer hasn't finished. The reason is that under_oom
> is cleared before invoking mem_cgroup_out_of_memory(), so move the
> action that unmark under_oom after completing oom handling. Therefore,
> the value of under_oom won't mislead users.

I do not really remember why are we doing it this way but trying to track
this down shows that we have been doing that since fb2a6fc56be6 ("mm:
memcg: rework and document OOM waiting and wakeup"). So this is an
established behavior for 10 years now. Do we really need to change it
now? The interface is legacy and hopefully no new workloads are
emerging.

I agree that the placement is surprising but I would rather not change
that unless there is a very good reason for that. Do you have any actual
workload which depends on the ordering? And if yes, how do you deal with
timing when the consumer of the notification just gets woken up after
mem_cgroup_out_of_memory completes?

> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e8ca4bdcb03c..0b6ed63504ca 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1970,8 +1970,8 @@ static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
>  	if (locked)
>  		mem_cgroup_oom_notify(memcg);
>  
> -	mem_cgroup_unmark_under_oom(memcg);
>  	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> +	mem_cgroup_unmark_under_oom(memcg);
>  
>  	if (locked)
>  		mem_cgroup_oom_unlock(memcg);
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
