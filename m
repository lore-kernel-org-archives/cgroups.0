From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] blk-cgroup: Add NULL check of pd_alloc_fn in
 blkcg_activate_policy
Date: Mon, 10 Oct 2022 10:29:17 -1000
Message-ID: <Y0SAneaJadYJwAkr@slm.duckdns.org>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-4-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qr1zRzW9mIDZS/nVxaVGHN2uZpMu0+zVTkGmRH0RCk0=;
        b=eCblmHQH4kyDc1eYk4XHk4yv5M7ka130o2+oGxoV8jwDPHThtNZPex0/wfw3fFx6V5
         8KOVo4KL30D1u7o2Ml5xYgwgjmfLOQ9rCreqVe1R7811ITpYjqT3obRQrlUF9dPU9f1G
         1JYXHZouF9Wh/oQXgxqi2iYMGduftdCuGx5HJtQLoPmeX85KvGmJdixnplooQkslRqaR
         NbjyTeop3s4FJi2H4tsQTSWoz2ehNfudk0lKTwWtUHQ0YqoRCPAaPdRPHhkhf/UEnLzb
         MzLbw76gk5sa58/NTbRCF8ONslpZW+g74EIqDj/QIWOY5qChntmvRCBzZrFV7YGpSo1m
         ruXA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221010023859.11896-4-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 10, 2022 at 10:38:58AM +0800, Kemeng Shi wrote:
> Function blkcg_policy_register only make sure pd_alloc_fn and pd_free_fn in
> pairs, so pd_alloc_fn could be NULL in registered blkcg_policy. Check NULL
> before use for pd_alloc_fn in blkcg_activate_policy to avoid protential
> NULL dereference.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
> ---
>  block/blk-cgroup.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 463c568d3e86..fc083c35dc42 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1404,6 +1404,9 @@ int blkcg_activate_policy(struct request_queue *q,
>  	if (blkcg_policy_enabled(q, pol))
>  		return 0;
>  
> +	if (pol->pd_alloc_fn == NULL)
> +		return -EINVAL;

This isn't the only place this function is called, so the above won't
achieve much. Given that this is rather trivially noticeable and all the
current users do implement pd_alloc_fn, I'm not sure we need to update this
now.

Thanks.

-- 
tejun
