From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v13 4/5] cgroup: allow a cgroup subsystem to reject a fork
Date: Tue, 9 Jun 2015 13:41:33 +0900
Message-ID: <20150609044133.GQ21465@mtj.duckdns.org>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
 <1433548938-32560-4-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M3VCbGg+dQgj/agr30VaBUaxDEjFC4I7FrjSnNfut/E=;
        b=uOFE+suyif/1paLob/tFxbVIytmco7gLKId03h23+B6akFV8jBIAQ7WUvXvSntlEbi
         JYJa2TxvrdIcwNrvh7Go/tMChh2jU61cgasE/+Sg6TmJVE1nNiH5IaHZNOkibxqAu7DD
         sP0N4Nuj8SDjO7zWRqLgS2B2QB9Rsz9t8OrWJvhrMAWcG0Q2kyQCU2NK7At75Zp09pp0
         cwgDt8XXIZp3UgFlfNS2jqDTCO6GCmQoxZU70j64/QE7ircY4iHMU/86U+TTvVGhLk0K
         e0ddxyxxS2XasiHGP+q87hi/P5lzSwEahc8f/aPjWffGnhS9QnydwONU1trzqxUU/ET2
         nZEw==
Content-Disposition: inline
In-Reply-To: <1433548938-32560-4-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

Looks pretty good to me in general.  Some minor comments below.

On Sat, Jun 06, 2015 at 10:02:17AM +1000, Aleksa Sarai wrote:

> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index a593e29..17d0046 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -62,9 +62,15 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
>                      struct pid *pid, struct task_struct *tsk);

>  void cgroup_fork(struct task_struct *p);
> -void cgroup_post_fork(struct task_struct *p);
> +extern int cgroup_can_fork(struct task_struct *p,
> +                          void *ss_priv[CGROUP_CANFORK_COUNT]);
> +extern void cgroup_cancel_fork(struct task_struct *p,
> +                              void *ss_priv[CGROUP_CANFORK_COUNT]);
> +extern void cgroup_post_fork(struct task_struct *p,
> +                            void *old_ss_priv[CGROUP_CANFORK_COUNT]);
>  void cgroup_exit(struct task_struct *p);
> 
> +

Is this blank line intentional?

>  int cgroup_init_early(void);
>  int cgroup_init(void);
...
> @@ -4924,6 +4927,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
>  
>  	have_fork_callback |= (bool)ss->fork << ss->id;
>  	have_exit_callback |= (bool)ss->exit << ss->id;
> +	have_canfork_callback |= (bool)ss->can_fork << ss->id;

Hmmm.... do we still need this mask?  We're already restricting
iteration pretty heavily.  I'd even suggest dropping both
have_fork_callback and have_exit_callback too and just put them inside
CGROUP_FORK_EXIT_START / STOP although that doesn't belong in this
patchset.

...
> +static void *subsys_canfork_priv(void *ss_priv[CGROUP_CANFORK_COUNT], int i)
> +{
> +	void **private;
> +	if ((private = subsys_canfork_priv_p(ss_priv, i)) != NULL)
> +		return *private;
> +	return NULL;
> +}

	void **private = subsys_canfork...;

	if (private)
		return *private;
	return NULL;

or even just

	return private ? *private : NULL;

We conventionally don't put assignments in if conditionals.

> +void cgroup_cancel_fork(struct task_struct *child,
> +			void *ss_priv[CGROUP_CANFORK_COUNT])
> +{
> +	struct cgroup_subsys *ss;
> +	int i;
> +
> +	for_each_subsys(ss, i)
> +		if(ss->cancel_fork)
                  ^
		  space

> +			ss->cancel_fork(child, subsys_canfork_priv(ss_priv, i));
> +}
> +
> +/**
>   * cgroup_post_fork - called on a new task after adding it to the task list
>   * @child: the task in question
>   *

Thanks.

-- 
tejun
