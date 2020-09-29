From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 0/4] Some improvements for blk throttle
Date: Tue, 29 Sep 2020 22:52:36 +0800
Message-ID: <cd26d036-c827-e120-df37-1da81619180f@linux.alibaba.com>
References: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1600592693.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Jens,

> Hi,
> 
> This patch set did some improvements for blk throttle, please
> help to review. Thanks.

Do you have any comments for this patch set? Thanks.

> 
> Baolin Wang (4):
>    blk-throttle: Remove a meaningless parameter for
>      throtl_downgrade_state()
>    blk-throttle: Avoid getting the current time if tg->last_finish_time
>      is 0
>    blk-throttle: Avoid tracking latency if low limit is invalid
>    blk-throttle: Fix IO hang for a corner case
> 
>   block/blk-throttle.c | 26 ++++++++++++++++----------
>   1 file changed, 16 insertions(+), 10 deletions(-)
> 
