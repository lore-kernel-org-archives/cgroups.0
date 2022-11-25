From: Andreas Herrmann <aherrmann@suse.de>
Subject: Re: [PATCH -next 2/2] blk-iocost: change div64_u64 to
 DIV64_U64_ROUND_UP in ioc_refresh_params()
Date: Fri, 25 Nov 2022 11:14:44 +0100
Message-ID: <Y4CVlCgB5eSw03yI@suselix>
References: <20221124140635.695205-1-linan122@huawei.com>
 <20221124140635.695205-2-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669371287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ktt+/ZYL1xCbjfcRNgvv+Mm6BA/t+FfR0Lzt53hhHtI=;
        b=V7cYwN6zMePIafDyR97fv+1c1jMsEAutNfgvBs1R4VydI4ZqGvdSEGOuyZAz+ygMnMeudm
        Ryya9oCtbEHv8GSGL2M4e1cvFe/uAP4V6lhRy96kdF12nFtUupqgFVuD2gzCa7rxM4hCrp
        HJQlOZ+c9fbEswdA7+6hYnpOQVjs58g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669371287;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ktt+/ZYL1xCbjfcRNgvv+Mm6BA/t+FfR0Lzt53hhHtI=;
        b=3WF6NMPuqnXBsXUfc9heSPeKDZ+AIrd/O08jOtknxnXsCB5CsULsI4o7/4DTSq4IgbpBd8
        8krhfSd5ttmdn9DQ==
Content-Disposition: inline
In-Reply-To: <20221124140635.695205-2-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Nan <linan122@huawei.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Thu, Nov 24, 2022 at 10:06:35PM +0800, Li Nan wrote:
> vrate_min is calculated by DIV64_U64_ROUND_UP, but vrate_max is calculated
> by div64_u64. Vrate_min may be 1 greater than vrate_max if the input
> values min and max of cost.qos are equal.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  block/blk-iocost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index a38a5324bf10..9030ad8672f3 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -926,7 +926,7 @@ static bool ioc_refresh_params(struct ioc *ioc, bool force)
>  
>  	ioc->vrate_min = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MIN] *
>  					    VTIME_PER_USEC, MILLION);
> -	ioc->vrate_max = div64_u64((u64)ioc->params.qos[QOS_MAX] *
> +	ioc->vrate_max = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MAX] *
>  				   VTIME_PER_USEC, MILLION);
>  
>  	return true;
> -- 
> 2.31.1
> 

-- 
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
