From: Christian Brauner <christian.brauner@mailbox.org>
Subject: Re: [lxc-devel] [RFC PATCH] cgroup, cpuset: add cpuset.remap_cpus
Date: Wed, 30 Aug 2017 15:27:55 +0200
Message-ID: <20170830132755.tnqmuttodexc3oh6@mailbox.org>
References: <1482419271-15410-1-git-send-email-w.bumiller@proxmox.com>
Reply-To: christian.brauner@ubuntu.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:reply-to:message-id:subject:subject
        :from:from:date:date:received; s=mail20150812; t=1504099677; bh=
        IeHHwtxSj2ZbDAvWyp9PTijH8DbMgxU63NTU1AeZrz8=; b=ZpwfbEtsSRVCKr2h
        5z6uekBUU/uYjoKY6QzJkzjN2hmljji35McNYMWy8oH0lgSsD2+Kv/y6HTsDTf7a
        POXTAgJAKOApqy8JogCHqhSoABVt+88hUnToPv1p1ybeCD/0abHjKq6Uua7O1nwg
        4e7BZo3z4UzgBEtMP+1PwXzOsIuLcDuEvWDIO/wDctRCAWSY+khqASgSQnf6j13c
        i5Zx3QD6l37X5k6RtEpXzxgHu7z1EUBZSEgD5Jf8gVx9cjBh/tZdtGonzYAVsEX1
        a2VQZD+qKDZqkGVVNq7gr3NhKetlPx3YWWt9SJuPW0H95uRk1cn1z5Iop8u9KUIu
        GpRhHA==
Content-Disposition: inline
In-Reply-To: <1482419271-15410-1-git-send-email-w.bumiller@proxmox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, w.bumiller@proxmox.com
Cc: stgraber@ubuntu.com, serge@hallyn.com

Hi,

The following patch was sent a while back by Wolfgang Bumiller to remap cpusets
for a whole subtree in a cgroup v1 cpuset hierarchy. The fact that currently
this is not possible in a non-racy why is a pretty big limitation. This is
especially true for nested containers. Where the nested containers often create
additional subcgroups in the cpuset controller at will. The fact that you can't
*easily* and in a non-racy way tighten the restriction on them after having
created the parent container's cpuset cgroup seems really troubling.

Here's a more concrete use case:
Let's say you started out with handing over all cores to container "c1". You
then create a nested container "c2" inside of "c1". This will - since the advent
of cgroup namespaces - usually mean that "c2"'s cpuset cgroup is a subcgroup in
"c1"'s cpuset cgroup. Usually, "c2"'s cpuset cgroup will also allocate all cores
or at least a subset of them made available to it by "c1"'s cpuset cgroup. When
the host now decides to restrict "c1"'s cpuset by removing some of the cores
that it shares with "c2"'s cpuset subcgroup the host will fail to do this giving
EBUSY. This leaves the container's open to consume the hosts cpu resources. The
only option I see right now is to kill the containers and redo the whole cpuset
layout for the whole subtree. This is usually not something you'd want to do
when critical processes are running. The other option is to implement an
algorithm for a container manager that does the remapping by walking the
relevant cpuset subtree and first removing any cpus from the lowest node that
uses these cpus and then adding all cpus it wants to add walking the tree top
down. But that is - as I said - racy since the nested container's might create
subcgroups thereby preventing he host from successfully performing the
remapping. So an in-kernel approach seems to be a good idea. But maybe I'm just
not seeing the obvious userspace solution to this which is entirely possible. I
just thought I ping about this patch since I didn't see a discussion of this
patch. Maybe it just got lost over Christmas. I take it that Wolfgang is still
willing to pick up that patch but if he doesn't want to or can't I'm happy to
step up. I just couldn't reach him today.

Thanks!
Christian

On Thu, Dec 22, 2016 at 04:07:51PM +0100, Wolfgang Bumiller wrote:
> Changes a cpuset, recursively remapping all its descendants
> to the new range.
> 
> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
> ---
> Currently once a cpuset cgroup has a subdirectory it's impossible to
> remove cpu without manually recursing through the cgroup file system.
> The problem gets worse if you want to remap cpus of a larger subtree.
> This is particularly useful with containers and problematic in that
> the recursion might race against the creation of new subdirectories.
> 
> I'm not sure why this functionality isn't there yet and thought I'd
> give it a try and send an RFC patch. I'm sure there's a reason though,
> given how surprisingly small/simple the patch turned out to be and
> I'm rarely the first to think of a feature like that ;-)
> 
> I hope this is something we could add one way or another, if possible
> required changes to the patch are within the scope of my abilities.
> 
>  include/linux/cpumask.h | 17 ++++++++++++++++
>  kernel/cpuset.c         | 54 +++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 60 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 59915ea..f5487c8 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -514,6 +514,23 @@ static inline void cpumask_copy(struct cpumask *dstp,
>  }
>  
>  /**
> + * cpumask_remap - *dstp = map(old, new)(*srcp)
> + * @dstp: the result
> + * @srcp: the input cpumask
> + * @oldp: the old mask
> + * @newp: the new mask
> + */
> +static inline void cpumask_remap(struct cpumask *dstp,
> +				 const struct cpumask *srcp,
> +				 const struct cpumask *oldp,
> +				 const struct cpumask *newp)
> +{
> +	bitmap_remap(cpumask_bits(dstp), cpumask_bits(srcp),
> +		     cpumask_bits(oldp), cpumask_bits(newp),
> +		     nr_cpumask_bits);
> +}
> +
> +/**
>   * cpumask_any - pick a "random" cpu from *srcp
>   * @srcp: the input cpumask
>   *
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 02a8ea5..22d0cb2 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -450,7 +450,8 @@ static void free_trial_cpuset(struct cpuset *trial)
>   * Return 0 if valid, -errno if not.
>   */
>  
> -static int validate_change(struct cpuset *cur, struct cpuset *trial)
> +static int validate_change(struct cpuset *cur, struct cpuset *trial,
> +			   bool remap)
>  {
>  	struct cgroup_subsys_state *css;
>  	struct cpuset *c, *par;
> @@ -458,11 +459,13 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
>  
>  	rcu_read_lock();
>  
> -	/* Each of our child cpusets must be a subset of us */
> -	ret = -EBUSY;
> -	cpuset_for_each_child(c, css, cur)
> -		if (!is_cpuset_subset(c, trial))
> -			goto out;
> +	if (!remap) {
> +		/* Each of our child cpusets must be a subset of us */
> +		ret = -EBUSY;
> +		cpuset_for_each_child(c, css, cur)
> +			if (!is_cpuset_subset(c, trial))
> +				goto out;
> +	}
>  
>  	/* Remaining checks don't apply to root cpuset */
>  	ret = 0;
> @@ -925,11 +928,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
>   * @cs: the cpuset to consider
>   * @trialcs: trial cpuset
>   * @buf: buffer of cpu numbers written to this cpuset
> + * @remap: recursively remap all child nodes
>   */
>  static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
> -			  const char *buf)
> +			  const char *buf, bool remap)
>  {
>  	int retval;
> +	struct cpuset *cp;
> +	struct cgroup_subsys_state *pos_css;
> +	struct cpumask tempmask;
>  
>  	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
>  	if (cs == &top_cpuset)
> @@ -957,11 +964,25 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
>  		return 0;
>  
> -	retval = validate_change(cs, trialcs);
> +	retval = validate_change(cs, trialcs, remap);
>  	if (retval < 0)
>  		return retval;
>  
>  	spin_lock_irq(&callback_lock);
> +	if (remap) {
> +		rcu_read_lock();
> +		cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> +			/* skip empty subtrees */
> +			if (cpumask_empty(cp->cpus_allowed)) {
> +				pos_css = css_rightmost_descendant(pos_css);
> +				continue;
> +			}
> +			cpumask_copy(&tempmask, cp->cpus_allowed);
> +			cpumask_remap(cp->cpus_allowed, &tempmask,
> +				      cs->cpus_allowed, trialcs->cpus_allowed);
> +		}
> +		rcu_read_unlock();
> +	}
>  	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
>  	spin_unlock_irq(&callback_lock);
>  
> @@ -1217,7 +1238,7 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
>  		retval = 0;		/* Too easy - nothing to do */
>  		goto done;
>  	}
> -	retval = validate_change(cs, trialcs);
> +	retval = validate_change(cs, trialcs, false);
>  	if (retval < 0)
>  		goto done;
>  
> @@ -1304,7 +1325,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
>  	else
>  		clear_bit(bit, &trialcs->flags);
>  
> -	err = validate_change(cs, trialcs);
> +	err = validate_change(cs, trialcs, false);
>  	if (err < 0)
>  		goto out;
>  
> @@ -1563,6 +1584,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>  typedef enum {
>  	FILE_MEMORY_MIGRATE,
>  	FILE_CPULIST,
> +	FILE_REMAP_CPULIST,
>  	FILE_MEMLIST,
>  	FILE_EFFECTIVE_CPULIST,
>  	FILE_EFFECTIVE_MEMLIST,
> @@ -1695,7 +1717,10 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>  
>  	switch (of_cft(of)->private) {
>  	case FILE_CPULIST:
> -		retval = update_cpumask(cs, trialcs, buf);
> +		retval = update_cpumask(cs, trialcs, buf, false);
> +		break;
> +	case FILE_REMAP_CPULIST:
> +		retval = update_cpumask(cs, trialcs, buf, true);
>  		break;
>  	case FILE_MEMLIST:
>  		retval = update_nodemask(cs, trialcs, buf);
> @@ -1811,6 +1836,13 @@ static struct cftype files[] = {
>  	},
>  
>  	{
> +		.name = "remap_cpus",
> +		.write = cpuset_write_resmask,
> +		.max_write_len = (100U + 6 * NR_CPUS),
> +		.private = FILE_REMAP_CPULIST,
> +	},
> +
> +	{
>  		.name = "mems",
>  		.seq_show = cpuset_common_seq_show,
>  		.write = cpuset_write_resmask,
> -- 
> 2.1.4
> 
> 
> _______________________________________________
> lxc-devel mailing list
> lxc-devel@lists.linuxcontainers.org
> http://lists.linuxcontainers.org/listinfo/lxc-devel
