From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Date: Wed, 15 May 2013 20:14:01 -0500
Message-ID: <20130516011401.GA17462@austin.hallyn.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20130514150539.GA26090@sergelap>
 <20130514155111.GJ680@redhat.com>
 <20130514162238.GA9056@sergelap>
 <87y5bhwa0h.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87y5bhwa0h.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amorgan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> >> On Tue, May 14, 2013 at 10:05:39AM -0500, Serge Hallyn wrote:
> >> > so now that the device cgroup properly respects hierarchy, not allowing
> >> > a cgroup to be given greater permission than its parent, should we consider
> >> > relaxing the capability checks?
> >> > 
> >> > There are two capable(CAP_SYS_ADMIN) checks in deice_cgroup.c: one in
> >> > devcgroup_can_attach() to protect changing another task's cgroup, and
> >> > one in devcgroup_update_access() to protect writes to the devices.allow
> >> > and devices.deny files.
> >> > 
> >> > I think the first should be changed to a check for ns_capable() to
> >> > the victim's user_ns.  Something like 
> >> > 
> >> > --- a/security/device_cgroup.c
> >> > +++ b/security/device_cgroup.c
> >> > @@ -70,10 +70,16 @@ static int devcgroup_can_attach(struct cgroup *new_cgrp,
> >> >                                 struct cgroup_taskset *set)
> >> >  {
> >> >         struct task_struct *task = cgroup_taskset_first(set);
> >> > +       struct user_namespace *ns;
> >> > +       int ret = -EPERM;
> >> > 
> >> > -       if (current != task && !capable(CAP_SYS_ADMIN))
> >> > -               return -EPERM;
> >> > -       return 0;
> >> > +       if (current == task)
> >> > +               return 0;
> >> > +
> >> > +       ns = userns_get(task);;
> >> > +       ret = ns_capable(ns, CAP_SYS_ADMIN) ? 0 : -EPERM;
> >> > +       put_user_ns(ns);
> >> > +       return ret;
> >> >  }
> >> 
> >> wouldn't this allow a userns root to move a task in the same userns into
> >> a parent cgroup? I believe than anything but moving down the hierarchy
> >> would be very complicated to verify (how far up can you go).
> >
> > But only if they are able to open the tasks file for writing, which
> > they shouldn't be able to do, right?
> 
> That should be looked at very closely.  There are some funny exploits of
> setuid root applications writing to files that have required some
> additional permission checks on /proc/<pid>/uid_map.  I think the
> cgroups files may be vulnerable to some of the same kind of exploits.
> 
> Certainly we should be verifying that the opener of the file had the
> capabilities we are trying to use to avoid being open to those kinds of
> problems.
> 
> I am trying to see the utilitity of the proposed patch.  It doesn't
> allow mknod.  So what is the benefit of having the user namespace bits?

I'm still thinking through it, which is why I haven't sent a real
patch.  What I'm working on is the unprivileged startup of a container.
Right now most things are not allowed in a private user ns, so device
cgroup is not as useful.  But it should be possible eventually to use
block devices, which the original unprivileged user owned, by chowning
the blockdev to a user mapped into the target userns.

The unprivileged user may want to use devices cgroup so he can chown
the loop file into the container, but only allow read-only mounts, for
instance.

> Is the point to allow the userns root to remove access to selected
> devices from it's children even if the DAC permissions would allow the
> access?

Yes I think that's it - except userns root before forking the container
init (and venturing into the really untrusted category).

...

> That said I haven't looked at open or mknod, and usually we are talking
> about calls that aren't made by suid apps so I think there is a fair
> chance that dropping some of those permissions could cause issues.
> The first danger that crosses my mind is what happens if you remove
> access to /dev/tty from a normal application that would trying and log
> strange goings on to a user if they could.

If they were going to do that over tty, that would be to the malicious
user anyway, so that should just either be ignored, or result in the
program exiting early.

> Shrug mostly I don't see the advantage of this change.

It's also possible that this will end up being worked around by the new
(not-yet-designed) interface/library which Tejun wants people to use,
sitting above the cgroupfs.  At least at a first layer.

Anyway this isn't urgent, as it's not in the way for general unprivileged
container creation.  But in general if we don't need the check to be
capable(), it would be better to introduce the right check.

-serge
