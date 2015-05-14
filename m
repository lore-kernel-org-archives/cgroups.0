From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] sched, cgroup: reorganize threadgroup locking
Date: Thu, 14 May 2015 10:09:13 +0900
Message-ID: <20150514010913.GA4441@swordfish>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
 <1431549318-16756-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2OnhefiMj46Zsd1yUCNwllwdMoBiv3z5xDMW4YONb0U=;
        b=0t/IgA/kqF6r+YfenmWZ7HAAWT9/RVo1/xyQOCUgUw0QRlGw0+h9QMSuBL9L79DrUI
         EORob/5JIRrRqjyLXsiT7k9DS8Z0atNDxVELZLkZGctgGnIeU1oiM6yAf/L9ffXy4eux
         3eqTfLqprnL5oTmnJQr/TrLxL9Xl/GRrmKi+4r9ffF29nGAzOuip5G9I7p33VIwaPANV
         nj2MYL+Y3LxqQOcBd+lc8fLrzN8VzSdC+7Qmc2wC8v+VYzGhAZcqllbi3KOy2Jsqg24l
         50f1YGHgpok8TN8+7iW8baXbjbzS8QuM3AczOCG6X3Sln+Wl8CP34kzYqyI7BslP4hVA
         fwxw==
Content-Disposition: inline
In-Reply-To: <1431549318-16756-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On (05/13/15 16:35), Tejun Heo wrote:
[..]
> -static inline void threadgroup_lock(struct task_struct *tsk)
> +static inline void threadgroup_change_begin(struct task_struct *tsk)
>  {
> -	down_write(&tsk->signal->group_rwsem);
> +	might_sleep();

I think cgroup_threadgroup_change_begin()->down_read() already does
might_sleep() check.

	-ss

> +	cgroup_threadgroup_change_begin(tsk);
>  }
>  
>  /**
> - * threadgroup_unlock - unlock threadgroup
> - * @tsk: member task of the threadgroup to unlock
> + * threadgroup_change_end - mark the end of changes to a threadgroup
> + * @tsk: task causing the changes
>   *
> - * Reverse threadgroup_lock().
> + * See threadgroup_change_begin().
>   */
> -static inline void threadgroup_unlock(struct task_struct *tsk)
> +static inline void threadgroup_change_end(struct task_struct *tsk)
>  {
> -	up_write(&tsk->signal->group_rwsem);
> +	cgroup_threadgroup_change_end(tsk);
>  }
> -#else
> -static inline void threadgroup_change_begin(struct task_struct *tsk) {}
> -static inline void threadgroup_change_end(struct task_struct *tsk) {}
> -static inline void threadgroup_lock(struct task_struct *tsk) {}
> -static inline void threadgroup_unlock(struct task_struct *tsk) {}
> -#endif
>  
>  #ifndef __HAVE_THREAD_FUNCTIONS
>  
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index cfa27f9..9309452 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -848,6 +848,48 @@ static struct css_set *find_css_set(struct css_set *old_cset,
>  	return cset;
>  }
>  
> +void cgroup_threadgroup_change_begin(struct task_struct *tsk)
> +{
> +	down_read(&tsk->signal->group_rwsem);
> +}
> +
> +void cgroup_threadgroup_change_end(struct task_struct *tsk)
> +{
> +	up_read(&tsk->signal->group_rwsem);
> +}
> +
> +/**
> + * threadgroup_lock - lock threadgroup
> + * @tsk: member task of the threadgroup to lock
> + *
> + * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
> + * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
> + * change ->group_leader/pid.  This is useful for cases where the threadgroup
> + * needs to stay stable across blockable operations.
> + *
> + * fork and exit explicitly call threadgroup_change_{begin|end}() for
> + * synchronization.  While held, no new task will be added to threadgroup
> + * and no existing live task will have its PF_EXITING set.
> + *
> + * de_thread() does threadgroup_change_{begin|end}() when a non-leader
> + * sub-thread becomes a new leader.
> + */
> +static void threadgroup_lock(struct task_struct *tsk)
> +{
> +	down_write(&tsk->signal->group_rwsem);
> +}
> +
> +/**
> + * threadgroup_unlock - unlock threadgroup
> + * @tsk: member task of the threadgroup to unlock
> + *
> + * Reverse threadgroup_lock().
> + */
> +static inline void threadgroup_unlock(struct task_struct *tsk)
> +{
> +	up_write(&tsk->signal->group_rwsem);
> +}
> +
>  static struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root)
>  {
>  	struct cgroup *root_cgrp = kf_root->kn->priv;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
