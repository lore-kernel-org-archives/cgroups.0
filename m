From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Date: Tue, 14 May 2013 14:02:06 -0700
Message-ID: <87y5bhwa0h.fsf@xmission.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
	<20130514150539.GA26090@sergelap> <20130514155111.GJ680@redhat.com>
	<20130514162238.GA9056@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130514162238.GA9056@sergelap> (Serge Hallyn's message of "Tue,
	14 May 2013 11:22:38 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amorgan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:

> Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
>> On Tue, May 14, 2013 at 10:05:39AM -0500, Serge Hallyn wrote:
>> > so now that the device cgroup properly respects hierarchy, not allowing
>> > a cgroup to be given greater permission than its parent, should we consider
>> > relaxing the capability checks?
>> > 
>> > There are two capable(CAP_SYS_ADMIN) checks in deice_cgroup.c: one in
>> > devcgroup_can_attach() to protect changing another task's cgroup, and
>> > one in devcgroup_update_access() to protect writes to the devices.allow
>> > and devices.deny files.
>> > 
>> > I think the first should be changed to a check for ns_capable() to
>> > the victim's user_ns.  Something like 
>> > 
>> > --- a/security/device_cgroup.c
>> > +++ b/security/device_cgroup.c
>> > @@ -70,10 +70,16 @@ static int devcgroup_can_attach(struct cgroup *new_cgrp,
>> >                                 struct cgroup_taskset *set)
>> >  {
>> >         struct task_struct *task = cgroup_taskset_first(set);
>> > +       struct user_namespace *ns;
>> > +       int ret = -EPERM;
>> > 
>> > -       if (current != task && !capable(CAP_SYS_ADMIN))
>> > -               return -EPERM;
>> > -       return 0;
>> > +       if (current == task)
>> > +               return 0;
>> > +
>> > +       ns = userns_get(task);;
>> > +       ret = ns_capable(ns, CAP_SYS_ADMIN) ? 0 : -EPERM;
>> > +       put_user_ns(ns);
>> > +       return ret;
>> >  }
>> 
>> wouldn't this allow a userns root to move a task in the same userns into
>> a parent cgroup? I believe than anything but moving down the hierarchy
>> would be very complicated to verify (how far up can you go).
>
> But only if they are able to open the tasks file for writing, which
> they shouldn't be able to do, right?

That should be looked at very closely.  There are some funny exploits of
setuid root applications writing to files that have required some
additional permission checks on /proc/<pid>/uid_map.  I think the
cgroups files may be vulnerable to some of the same kind of exploits.

Certainly we should be verifying that the opener of the file had the
capabilities we are trying to use to avoid being open to those kinds of
problems.

I am trying to see the utilitity of the proposed patch.  It doesn't
allow mknod.  So what is the benefit of having the user namespace bits?

Is the point to allow the userns root to remove access to selected
devices from it's children even if the DAC permissions would allow the
access?

>> > For the second, the hierarchy support should let us ignore concerns
>> > about unprivileged users escalating privilege, but I'm trying to decide
>> > whether we  need to worry about the sendmail capability class of bugs.
>> 
>> You have a pointer for more information on those?
>
> Darn - unfortunately the best description of it, which was at
> http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html
> is no longer there since userweb was taken down, and it was never
> captured by archive.org.  There's a brief description in
> http://lwn.net/Articles/280279/ at the paragraph starting with "The
> memory of the sendmail-capabilities bug from 2000..."

I think the sendmail website has something as well.  The core problem
was programs not dealing safely with having some of their privileges
removed.  As I recall an unprivileged attacker at one point could drop
the CAP_SYS_SETUID on sendmail and get it to deliver mail as root.

I took a good hard look at this issue before implementing limits on
setuid in the user namespace and it appears that the authors of setuid
application learned from this as well and I could not find an single
program that would call setuid without out checking it's return code.

That said I haven't looked at open or mknod, and usually we are talking
about calls that aren't made by suid apps so I think there is a fair
chance that dropping some of those permissions could cause issues.

The first danger that crosses my mind is what happens if you remove
access to /dev/tty from a normal application that would trying and log
strange goings on to a user if they could.

Shrug mostly I don't see the advantage of this change.

Eric


>> > My sense is actually the answer is no, and we can drop the capable()
>> > check altogether.  The reason is that while userspace frequently doesn't
>> > properly handle a failing system call due to unexpected lack of partial
>> > privilege, I wouldn't expect any setuid root program to ignore failure
>> > to open or mknod a device file (and proceed into a bad failure mode).
>> > Does this sound rasonable, or a recipe for disaster?
>> 
>> The second case sounds ok to me
>
> -serge
