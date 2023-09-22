From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg, oom: do not wake up memcg_oom_waitq if
 waitqueue is empty
Date: Fri, 22 Sep 2023 16:22:25 -0700
Message-ID: <ZQ4hsQRp31RXMOfv@P9FQF9L96D.corp.robot.car>
References: <20230922070529.362202-2-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695424949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Yd5FAYRp2gWhAoux+J4rXbuTHxCOAELJy5W8/YW14E=;
        b=SpxHInxhdJoSkVJUo8IGgUe0T+xeuNN/TwfobKv6NiHAwLsdG8y1Y7g7X+2NNsUrtNDvEF
        KWX9a/mwXDZt6d7i0ga1Kyily9Clp8bpc23e6KTYoBISUl8//BqxkZz2k+ILhW+gTIfOc4
        yOr0z/NNYPOR5SKg4wCaICwa8fC0JXU=
Content-Disposition: inline
In-Reply-To: <20230922070529.362202-2-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Sep 22, 2023 at 07:05:29AM +0000, Haifeng Xu wrote:
> Only when memcg oom killer is disabled, the task which triggers memecg
> oom handling will sleep on a waitqueue. Except this case, the waitqueue
> is empty though under_oom is true. There is no need to step into wake
> up path when resolve the oom situation. So add a check that whether the
> waitqueue is empty.
> 
> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0b6ed63504ca..2bb98ff5be3d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1918,7 +1918,7 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
>  	 * achieved by invoking mem_cgroup_mark_under_oom() before
>  	 * triggering notification.
>  	 */
> -	if (memcg && memcg->under_oom)
> +	if (memcg && memcg->under_oom && !list_empty(&memcg_oom_waitq.head))
>  		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);

This change looks questionable to me:
1) it's not obvious that this racy check is fine. can an oom event be
   missed because of a race here? why not?
2) is there any measurable impact? it's not a hot path, so I'd keep it
   simple.

Thanks!
