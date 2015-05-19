From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Tue, 19 May 2015 15:11:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505191508530.4225@nanos>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com> <1431960667-26593-9-git-send-email-cyphar@cyphar.com> <20150519080055.GA3644@twins.programming.kicks-ass.net> <CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 19 May 2015, Aleksa Sarai wrote:

> >> However, it should be noted that organisational operations (adding and
> >> removing tasks from a PIDs hierarchy) will *not* be prevented.
> >
> > This is how you spell: broken controller.
> 
> This has been discussed before. Organisational operations (i.e.
> attaching to a cgroup) are not to be blocked by a cgroup controller in
> the unified hierarchy. You simply can't escape out of a parent
> cgroup's limit through attaching to a child cgroup (because you will
> attach either before the fork checks against the cgroup [in which case
> the child's limit is followed -- which means you also follow the
> parent's limit] or after it checks [which means you'll hit the
> parent's limit and won't be able to fork]).

That's complete and utter nonsense. What has the parent limit to do
with the overflow of the child limit?

parent:	 limit 100   usecnt 80
child:	 limit 10    usecnt 10

So moving anything into child is violating the constraints and has to
be refused. Anything else is just dirty hackery.

Thanks,

	tglx



