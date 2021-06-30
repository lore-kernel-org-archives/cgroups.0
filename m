From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH 3/3] loop: Charge i/o to mem and blk cg
Date: Wed, 30 Jun 2021 10:49:58 -0400
Message-ID: <YNyEltLABd17spxy@dschatzberg-fedora-PC0Y6AEN>
References: <20210610173944.1203706-1-schatzberg.dan@gmail.com>
 <20210610173944.1203706-4-schatzberg.dan@gmail.com>
 <YNXvr81YFzbaTxCb@blackbook>
 <YNnZ7hIRIk9dJDry@dschatzberg-fedora-PC0Y6AEN>
 <YNr1TYfBwR/tEpEJ@blackbook>
 <YNsoNeQNMmdplmtp@dschatzberg-fedora-PC0Y6AEN>
 <YNw8kRpT6R2emuhI@blackbook>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7non7Ht3wU/Vgs0c/H0HW+wlwkdFp/0NZ1g7sAhRaEc=;
        b=gGD9BAtpYOeepZdTbE3KHgAiQMcPPfpnG9JJlnbUMfEhlC8BfSFmt8miSEvOuIEZiB
         3rzRcjaUvadqxpFG1/UCWQxX3S4rZ592U9H9rz8afxfdqc1r2Rde8c8BEn9i7xgMhNDv
         JPyYE28nZZUx9+NLzRiuD3VmblJGAy13TwSeiDfi41Y1wHRqNK+gLcQjTZxfG2M1YsUZ
         0c2kCQtqWyTPbUPzKbLyuJMbmCzox2eNsaFegX5bjW/wN/jIK4/VDB9Z58im/s+xDGmz
         cCYbg8XIqnEdiJwNjEYwVOBbY9TWqJad9qQ5AqQ/TxIfy00Mt1Ykar5zkLmd3VYYunt6
         2M3g==
Content-Disposition: inline
In-Reply-To: <YNw8kRpT6R2emuhI@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>

> This is how I understand it:
> 
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -996,6 +996,7 @@ static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
>         rb_insert_color(&worker->rb_node, &lo->worker_tree);
>  queue_work:
>         if (worker) {
> +               WARN_ON_ONCE(worker->blkcg_css != cmd->blkcg_css);

Yes, this is correct. Though the check here seems a bit obvious to me
- it must be correct because we assign worker above:

if (cur_worker->blkcg_css == cmd->blkcg_css) {
        worker = cur_worker;
        break;

or when we construct the worker:

worker->blkcg_css = cmd->blkcg_css;

I think this WARN_ON_ONCE check might be more interesting in
loop_process_work which invokes loop_handle_cmd and actually uses
cmd->blkcg_css. In any event, your understanding is correct here.

>                 /*
>                  * We need to remove from the idle list here while
>                  * holding the lock so that the idle timer doesn't
> @@ -2106,6 +2107,8 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>         cmd->memcg_css = NULL;
>  #ifdef CONFIG_BLK_CGROUP
>         if (rq->bio && rq->bio->bi_blkg) {
> +               /* reference to blkcg_css will be held by loop_worker (outlives
> +                * cmd) or it is the eternal root css */

Yes, this is correct. Feel free to add my Acked-by to such a patch
