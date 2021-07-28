From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH block/for-5.14-fixes] blk-iocost: fix operation ordering
 in iocg_wake_fn()
Date: Tue, 27 Jul 2021 19:27:16 -0600
Message-ID: <7e00b3af-1667-4e27-d4b0-1317fcee9032@kernel.dk>
References: <YQCm8flaer2Ek0c+@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BuRrato+o09YUZsVPMy1mXs7KN2geli20wiSeJ7rF70=;
        b=iRflQWEcz/8FkWlJ6aPgsfGG17MqqawTqklVW88bdIUxZ3917VCU9DLXGmBstsNIYO
         fB175NSa7KQb3FOoLG6XG6p6kaVOJT0k+pIcx9XzP2/kXN6FnA8Ho5kiX+Hx3vDaCelM
         2RxYGos9abHhaO4UAl3mV/0zm57aC+iS5nc2bwTFmZloZKsqD4uZ3LYBzWKgadmgQpSF
         BTTgwXimJLbYaNGaEmSUIn5oirLEudJyfMt2iA4NylrhKXzmXKUMGCkWRPxCrWCNdqgP
         ouiY20aMvQo7azBi9oKLxY8TzaxydEA2zcND+vCy0pFGg2CnIR5UikV13+H5XT1xtJ2s
         jN7w==
In-Reply-To: <YQCm8flaer2Ek0c+-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>

On 7/27/21 6:38 PM, Tejun Heo wrote:
> From aae4e1b4e26c3c671fc19aed2fb2ee19f7438707 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 27 Jul 2021 14:21:30 -1000
> 
> iocg_wake_fn() open-codes wait_queue_entry removal and wakeup because it
> wants the wq_entry to be always removed whether it ended up waking the task
> or not. finish_wait() tests whether wq_entry needs removal without grabbing
> the wait_queue lock and expects the waker to use list_del_init_careful()
> after all waking operations are complete, which iocg_wake_fn() didn't do.
> The operation order was wrong and the regular list_del_init() was used.
> 
> The result is that if a watier wakes up racing the waker, it can free pop
> the wq_entry off stack before the waker is still looking at it, which can
> lead to a backtrace like the following.
> 
>   [7312084.588951] general protection fault, probably for non-canonical address 0x586bf4005b2b88: 0000 [#1] SMP
>   ...
>   [7312084.647079] RIP: 0010:queued_spin_lock_slowpath+0x171/0x1b0
>   ...
>   [7312084.858314] Call Trace:
>   [7312084.863548]  _raw_spin_lock_irqsave+0x22/0x30
>   [7312084.872605]  try_to_wake_up+0x4c/0x4f0
>   [7312084.880444]  iocg_wake_fn+0x71/0x80
>   [7312084.887763]  __wake_up_common+0x71/0x140
>   [7312084.895951]  iocg_kick_waitq+0xe8/0x2b0
>   [7312084.903964]  ioc_rqos_throttle+0x275/0x650
>   [7312084.922423]  __rq_qos_throttle+0x20/0x30
>   [7312084.930608]  blk_mq_make_request+0x120/0x650
>   [7312084.939490]  generic_make_request+0xca/0x310
>   [7312084.957600]  submit_bio+0x173/0x200
>   [7312084.981806]  swap_readpage+0x15c/0x240
>   [7312084.989646]  read_swap_cache_async+0x58/0x60
>   [7312084.998527]  swap_cluster_readahead+0x201/0x320
>   [7312085.023432]  swapin_readahead+0x2df/0x450
>   [7312085.040672]  do_swap_page+0x52f/0x820
>   [7312085.058259]  handle_mm_fault+0xa16/0x1420
>   [7312085.066620]  do_page_fault+0x2c6/0x5c0
>   [7312085.074459]  page_fault+0x2f/0x40
> 
> Fix it by switching to list_del_init_careful() and putting it at the end.

Fixed up the malformed commit message, applied, thanks!

-- 
Jens Axboe

