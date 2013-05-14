From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Date: Tue, 14 May 2013 11:51:11 -0400
Message-ID: <20130514155111.GJ680@redhat.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20130514150539.GA26090@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130514150539.GA26090@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, amorgan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 14, 2013 at 10:05:39AM -0500, Serge Hallyn wrote:
> so now that the device cgroup properly respects hierarchy, not allowing
> a cgroup to be given greater permission than its parent, should we consider
> relaxing the capability checks?
> 
> There are two capable(CAP_SYS_ADMIN) checks in deice_cgroup.c: one in
> devcgroup_can_attach() to protect changing another task's cgroup, and
> one in devcgroup_update_access() to protect writes to the devices.allow
> and devices.deny files.
> 
> I think the first should be changed to a check for ns_capable() to
> the victim's user_ns.  Something like 
> 
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -70,10 +70,16 @@ static int devcgroup_can_attach(struct cgroup *new_cgrp,
>                                 struct cgroup_taskset *set)
>  {
>         struct task_struct *task = cgroup_taskset_first(set);
> +       struct user_namespace *ns;
> +       int ret = -EPERM;
> 
> -       if (current != task && !capable(CAP_SYS_ADMIN))
> -               return -EPERM;
> -       return 0;
> +       if (current == task)
> +               return 0;
> +
> +       ns = userns_get(task);;
> +       ret = ns_capable(ns, CAP_SYS_ADMIN) ? 0 : -EPERM;
> +       put_user_ns(ns);
> +       return ret;
>  }

wouldn't this allow a userns root to move a task in the same userns into
a parent cgroup? I believe than anything but moving down the hierarchy
would be very complicated to verify (how far up can you go).

> For the second, the hierarchy support should let us ignore concerns
> about unprivileged users escalating privilege, but I'm trying to decide
> whether we  need to worry about the sendmail capability class of bugs.

You have a pointer for more information on those?

> My sense is actually the answer is no, and we can drop the capable()
> check altogether.  The reason is that while userspace frequently doesn't
> properly handle a failing system call due to unexpected lack of partial
> privilege, I wouldn't expect any setuid root program to ignore failure
> to open or mknod a device file (and proceed into a bad failure mode).
> Does this sound rasonable, or a recipe for disaster?

The second case sounds ok to me

-- 
Aristeu
