From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-iocost: Pass gendisk to ioc_refresh_params
Date: Mon, 27 Feb 2023 08:27:19 -1000
Message-ID: <Y/z2B+153X0PYpjO@slm.duckdns.org>
References: <20230227151252.1411499-1-leitao@debian.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mGr1oL/pZpPll19+c3ioRmhLkSsTJHby1AuhBJm//pc=;
        b=AXLk46Xo38NfyHxtx8zulMsDJlEFXxboaZ7CcFKXsR8lysmnKJevshrI8i8WK3fJTF
         uWR4w1WfELt0Mq+azcWdHPKbNrLZ4SbbMF+Dkc5RflxcjT1jViFzgFaN1/07tFwvLGFX
         NcxpDm+af0Io/ke056P3+ooazUZqZtyEcVpRp3fNMnNcS71FCcdqPYfKgzryOUsxSAj1
         7fUCo5vF3vh8qRZlYEh/4zoRmerPgXNLa9QB4SRDNimzCG6/nMmNK209HnPte1nf7Wu5
         VnR2Yv9PRATCOS9AS8FmpBZfQeJ7dumwjV4T5CKMSSKlVeffBA9uLpS0wEJocpilftqF
         uOYQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230227151252.1411499-1-leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, aherrmann-l3A5Bk7waGM@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leit-b10kYP2dOMg@public.gmane.org

Hello,

A couple minor nitpicks:

Can you please add a short comment here too saying that @ioc->rqos.disk
isn't initialized yet when this function is called from the init path?

> +static int ioc_autop_idx(struct ioc *ioc, struct gendisk *disk)
>  {
>  	int idx = ioc->autop_idx;
>  	const struct ioc_params *p = &autop[idx];
> @@ -808,11 +808,11 @@ static int ioc_autop_idx(struct ioc *ioc)
>  	u64 now_ns;
>  
>  	/* rotational? */
> -	if (!blk_queue_nonrot(ioc->rqos.disk->queue))
> +	if (!blk_queue_nonrot(disk->queue))
>  		return AUTOP_HDD;
>  
>  	/* handle SATA SSDs w/ broken NCQ */
> -	if (blk_queue_depth(ioc->rqos.disk->queue) == 1)
> +	if (blk_queue_depth(disk->queue) == 1)
>  		return AUTOP_SSD_QD1;
>  
>  	/* use one of the normal ssd sets */
> @@ -901,14 +901,19 @@ static void ioc_refresh_lcoefs(struct ioc *ioc)
>  		    &c[LCOEF_WPAGE], &c[LCOEF_WSEQIO], &c[LCOEF_WRANDIO]);
>  }
>  
> -static bool ioc_refresh_params(struct ioc *ioc, bool force)
> +/*
> + * struct gendisk is required as an argument because ioc->rqos.disk
> + * might not be properly initialized
> + */

Here too, let's explicitly say when it's not initialized.

> +static bool _ioc_refresh_params(struct ioc *ioc, bool force,
> +				struct gendisk *disk)

Given that __ are about an order of magnitude more common in the kernel,
would you mind renaming it to __ioc_refresh_params() or e.g.
ioc_refresh_params_disk()?

Please feel free to add

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
