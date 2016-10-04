From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 15:18:40 -0500
Message-ID: <20161004201840.GA27018@mail.hallyn.com>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <20161004161630.GC4205@htj.duckdns.org>
 <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
 <20161004193838.GH4205@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161004193838.GH4205-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello, John.
> 
> On Tue, Oct 04, 2016 at 11:01:12AM -0700, John Stultz wrote:
> > So to make sure I understand your suggestion, you're suggesting the
> > cgroupfs files like:
> > cpuctrl/tasks,
> > cpuctrl/bg_non_interactive/tasks,
> > cpuset/foreground/tasks,
> > cpuset/background/tasks,
> > etc
> > use ACL permissions to specify the specific uids that can write to
> > them? I guess this would be conceptually similar to just setting the
> > owner to the system task, no?  Though I'm not sure that would be
> 
> Yeah, finer grained but essentially just giving write perms.
> 
> > sufficient since it would still fail the
> > cgroup_procs_write_permission() checks. Or are you suggesting we add
> > extra logic to make the file owner uid as sufficient to change other
> > tasks?
> 
> Hah, now I'm not sure how this is supposed to work inside a userns as
> it's checking against GLOBAL_ROOT_UID.  cc'ing Serge.  Serge, can you
> please have a look?

Hi, thanks for the cc,

how about changing the GLOBAL_ROOT_UID check with a targeted
capability check, like

	if (!ns_capable(tcred->user_ns, CAP_SYS_NICE) &&
            !uid_eq(cred->euid, tcred->uid) &&
            !uid_eq(cred->euid, tcred->suid))
		ret = -EACCES;

where the actual capability to use may require some thought.


> But back on subject, yeah, I think a capability based approach is
> better here too.  No idea how difficult it is to add a new CAP but I
> think it's worth trying.  Can you please spin up a patch?
> 
> Thanks!
> 
> -- 
> tejun
