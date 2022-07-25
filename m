From: Oleg Nesterov <onestero-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Mon, 25 Jul 2022 14:12:09 +0200
Message-ID: <20220725121208.GB28662@redhat.com>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
 <YtwFjPnCtw8ySnuv@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658751134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uoeyod5zDB0ZJ1Q5JYhvmo5sNmJuhZfqcU+zHvGMHKo=;
        b=Nm9vqG6ljZFhyyrF4H4YRTdIVewd4hbLlIuXFi5IH39WTTR1pANzHjZPN1OSvLkEb3R1Ir
        le3sno7y7t0JrAGLUKs99evjRCKJY9zlwEzGtfUMxlWlZ8DM1jsmSLNpwty+4VFosrECSf
        YsdjJ2SkfeNjJCH0Oqafb9V9npDVVbw=
Content-Disposition: inline
In-Reply-To: <YtwFjPnCtw8ySnuv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/23, Tejun Heo wrote:
>
> +void cgroup_favor_dynmods(struct cgroup_root *root, bool favor)
> +{
> +	bool favoring = root->flags & CGRP_ROOT_FAVOR_DYNMODS;
> +
> +	/* see the comment above CGRP_ROOT_FAVOR_DYNMODS definition */
> +	if (favor && !favoring) {
> +		rcu_sync_enter(&cgroup_threadgroup_rwsem.rss);
> +		root->flags |= CGRP_ROOT_FAVOR_DYNMODS;
> +	} else if (!favor && favoring) {
> +		rcu_sync_exit(&cgroup_threadgroup_rwsem.rss);
> +		root->flags &= ~CGRP_ROOT_FAVOR_DYNMODS;
> +	}
> +}

I see no problems in this patch. But just for record, we do not need
synchronize_rcu() in the "favor && !favoring" case, so we cab probably
do something like

	--- a/kernel/rcu/sync.c
	+++ b/kernel/rcu/sync.c
	@@ -118,7 +118,7 @@ static void rcu_sync_func(struct rcu_head *rhp)
	  * optimize away the grace-period wait via a state machine implemented
	  * by rcu_sync_enter(), rcu_sync_exit(), and rcu_sync_func().
	  */
	-void rcu_sync_enter(struct rcu_sync *rsp)
	+void __rcu_sync_enter(struct rcu_sync *rsp, bool wait)
	 {
		int gp_state;
	 
	@@ -146,13 +146,20 @@ void rcu_sync_enter(struct rcu_sync *rsp)
			 * See the comment above, this simply does the "synchronous"
			 * call_rcu(rcu_sync_func) which does GP_ENTER -> GP_PASSED.
			 */
	-		synchronize_rcu();
	-		rcu_sync_func(&rsp->cb_head);
	-		/* Not really needed, wait_event() would see GP_PASSED. */
	-		return;
	+		if (wait) {
	+			synchronize_rcu();
	+			rcu_sync_func(&rsp->cb_head);
	+		} else {
	+			rcu_sync_call(rsp);
	+		}
	+	} else if (wait) {
	+		wait_event(rsp->gp_wait, READ_ONCE(rsp->gp_state) >= GP_PASSED);
		}
	+}
	 
	-	wait_event(rsp->gp_wait, READ_ONCE(rsp->gp_state) >= GP_PASSED);
	+void rcu_sync_enter(struct rcu_sync *rsp)
	+{
	+	__rcu_sync_enter(rsp, true);
	 }
	 
	 /**

later.

__rcu_sync_enter(rsp, false) works just like rcu_sync_enter_start() but it can
be safely called at any moment.

And can't resist, off-topic question... Say, cgroup_attach_task_all() does

	mutex_lock(&cgroup_mutex);
	percpu_down_write(&cgroup_threadgroup_rwsem);

and this means that synchronize_rcu() can be called with cgroup_mutex held.
Perhaps it makes sense to change this code to do

	rcu_sync_enter(&cgroup_threadgroup_rwsem.rss);
	mutex_lock(&cgroup_mutex);
	percpu_down_write(&cgroup_threadgroup_rwsem);
	...
	percpu_up_write(&cgroup_threadgroup_rwsem);
	mutex_unlock(&cgroup_mutex);
	rcu_sync_exit(&cgroup_threadgroup_rwsem.rss);

? Just curious.

> -	/*
> -	 * The latency of the synchronize_rcu() is too high for cgroups,
> -	 * avoid it at the cost of forcing all readers into the slow path.
> -	 */
> -	rcu_sync_enter_start(&cgroup_threadgroup_rwsem.rss);

Note that it doesn't have other users, probably you can kill it.

Oleg.

