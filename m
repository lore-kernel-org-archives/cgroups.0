From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Tue, 19 May 2015 12:56:31 +0200
Message-ID: <20150519105631.GH19282@twins.programming.kicks-ass.net>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-9-git-send-email-cyphar@cyphar.com>
 <20150519080055.GA3644@twins.programming.kicks-ass.net>
 <CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On Tue, May 19, 2015 at 06:44:39PM +1000, Aleksa Sarai wrote:
> >> However, it should be noted that organisational operations (adding and
> >> removing tasks from a PIDs hierarchy) will *not* be prevented.
> >
> > This is how you spell: broken controller.
> 
> This has been discussed before. Organisational operations (i.e.
> attaching to a cgroup) are not to be blocked by a cgroup controller in
> the unified hierarchy. 

That's utterly insane. As argued at length in threads like:

  lkml.kernel.org/r/alpine.DEB.2.11.1505061100040.4225@nanos

This breaks fundamental control rules and makes life for a number of
controllers impossible.

Also, I'll NAK each and every patch that will attempt to remove failing
can_attach from the cgroup core as it will fundamentally break some
scheduler controllers.

So please use it, it doesn't make any bloody sense to 'control' the
number of PIDs but then allow it to overrun the set point.
