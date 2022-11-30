From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 4/9] blk-iocost: read params inside lock in
 sysfs apis
Date: Wed, 30 Nov 2022 10:16:24 -1000
Message-ID: <Y4e6GANZCJbz7jNk@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-5-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oPepsFkzzAlPERh82aZt4pkV/bnS504IWTOqRm6eglI=;
        b=YYkKiuPumm27s0EmcWsUUHG5e9ytXuN0TIr3LbH2yjsTP3/CYiHOdAUaC7tpxgzbYw
         ham/qqRP9Rf8oGtfxozA3Od1Yr1xxcSp6EFq1Vb5gvMEiTeO8WSRy2WGpvYYDdestnar
         zqAR+LFnsmNAHWmK04ikJBKx0eHFGgBoJAojHQWoJHwuQpi4YBGbDY3Igq7+lyuiQpMk
         FSyoFlMJ30RdpTQ7KPLH6Fd35hZ8zk0efiBZjtF0bLCH4djtWO4D4xSglwKTsOVmj90O
         lEofmsroronNsvdpunT05r8iya9bqU0VlxNYXkmzTzhYAN1wC1XCn9nioQbbmhqmMn9v
         1Yrg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-5-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Nov 30, 2022 at 09:21:51PM +0800, Li Nan wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Otherwise, user might get abnormal values if params is updated
> concurrently.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
