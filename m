From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] block: move the bdi from the request_queue to the
 gendisk
Date: Tue, 10 Aug 2021 18:44:07 +0200
Message-ID: <20210810164407.GA20662@lst.de>
References: <20210809141744.1203023-1-hch@lst.de> <20210809141744.1203023-5-hch@lst.de> <20210809154728.GH30319@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210809154728.GH30319@quack2.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Mon, Aug 09, 2021 at 05:47:28PM +0200, Jan Kara wrote:
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 2c4ac51e54eb..d2725f94491d 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -525,7 +525,7 @@ void blk_mq_free_request(struct request *rq)
> >  		__blk_mq_dec_active_requests(hctx);
> >  
> >  	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
> > -		laptop_io_completion(q->backing_dev_info);
> > +		laptop_io_completion(queue_to_disk(q)->bdi);
> > 
> 
> E.g. cannot this get called for a queue that is without a disk?

As Jens already explained we need the gendisk for non-passthrough
commands.  Same for the wbt case.
