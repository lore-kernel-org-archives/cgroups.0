From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Thu, 1 Mar 2012 16:02:13 -0500
Message-ID: <20120301210213.GF13533@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com>
 <1329990094.24994.64.camel@twins>
 <1330006399.11248.20.camel@twins>
 <4F4FAF89.3090706@redhat.com>
 <1330633603.7414.49.camel@marge.simpson.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1330633603.7414.49.camel-YqMYhexLQo31wTEvPJ5Q0F6hYfS7NtTn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>
Cc: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Mar 01, 2012 at 09:26:43PM +0100, Mike Galbraith wrote:
> On Thu, 2012-03-01 at 18:19 +0100, Michal Schmidt wrote: 
> > Dne 23.2.2012 15:13, Peter Zijlstra napsal:
> > > My utter disregard for cgroups comes from having to actually implement a
> > > controller for them, its a frigging nightmare. The systemd retards
> > > mandating all this nonsense for booting a machine is completely bonghit
> > > inspired and hasn't made me feel any better about it.
> > 
> > systemd requires only CONFIG_CGROUPS=y. It does not need any controllers.
> > 
> > The insults are entirely unnecessary.
> 
> At the risk of insulting any systemd person, I recently upgraded my box,
> and had my very first encounter with systemd.  It didn't go well at all,
> to say the very least.  In fact, it quickly became a violent removal.
> 
> After the fact, when I queried, I was told straight out that I should
> live in harmony with the cgroups configuration systemd set up for me and
> be happy.  For the nonce, you can remove it, and here's how (thanks for
> that guys), but that removal option is _going_ to go away.  No, you
> can't simply turn our cgroup setup off and control your box as if you
> actually _own_ the thing, because cgroups is an integral part of the
> systemd concept.
> 
> Really.  I hope that was idiotic fanboy tripe, because that flat ain't
> gonna happen here, ever.
> 
> Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
> over sysvinits job afaiui, what does that have to do with cgroups?

I think they were using it to track all the children forked by a service
and cleanup all of them if need be. So they just need it for logical
grouping functionality and don't require any controllers as such.

Thanks
Vivek
