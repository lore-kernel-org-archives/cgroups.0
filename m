From: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 02/15] block: don't call blk_throtl_stat_add for
 non-READ/WRITE commands
Date: Fri, 20 Jan 2023 09:55:31 +0100
Message-ID: <Y8pXAyRs5lABGdsD@suselix>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-3-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674204933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e4Q1VHGGcDhGS3UBPXctvtuTi2sVs/AqValPMfoWSYE=;
        b=Su6hdgzchZCXt2HTOTOjgHNxtpHGqdPLqfJJkMOHMurMPCV4yMqMCnYQAezfefQdiYvAvk
        wL8S7fl568RRar4j3Hm3zw+ZvcSwvHncGjZwdIlEuZ6x+BAvTAIT85Tk/HwB2A2H7zQmuv
        rZCDaypwyod4q5cySeYww2Zxa0g8KTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674204933;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e4Q1VHGGcDhGS3UBPXctvtuTi2sVs/AqValPMfoWSYE=;
        b=j4qsZrhR7S36Hkx+UjJnhv91ntaLtfw16raFwIR7bcP7jxeZa/787+JmWt1Yc0WjQHNstZ
        3NVG7kHoBxNc5fDA==
Content-Disposition: inline
In-Reply-To: <20230117081257.3089859-3-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 17, 2023 at 09:12:44AM +0100, Christoph Hellwig wrote:
> blk_throtl_stat_add is called from blk_stat_add explicitly, unlike the
> other stats that go through q->stats->callbacks.  To prepare for cgroup
> data moving to the gendisk, ensure blk_throtl_stat_add is only called
> for the plain READ and WRITE commands that it actually handles internally,
> as blk_stat_add can also be called for passthrough commands on queues that
> do not have a genisk associated with them.
                ^^^^^^
		gendisk
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  block/blk-stat.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Looks good to me. Feel free to add
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

> diff --git a/block/blk-stat.c b/block/blk-stat.c
> index 2ea01b5c1aca04..c6ca16abf911e2 100644
> --- a/block/blk-stat.c
> +++ b/block/blk-stat.c
> @@ -58,7 +58,8 @@ void blk_stat_add(struct request *rq, u64 now)
>  
>  	value = (now >= rq->io_start_time_ns) ? now - rq->io_start_time_ns : 0;
>  
> -	blk_throtl_stat_add(rq, value);
> +	if (req_op(rq) == REQ_OP_READ || req_op(rq) == REQ_OP_WRITE)
> +		blk_throtl_stat_add(rq, value);
>  
>  	rcu_read_lock();
>  	cpu = get_cpu();
> -- 
> 2.39.0
> 

-- 
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
