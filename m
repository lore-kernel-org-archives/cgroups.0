From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 16:26:43 -0500
Message-ID: <20161004212643.GA27842@mail.hallyn.com>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <20161004161630.GC4205@htj.duckdns.org>
 <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
 <20161004193838.GH4205@htj.duckdns.org>
 <20161004201840.GA27018@mail.hallyn.com>
 <20161004203301.GK4205@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161004203301.GK4205-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello, Serge.
> 
> On Tue, Oct 04, 2016 at 03:18:40PM -0500, Serge E. Hallyn wrote:
> > how about changing the GLOBAL_ROOT_UID check with a targeted
> > capability check, like
> > 
> > 	if (!ns_capable(tcred->user_ns, CAP_SYS_NICE) &&
> >             !uid_eq(cred->euid, tcred->uid) &&
> >             !uid_eq(cred->euid, tcred->suid))
> > 		ret = -EACCES;
> > 
> > where the actual capability to use may require some thought.
> 
> Yeah, that's the direction I'm thinking too.  We can't use
> CAP_SYS_NICE in general tho.  Let's see if a dedicated CAP sticks.

One possibility would be to let each cgroup subsystem define
a move_caps capability mask which is required over the target
task.  And add a new CAP_CGROUP which always suffices?
