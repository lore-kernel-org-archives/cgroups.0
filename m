From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Tue, 3 Mar 2020 08:48:55 -0500
Message-ID: <20200303134855.GA186184@mtj.thefacebook.com>
References: <20200219183231.50985-1-balejs@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eeNzn8H18FzPdQesLxTltwdmSd8JJDcXIg9kUyzHqWE=;
        b=WUhEHc5vql7ujIsEF3YHXKRSPLmhv/fLYpNQcZJljQqi4gtjdwhw6AbZIFvY082EsT
         LrzFJH1uw3wD4vcFMkziFsHeadM0WGFkWAPGsvoHm1sEwZKWYU3jvijiuYlmS3FbEl4W
         ATccS1Mzp8UkXzZkfb+SMX8fJnqeOUKNbFudgw329WdafEFjgsmDO2FD1P098aeK+ji5
         WK9shX1psrjhZS0EvBjaqf/AoNNd/A033bf4uZh+I6Br1UBnip1h0bBG/Ow9RG7V8BOm
         mHQe0xu2/SZnPvFdU/16fTcMa1lqkxZeGdhawwAOQOSEgGOYqdCTXIaSGZfX2Kfsw9qs
         3BXw==
Content-Disposition: inline
In-Reply-To: <20200219183231.50985-1-balejs-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Ballesio <balejs-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: guro-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, minchan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello,

On Wed, Feb 19, 2020 at 10:32:31AM -0800, Marco Ballesio wrote:
> @@ -94,6 +94,18 @@ The following cgroupfs files are created by cgroup freezer.
>    Shows the parent-state.  0 if none of the cgroup's ancestors is
>    frozen; otherwise, 1.
>  
> +* freezer.killable: Read-write
> +
> +  When read, returns the killable state of a cgroup - "1" if frozen
> +  tasks will respond to fatal signals, or "0" if they won't.
> +
> +  When written, this property sets the killable state of the cgroup.
> +  A value equal to "1" will switch the state of all frozen tasks in
> +  the cgroup to TASK_INTERRUPTIBLE (similarly to cgroup v2) and will
> +  make them react to fatal signals. A value of "0" will switch the
> +  state of frozen tasks to TASK_UNINTERRUPTIBLE and they won't respond
> +  to signals unless thawed or unfrozen.

As Roman said, I'm not too sure about adding a new cgroup1 freezer
interface at this point. If we do this, *maybe* a mount option would
be more minimal?

> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index dc520f01f99d..92de1bfe62cf 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -42,6 +42,9 @@ bool freezing_slow_path(struct task_struct *p)
>  	if (test_tsk_thread_flag(p, TIF_MEMDIE))
>  		return false;
>  
> +	if (cgroup_freezer_killable(p) && fatal_signal_pending(p))
> +		return false;
> +
>  	if (pm_nosig_freezing || cgroup_freezing(p))
>  		return true;
>  
> @@ -63,7 +66,12 @@ bool __refrigerator(bool check_kthr_stop)
>  	pr_debug("%s entered refrigerator\n", current->comm);
>  
>  	for (;;) {
> -		set_current_state(TASK_UNINTERRUPTIBLE);
> +		bool killable = cgroup_freezer_killable(current);
> +
> +		if (killable)
> +			set_current_state(TASK_INTERRUPTIBLE);
> +		else
> +			set_current_state(TASK_UNINTERRUPTIBLE);
>  
>  		spin_lock_irq(&freezer_lock);
>  		current->flags |= PF_FROZEN;
> @@ -75,6 +83,16 @@ bool __refrigerator(bool check_kthr_stop)
>  		if (!(current->flags & PF_FROZEN))
>  			break;
>  		was_frozen = true;
> +
> +		/*
> +		 * Now we're sure that there is no pending fatal signal.
> +		 * Clear TIF_SIGPENDING to not get out of schedule()
> +		 * immediately (if there is a non-fatal signal pending), and
> +		 * put the task into sleep.
> +		 */

and this looks really racy to me. What happens if this task gets a
fatal signal here? We clear TIF_SIGPENDING and go to sleep?

> +		if (killable)
> +			clear_thread_flag(TIF_SIGPENDING);
> +
>  		schedule();
>  	}

Thanks.

-- 
tejun
