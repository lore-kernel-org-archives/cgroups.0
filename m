From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Wed, 8 Apr 2020 20:44:17 -0700
Message-ID: <b027a718-1c76-6e34-1edb-5435a5605d35@acm.org>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200408201450.3959560-3-tj@kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com

On 2020-04-08 13:14, Tejun Heo wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 32868fbedc9e..bfd34c6a27ef 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -142,6 +142,14 @@ struct request {
>  
>  	/* the following two fields are internal, NEVER access directly */
>  	unsigned int __data_len;	/* total data len */
> +#ifdef CONFIG_BLK_RQ_IO_DATA_LEN
> +	/*
> +	 * Total data len at the time of issue. This doesn't get deducted by
> +	 * blk_update_request() and can be used by completion path to determine
> +	 * the request size.
> +	 */
> +	unsigned int io_data_len;
> +#endif
>  	sector_t __sector;		/* sector cursor */
>  
>  	struct bio *bio;

So we have one struct member with the description "total data len" and
another struct member with the description "total data len at the time
of issue"? How could one not get confused by these descriptions?

This change makes the comment above __data_len incorrect. Please update
that comment or move io_data_len in front of that comment.

How does this change interact with the code in drivers/scsi/sd.c that
manipulates __data_len directly?

Thanks,

Bart.


