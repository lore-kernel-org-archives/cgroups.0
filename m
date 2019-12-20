From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] clone3: allow spawning processes into cgroups
Date: Fri, 20 Dec 2019 21:36:50 +0100
Message-ID: <20191220203650.GA15133@redhat.com>
References: <20191218173516.7875-1-christian.brauner@ubuntu.com>
 <20191218173516.7875-3-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576874220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4jjRnLYjGrqgF7WL+aNzr4dW0tQZdCM9Qqr1PxQyLYQ=;
        b=CPOUv+luqofKZe6ideEHXXcBsW3L4JPJKOxZSWOLEzNIqorxihmH7DX20/QiFvEZbw/oXY
        OgeIexMwwdPL7Ar5aOK9UdWOWoTzXsiVY82r9FG3pokzhelvGsYqgUssOYcpmM2i0t7DnD
        GX2/D6kcUnlioYNtT4iC4Q0Fdivl1jU=
Content-Disposition: inline
In-Reply-To: <20191218173516.7875-3-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org

On 12/18, Christian Brauner wrote:
>
> This adds support for creating a process in a different cgroup than its
> parent.

Cough... I will not comment the intent ;) I can't review the cgroup patches
anyway.

However,

> +int cgroup_lock_fork(struct kernel_clone_args *kargs)
> +	__acquires(&cgroup_mutex)
> +{
> +	struct cgroup *cgrp;
> +
> +	if (!(kargs->flags & CLONE_INTO_CGROUP))
> +		return 0;
> +
> +	cgrp = kargs->cgrp;
> +	if (!cgrp)
> +		return 0;
> +
> +	mutex_lock(&cgroup_mutex);
> +
> +	if (!cgroup_is_dead(cgrp))
> +		return 0;
> +
> +	mutex_unlock(&cgroup_mutex);
> +	return -ENODEV;

...

> @@ -2172,7 +2172,7 @@ static __latent_entropy struct task_struct *copy_process(
>  	 * between here and cgroup_post_fork() if an organisation operation is in
>  	 * progress.
>  	 */
> -	retval = cgroup_can_fork(p);
> +	retval = cgroup_can_fork(current, p, args);
>  	if (retval)
>  		goto bad_fork_cgroup_threadgroup_change_end;
>  
> @@ -2226,6 +2226,10 @@ static __latent_entropy struct task_struct *copy_process(
>  		goto bad_fork_cancel_cgroup;
>  	}
>  
> +	retval = cgroup_lock_fork(args);

mutex_lock() under spin_lock() ??


just in case, note that mutex_lock(&cgroup_mutex) is not safe even under
cgroup_threadgroup_change_begin(), this can deadlock.

Oleg.

