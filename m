From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] block: cancel all throttled bios in del_gendisk()
Date: Wed, 1 Dec 2021 07:01:17 -1000
Message-ID: <YaeqXU82Nta+PhF6@slm.duckdns.org>
References: <20211201094014.330165-1-yukuai3@huawei.com>
 <20211201094014.330165-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TNnID0pM8oD7D3r3FRXAh0e1o2KiMtfDSMZ8UHjXvhI=;
        b=dA/1Ba+LXxVdHk43lnRtTzYYDEZnm1SeoS0qMwFyrvslSljbrcih2aHLkBv/eg0g/S
         Rf8+0rtVJULopDo6OM56rZ6WqrqPJ4CTvtRnO+l86qBYKxO3quT+wQApFx6yvrrWYODt
         xNl1JJhBLj7Yj1fmVIZJ7BDT891ygHW2J5ZOsniAQRXzPJQ3CEK7euX1Lg6spl9S1Gw/
         4TWulikB7LeCxicPmwmN9MH4Mbq/oh/w7VG6FcNqc7w8VTvgj1HE9coW4lWeVOSX9+Sa
         hmeWoS1nBVuWI8NXlK+9QgRojQ2NLvpzV27X3zhhHlxRKCLFX0UrGEnSceae5jt3myoG
         NCRg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211201094014.330165-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Dec 01, 2021 at 05:40:14PM +0800, Yu Kuai wrote:
> +	/*
> +	 * hold queue_lock to prevent concurrent with dispatching
> +	 * throttled bios by timer.
> +	 */
> +	spin_lock_irq(&q->queue_lock);
> +	rcu_read_lock();

Can you see whether it still needs rcu_read_lock() while holding queue_lock?
Now that all RCU flavors are merged, I think just holding the queue_lock
should be enough here.

Looks good otherwise.

Thanks.

-- 
tejun
