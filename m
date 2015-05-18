From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 6/8] cgroup: allow a cgroup subsystem to reject a fork
Date: Mon, 18 May 2015 18:12:46 -0400
Message-ID: <20150518221246.GL24861@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-7-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PqmWrAv7+pPDciYTH+56ec1OgXomZsLz/GbIYPVmzqM=;
        b=u58YkhijogZUx/u0ByR0dwPvPLo5hpXGcM3YRNVXOnSX8OG7rGI1TZj16cdZfiDoiB
         0S8uO2PpUFHzle21qzUg9Z8FV/+43JrJgC6wMenk/bMF92OfrUGFpt6Lv/obWi36R9gc
         /0jvKZAwEu/eD/F8iSUO95OD7HBtXWqTPYApbBMkiGUnYrZlH7DqbUScddALh/ul0U02
         Ankk7HNk+UWWbYdsiyZf1T+QWBMrae1EBq4jND2zOGYGeoRRb0WFNHsBoeJSD7/2jCtZ
         Ez8OAD/V3TdhriVpwOa/pWIhakztkwj/yusq2660NBH1BxhAq+OddzF9BibItwJarcZd
         ByzQ==
Content-Disposition: inline
In-Reply-To: <1431960667-26593-7-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Tue, May 19, 2015 at 12:51:05AM +1000, Aleksa Sarai wrote:
> Add a new cgroup subsystem callback can_fork that conditionally
> states whether or not the fork is accepted or rejected by a cgroup
> policy. In addition, add a cancel_fork callback so that if an error
> occurs later in the forking process, any state modified by can_fork can
> be reverted.
> 
> Allow for a private opaque pointer to be passed from the cgroup_can_fork
> to cgroup_post_fork, allowing for the fork state to be stored by each
> subsystem separately.
> 
> Also add a tagging system for cgroup_subsys.h to allow for CGROUP_<TAG>
> enumerations to be be defined and used. Also explicitly add a
> CGROUP_CANFORK_COUNT macro to make arrays easier to define.
> 
> This is in preparation for implementing the pids cgroup subsystem.
> 
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

This generally looks good to me now.

Ingo, Peter, I'm planning on routing this through cgroup branch after
minor revisions.  If there's any objection, please let me know.

> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 35ba593..886a883 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -28,11 +28,16 @@
>  /* define the enumeration of all cgroup subsystems */
>  #define SUBSYS(_x) _x ## _cgrp_id,
>  enum cgroup_subsys_id {
> +#define SUBSYS_TAG(_t) CGROUP_ ## _t, \
> +	__unused_tag_ ## _t = CGROUP_ ## _t - 1,

Why not put this together with SUBSYS() def?

>  #include <linux/cgroup_subsys.h>
> +#undef SUBSYS_TAG

And this with undef?

>  	CGROUP_SUBSYS_COUNT,
>  };
>  #undef SUBSYS
>  
> +#define CGROUP_CANFORK_COUNT (CGROUP_CANFORK_END - CGROUP_CANFORK_START)
> +
>  struct cgroup_root;
>  struct cgroup_subsys;
>  struct cgroup;
...
> @@ -3,6 +3,11 @@
>   *
>   * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
>   */
> +#ifndef SUBSYS_TAG
> +#	define __TMP_SUBSYS_TAG
> +#	define SUBSYS_TAG(_x)

It'd be nice if there's a comment explaining inclusion rules for this
file.  Also, let's not do the indenting thing.  I don't think it adds
much and it tends to get inconsistent and weird (e.g. why isn't
#include indented when inside #ifdef?) over time.  These aren't really
eye dazzling definitions.

> @@ -2324,9 +2327,10 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
>  	 */
>  	tset.csets = &tset.dst_csets;
>  
> -	for_each_e_css(css, i, cgrp)
> +	for_each_e_css(css, i, cgrp) {
>  		if (css->ss->attach)
>  			css->ss->attach(css, &tset);
> +	}

I don't object but is there a reason for this change?  If it's just
for stylistic consistency, please mention it in the description.

> @@ -5180,6 +5185,23 @@ static const struct file_operations proc_cgroupstats_operations = {
>  	.release = single_release,
>  };
>  
> +static void **subsys_canfork_privatep(void *ss_private[CGROUP_CANFORK_COUNT],
> +				      int i)

Heh, how about subsys_canfork_priv_p()?  privatep and private are
kinda tricky to tell apart.

> +{
> +	if (CGROUP_CANFORK_START <= i && i < CGROUP_CANFORK_END)
> +		return &ss_private[i - CGROUP_CANFORK_START];
> +	return NULL;
> +}
> +
> +static void *subsys_canfork_private(void *ss_private[CGROUP_CANFORK_COUNT],
> +				    int i)

and subsys_canfork_priv() here.

> +{
> +	void **private;
> +	if ((private = subsys_canfork_privatep(ss_private, i)) != NULL)
> +		return *private;
> +	return NULL;
> +}
...
> @@ -5195,6 +5217,61 @@ void cgroup_fork(struct task_struct *child)
>  }
>  
>  /**
> + * cgroup_can_fork - called on a new task before the process is exposed
> + * @child: the task in question.
> + *
> + * This calls the subsystem can_fork() callbacks. If the can_fork() callback
> + * returns an error, the fork aborts with that error code. This allows for
> + * a cgroup subsystem to conditionally allow or deny new forks.
> + */
> +int cgroup_can_fork(struct task_struct *child,
> +		    void *ss_private[CGROUP_CANFORK_COUNT])
> +{
> +	struct cgroup_subsys *ss;
> +	int i, j, retval;
> +
> +	for_each_subsys_which(ss, i, &have_canfork_callback) {
> +		retval = ss->can_fork(child,
> +				      subsys_canfork_privatep(ss_private, i));

How about shortening things a bit?  It doesn't lose any clarity and we
don't have to do ugly line splits.

		ret = ss->can_fork(child, subsys_canfork_priv_p(ss_priv, i));

> +		if (retval)
> +			goto out_revert;
> +	}
> +
> +	return 0;
> +
> +out_revert:
> +	for_each_subsys(ss, j) {
> +		if (j >= i)
> +			break;
> +
> +		if (ss->cancel_fork)
> +			ss->cancel_fork(child,
> +					subsys_canfork_private(ss_private, j));
> +	}
> +
> +	return retval;
> +}
...
> @@ -1516,6 +1517,16 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	p->task_works = NULL;
>  
>  	/*
> +	 * Ensure that the cgroup subsystem policies allow the new process to be
> +	 * forked. It should be noted the the new process's css_set can be changed
> +	 * between here and cgroup_post_fork() if an organisation operation is in
> +	 * progress.
> +	 */

Let's move the latter half of the comment to cgroup_can_fork().  fork
path doesn't need to care about this level of cgroup-specific details.

Thanks.

-- 
tejun
