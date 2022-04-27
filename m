From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next v3 1/3] block, bfq: record how many queues are busy
 in bfq_group
Date: Wed, 27 Apr 2022 14:52:51 +0200
Message-ID: <20220427125251.yl7ff4ti33w6ktrf@quack3.lan>
References: <20220427124722.48465-1-yukuai3@huawei.com>
 <20220427124722.48465-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651063972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yhhsQZ/apy3ajEmL5BMkQH4udIsKMO/zX6YXUvskbjo=;
        b=HKwz9nxCbcYcqN9QwfH1r/OK8igSL7ddbDwQPY0FTJ9uWwqeDCyym37BrWo7AuYPgFyIfr
        ZZUi0JysOo5F8s8wa3Efo0O62vpkwufpcdX5yjShpE8Nb6w+Qo8LJrQ/J/IQwp1cmsbITY
        30oslwuMsB2FRM+EppyUlA2FiA7c9DM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651063972;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yhhsQZ/apy3ajEmL5BMkQH4udIsKMO/zX6YXUvskbjo=;
        b=HMVy/XOhIcTAl6OpMei3jxWEDWxT8+4SiZ5FoEVgdmSiCFbi8a8tlLNJLhHJTzd2g71rRw
        2X9PmFajXjj4N0Cw==
Content-Disposition: inline
In-Reply-To: <20220427124722.48465-2-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: jack@suse.cz, tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Wed 27-04-22 20:47:20, Yu Kuai wrote:
> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
> 
> Add a counter 'busy_queues' in bfq_group, and update it in
> bfq_add/del_bfqq_busy().
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

...

> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index f8eb340381cf..53826797430f 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -218,6 +218,14 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
>  	return false;
>  }
>  
> +static void bfq_update_busy_queues(struct bfq_queue *bfqq, bool is_add)
> +{
> +	if (is_add)
> +		bfqq_group(bfqq)->busy_queues++;
> +	else
> +		bfqq_group(bfqq)->busy_queues--;
> +}
> +
>  #else /* CONFIG_BFQ_GROUP_IOSCHED */

I think the bool argument here unnecessarily hurts readability (it's
difficult to see what the argument means without looking into the
implementation). I'd rather create two functions bfq_{inc,dec}_busy_queues()
or if you really insist on a single function, we can have
bfq_add_busy_queues() and have 'int' argument that will be +1 or -1.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
