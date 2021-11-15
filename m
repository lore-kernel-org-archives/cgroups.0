From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix missing put device in error path from
 blkg_conf_pref()
Date: Mon, 15 Nov 2021 11:37:21 -1000
Message-ID: <YZLTEZS66QqRxjuX@slm.duckdns.org>
References: <20211102020705.2321858-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sy0cBwSY9OB0AfhJQItSKu5D9CkSMvp3AC0Bk6Ha4VQ=;
        b=pN6KNRwqQkwkOps2PgEPNWx6ZqE9B6BEhhsEEiyYN7MYDinla+sbz/gXcJ2ygSQhJq
         7z3VZJaa/DEz0KQ58iKtuRH5SsFuyQ92/N6vUoBv/9dDKUW7K7qPAkRKPuN2kQpuAGZ8
         8Ei+42gAjmPc8TZL5pV8KQvgGGYy6VZFv6X6zQQ8F8Nk4XJqV+TdlZ8g/beGlO7knjdu
         iTWmYMHh7t3zasaqNfMIvD99JnxyeSZMC8mEVBacCZbIvI/L8zZQOG6nxXoXnBUyQc2W
         inCJcZdDwvNBZlTM7IsZkrub7/Q+/9X1vrdlI6g6z5gULncLtvNH/cwVtPaotIizYEZp
         mEAg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211102020705.2321858-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Nov 02, 2021 at 10:07:05AM +0800, Yu Kuai wrote:
> If blk_queue_enter() failed due to queue is dying, the
> blkdev_put_no_open() is needed because blkcg_conf_open_bdev() succeeded.
> 
> Fixes: 0c9d338c8443 ("blk-cgroup: synchronize blkg creation against policy deactivation")
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
