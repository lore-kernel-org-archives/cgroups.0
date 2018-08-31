From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/15] blkcg: always associate a bio with a blkg
Date: Fri, 31 Aug 2018 16:16:09 -0700
Message-ID: <20180831231609.GD1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-7-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Moh6buiZCtTFeGgHIcC8OSQ92HOZv/0w4cMeUXtqmzs=;
        b=iQSxv0Y1e3DmCCrD4sxrZWOOEUAOG7StK+aypzLseICivO2susNwVm73cUSjz6GGvZ
         d4TOkh814oO4AZfSR8VPzq9QZx/LLWufmnCAaIIdI98qMelhQ1qYXwo4INJiMzxV+f2E
         wVvSI39hUOtjuFZQlMcBMJyon2UD6k8+M3DCkPuesYnC7EQfSw5J3CbOZuXCR/dmhaKv
         4Eex++//NNg8xer4fjsNze+ZxlujIJsyPZZ+1RNMb9VLVbxux7X3feVF7u6OR8f7cKv9
         KDKFFeQfVPRk8jly3M5DAOR3WlUksxACSefCCxf67Hd443fbYw6Q/A7FukmShiHpHxjj
         5oVw==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-7-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 30, 2018 at 09:53:47PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> Previously, blkg's were only assigned as needed by blk-iolatency and
> blk-throttle. bio->css was also always being associated while blkg was
> being looked up and then thrown away in blkcg_bio_issue_check.
> 
> This patch beings the cleanup of bio->css and bio->bi_blkg by always
             ^
	     begins

> +int bio_associate_create_blkg(struct request_queue *q, struct bio *bio)
> +{
> +	struct blkcg *blkcg;
> +	struct blkcg_gq *blkg;
> +	int ret = 0;
> +
> +	/* someone has already associated this bio with a blkg */
> +	if (bio->bi_blkg)
> +		return ret;
> +
> +	rcu_read_lock();
> +
> +	bio_associate_blkcg(bio, NULL);
> +	blkcg = bio_blkcg(bio);
> +
> +	if (!blkcg->css.parent) {
> +		ret = bio_associate_blkg(bio, q->root_blkg);
> +		goto assoc_out;
> +	}
> +
> +	blkg = blkg_lookup_create(blkcg, q);
> +	if (IS_ERR(blkg))
> +		blkg = q->root_blkg;
> +
> +	ret = bio_associate_blkg(bio, blkg);
> +assoc_out:

Maybe if/else instead of goto?

Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
