From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Tue, 26 Jul 2022 13:14:09 -1000
Message-ID: <YuB1QW6Kce5nkBu6@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
 <YtwFjPnCtw8ySnuv@slm.duckdns.org>
 <20220725121208.GB28662@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=dENzbJt1guxesUSDXfqIuUH8HSBp0gL0djmYPEroaFo=;
        b=T4rpXUuAvUynX4msd8KQnGEVJFSRIl5nzM/D3tRhWXKZc4ZJ5DUwfEC9QgGv/5xjXW
         E6OAd6kkjYfFhdUM30igCr8XSn8lYDFiONlfDj4/9doWZZTUYYHQEFax0ApOkxFlS65z
         wqNL2mruoIffrmifwfHPILKEt769Nsp3IR0YSnkklSM9ptR2euVO7k2KtnqRz4cax2I1
         LTIuhLlQcq3TJ4TeDbr9kEK73CSVnQNNBWpbttRTpZP7j0kMtWJ0iii+mbTiJwSsGp4Z
         L5iscMqS/X8AZMaWDLqzWPsVAPMNdg4ZXBTwTOe49qOCsiwF9J28bxOMs76GMwM7wn2q
         IVIw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220725121208.GB28662-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <onestero-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Oleg.

On Mon, Jul 25, 2022 at 02:12:09PM +0200, Oleg Nesterov wrote:
> I see no problems in this patch. But just for record, we do not need
> synchronize_rcu() in the "favor && !favoring" case, so we cab probably
> do something like
> 
> 	@@ -146,13 +146,20 @@ void rcu_sync_enter(struct rcu_sync *rsp)
> 			 * See the comment above, this simply does the "synchronous"
> 			 * call_rcu(rcu_sync_func) which does GP_ENTER -> GP_PASSED.
> 			 */
> 	+		if (wait) {
> 	+			synchronize_rcu();
> 	+			rcu_sync_func(&rsp->cb_head);
> 	+		} else {
> 	+			rcu_sync_call(rsp);
> 	+		}
> 	+	} else if (wait) {
> 	+		wait_event(rsp->gp_wait, READ_ONCE(rsp->gp_state) >= GP_PASSED);
...
> later.
> 
> __rcu_sync_enter(rsp, false) works just like rcu_sync_enter_start() but it can
> be safely called at any moment.

Yeah, I originally used rcu_sync_enter_start() but quickly found out that it
can't be reverted reliably. Given how cold the option switching path is, I
think it's fine to pay an extra synchronize_rcu() there rather than adding
more complexity to rcu_sync_enter() unless this will be useful somewhere
else too.

> And can't resist, off-topic question... Say, cgroup_attach_task_all() does
> 
> 	mutex_lock(&cgroup_mutex);
> 	percpu_down_write(&cgroup_threadgroup_rwsem);
> 
> and this means that synchronize_rcu() can be called with cgroup_mutex held.
> Perhaps it makes sense to change this code to do
> 
> 	rcu_sync_enter(&cgroup_threadgroup_rwsem.rss);
> 	mutex_lock(&cgroup_mutex);
> 	percpu_down_write(&cgroup_threadgroup_rwsem);
> 	...
> 	percpu_up_write(&cgroup_threadgroup_rwsem);
> 	mutex_unlock(&cgroup_mutex);
> 	rcu_sync_exit(&cgroup_threadgroup_rwsem.rss);
> 
> ? Just curious.

I'm not quite following. Are you saying that if we switching the rwsem into
slow mode before grabbing the locks, we can avoid inducing latencies on
other users? Hmm... assuming that I'm understanding you correctly, one
problem with that approach is that everyone would be doing synchronize_rcu()
whether they want to change favoring state. In vast majority of cases, users
won't care about this flag but most users will end up mounting cgroup and do
the rcu_sync_enter(), so we'd end up adding a grace period wait in most boot
scenarios. It's not a lot in itself but seems less desriable than making the
users who want to change the mode pay at the time of changing.

> > -	/*
> > -	 * The latency of the synchronize_rcu() is too high for cgroups,
> > -	 * avoid it at the cost of forcing all readers into the slow path.
> > -	 */
> > -	rcu_sync_enter_start(&cgroup_threadgroup_rwsem.rss);
> 
> Note that it doesn't have other users, probably you can kill it.

Ah, nice, will do that.

Thanks.

-- 
tejun
