From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RESEND 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Wed, 27 Jul 2022 19:39:08 +0200
Message-ID: <20220727173906.GB18822@redhat.com>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
 <YtwFjPnCtw8ySnuv@slm.duckdns.org>
 <20220725121208.GB28662@redhat.com>
 <YuB1QW6Kce5nkBu6@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658943554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5b5gVej4MQa9hZ7l9p+CF9FxGIX65gr66TPXFnDVek=;
        b=bSz4tKA60k+kphl1rQUIu1Lh1Ef+HRW6vu5ylVOYwsu0I4HVOmhefy96Of3cQ0zXqIYXYv
        sDn8zikyijlJwC1403jHSBVKUwDF0BMnFwIMwzbV/IIt7+t4wYWVjCJf5WbeFwlS/SZJBX
        W8Dckuoxt/hlgP1fRBjJb2fxP2UHegA=
Content-Disposition: inline
In-Reply-To: <YuB1QW6Kce5nkBu6@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Peter Zijlstra <peterz@infradead.org>, John Stultz <john.stultz@linaro.org>, Dmitry Shmidt <dimitrysh@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hi Tejun,

On 07/26, Tejun Heo wrote:
>
> > __rcu_sync_enter(rsp, false) works just like rcu_sync_enter_start() but it can
> > be safely called at any moment.
>
> Yeah, I originally used rcu_sync_enter_start() but quickly found out that it
> can't be reverted reliably. Given how cold the option switching path is, I
> think it's fine to pay an extra synchronize_rcu() there rather than adding
> more complexity to rcu_sync_enter() unless this will be useful somewhere
> else too.

Yes, agreed. As I said, this is just for record, so that I can find this (simple)
patch on lkml if we have another user of __rcu_sync_enter(rsp, bool wait).

> > And can't resist, off-topic question... Say, cgroup_attach_task_all() does
> >
> > 	mutex_lock(&cgroup_mutex);
> > 	percpu_down_write(&cgroup_threadgroup_rwsem);
> >
> > and this means that synchronize_rcu() can be called with cgroup_mutex held.
> > Perhaps it makes sense to change this code to do
> >
> > 	rcu_sync_enter(&cgroup_threadgroup_rwsem.rss);
> > 	mutex_lock(&cgroup_mutex);
> > 	percpu_down_write(&cgroup_threadgroup_rwsem);
> > 	...
> > 	percpu_up_write(&cgroup_threadgroup_rwsem);
> > 	mutex_unlock(&cgroup_mutex);
> > 	rcu_sync_exit(&cgroup_threadgroup_rwsem.rss);
> >
> > ? Just curious.
>
> I'm not quite following.

Me too ;)

> Are you saying that if we switching the rwsem into
> slow mode before grabbing the locks, we can avoid inducing latencies on
> other users?

Well yes, in that another mutex_lock(&cgroup_mutex) won't sleep until
synchronize_rcu() (called under cgroup_mutex) completes.

> Hmm... assuming that I'm understanding you correctly, one
> problem with that approach is that everyone would be doing synchronize_rcu()
> whether they want to change favoring state.

Hmm... I didn't mean the changing if favoring state... And in any case,
this won't cause any additional synchronize_rcu().

Nevermind, please forget, this probably makes no sense.

Oleg.

