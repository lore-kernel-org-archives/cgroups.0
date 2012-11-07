From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 9/9] cgroup_freezer: implement proper hierarchy support
Date: Wed, 7 Nov 2012 12:00:57 +0100
Message-ID: <20121107110024.GA4143@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1351931915-1701-10-git-send-email-tj@kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

On Sat 03-11-12 01:38:35, Tejun Heo wrote:
[...]
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 4f12d31..3262537 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
[...]
> @@ -320,14 +388,39 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze,
>   * @freezer: freezer of interest
>   * @freeze: whether to freeze or thaw
>   *
> - * Freeze or thaw @cgroup according to @freeze.
> + * Freeze or thaw @freezer according to @freeze.  The operations are
> + * recursive - all descendants of @freezer will be affected.
>   */
>  static void freezer_change_state(struct freezer *freezer, bool freeze)
>  {
> +	struct cgroup *pos;
> +
>  	/* update @freezer */
>  	spin_lock_irq(&freezer->lock);
>  	freezer_apply_state(freezer, freeze, CGROUP_FREEZING_SELF);
>  	spin_unlock_irq(&freezer->lock);
> +
> +	/*
> +	 * Update all its descendants in pre-order traversal.  Each
> +	 * descendant will try to inherit its parent's FREEZING state as
> +	 * CGROUP_FREEZING_PARENT.
> +	 */
> +	rcu_read_lock();
> +	cgroup_for_each_descendant_pre(pos, freezer->css.cgroup) {
> +		struct freezer *pos_f = cgroup_freezer(pos);
> +		struct freezer *parent = parent_freezer(freezer);

This doesn't seem right. Why are we interested in freezer->parent here
at all? We should either care about freezer->state & CGROUP_FREEZING or
parent = parent_freezer(pos_f), right?

> +
> +		/*
> +		 * Our update to @parent->state is already visible which is
> +		 * all we need.  No need to lock @parent.  For more info on
> +		 * synchronization, see freezer_post_create().
> +		 */
> +		spin_lock_irq(&pos_f->lock);
> +		freezer_apply_state(pos_f, parent->state & CGROUP_FREEZING,
> +				    CGROUP_FREEZING_PARENT);
> +		spin_unlock_irq(&pos_f->lock);
> +	}
> +	rcu_read_unlock();
>  }
>  
>  static int freezer_write(struct cgroup *cgroup, struct cftype *cft,
-- 
Michal Hocko
SUSE Labs
