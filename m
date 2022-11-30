From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/10] blk-throttle: remove repeat check of elapsed
 time from last upgrade in throtl_hierarchy_can_downgrade
Date: Wed, 30 Nov 2022 11:34:18 -1000
Message-ID: <Y4fMWvr0PQXhJNNz@slm.duckdns.org>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-9-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQaaCYRaH7FJdGcFxn1nAT6sve1WgBKeRZDBUjitAtQ=;
        b=ICKSZlXzxHqwLEwTb9STGr6dg5avLp4EIUiAtituFWz/GyAFIn0+Qxc2/p8Yn8Ti0w
         qs/34+Z6bPZG0earjXXvVoArsdkTrneZawYVPCK4ojZNhgZ0y3yoHXs63HZWl2r3RxSH
         nHWRT8dXAyaq373nWvTQD11RbltKqYaa2oRi1sWIErvMVX1Cen6SgXpST7DSvqHdW8nr
         k/7RUgeZJg0I/xx1pudIDUibzZxggIZ/vtcuCJCKdui658FAFlCLQ3Pqdy5t9MsQ/e+c
         LCcREScegfNOrfO3UMD3+lCJzKXLXcyE3LMJTK0pDDsTKP0WkaPIdRy3PJ7fVun9Mfv1
         hd3g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221129030147.27400-9-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 29, 2022 at 11:01:45AM +0800, Kemeng Shi wrote:
> There is no need to check elapsed time from last upgrade for each node in
> hierarchy. Move this check before traversing as throtl_can_upgrade do
> to remove repeat check.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
