From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] allow a task to join a pid namespace
Date: Mon, 4 Jun 2012 18:51:17 +0200
Message-ID: <20120604165117.GA13091@redhat.com>
References: <1338816828-25312-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1338816828-25312-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On 06/04, Glauber Costa wrote:
>
> Currently, it is possible for a process  to join existing
> net, uts and ipc namespaces. This patch allows a process to join an
> existing pid namespace as well.

I can't understand this patch... but probably I missed something,
I never really understood setns.

> +static int pidns_install(struct nsproxy *nsproxy, void *_ns)
> +{
> +	struct pid *newpid;
> +	struct pid_namespace *ns = _ns;
> +
> +	if (is_container_init(current))
> +		return -EINVAL;
> +
> +	if (nsproxy->pid_ns != ns->parent)
> +		return -EPERM;

At least you should also check that current is single-threaded,
I guess.

> +
> +	if (task_pgrp(current) !=  task_pid(current))
> +		return -EPERM;
> +
> +	if (task_session(current) !=  task_pid(current))
> +		return -EPERM;

Both checks are obviously racy without tasklist.

> +	newpid = alloc_pid(ns);
> +	if (!newpid)
> +		return -ENOMEM;

Hmm. Doesn't this mean that pid_nr of this task (as it seen
in its current namespace) will be changed? This doesn't look
sane.

> +	put_pid_ns(nsproxy->pid_ns);
> +	nsproxy->pid_ns = get_pid_ns(ns);
> +
> +	write_lock_irq(&tasklist_lock);
> +	change_pid(current, PIDTYPE_PID, newpid);
> +	change_pid(current, PIDTYPE_PGID, newpid);
> +	change_pid(current, PIDTYPE_SID, newpid);
> +	write_unlock_irq(&tasklist_lock);

Hmm. So, until the caller does switch_task_namespaces()
task_active_pid_ns(current) != current->nsproxy->pid_ns,
doesn't look very nice too.

I don't think this can be right. If nothing else, this breaks
it_real_fn().

Oleg.
