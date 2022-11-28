From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-iocost: fix shift-out-of-bounds in
 iocg_hick_delay()
Date: Mon, 28 Nov 2022 09:58:18 -1000
Message-ID: <Y4US2vFmR4pnw08Z@slm.duckdns.org>
References: <20221128030413.882998-1-lijinlin3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fW5pu/oGfiEsFMKGLZAHU+S02fDyBuhcJUqWHINL2qU=;
        b=mx86HuOzrzmHVFcBmkCrHteGNzM0udqe/N2eUm6fMH2MBbX1t4PmdhNn+tBat/L0ad
         cBZ+zD49RA1+ZK+Cc9Uph5opYzkQ0i4yGNCB/ET7oI9hRX3+qg2Zf7XLlemLJvGlt01z
         FAjBLe2U/tvLvC4pYTUMQSJf577RdcisPSatY6/7pfOuoVkQDFlwGvZcQEYeI+3Ex+Lv
         4qfGpvfTGHFCwuxsHQnbIm59Vq4YUuqQk/qWfk/C4OGA2oBCvAXFioZGj+sHUIHAOQRE
         sjslj73JFVvORreDotKaFGVo1vdffNYJEChWtP+VpUyKv5z4aG0vVzeuUQMrY9qZHaVQ
         lW9Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221128030413.882998-1-lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Jinlin <lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Nov 28, 2022 at 11:04:13AM +0800, Li Jinlin wrote:
>  	/* calculate the current delay in effect - 1/2 every second */
>  	tdelta = now->now - iocg->delay_at;
>  	if (iocg->delay)
> -		delay = iocg->delay >> div64_u64(tdelta, USEC_PER_SEC);
> +		delay = iocg->delay >>
> +			min_t(u64, div64_u64(tdelta, USEC_PER_SEC), 63);

I replied earlier but the right thing to do here is setting delay to 0 if
the shift is >= 64.

Thanks.

-- 
tejun
