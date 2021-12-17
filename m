From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup/cpuset: Make child cpusets restrict parents on v1
 hierarchy
Date: Fri, 17 Dec 2021 11:34:09 -0500
Message-ID: <a7c9aaa1-b813-fccc-6623-0c6409642b6b@redhat.com>
References: <8d73dc26-74e1-d763-d897-6e03cdac3c8c@redhat.com>
 <20211217154854.41409-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639758873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHsgYvtM2VbxZhXYtiIDslv8uvAy3OgBfsyPMPqyKfY=;
        b=GH1/pCU/7YRCnIUb3oBfxURxOFj1EmDUaRg82g291Hbeu2qbytcoQkrMzAyLbvpEIe4Zny
        FK42AtouCMkG/yPG7+VeADkFOZ71+N01NLE1Z2hVCFg8JamH9eClDq/5DZ5EDRvWkbt5gp
        nTpVU1O3zCAOM5f5W0wKxZJ6dsIUAEk=
Content-Language: en-US
In-Reply-To: <20211217154854.41409-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, tj@kernel.org
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net, frederic@kernel.org, guro@fb.com, hannes@cmpxchg.org, juri.lelli@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, lizefan.x@bytedance.com, mtosatti@redhat.com, pauld@redhat.com, peterz@infradead.org, shuah@kernel.org

On 12/17/21 10:48, Michal Koutný wrote:
> The commit 1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets
> restrict parent in default hierarchy") inteded to relax the check only
> on the default hierarchy (or v2 mode) but it dropped the check in v1
> too.
>
> This patch returns and separates the legacy-only validations so that
> they can be considered only in the v1 mode, which should enforce the old
> constraints for the sake of compatibility.
>
> Fixes: 1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets restrict parent in default hierarchy")
> Suggested-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---
>   kernel/cgroup/cpuset.c | 52 ++++++++++++++++++++++++++++++++----------
>   1 file changed, 40 insertions(+), 12 deletions(-)
>
> This is formatted as a separate patch fixing the already queued change in
> for-5.17 but it can be eventually squashed into the referenced commit AFAIAC.
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0dd7d853ed17..ce6929ddc0b0 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -590,6 +590,35 @@ static inline void free_cpuset(struct cpuset *cs)
>   	kfree(cs);
>   }
>   
> +/*
> + * validate_change_legacy() - Validate conditions specific to legacy (v1)
> + *                            behavior.
> + */
> +static int validate_change_legacy(struct cpuset *cur, struct cpuset *trial)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cpuset *c, *par;
> +	int ret;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +
> +	/* Each of our child cpusets must be a subset of us */
> +	ret = -EBUSY;
> +	cpuset_for_each_child(c, css, cur)
> +		if (!is_cpuset_subset(c, trial))
> +			goto out;
> +
> +	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
> +	ret = -EACCES;
> +	par = parent_cs(cur);
> +	if (par && !is_cpuset_subset(trial, par))
> +		goto out;
> +
> +	ret = 0;
> +out:
> +	return ret;
> +}
> +
>   /*
>    * validate_change() - Used to validate that any proposed cpuset change
>    *		       follows the structural rules for cpusets.
> @@ -614,20 +643,21 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
>   {
>   	struct cgroup_subsys_state *css;
>   	struct cpuset *c, *par;
> -	int ret;
> -
> -	/* The checks don't apply to root cpuset */
> -	if (cur == &top_cpuset)
> -		return 0;
> +	int ret = 0;
>   
>   	rcu_read_lock();
> -	par = parent_cs(cur);
>   
> -	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
> -	ret = -EACCES;
> -	if (!is_in_v2_mode() && !is_cpuset_subset(trial, par))
> +	if (!is_in_v2_mode())
> +		ret = validate_change_legacy(cur, trial);
> +	if (ret)
> +		goto out;
> +
> +	/* Remaining checks don't apply to root cpuset */
> +	if (cur == &top_cpuset)
>   		goto out;
>   
> +	par = parent_cs(cur);
> +
>   	/*
>   	 * If either I or some sibling (!= me) is exclusive, we can't
>   	 * overlap
> @@ -1175,9 +1205,7 @@ enum subparts_cmd {
>    *
>    * Because of the implicit cpu exclusive nature of a partition root,
>    * cpumask changes that violates the cpu exclusivity rule will not be
> - * permitted when checked by validate_change(). The validate_change()
> - * function will also prevent any changes to the cpu list if it is not
> - * a superset of children's cpu lists.
> + * permitted when checked by validate_change().
>    */
>   static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
>   					  struct cpumask *newmask,

Thanks for addressing this issue.

Reviewed-by: Waiman Long <longman@redhat.com>

