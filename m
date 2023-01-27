From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 05/15] blk-cgroup: store a gendisk to throttle in struct
 task_struct
Date: Fri, 27 Jan 2023 13:40:00 -1000
Message-ID: <Y9Rg0GuNAmJPlDri@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-6-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bHHdtG+qXLcunlXNSfmfexDXB5Ie4ZWaLHsKQA0ypsg=;
        b=kWP7axAIAtVonz+dlVJ3RVeoMAQb5wNQDtnG8ZL+p+cDNkrcqxHDH+2wR9e2YdY7Y5
         VuXfcsYd3QMZJ9br4KDhGElnbKo4U4ew3/2by/ku8JmUV906waHSDKvCz6gGVyMRwn5B
         pnlf+idt8VvHUr/bGyz/Y2YKZDmrYEIXUFmJQbJLIpJlBDDPIxfQlqTdCatge49SgsQx
         BpcOUGflTFSTupzdJcmuIAYjZjdcl3yemUwlXQ1rm1RdviEX80BAbNnFi+v+mLabqzVJ
         zOur3OntiXiWboeV6v2XdDQ+fe/MHZL+AK2hsJTxXY/sEhduIApf5gmE/oiNi/uZKRMw
         YC5w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-6-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

On Tue, Jan 24, 2023 at 07:57:05AM +0100, Christoph Hellwig wrote:
>  void blkcg_maybe_throttle_current(void)
>  {
> -	struct request_queue *q = current->throttle_queue;
> +	struct gendisk *disk = current->throttle_disk;
>  	struct blkcg *blkcg;
>  	struct blkcg_gq *blkg;
>  	bool use_memdelay = current->use_memdelay;
>  
> -	if (!q)
> +	if (!disk)
>  		return;
>  
> -	current->throttle_queue = NULL;
> +	current->throttle_disk = NULL;
>  	current->use_memdelay = false;
>  
> +	if (test_bit(GD_DEAD, &disk->state))
> +		goto out_put_disk;
...
> @@ -1835,18 +1839,15 @@ void blkcg_maybe_throttle_current(void)
>   */
>  void blkcg_schedule_throttle(struct gendisk *disk, bool use_memdelay)
>  {
> -	struct request_queue *q = disk->queue;
> -
>  	if (unlikely(current->flags & PF_KTHREAD))
>  		return;
>  
> -	if (current->throttle_queue != q) {
> -		if (!blk_get_queue(q))
> -			return;
> +	if (current->throttle_disk != disk) {
> +		get_device(disk_to_dev(disk));

So, we're shifting the dead test from schedule to the actual throttle path,
which makes sense but I think this should at least be mentioned in the
description if not put in its own patch.

Thanks.

-- 
tejun
