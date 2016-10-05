From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 4 Oct 2016 23:25:29 -0500
Message-ID: <20161005042529.GA30929@mail.hallyn.com>
References: <1475626874-22949-1-git-send-email-john.stultz@linaro.org>
 <20161005003833.GA29239@mail.hallyn.com>
 <CALAqxLU7qqKBVKO-bq_zKCUJqqvprNi8z5RpOb=Cec-VP=P4Yw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALAqxLU7qqKBVKO-bq_zKCUJqqvprNi8z5RpOb=Cec-VP=P4Yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Tue, Oct 04, 2016 at 08:00:18PM -0700, John Stultz wrote:
> On Tue, Oct 4, 2016 at 5:38 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting John Stultz (john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org):
> >> So this patch, as suggested by Tejun,  simply adds a new process
> >> capability flag (CAP_CGROUP_MIGRATE_TASK), and uses it when checking
> >
> > So realistically, what all can this mean?  Freezing tasks, changing
> > cpu/memory limits, changing network and disk throughput, forbid forking,
> > and (most importantly) forbid access to certain devices.
> >
> > I think that's all ok.  (And we still separately check for inode write
> > perms.)
> 
> Sounds good.
> 
> > If anything I'd say the GLOBAL_ROOT_UID check could be taken out since
> > otherwise a host-root task effectively cannot drop this capability.
> 
> Is this ok to leave for a separate patch?

Yeah.  And I'm not sure whether Tejun would object to that idea.

> > Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> 
> Thanks for the review!
> 
> Unless there's other feedback, I'll sit on this until the merge window
> is over and then resubmit for consideration for 4.10.
> 
> thanks
> -john
