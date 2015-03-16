From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Mon, 16 Mar 2015 12:53:35 -0400
Message-ID: <20150316165335.GC8353@htj.duckdns.org>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
 <1426307835-5893-3-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wHFr0Ie7YWpF4XKAn029hdhYN1ti2TQvCvWOCwJiKO4=;
        b=qAyFEYqRrqTYlvB9cIPrsq+A5kA7GFtelqmWDNNsbNWOCOc4ropGc1yIgutPmncr6r
         OsCn98Qqyh9L8LBVHciKmF8cEXd8vC04bZUbaSkI+LKw5dflf1qgZg1ptzFgha3petEw
         bcoaTPGu8cpvcTbNxU9nCL19WHIhS+FR4xvNfCnzBuo0G0WgIcKv3gfVb1RRNbPJI09q
         g4BAi13Bmq59dG/Tm17ZBV8LRE+cQKiuEsNYrexT3kl6prtcjOedHF/h0u4JB7Ugp/uA
         /pFUjn5gfvI5MvcmUZQV4N8s6KFq6atPatOzlX7wXeHAAKbd9dBzAhVpRs69BBIjPwee
         zL7Q==
Content-Disposition: inline
In-Reply-To: <1426307835-5893-3-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Sat, Mar 14, 2015 at 03:37:14PM +1100, Aleksa Sarai wrote:
> +/* Ditto for the can_fork/cancel_fork/reapply_fork callbacks. */
> +static int need_canfork_callback __read_mostly = 0,
> +	   need_reapplyfork_callback __read_mostly = 0;

Please separate the two definitions.  Please consult
Documentation/CodingStyle and in general try not to be creative with
style.

> +int cgroup_can_fork(struct task_struct *child, void **state)
> +{
> +	struct cgroup_subsys *ss;
> +	struct css_set *cset;
> +	int i, j, retval;
> +
> +	cset = task_css_set(current);
> +	get_css_set(cset);

So, you stuck with css_set refcnting.  That's fine, but please do
finish discussing in the original thread instead of throwing out new
version without explaining why you reached a particular conclusion.
Did you explore the idea of passing an opaque pointer from can_fork to
post_fork?  If so, why did you choose this direction instead of that
one?

Also, what pins the cset between task_css_set() and get_css_set()?
task_css_set() is protected by RCU and the above should have triggered
RCU warning if the debug option is enabled.  Please always test with
the debug options enabled, especially the lockdep and RCU ones.

> +	*state = cset;

There's no reason for css_set pointer to be passed around as an opaque
pointer.  The type is fixed.  I suppose this is from me mentioning
void pointer in the previous thread but that was about the cpuset
can_fork() implementation returning its css pointer, not css_set.
Please conclude discussions before working on the following version.

> @@ -5249,6 +5315,24 @@ void cgroup_post_fork(struct task_struct *child)
>  	}
>  
>  	/*
> +	 * Deal with tasks that were migrated mid-fork. If the css_set
> +	 * changed between can_fork() and post_fork() an organisation
> +	 * operation has occurred, and we need to revert/reapply the
> +	 * the can_fork().
> +	 */
> +	for_each_subsys_which(need_canfork_callback, ss, i) {
> +		struct cgroup_subsys_state *css = cset->subsys[i],
> +					   *old_css = old_cset->subsys[i];
> +
> +		/*
> +		 * We only reapply for subsystems whose
> +		 * association changed in the interim.
> +		 */
> +		if (old_css != css && ss->reapply_fork)
> +			ss->reapply_fork(css, old_css, child);
> +	}

Do we really need a separate callback for this?  Can't we just add
@old_css param to ss->fork() which is NULL if it didn't change since
can_fork()?

> @@ -1196,6 +1196,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  {
>  	int retval;
>  	struct task_struct *p;
> +	void *cfs;

If we're gonna do css_set, there's no need to make this an opaque
pointer.

Thanks.

-- 
tejun
