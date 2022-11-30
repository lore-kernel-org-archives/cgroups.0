From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 3/9] blk-iocost: don't allow to configure bio
 based device
Date: Wed, 30 Nov 2022 10:15:03 -1000
Message-ID: <Y4e5x37B2Mh+Bfko@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-4-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3g9mSSTzBVgbdJrFv6g4zSJhT5rvOWrA1mwwXQAvko=;
        b=NnQ1jmB4WIykg8PlJ1nvAeT8NodTppKpNNw5V8wAg7twFnjXER3jxgeXtinbAZOipL
         Iqdoqym1NEW5yg+yI0NB++i7g+Ou5mxRqZTTx5p240lN0z8rX8wBQvxQDyqvpxPTDeuw
         Ene8U600qy0MCvtjXul4oa6mbz9hf6l8preNi0VRD89TBvgVjTw++amZqBpCErV9IjyV
         BDepgmdUBmzgZ5/aXjRpn0G6Dm91zxoZM905O13+vTAQRIeKoB1SotMtiijyP+0Pyf4J
         XZLhtjtxiaMVzNzu9kONvMLvjaMfr1x1+S3DoJQGLBW6ObOPOo4wToh+mJ5tsGwsiEFN
         KNnA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-4-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Nov 30, 2022 at 09:21:50PM +0800, Li Nan wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> iocost is based on rq_qos, which can only work for request based device,
> thus it doesn't make sense to configure iocost for bio based device.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
