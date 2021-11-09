From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v1 3/5] mm/oom: handle remote ooms
Date: Mon, 8 Nov 2021 17:19:07 -0800
Message-ID: <YYnMixe3zW4UEau0@carbon.dhcp.thefacebook.com>
References: <20211108211959.1750915-1-almasrymina@google.com>
 <20211108211959.1750915-4-almasrymina@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kEe1gG5PhKBw5O/hvKp4ft7lMouVA+oZMvUv97iPlXA=;
 b=KQFDc0UxBOELTRJuxCzhLho6wmuY+1PvSSFv/XKtSSs+pa6eXmbyewLYX0h/mQ6Neyx2
 G4pRTuS7Sk7FLRoJrdIzyU2++bNHxHZkg8fscUrYXLnBT6KxoyfeDiHRprcM7yQvrY1s
 E7c9qBnfgavIeEKF3HrnfbedUo+rnLTmlsw= 
Content-Disposition: inline
In-Reply-To: <20211108211959.1750915-4-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Nov 08, 2021 at 01:19:57PM -0800, Mina Almasry wrote:
> On remote ooms (OOMs due to remote charging), the oom-killer will attempt
> to find a task to kill in the memcg under oom, if the oom-killer
> is unable to find one, the oom-killer should simply return ENOMEM to the
> allocating process.
> 
> If we're in pagefault path and we're unable to return ENOMEM to the
> allocating process, we instead kill the allocating process.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Roman Gushchin <songmuchun@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: riel@surriel.com
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> 
> ---
>  mm/memcontrol.c | 21 +++++++++++++++++++++
>  mm/oom_kill.c   | 21 +++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2e4c20d09f959..fc9c6280266b6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2664,6 +2664,27 @@ int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len)
>  	return ret < 0 ? ret : 0;
>  }
> 
> +/*
> + * Returns true if current's mm is a descendant of the memcg_under_oom (or
> + * equal to it). False otherwise. This is used by the oom-killer to detect
> + * ooms due to remote charging.
> + */
> +bool is_remote_oom(struct mem_cgroup *memcg_under_oom)
> +{
> +	struct mem_cgroup *current_memcg;
> +	bool is_remote_oom;
> +
> +	if (!memcg_under_oom)
> +		return false;
> +
> +	current_memcg = get_mem_cgroup_from_mm(current->mm);
> +	is_remote_oom =
> +		!mem_cgroup_is_descendant(current_memcg, memcg_under_oom);
> +	css_put(&current_memcg->css);
> +
> +	return is_remote_oom;

You'll be probably better with mem_cgroup_from_task(current) within an rcu read
section?

> +}
> +
>  /*
>   * Set or clear (if @memcg is NULL) charge association from file system to
>   * memcg.  If @memcg != NULL, then a css reference must be held by the caller to
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 0a7e16b16b8c3..556329dee273f 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1106,6 +1106,27 @@ bool out_of_memory(struct oom_control *oc)
>  	}
> 
>  	select_bad_process(oc);
> +
> +	/*
> +	 * For remote ooms in userfaults, we have no choice but to kill the
> +	 * allocating process.
> +	 */
> +	if (!oc->chosen && is_remote_oom(oc->memcg) && current->in_user_fault &&
> +	    !oom_unkillable_task(current)) {
> +		get_task_struct(current);
> +		oc->chosen = current;
> +		oom_kill_process(
> +			oc, "Out of memory (Killing remote allocating task)");
> +		return true;
> +	}
> +
> +	/*
> +	 * For remote ooms in non-userfaults, simply return ENOMEM to the
> +	 * caller.
> +	 */
> +	if (!oc->chosen && is_remote_oom(oc->memcg))
> +		return false;
> +
>  	/* Found nothing?!?! */
>  	if (!oc->chosen) {

I'd move both if's here:

    	      if (is_remote_oom(oc->memcg)) {
	      	 if (current->in_user_fault && !oom_unkillable_task(current)) {
		    ...
		 }

		 return false;
	      }


>  		dump_header(oc, NULL);
> --
> 2.34.0.rc0.344.g81b53c2807-goog
