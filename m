From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next v8 2/4] block, bfq: record how many queues have
 pending requests
Date: Wed, 1 Jun 2022 10:35:29 +0200
Message-ID: <20220601083529.oz26s6jefxz6fnyg@quack3.lan>
References: <20220531140858.3324294-1-yukuai3@huawei.com>
 <20220531140858.3324294-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654072530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZgDe2eXlhB42LN+QI5BZWIRc4kyPQuFvdb59+D3ByMQ=;
        b=bV70JBnMBSgY94pQahRNjPumE6SgHGja6J+fLoGZJ9eClDYKyM6NQvJD0tf0hovyu6n+BB
        /ivw96PkjmnPwGablQxiwPnrsd/LeMcmKhvDePXVtA+PSK+pqm1YExM+ZtznQ7+cyGiBB+
        U2JqupjlBJ3c+xiH9bgd5t4wukBQxCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654072530;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZgDe2eXlhB42LN+QI5BZWIRc4kyPQuFvdb59+D3ByMQ=;
        b=rHP/WFvK2JmjuczkrX0+8NAVEE++a9lq4iv8fPBYMTFjHZdt9JXZydlvUU34LsCarDNPTm
        2y9AXdwb/V2MZaCA==
Content-Disposition: inline
In-Reply-To: <20220531140858.3324294-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue 31-05-22 22:08:56, Yu Kuai wrote:
> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
> 
> Add a counter in bfq_group, and update it while tracking if bfqq have
> pending requests.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks good, except I think that we also need to update the counters
'num_groups_with_pending_reqs' in bfq_move_bfqq()?

								Honza

> ---
>  block/bfq-cgroup.c  |  1 +
>  block/bfq-iosched.h |  1 +
>  block/bfq-wf2q.c    | 12 ++++++++++--
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 09574af83566..0954a258a107 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
>  				   */
>  	bfqg->bfqd = bfqd;
>  	bfqg->active_entities = 0;
> +	bfqg->num_queues_with_pending_reqs = 0;
>  	bfqg->online = true;
>  	bfqg->rq_pos_tree = RB_ROOT;
>  }
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 3b9b1a0e7c1c..a5f7c0c1a3b3 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -943,6 +943,7 @@ struct bfq_group {
>  	struct bfq_entity *my_entity;
>  
>  	int active_entities;
> +	int num_queues_with_pending_reqs;
>  
>  	struct rb_root rq_pos_tree;
>  
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index 12d20f26ad69..b533e17e9f0c 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -1651,16 +1651,24 @@ static void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
>  {
>  	struct bfq_entity *entity = &bfqq->entity;
>  
> -	if (!entity->in_groups_with_pending_reqs)
> +	if (!entity->in_groups_with_pending_reqs) {
>  		entity->in_groups_with_pending_reqs = true;
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +		bfqq_group(bfqq)->num_queues_with_pending_reqs++;
> +#endif
> +	}
>  }
>  
>  void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
>  {
>  	struct bfq_entity *entity = &bfqq->entity;
>  
> -	if (entity->in_groups_with_pending_reqs)
> +	if (entity->in_groups_with_pending_reqs) {
>  		entity->in_groups_with_pending_reqs = false;
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +		bfqq_group(bfqq)->num_queues_with_pending_reqs--;
> +#endif
> +	}
>  }
>  
>  /*
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
