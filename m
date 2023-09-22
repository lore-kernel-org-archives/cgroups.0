From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is
 done
Date: Fri, 22 Sep 2023 16:17:28 -0700
Message-ID: <ZQ4giCbTqUpmKWAa@P9FQF9L96D.corp.robot.car>
References: <20230922070529.362202-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695424651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iQQ1ROeb5sVWDljoKrPkH1Y3Dt9naFHqMwDT9jkaz80=;
        b=lDcVe7Ctz0mr4FYdfk0PCQoXY9LxRip/ravP62GITtVHu/Vmta5XDggxyz6KEvsRfYJGd3
        /PvmthJtM6zLKMIC7BNZIJjh2XpsYjdkw8ehXNSVqIMHmqqdZDf0s+Jk2SEQU29sVHGeMX
        DfVr3cbPy8lpYlN/qX+ybiWaO7kS+eU=
Content-Disposition: inline
In-Reply-To: <20230922070529.362202-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Sep 22, 2023 at 07:05:28AM +0000, Haifeng Xu wrote:
> When application in userland receives oom notification from kernel
> and reads the oom_control file, it's confusing that under_oom is 0
> though the omm killer hasn't finished. The reason is that under_oom
> is cleared before invoking mem_cgroup_out_of_memory(), so move the
> action that unmark under_oom after completing oom handling. Therefore,
> the value of under_oom won't mislead users.
> 
> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Makes sense to me.

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!

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
> 
