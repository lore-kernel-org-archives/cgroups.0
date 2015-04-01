From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Wed, 1 Apr 2015 12:02:58 -0400
Message-ID: <20150401160258.GP9974@htj.duckdns.org>
References: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
 <1427878641-5273-4-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RXlAJDHvfyOL+qdQfbPE9/aTfSI0lLF26CEvAqvV4x0=;
        b=APTucbpoeRTJvXrhpLLeVwaIulE7vSRB9cBAKRcqtKqD5kqiEJNZ1uDYGaQ++0LFIi
         243MHIMoicVEE/BPUFjEsmNEJWWrmtDT7CwJ9sUoklCD5WZ+k6dS2ExJKDvj+kbZkFuj
         8JP4UGrai66W4zH1nrz3R+CIBL0BjdcvnFj3gwSVK29qOAQKwSuVSBAQZXODp9/EiJhe
         myeUcJ2k71dfgwrfBGNMO8ujy095Jib3mlL40N+u7ksQyoKqPiFopiWXQVexmr3mvefD
         gqQaOVourJttzsHg8K16Pvf2ObLvSCxhjx8Ee1eA5hII/vSRwXi4JTBps1fbhE9XaG/9
         etkA==
Content-Disposition: inline
In-Reply-To: <1427878641-5273-4-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Wed, Apr 01, 2015 at 07:57:20PM +1100, Aleksa Sarai wrote:
> +struct cgroup_fork_state {
> +	void *ss_state[CGROUP_SUBSYS_COUNT];
> +};

Can we collect the subsystems which require pre/post fork callbacks to
the front in group_subsys.h and do do CGROUP_SUBSYS_FORK_COUNT (or
whatever) instead?  Then, we don't need all these subsys bitmasks
either we can just test the index against that and be done with it.

> +
> +/**
> + * cgroup_cfs_alloc - allocates an empty cgroup_fork_state
> + */
> +struct cgroup_fork_state *cgroup_cfs_alloc(void)
> +{
> +	struct cgroup_fork_state *cfs;
> +
> +	cfs = kzalloc(sizeof(struct cgroup_fork_state), GFP_KERNEL);
> +	if (!cfs)
> +		return ERR_PTR(-ENOMEM);
> +
> +	return cfs;
> +}

Just make it a void * array and put it on stack.  Abstraction at this
level doesn't serve any purpose.  No controller code is gonna see this
anyway.

> +int cgroup_can_fork(struct task_struct *child, struct cgroup_fork_state *cfs)
> +{
> +	struct cgroup_subsys *ss;
> +	int i, j, retval;
> +
> +	for_each_subsys_which(need_canfork_callback, ss, i) {
> +		retval = ss->can_fork(child, &cfs->ss_state[i]);
> +		if (retval)
> +			goto out_revert;
> +	}
> +
> +	return 0;
> +
> +out_revert:
> +	for_each_subsys_which(need_cancelfork_callback, ss, j) {
> +		if (j >= i)
> +			break;
> +		ss->cancel_fork(child, &cfs->ss_state[i]);

cancel_fork() has no reason to update the opaque pointer.  No reason
to pass pointer of it.

> +void cgroup_cancel_fork(struct task_struct *child, struct cgroup_fork_state *cfs)
> +{
> +	struct cgroup_subsys *ss;
> +	int i;
> +
> +	for_each_subsys_which(need_cancelfork_callback, ss, i) {
> +		void **state = NULL;
> +
> +		/*
> +		 * Only if %ss has a can_fork() callback is %cfs->ss_state[i] meaningful

I don't think we do %var, do we?  % is used for macros and consts.

> +		 * -- otherwise just pass a NULL.
> +		 */
> +		if (need_canfork_callback & (1 << i))
> +			state = &cfs->ss_state[i];
> +
> +		ss->cancel_fork(child, &cfs->ss_state[i]);

Ditto, just pass the pointer itself.

> @@ -5241,8 +5346,18 @@ void cgroup_post_fork(struct task_struct *child)
>  	 * css_set; otherwise, @child might change state between ->fork()
>  	 * and addition to css_set.
>  	 */
> -	for_each_subsys_which(need_fork_callback, ss, i)
> -		ss->fork(child);
> +	for_each_subsys_which(need_fork_callback, ss, i) {
> +		void **state = NULL;
> +
> +		/*
> +		 * Only if %ss has a can_fork() callback is %old_cfs->ss_state[i]
> +		 * meaningful -- otherwise just pass a NULL.
> +		 */

Again, if you just passed the pointer, you wouldn't need the above.
Just clear the array on init and pass in whatever value is in there.

> +		if (need_canfork_callback & (1 << i))
> +			state = &old_cfs->ss_state[i];
> +
> +		ss->fork(child, state);
> +	}
>  }

Thanks.

-- 
tejun
