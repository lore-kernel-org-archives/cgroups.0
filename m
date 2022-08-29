From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 1/4] blk-throttle: fix that io throttle can only work
 for single bio
Date: Sun, 28 Aug 2022 18:03:32 -1000
Message-ID: <Yww6lPQaz/Lk4lL6@slm.duckdns.org>
References: <20220829022240.3348319-1-yukuai1@huaweicloud.com>
 <20220829022240.3348319-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=/d1aCoj8mwhQkz6vc1Xqxkc26Va3irgGJEolPmhseeg=;
        b=eA3WGcD66qm9XgvBqd9G9EtOdEfoYHifkvzr4Rv9RR9TaTlWa5iguQ358dJld+6CcS
         18d0rsmtgfs4GP2zSuvA+rVmVW0Yq5HNgRSZho/bL8WhgCID7zj2hiqsmGLDCbXnmXdK
         aGLk7xpU1S2zhVK23R1hovWs7brS5QzSQf1zLiGNwJdxifjiQ8NB4OCDHSwXiMmXS9iH
         jHZRPs7mgvLec4UwVTQCXj1sxyE6uEAQs1xxmmJMryXrGTKLw1vPeXpnB5XVlufPPWe0
         sHjVq82/FUQSPhwxVPoHce4G7XkmUeKg7BDuh7RA3bGNut9hTvDT3lzkbwIdvM/7mrIM
         T66A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220829022240.3348319-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Aug 29, 2022 at 10:22:37AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Test scripts:
> cd /sys/fs/cgroup/blkio/
> echo "8:0 1024" > blkio.throttle.write_bps_device
> echo $$ > cgroup.procs
> dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &
> dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &
> 
> Test result:
> 10240 bytes (10 kB, 10 KiB) copied, 10.0134 s, 1.0 kB/s
> 10240 bytes (10 kB, 10 KiB) copied, 10.0135 s, 1.0 kB/s
> 
> The problem is that the second bio is finished after 10s instead of 20s.
> 
> Root cause:
> 1) second bio will be flagged:
> 
> __blk_throtl_bio
>  while (true) {
>   ...
>   if (sq->nr_queued[rw]) -> some bio is throttled already
>    break
>  };
>  bio_set_flag(bio, BIO_THROTTLED); -> flag the bio
> 
> 2) flagged bio will be dispatched without waiting:
> 
> throtl_dispatch_tg
>  tg_may_dispatch
>   tg_with_in_bps_limit
>    if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED))
>     *wait = 0; -> wait time is zero
>     return true;
> 
> commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
> support to count split bios for iops limit, thus it adds flagged bio
> checking in tg_with_in_bps_limit() so that split bios will only count
> once for bps limit, however, it introduce a new problem that io throttle
> won't work if multiple bios are throttled.
> 
> In order to fix the problem, handle iops/bps limit in different ways:
> 
> 1) for iops limit, there is no flag to record if the bio is throttled,
>    and iops is always applied.
> 2) for bps limit, original bio will be flagged with BIO_BPS_THROTTLED,
>    and io throttle will ignore bio with the flag.
> 
> Noted this patch also remove the code to set flag in __bio_clone(), it's
> introduced in commit 111be8839817 ("block-throttle: avoid double
> charge"), and author thinks split bio can be resubmited and throttled
> again, which is wrong because split bio will continue to dispatch from
> caller.
> 
> Fixes: 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
