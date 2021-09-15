From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] blk-throttle: enable io throttle for root in cgroup
 v2
Date: Wed, 15 Sep 2021 16:20:54 +0800
Message-ID: <6ea924a3-6a19-ef9d-1741-26c8aaf6429e@huawei.com>
References: <20210909140815.2600858-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210909140815.2600858-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2021/09/09 22:08, Yu Kuai wrote:
> We want to limit the overall iops/bps of the device in cgroup v2,
> however "io.max" or "io.min" do not exist in root cgroup currently,
> which makes it impossible.
> 
> This patch enables io throttle for root cgroup:
>   - enable "io.max" and "io.min" in root
>   - don't skip root group in tg_iops_limit() and tg_bps_limit()
>   - don't skip root group in tg_conf_updated()
> 
> I'm not sure why this feature is disabled in the first place, is
> there any problem or design constraint?
> 
Ping...

BTW, sorry about the misspell of "io.low".
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   block/blk-throttle.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 55c49015e533..fffe072de538 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -302,9 +302,6 @@ static uint64_t tg_bps_limit(struct throtl_grp *tg, int rw)
>   	struct throtl_data *td;
>   	uint64_t ret;
>   
> -	if (cgroup_subsys_on_dfl(io_cgrp_subsys) && !blkg->parent)
> -		return U64_MAX;
> -
>   	td = tg->td;
>   	ret = tg->bps[rw][td->limit_index];
>   	if (ret == 0 && td->limit_index == LIMIT_LOW) {
> @@ -332,9 +329,6 @@ static unsigned int tg_iops_limit(struct throtl_grp *tg, int rw)
>   	struct throtl_data *td;
>   	unsigned int ret;
>   
> -	if (cgroup_subsys_on_dfl(io_cgrp_subsys) && !blkg->parent)
> -		return UINT_MAX;
> -
>   	td = tg->td;
>   	ret = tg->iops[rw][td->limit_index];
>   	if (ret == 0 && tg->td->limit_index == LIMIT_LOW) {
> @@ -1430,9 +1424,8 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
>   		struct throtl_grp *parent_tg;
>   
>   		tg_update_has_rules(this_tg);
> -		/* ignore root/second level */
> -		if (!cgroup_subsys_on_dfl(io_cgrp_subsys) || !blkg->parent ||
> -		    !blkg->parent->parent)
> +		/* ignore root level */
> +		if (!cgroup_subsys_on_dfl(io_cgrp_subsys) || !blkg->parent)
>   			continue;
>   		parent_tg = blkg_to_tg(blkg->parent);
>   		/*
> @@ -1771,7 +1764,6 @@ static struct cftype throtl_files[] = {
>   #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
>   	{
>   		.name = "low",
> -		.flags = CFTYPE_NOT_ON_ROOT,
>   		.seq_show = tg_print_limit,
>   		.write = tg_set_limit,
>   		.private = LIMIT_LOW,
> @@ -1779,7 +1771,6 @@ static struct cftype throtl_files[] = {
>   #endif
>   	{
>   		.name = "max",
> -		.flags = CFTYPE_NOT_ON_ROOT,
>   		.seq_show = tg_print_limit,
>   		.write = tg_set_limit,
>   		.private = LIMIT_MAX,
> 
