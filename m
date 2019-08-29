From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/10] blk-mq: add optional request->alloc_time_ns
Date: Thu, 29 Aug 2019 08:43:38 -0700
Message-ID: <20190829154338.GT2263813@devbig004.ftw2.facebook.com>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190829082248.6464-1-hdanton@sina.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CqwCR92AMmjVYXHP7t59EX+jlAdzhnsJr6HfrLhRRVM=;
        b=ODTqtLtVa7hDa2Czg8NAJLdKjgXn5m5qdq4KmSlV81udeaxSfT400wmfiGbSX/kI47
         wCjpbJZioV/O2MA8cGnsNP61pg5ZthxJK8GF+EEKQmibdoNljA9toPeRhz8bu/MhMzPq
         Wj97l7gcAViSokNRCrej0Q/RWHMrqtogGokMV15fuDkIa5DKDIzpUS8DlIGDPWtPrOop
         kWOP/l+E6TrsDiXSnIOOii7vaTlO6RNr56uuPqsYy49B7SkG5FBmtuiqN+BoD363oxyB
         RilTZSTV1CQICNIfrk2aQE0tOkRmbFdVDdDBK1hHlJysQvXDh6r1a3qngKk4Ql/gghR0
         CQFQ==
Content-Disposition: inline
In-Reply-To: <20190829082248.6464-1-hdanton@sina.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton@sina.com>
Cc: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

Hello,

On Thu, Aug 29, 2019 at 04:22:48PM +0800, Hillf Danton wrote:
> >  static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
> > -		unsigned int tag, unsigned int op)
> > +		unsigned int tag, unsigned int op, u64 alloc_time_ns)
> >  {
> >  	struct blk_mq_tags *tags = blk_mq_tags_from_data(data);
> >  	struct request *rq = tags->static_rqs[tag];
> > @@ -325,6 +325,9 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
> >  	RB_CLEAR_NODE(&rq->rb_node);
> >  	rq->rq_disk = NULL;
> >  	rq->part = NULL;
> > +#ifdef CONFIG_BLK_RQ_ALLOC_TIME
> 
> Not only matches start_time, but everal hunks may collapse into one
> if checking alloc_time is lifted up.
> 
> 	if (blk_queue_rq_alloc_time(rq->q))
> 		rq->alloc_time_ns = ktime_get_ns();
> 	else
> 		rq->alloc_time_ns = 0;

Can you please elaborate?  Lifted up where?

Thanks.

-- 
tejun
