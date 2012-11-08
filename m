From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 7/9] cgroup_freezer: introduce
 CGROUP_FREEZING_[SELF|PARENT]
Date: Thu, 8 Nov 2012 13:47:55 +0100
Message-ID: <20121108124755.GG31821@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1351931915-1701-8-git-send-email-tj@kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

On Sat 03-11-12 01:38:33, Tejun Heo wrote:
> Introduce FREEZING_SELF and FREEZING_PARENT and make FREEZING OR of
> the two flags.  This is to prepare for full hierarchy support.
> 
> freezer_apply_date() is updated such that it can handle setting and
> clearing of both flags.  The two flags are also exposed to userland
> via read-only files self_freezing and parent_freezing.
> 
> Other than the added cgroupfs files, this patch doesn't introduce any
> behavior change.

OK, I can imagine that this might be useful to find the first parent
group that needs to be thawed to unfreeze the group I am interested
in. Could you also update Documentation/cgroups/freezer-subsystem.txt to
clarify the intended usage?

Minor nit. Same as mentioned in the previous patch freezer_apply_state
should get enum freezer_state_flags state parameter.

> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  kernel/cgroup_freezer.c | 55 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 47 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index e76aa9f..b8ad93c 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -23,8 +23,12 @@
>  #include <linux/seq_file.h>
>  
>  enum freezer_state_flags {
> -	CGROUP_FREEZING		= (1 << 1), /* this freezer is freezing */
> +	CGROUP_FREEZING_SELF	= (1 << 1), /* this freezer is freezing */
> +	CGROUP_FREEZING_PARENT	= (1 << 2), /* the parent freezer is freezing */
>  	CGROUP_FROZEN		= (1 << 3), /* this and its descendants frozen */
> +
> +	/* mask for all FREEZING flags */
> +	CGROUP_FREEZING		= CGROUP_FREEZING_SELF | CGROUP_FREEZING_PARENT,
>  };
>  
>  struct freezer {
> @@ -245,8 +249,13 @@ static void unfreeze_cgroup(struct freezer *freezer)
>   * freezer_apply_state - apply state change to a single cgroup_freezer
>   * @freezer: freezer to apply state change to
>   * @freeze: whether to freeze or unfreeze
> + * @state: CGROUP_FREEZING_* flag to set or clear
> + *
> + * Set or clear @state on @cgroup according to @freeze, and perform
> + * freezing or thawing as necessary.
>   */
> -static void freezer_apply_state(struct freezer *freezer, bool freeze)
> +static void freezer_apply_state(struct freezer *freezer, bool freeze,
> +				unsigned int state)
>  {
>  	/* also synchronizes against task migration, see freezer_attach() */
>  	lockdep_assert_held(&freezer->lock);
> @@ -254,13 +263,19 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze)
>  	if (freeze) {
>  		if (!(freezer->state & CGROUP_FREEZING))
>  			atomic_inc(&system_freezing_cnt);
> -		freezer->state |= CGROUP_FREEZING;
> +		freezer->state |= state;
>  		freeze_cgroup(freezer);
>  	} else {
> -		if (freezer->state & CGROUP_FREEZING)
> -			atomic_dec(&system_freezing_cnt);
> -		freezer->state &= ~(CGROUP_FREEZING | CGROUP_FROZEN);
> -		unfreeze_cgroup(freezer);
> +		bool was_freezing = freezer->state & CGROUP_FREEZING;
> +
> +		freezer->state &= ~state;
> +
> +		if (!(freezer->state & CGROUP_FREEZING)) {
> +			if (was_freezing)
> +				atomic_dec(&system_freezing_cnt);
> +			freezer->state &= ~CGROUP_FROZEN;
> +			unfreeze_cgroup(freezer);
> +		}
>  	}
>  }
>  
> @@ -275,7 +290,7 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
>  {
>  	/* update @freezer */
>  	spin_lock_irq(&freezer->lock);
> -	freezer_apply_state(freezer, freeze);
> +	freezer_apply_state(freezer, freeze, CGROUP_FREEZING_SELF);
>  	spin_unlock_irq(&freezer->lock);
>  }
>  
> @@ -295,6 +310,20 @@ static int freezer_write(struct cgroup *cgroup, struct cftype *cft,
>  	return 0;
>  }
>  
> +static u64 freezer_self_freezing_read(struct cgroup *cgroup, struct cftype *cft)
> +{
> +	struct freezer *freezer = cgroup_freezer(cgroup);
> +
> +	return (bool)(freezer->state & CGROUP_FREEZING_SELF);
> +}
> +
> +static u64 freezer_parent_freezing_read(struct cgroup *cgroup, struct cftype *cft)
> +{
> +	struct freezer *freezer = cgroup_freezer(cgroup);
> +
> +	return (bool)(freezer->state & CGROUP_FREEZING_PARENT);
> +}
> +
>  static struct cftype files[] = {
>  	{
>  		.name = "state",
> @@ -302,6 +331,16 @@ static struct cftype files[] = {
>  		.read_seq_string = freezer_read,
>  		.write_string = freezer_write,
>  	},
> +	{
> +		.name = "self_freezing",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.read_u64 = freezer_self_freezing_read,
> +	},
> +	{
> +		.name = "parent_freezing",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.read_u64 = freezer_parent_freezing_read,
> +	},
>  	{ }	/* terminate */
>  };
>  
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
