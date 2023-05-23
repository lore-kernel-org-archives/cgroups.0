From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH for-6.4/block] block/rq_qos: protect rq_qos apis with a
 new lock
Date: Tue, 23 May 2023 11:13:59 -0600
Message-ID: <168486203985.398377.17593981162726402548.b4-ty@kernel.dk>
References: <20230414084008.2085155-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684862041; x=1687454041;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmWtJOzNztkpnf4UzHCczQhsDx+hgxiMe2XgRqYyHhI=;
        b=rQvy6TSK+wfTlo0HdARvbSVdkvmZoky53LQfz6I/sHZSh/vam08zvcWX8BKFq35rPJ
         FiOXal8syvG9pEP0WTv6iW7eSanhHy7ABqS8itvydZ8rH14nwiDgZz79SGNg3RH3bQj8
         WTmLv9HJ2uOAsK7i88YATrsiJwt/hKCRYYVxQMA7/a3MuM4g4yafCnt36kQlOjL/VWPH
         6o5dMj0POMwamomezMYNOxNy841T05ufNRwMDpAkAYeEwREsLkqobJ+hg8+fwPBm4nOe
         u6quTE5qyRblQsMAa260HpGZ0iO2Y0Wue1iugiodj3bo6gNKl8rdK5sY8KOYxSKugSqK
         REMA==
In-Reply-To: <20230414084008.2085155-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


On Fri, 14 Apr 2023 16:40:08 +0800, Yu Kuai wrote:
> commit 50e34d78815e ("block: disable the elevator int del_gendisk")
> move rq_qos_exit() from disk_release() to del_gendisk(), this will
> introduce some problems:
> 
> 1) If rq_qos_add() is triggered by enabling iocost/iolatency through
>    cgroupfs, then it can concurrent with del_gendisk(), it's not safe to
>    write 'q->rq_qos' concurrently.
> 
> [...]

Applied, thanks!

[1/1] block/rq_qos: protect rq_qos apis with a new lock
      commit: a13bd91be22318768d55470cbc0b0f4488ef9edf

Best regards,
-- 
Jens Axboe



