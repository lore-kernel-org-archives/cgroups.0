From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH] block: don't allow the same type rq_qos add more than once
Date: Tue, 19 Jul 2022 14:53:09 +0800
Message-ID: <CAMZfGtVLkO6T-0n7fMBTvR84Ji8GhTO5==u9v+8f+dRkJhFHMA@mail.gmail.com>
References: <20220718083646.67601-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u5KxztmCmMVHIN310A4ZHMWsumpUd/uei+99VlIfECo=;
        b=g45peOwJLERlzIw9j9Qr3FglyHx1ejYM46zmBvA/t4aMhMusgrlHHP7DtNqT3w8UDx
         +nBrmbn3AeWkJLwpUK3lBY+pXw5XeerP0NGTxCjRBjj8iozdPjAL8Jci7xtIVoqKdBHL
         fEUljn0PqIWZr/hPjTugMvYwnqskDlL10SVhxZ8CnPVRvTIxBC5x8rAXgDmSAduRjwo4
         vhYvaSwgrqv7mSpvQ5A7gKQbEfS+zIX/0XYSM/O/B+apqFIO+1NiJatid+NqnQIqIo7K
         L1w3wWiR2lvJZHwarcjfbBoMYr2KyA83S8A3w/tgFxGpzA8wF+Vuh0UAE5vn24mWyr64
         ig1A==
In-Reply-To: <20220718083646.67601-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666@bytedance.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Mon, Jul 18, 2022 at 4:37 PM Jinke Han <hanjinke.666@bytedance.com> wrote:
>
> From: hanjinke <hanjinke.666@bytedance.com>
>
> In our test of iocost, we encounttered some list add/del corrutions of
> inner_walk list in ioc_timer_fn.
> The resean can be descripted as follow:
>
> cpu 0                                           cpu 1
> ioc_qos_write                                   ioc_qos_write
>
> ioc = q_to_ioc(bdev_get_queue(bdev));
> if (!ioc) {
>         ioc = kzalloc();                        ioc = q_to_ioc(bdev_get_queue(bdev));
>                                                         if (!ioc) {
>                                                                 ioc = kzalloc();
>                                                                 ...
>                                                                 rq_qos_add(q, rqos);
>                                                          }
>         ...
>         rq_qos_add(q, rqos);
>         ...
> }
>
> When the io.cost.qos file is written by two cpu concurrently, rq_qos may
> be added to one disk twice. In that case, there will be two iocs enabled
> and running on one disk. They own different iocgs on their active list.
> In the ioc_timer_fn function, because of the iocgs from two ioc have the
> same root iocg, the root iocg's walk_list may be overwritten by each
> other and this lead to list add/del corrutions in building or destorying
> the inner_walk list.
>
> And so far, the blk-rq-qos framework works in case that one instance for
> one type rq_qos per queue by default. This patch make this explicit and
> also fix the crash above.
>
> Signed-off-by: hanjinke <hanjinke.666@bytedance.com>

The change LGTM. Maybe it is better to add a Fixes tag here so that
others can easily know what Linux versions should be backported.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
