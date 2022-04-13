From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next 02/11] block, bfq: apply news apis where root group
 is not expected
Date: Wed, 13 Apr 2022 11:50:44 +0200
Message-ID: <20220413095044.uwxeqli2ytcdanem@quack3.lan>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220305091205.4188398-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649843444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U9sUMbXWYwe92wKsFm671vYxFMhofHKxVsokA7MWvxI=;
        b=bTcP6RKTnl17n4CZJtBbVYJAuXrT0mU2E9IlMAvJn6Iwmg+KGRUJSfjEj0xxvMQ8mUZPH7
        Ig9KDYUnNqAyvcyQuzWLIajOqTTVW/RfvkaTCUXXIwewln8obB8X4qnMmxPnRoI3r7Btsz
        OrqeG4WbhdwWL5sUiAXsufft/t80ZOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649843444;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U9sUMbXWYwe92wKsFm671vYxFMhofHKxVsokA7MWvxI=;
        b=EfUHcSGf4VbiiRKfNtY4mZiMrQjXfNc+7EzF8GykI5/0/tNxB/uS8fg0qWxJ4Vx/nYffpP
        01J2diM08p/fNHDw==
Content-Disposition: inline
In-Reply-To: <20220305091205.4188398-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Sat 05-03-22 17:11:56, Yu Kuai wrote:
> 'entity->sched_data' is set to parent group's sched_data, thus it's NULL
> for root group. And for_each_entity() is used widely to access
> 'entity->sched_data', thus aplly news apis if root group is not
                             ^^ apply

> expected. Prepare to count root group into 'num_groups_with_pending_reqs'.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  block/bfq-iosched.c |  2 +-
>  block/bfq-iosched.h | 22 ++++++++--------------
>  block/bfq-wf2q.c    | 10 +++++-----
>  3 files changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 69ddf6b0f01d..3bc7a7686aad 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -4393,7 +4393,7 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
>  	 * service with the same budget.
>  	 */
>  	entity = entity->parent;
> -	for_each_entity(entity)
> +	for_each_entity_not_root(entity)
>  		entity->service = 0;
>  }

So why is it a problem to clear the service for root cgroup here?

> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index f8eb340381cf..c4cb935a615a 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -815,7 +815,7 @@ void bfq_bfqq_served(struct bfq_queue *bfqq, int served)
>  		bfqq->service_from_wr += served;
>  
>  	bfqq->service_from_backlogged += served;
> -	for_each_entity(entity) {
> +	for_each_entity_not_root(entity) {
>  		st = bfq_entity_service_tree(entity);

Hum, right so how come this was not crashing? Because entity->sched_data is
indeed NULL for bfqd->root_group->entity and so bfq_entity_service_tree()
returned some bogus pointer? Similarly for the cases you are changing
below?

								Honza

> 
>  		entity->service += served;
> @@ -1201,7 +1201,7 @@ static void bfq_deactivate_entity(struct bfq_entity *entity,
>  	struct bfq_sched_data *sd;
>  	struct bfq_entity *parent = NULL;
>  
> -	for_each_entity_safe(entity, parent) {
> +	for_each_entity_not_root_safe(entity, parent) {
>  		sd = entity->sched_data;
>  
>  		if (!__bfq_deactivate_entity(entity, ins_into_idle_tree)) {
> @@ -1270,7 +1270,7 @@ static void bfq_deactivate_entity(struct bfq_entity *entity,
>  	 * is not the case.
>  	 */
>  	entity = parent;
> -	for_each_entity(entity) {
> +	for_each_entity_not_root(entity) {
>  		/*
>  		 * Invoke __bfq_requeue_entity on entity, even if
>  		 * already active, to requeue/reposition it in the
> @@ -1570,7 +1570,7 @@ struct bfq_queue *bfq_get_next_queue(struct bfq_data *bfqd)
>  	 * We can finally update all next-to-serve entities along the
>  	 * path from the leaf entity just set in service to the root.
>  	 */
> -	for_each_entity(entity) {
> +	for_each_entity_not_root(entity) {
>  		struct bfq_sched_data *sd = entity->sched_data;
>  
>  		if (!bfq_update_next_in_service(sd, NULL, false))
> @@ -1597,7 +1597,7 @@ bool __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
>  	 * execute the final step: reset in_service_entity along the
>  	 * path from entity to the root.
>  	 */
> -	for_each_entity(entity)
> +	for_each_entity_not_root(entity)
>  		entity->sched_data->in_service_entity = NULL;
>  
>  	/*
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
