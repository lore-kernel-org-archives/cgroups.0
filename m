From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 12:46:24 -0700
Message-ID: <CALAqxLWQ8hwWyzfUWnXY+oTssqTqyGenbbVFzJ7gzgu-7gWNgg@mail.gmail.com>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <20161004161630.GC4205@htj.duckdns.org> <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
 <20161004193838.GH4205@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2gXfiZ7YPB1wN0NASFQ3SmkNxQh10PQxflUU878RWGk=;
        b=WpFl7KXK+VxaWc8pA0Po3+73hkrnUTM14ibMF2hcweETDFKv+Fhz7CP0SVW2nnXyUC
         xAOnS3kgo8nVI3hXZASttfm1LTb4jD+ONNMsss+nPvUX/kyQi1+PSIEv+g03859JMYFZ
         9oLJd8PHxcyTua3gz0/R9BnYz8LMJPhhp9z7o=
In-Reply-To: <20161004193838.GH4205-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Oct 4, 2016 at 12:38 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, John.
>
> On Tue, Oct 04, 2016 at 11:01:12AM -0700, John Stultz wrote:
>> So to make sure I understand your suggestion, you're suggesting the
>> cgroupfs files like:
>> cpuctrl/tasks,
>> cpuctrl/bg_non_interactive/tasks,
>> cpuset/foreground/tasks,
>> cpuset/background/tasks,
>> etc
>> use ACL permissions to specify the specific uids that can write to
>> them? I guess this would be conceptually similar to just setting the
>> owner to the system task, no?  Though I'm not sure that would be
>
> Yeah, finer grained but essentially just giving write perms.
>
>> sufficient since it would still fail the
>> cgroup_procs_write_permission() checks. Or are you suggesting we add
>> extra logic to make the file owner uid as sufficient to change other
>> tasks?
>
> Hah, now I'm not sure how this is supposed to work inside a userns as
> it's checking against GLOBAL_ROOT_UID.  cc'ing Serge.  Serge, can you
> please have a look?
>
> But back on subject, yeah, I think a capability based approach is
> better here too.  No idea how difficult it is to add a new CAP but I
> think it's worth trying.  Can you please spin up a patch?

Ok. I'll respin this introducing and using a new CAP value.

That said, while CAP_SYS_NICE seems a bit overloaded here, it doesn't
conceptually have that much friction for use with cpuset and cpuctrl
cgroups:

(from the man page: http://man7.org/linux/man-pages/man7/capabilities.7.html )
CAP_SYS_NICE
* Raise process nice value (nice(2), setpriority(2)) and
   change the nice value for arbitrary processes;
* set real-time scheduling policies for calling process, and
  set scheduling policies and priorities for arbitrary
  processes (sched_setscheduler(2), sched_setparam(2),
  shed_setattr(2));
* set CPU affinity for arbitrary processes
  (sched_setaffinity(2));
* set I/O scheduling class and priority for arbitrary
  processes (ioprio_set(2));
* apply migrate_pages(2) to arbitrary processes and allow
   processes to be migrated to arbitrary nodes;
* apply move_pages(2) to arbitrary processes;
* use the MPOL_MF_MOVE_ALL flag with mbind(2) and
  move_pages(2).

If you can tweak nice value and set realtime scheduling policy that
really seems to me just as invasive as what moving tasks between the
cpuctrl and cpuset cgroups could do.

thanks
-john
