From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -next 1/4] blk-iocost: track whether iocg is still online
Date: Wed, 21 Dec 2022 02:33:51 -0800
Message-ID: <Y6LhD8CEkcgLUJoQ@infradead.org>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
 <20221217030527.1250083-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qo0/7oh20JB4vOMTtkVk74rFMV3lr/eFERwPDckaJ84=; b=CvfudaDgduzGkGO/tL8HCoG0cx
        Vc/Ed3d8vSiE7XbGKRh+aPrjOZK9rolmp/I9Vno85q9Wpgb9tIcV+ooTCk+Xt2ZwvR7x9tN3fepaG
        gtzJIt4P+lDSpucNMSjQtI4yAY0UKUMweQd09/TuwkZmfTzkVEA4P2vJIHz2vrjXm59VmfO/Bfj34
        ypTGRrN68fpcqATg/QgkQw3pIstO2GHIgsKOc/EAK+00mzVQ+SMX/1Tybvg5gv3sW/xMzfxsEBaus
        Lguks2sBH0yrSLIvW+onUv8D1bH/W4BjFIr39DPBJXCxQm4lKvdWg2xCmSM/i781J3eoDJgTEY1dr
        ifUFXrfQ==;
Content-Disposition: inline
In-Reply-To: <20221217030527.1250083-2-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Sat, Dec 17, 2022 at 11:05:24AM +0800, Yu Kuai wrote:
> @@ -459,6 +459,8 @@ struct ioc_gq {
>  	struct blkg_policy_data		pd;
>  	struct ioc			*ioc;
>  
> +	bool online;

Nit: maybe tab align this field like the fields above it.

> +static void ioc_pd_offline(struct blkg_policy_data *pd)
> +{
> +	struct ioc_gq *iocg = pd_to_iocg(pd);
> +	struct ioc *ioc = iocg->ioc;
> +	unsigned long flags;
> +
> +	if (ioc) {

How could ioc be NULL here?

