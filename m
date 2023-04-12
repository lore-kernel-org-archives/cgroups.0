From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] blk-throttle: only enable blk-stat when
 BLK_DEV_THROTTLING_LOW
Date: Wed, 12 Apr 2023 07:14:52 -1000
Message-ID: <ZDbnDGtoY3q_ow-R@slm.duckdns.org>
References: <20230412160754.1981705-1-chengming.zhou@linux.dev>
 <20230412160754.1981705-2-chengming.zhou@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681319694; x=1683911694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0VRajwDCS1Rg/Spw2tnj0AXocI1N336v8O1yep9+DQ=;
        b=XJVCAGJvep9wSQoZc+nwUbfW82+Of3wXWE/YDZ5k0WnQWWtRGPvsWU0H12x3yS5WtG
         QGdKQe78HYFpYAlup1V8VDN/C/EESxfacz/ioZawPOwehU9KWuxpOjpbglXradyFQ8WB
         mGwncSrB8+h2DUjD0Kp/61qCFlso9DW858E4XFAYV80UB/2lez035y2GRlhqU0M56l+D
         YWKJYvgpYwwUQSqYiV8DFfXOeRHehET1hiNu79Rk6o9vvr16Sfy6pA91D6uveMcFulQs
         TdqScjNKaV7gS67hcMlK3bHH+iQAhYjg2AotxU3ZYiwJuCFkKHWs2RT31Pj4JN28H7/S
         an2g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230412160754.1981705-2-chengming.zhou-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengming.zhou-fxUVXftIFDnyG1zEObXtfA@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Thu, Apr 13, 2023 at 12:07:54AM +0800, chengming.zhou-fxUVXftIFDnyG1zEObXtfA@public.gmane.org wrote:
> From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> blk_throtl_register() will unconditionally enable blk-stat for gendisk
> when register, even when we have no BLK_DEV_THROTTLING_LOW config.
> 
> Since the kernel always has only BLK_DEV_THROTTLING config and the
> BLK_DEV_THROTTLING_LOW config is still in EXPERIMENTAL state, we can
> just skip blk-stat when !BLK_DEV_THROTTLING_LOW.
> 
> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
