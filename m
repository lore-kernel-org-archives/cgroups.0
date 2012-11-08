From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 5/9] cgroup_freezer: prepare freezer_change_state() for
 full hierarchy support
Date: Thu, 8 Nov 2012 10:56:59 +0100
Message-ID: <20121108095659.GC31821@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1351931915-1701-6-git-send-email-tj@kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

On Sat 03-11-12 01:38:31, Tejun Heo wrote:
> * Make freezer_change_state() take bool @freeze instead of enum
>   freezer_state.
> 
> * Separate out freezer_apply_state() out of freezer_change_state().
>   This makes freezer_change_state() a rather silly thin wrapper.  It
>   will be filled with hierarchy handling later on.
> 
> This patch doesn't introduce any behavior change.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Makes sense
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  kernel/cgroup_freezer.c | 48 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 975b3d8..2690830 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -247,45 +247,57 @@ static void unfreeze_cgroup(struct freezer *freezer)
>  	cgroup_iter_end(cgroup, &it);
>  }
>  
> -static void freezer_change_state(struct freezer *freezer,
> -				 enum freezer_state goal_state)
> +/**
> + * freezer_apply_state - apply state change to a single cgroup_freezer
> + * @freezer: freezer to apply state change to
> + * @freeze: whether to freeze or unfreeze
> + */
> +static void freezer_apply_state(struct freezer *freezer, bool freeze)
>  {
>  	/* also synchronizes against task migration, see freezer_attach() */
> -	spin_lock_irq(&freezer->lock);
> +	lockdep_assert_held(&freezer->lock);
>  
> -	switch (goal_state) {
> -	case CGROUP_THAWED:
> -		if (freezer->state != CGROUP_THAWED)
> -			atomic_dec(&system_freezing_cnt);
> -		freezer->state = CGROUP_THAWED;
> -		unfreeze_cgroup(freezer);
> -		break;
> -	case CGROUP_FROZEN:
> +	if (freeze) {
>  		if (freezer->state == CGROUP_THAWED)
>  			atomic_inc(&system_freezing_cnt);
>  		freezer->state = CGROUP_FREEZING;
>  		freeze_cgroup(freezer);
> -		break;
> -	default:
> -		BUG();
> +	} else {
> +		if (freezer->state != CGROUP_THAWED)
> +			atomic_dec(&system_freezing_cnt);
> +		freezer->state = CGROUP_THAWED;
> +		unfreeze_cgroup(freezer);
>  	}
> +}
>  
> +/**
> + * freezer_change_state - change the freezing state of a cgroup_freezer
> + * @freezer: freezer of interest
> + * @freeze: whether to freeze or thaw
> + *
> + * Freeze or thaw @cgroup according to @freeze.
> + */
> +static void freezer_change_state(struct freezer *freezer, bool freeze)
> +{
> +	/* update @freezer */
> +	spin_lock_irq(&freezer->lock);
> +	freezer_apply_state(freezer, freeze);
>  	spin_unlock_irq(&freezer->lock);
>  }
>  
>  static int freezer_write(struct cgroup *cgroup, struct cftype *cft,
>  			 const char *buffer)
>  {
> -	enum freezer_state goal_state;
> +	bool freeze;
>  
>  	if (strcmp(buffer, freezer_state_strs[CGROUP_THAWED]) == 0)
> -		goal_state = CGROUP_THAWED;
> +		freeze = false;
>  	else if (strcmp(buffer, freezer_state_strs[CGROUP_FROZEN]) == 0)
> -		goal_state = CGROUP_FROZEN;
> +		freeze = true;
>  	else
>  		return -EINVAL;
>  
> -	freezer_change_state(cgroup_freezer(cgroup), goal_state);
> +	freezer_change_state(cgroup_freezer(cgroup), freeze);
>  	return 0;
>  }
>  
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
