From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 02/10] blk-throttle: Fix that bps of child could
 exceed bps limited in parent
Date: Wed, 30 Nov 2022 11:09:20 -1000
Message-ID: <Y4fGgGaNBueotI1E@slm.duckdns.org>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-3-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7v4d6zaC4L81hfiBNb2Cor9kyL3VqKmV3/kGNvOemQ4=;
        b=KkQfDW/gc08jpOQwU7UFqMKS7YNnQ9pn2xJKWk1O/71hBqhVuZvr0RPB+dmEmUL5ye
         xDpaMQ4XhbVldeIM5DIbTL0SLuUc1TY8tpvitVtwhxyYnuHHzufMBZLcTM0uWv4mUKg9
         WcjfkyG6DzHJOhP3nUpI7C0Kx9TooMPDylwUQ2yRjIsK4pbudxvzTQZYkV3I75xd38c8
         39fm+Z7m1U8xCTByy7ZY4l0ggq7zbR9Ilgwl6I/3X8P20eJd+68SaFY3ySEWh0o8/tZb
         V5X8HJayccgkIWTrGUSa2b0gTfKURFTnRcDDQ0h8qJqJV31igDseAKynOE7XcHHBW9Sn
         eXIA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221129030147.27400-3-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 29, 2022 at 11:01:39AM +0800, Kemeng Shi wrote:
> Consider situation as following (on the default hierarchy):
>  HDD
>   |
> root (bps limit: 4k)
>   |
> child (bps limit :8k)
>   |
> fio bs=8k
> Rate of fio is supposed to be 4k, but result is 8k. Reason is as
> following:
> Size of single IO from fio is larger than bytes allowed in one
> throtl_slice in child, so IOs are always queued in child group first.
> When queued IOs in child are dispatched to parent group, BIO_BPS_THROTTLED
> is set and these IOs will not be limited by tg_within_bps_limit anymore.
> Fix this by only set BIO_BPS_THROTTLED when the bio traversed the entire
> tree.
> 
> There patch has no influence on situation which is not on the default
> hierarchy as each group is a single root group without parent.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
