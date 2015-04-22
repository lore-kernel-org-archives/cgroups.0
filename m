From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 3/4] cgroups: allow a cgroup subsystem to reject a
 fork
Date: Wed, 22 Apr 2015 11:54:45 -0400
Message-ID: <20150422155445.GD10738@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-4-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iVgzYMOA6KXwXczAECbi7qcVY1a7sdog//5laVtWIeE=;
        b=bD9vzG9s6An0L+yqfMFxYB30gsqBLK0tBDxeB5yfScqnERN9QnRivB3JdJuM9AmQbw
         kJzE14qYwTsFwccB/fpCxAgLLKKP2//RIZQswEWWLvlRczzztOkPRJDZItVsiiHtRf+G
         osm8hNtfNg9WijIrWGyqWstTYqSnMtyMohFMhbnW1banLfbbYOJpcGe6H8f4Ex/U5aCF
         hqQ3v+tjFrxtqH+ShsrdENe41CfSVJQH2GlA7kL3rbamnckRncG9nG1Yp66jWtlOf99i
         3YikcY0OUchVI5ic8U2yyn8Pren7aB3bH2r8DJTeCqK5x6eC8RNbrMJUSQKLIc7rZze4
         QyLQ==
Content-Disposition: inline
In-Reply-To: <1429446154-10660-4-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Apr 19, 2015 at 10:22:33PM +1000, Aleksa Sarai wrote:
> @@ -25,6 +25,19 @@
>  
>  #ifdef CONFIG_CGROUPS
>  
> +/* define the enumeration of all cgroup subsystems */
> +enum cgroup_subsys_id {
> +#define SUBSYS(_x) _x ## _cgrp_id,
> +#define SUBSYS_TAG(_t) CGROUP_ ## _t, \
> +	__unused_tag_ ## _t = CGROUP_ ## _t - 1,
> +#include <linux/cgroup_subsys.h>
> +#undef SUBSYS_TAG
> +#undef SUBSYS
> +	CGROUP_SUBSYS_COUNT,
> +};

It's generally a good idea to not combine code movement and
modification as it tends to obfuscate what's going on.  Can you please
create a prep patch to move the chunk above?

> +#define CGROUP_PREFORK_COUNT (CGROUP_PREFORK_END - CGROUP_PREFORK_START)

Is it prefork or can_fork?  Given post_fork, maybe pre_fork is a more
consistent name?

> +
>  struct cgroup_root;
>  struct cgroup_subsys;
>  struct cgroup;
> @@ -32,7 +45,12 @@ struct cgroup;
>  extern int cgroup_init_early(void);
>  extern int cgroup_init(void);
>  extern void cgroup_fork(struct task_struct *p);
> -extern void cgroup_post_fork(struct task_struct *p);
> +extern int cgroup_can_fork(struct task_struct *p,
> +			   void *ss_state[CGROUP_PREFORK_COUNT]);
> +extern void cgroup_cancel_fork(struct task_struct *p,
> +			       void *ss_state[CGROUP_PREFORK_COUNT]);
> +extern void cgroup_post_fork(struct task_struct *p,
> +			     void *old_ss_state[CGROUP_PREFORK_COUNT]);

Also, why are they named @ss_state when the param to the callbacks are
@private?  Wouldn't ss_private[] be more consistent?

> @@ -945,10 +959,21 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
>  
>  struct cgroup_subsys_state;
>  
> +#define CGROUP_PREFORK_COUNT 0
> +
>  static inline int cgroup_init_early(void) { return 0; }
>  static inline int cgroup_init(void) { return 0; }
>  static inline void cgroup_fork(struct task_struct *p) {}
> -static inline void cgroup_post_fork(struct task_struct *p) {}
> +static inline int cgroup_can_fork(struct task_struct *p,
> +				  void *s[CGROUP_PREFORK_COUNT])
> +{
> +	return 0;
> +}

Style consistency?

> +static inline void cgroup_cancel_fork(struct task_struct *p,
> +				      void *s[CGROUP_PREFORK_COUNT]) {}
> +static inline void cgroup_post_fork(struct task_struct *p,
> +				    void *s[CGROUP_PREFORK_COUNT]) {}

Why are the arguments named @s here?

> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index e4a96fb..fdd3551 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -3,6 +3,16 @@
>   *
>   * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
>   */
> +#ifndef SUBSYS
> +#	define __TMP_SUBSYS
> +#	define SUBSYS(_x)
> +#endif

Does it ever make sense to include cgroup_subsys.h w/o SUBSYS macro?

...
> + * These bitmask flags indicate whether tasks in the fork and exit paths
> + * should check for fork/exit handlers to call. This avoids us having to do
> + * extra work in the fork/exit path if a subsystems doesn't need to be
> + * called.
>   */
>  static int need_fork_callback __read_mostly;
>  static int need_exit_callback __read_mostly;

This comment belongs to an earlier patch but need_ is a bit misnomer
at this point.  Shouldn't it be more like have_fork_callback?

>  
> +/* Ditto for the can_fork/cancel_fork/reapply_fork callbacks. */
> +static int need_canfork_callback __read_mostly;
> +static int need_cancelfork_callback __read_mostly;

And given that the reason we have these masks is avoiding iteration in
relatively hot paths.  Does cancelfork mask make sense?

> @@ -412,7 +416,7 @@ static int notify_on_release(const struct cgroup *cgrp)
>  	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
>  
>  /**
> - * for_each_subsys_which - filter for_each_subsys with a bitmask
> + * for_each_subsys_which - filter for_each_subsys with a subsys bitmask

Does this chunk belong to this patch?

> @@ -2078,6 +2084,18 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
>  	list_move_tail(&tsk->cg_list, &new_cset->mg_tasks);
>  
>  	/*
> +	 * We detach from the old_cset subsystems here. We must do this
> +	 * before we drop the refcount for old_cset, in order to make sure
> +	 * that nobody frees it underneath us.
> +	 */
> +	for_each_e_css(css, i, old_cgrp) {
> +		struct cgroup_subsys_state *old_css = old_cset->subsys[i];
> +
> +		if (old_css->ss->detach)
> +			old_css->ss->detach(old_css, tsk);
> +	}

I don't get this.  What can ->detach do that ->can_attach cannot?

> +void cgroup_cancel_fork(struct task_struct *child,
> +			void *ss_state[CGROUP_PREFORK_COUNT])
> +{
> +	struct cgroup_subsys *ss;
> +	int i;
> +
> +	for_each_subsys_which(need_cancelfork_callback, ss, i) {
> +		void *state = NULL;
> +
> +		if (CGROUP_PREFORK_START <= i && i < CGROUP_PREFORK_END)
> +			state = ss_state[i - CGROUP_PREFORK_START];

Maybe we want a helper callback which does

	if (CGROUP_PREFORK_START <= ssid && ssid < CGROUP_PREFORK_END)
		return &ss_state[ssid - CGROUP_PREFORK_START];
	return NULL;

> +
> +		ss->cancel_fork(child, state);
> +	}
> +}

> @@ -1196,6 +1196,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  {
>  	int retval;
>  	struct task_struct *p;
> +	void *ss_state[CGROUP_PREFORK_COUNT] = {};

Please use a name which signifies that this is for cgroups.

> @@ -1468,6 +1469,18 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	INIT_LIST_HEAD(&p->thread_group);
>  	p->task_works = NULL;
>  
> +
> +	/*
> +	 * Ensure that the cgroup subsystem policies allow the new process to be
> +	 * forked. If this fork is happening in an organization operation, then
> +	 * this will not charge the correct css_set. This is fixed during
> +	 * cgroup_post_fork() (when the css_set has been updated) by undoing
> +	 * this operation and forcefully charging the correct css_set.
> +	 */

I'm not sure the above description is appropriate for copy_process().
From copy_process()'s perspective, it doesn't matter what goes on
internally and the behavior being described is pretty specific to the
way the pids controller is implemented.

Thanks.

-- 
tejun
