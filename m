From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: (subset) [PATCH 1/2 block/for-6.2] blk-iolatency: Fix memory leak
 on add_disk() failures
Date: Wed, 14 Dec 2022 12:43:28 -0700
Message-ID: <167104700802.18171.11122547200509229739.b4-ty@kernel.dk>
References: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Mo0zxBwzxFipCiGCCwccoKGO7YvtvSURarcs0pMhQI=;
        b=lvENkja2zLcChQJAHLDCQQqh3zlQH8Dsoq55tTl87sB+2c0MjiwdB7LOF6vWIz22Fu
         eCICg9Fj6TfwXA8yG7XYMiaf2z12/uwOtxGbirrVMlhelM9zsuZSiJc0fsCQcVkxIqWi
         RQd2jNWuTv9nWpvqSBjTE6mk9xX/4Ih+TD6DNwKiit6DgH/l7Dbq4AiiFcND0y8/5zYZ
         HcmI74WEhjBHTUZjZl0MFiaX3CzA+Q2HPYKOJGeQA+jYIBNJZTtivM8BtmFfUwTiLPqK
         ov7lyv5b6U8d6dtzpDcDCl9w8rm+uTR3Js1B0DGhRtqpJZkWRzUSkxytnCYJqyMhzm2G
         G9Cg==
In-Reply-To: <Y5TQ5gm3O4HXrXR3-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darklight2357-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Sat, 10 Dec 2022 08:33:10 -1000, Tejun Heo wrote:
> When a gendisk is successfully initialized but add_disk() fails such as when
> a loop device has invalid number of minor device numbers specified,
> blkcg_init_disk() is called during init and then blkcg_exit_disk() during
> error handling. Unfortunately, iolatency gets initialized in the former but
> doesn't get cleaned up in the latter.
> 
> This is because, in non-error cases, the cleanup is performed by
> del_gendisk() calling rq_qos_exit(), the assumption being that rq_qos
> policies, iolatency being one of them, can only be activated once the disk
> is fully registered and visible. That assumption is true for wbt and iocost,
> but not so for iolatency as it gets initialized before add_disk() is called.
> 
> [...]

Applied, thanks!

[1/2] blk-iolatency: Fix memory leak on add_disk() failures
      commit: 813e693023ba10da9e75067780f8378465bf27cc

Best regards,
-- 
Jens Axboe


