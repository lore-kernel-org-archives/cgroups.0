From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next v4 1/3] block, bfq: record how many queues are busy
 in bfq_group
Date: Thu, 28 Apr 2022 13:18:00 +0200
Message-ID: <20220428111800.aqfzwwii5dabx3ko@quack3.lan>
References: <20220428111907.3635820-1-yukuai3@huawei.com>
 <20220428111907.3635820-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651144682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTrnvMpAhjSGeg1gbv33jLZDolAkh8q0+zNQ815xKlQ=;
        b=u/MaWQyAW2WWLjnSuO7VRXh2tbAm8BiWtFpc6daZUTVzIaWYKwFlx01h1w+nw4vs52VB8E
        FiEZAmdelzrw+GfHEPtQdL5J5Fq02eMk7mYvyRoGQRjqM9whOKLIbb/W6YAU0pWbWTllJX
        V+9rqJVoqyrkpjBK7QPyFBMp0SpODyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651144682;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTrnvMpAhjSGeg1gbv33jLZDolAkh8q0+zNQ815xKlQ=;
        b=sQOtrYhIKz01UuNxtkiMhUrfGvIlrtZgRKSHw0Qr/9X8S0UTvFRvWkUKZ22FzRc6nV8GEW
        JLpypogPB1UaJGDg==
Content-Disposition: inline
In-Reply-To: <20220428111907.3635820-2-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu 28-04-22 19:19:05, Yu Kuai wrote:
> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
> 
> Add a counter 'busy_queues' in bfq_group, and update it in
> bfq_add/del_bfqq_busy().
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Just two nits below:

> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -218,6 +218,16 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
>  	return false;
>  }
>  
> +static void bfq_add_busy_queues(struct bfq_queue *bfqq)
> +{
> +	bfqq_group(bfqq)->busy_queues++;
> +}
> +
> +static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
> +{
> +	bfqq_group(bfqq)->busy_queues--;
> +}
> +

An opposite from "decrement" is "increment", not "add". So
bfq_add_busy_queues() should be bfq_inc_busy_queues().

> @@ -230,6 +240,14 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
>  	return true;
>  }
>  
> +static void bfq_add_busy_queues(struct bfq_queue *bfqq)
> +{
> +}
> +
> +static void bfq_add_busy_queues(struct bfq_queue *bfqq)
> +{
> +}
> +

You have two times the same function here and you miss the other one...

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
