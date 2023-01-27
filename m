From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/15] blk-cgroup: pin the gendisk in struct blkcg_gq
Date: Fri, 27 Jan 2023 13:15:18 -1000
Message-ID: <Y9RbBkyqhiRcSiRf@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1eAZDC+CSdqDtsryai1DaA/T4ovNaxm1PeaJnPbpd9g=;
        b=SsGqF9F0m/273yWjG9aHVv0nTg7qlrqNz9yqDYeIZeBP8oEQIILBEgBmw485h86cR4
         l0qRlv+V9ONcMmi5G1H3SHro4JrPu6U5NWuIaRGZTn7TFJ1HdT0lsXBSSAZTDG+iq6ah
         pwBudbcPE8M9MW2HLEr0psgNmoM2OqjipeLuMzUZkSO8ly12JP7u5+L/vBKIbhX1z1ng
         QXIhNv6MN8wuYYeqC1N7NcXd2MVi6QbOw1kAl3zpMmLvLQ1yPJnhLAknvL1pw8Io7GSn
         KPO0jMMXpXlAe+Fr6aEku2rjv/YYDrdwo6FwJ75olaW7SjdR9cKohZBjzwzM1Mg3gqCl
         Shqg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-5-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

Hello,

On Tue, Jan 24, 2023 at 07:57:04AM +0100, Christoph Hellwig wrote:
> @@ -245,10 +245,9 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
>  	if (!blkg->iostat_cpu)
>  		goto err_free;
>  
> -	if (!blk_get_queue(disk->queue))
> -		goto err_free;
> +	get_device(disk_to_dev(disk));

We lose the blk_queue_dying() test here. It'd be great if the patch
description explains why this is safe.

> @@ -547,9 +546,7 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
>  
>  const char *blkg_dev_name(struct blkcg_gq *blkg)
>  {
> -	if (!blkg->q->disk || !blkg->q->disk->bdi->dev)
> -		return NULL;
> -	return bdi_dev_name(blkg->q->disk->bdi);
> +	return bdi_dev_name(blkg->disk->bdi);

This isn't completely trivial like other conversions. Maybe worth mentioning
in the description too?

Thanks.

-- 
tejun
