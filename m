From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 18:11:05 -0500
Message-ID: <20150228231105.GA24266@phnom.home.cmpxchg.org>
References: <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org>
 <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
 <20150227214904.GQ3964@htj.duckdns.org>
 <CAAAKZwsCc8BtFx58KMFpRTohU81oCBeGVOPGMJrjJt9q5upKfQ@mail.gmail.com>
 <20150228165706.GS3964@htj.duckdns.org>
 <CAAAKZwv=idxvrffHx2QyW=PGH4k42ckq-VLJGQrXkeQ6NmByRQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAAKZwv=idxvrffHx2QyW=PGH4k42ckq-VLJGQrXkeQ6NmByRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, richard <richard-/L3Ra7n9ekc@public.gmane.org>, mingo <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Feb 28, 2015 at 02:26:58PM -0800, Tim Hockin wrote:
> On Sat, Feb 28, 2015 at 8:57 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Sat, Feb 28, 2015 at 08:48:12AM -0800, Tim Hockin wrote:
> > > I am sorry that real-user problems are not perceived as substantial.  This
> > > was/is a real issue for us.  Being in limbo for years on end might not be a
> > > technical point, but I do think it matters, and that was my point.
> >
> > It's a problem which is localized to you and caused by the specific
> > problems of your setup.  This isn't a wide-spread problem at all and
> > the world doesn't revolve around you.  If your setup is so messed up
> > as to require sticking to 16bit pids, handle that locally.  If
> > something at larger scale eases that handling, you get lucky.  If not,
> > it's *your* predicament to deal with.  The rest of the world doesn't
> > exist to wipe your ass.
> 
> Wow, so much anger.

Yeah, quite surprising after such an intellectually honest discussion:

: On Fri, Feb 27, 2015 at 01:45:09PM -0800, Tim Hockin wrote:
: > At least 3 or 4 people have INDEPENDENTLY decided this is what is
: > causing them pain and tried to fix it and invested the time to send a
: > patch says that it is actually a thing.  There exists a problem that
: > you are disallowing to be fixed.  Do you recognize that users are
: > experiencing pain?  Why do you hate your users? :)

[...]

: > Are you willing to put a drop-dead date on it?  If we don't have
: > kmemcg working well enough to _actually_ bound PID usage and FD usage
: > by, say, June 1st, will you then accept a patch to this effect?  If
: > the answer is no, then I have zero faith that it's coming any time
: > soon - I heard this 2 years ago.  I believed you then.

> I'm not even sure how to respond, so I'll just say this and sign
> off.  All I want is a better, friendlier, more useful system
> overall.  We clearly have different ways of looking at the problem.

Overlapping features and inconsistent userspace interfaces are only
better for the people that pick the hacks.  They are the opposite of
friendly and useful.  They are also horrible to maintain, which could
be a reason why you constantly disagree with the people that cleaned
up this unholy mess and are now trying to keep a balance between your
short term interests and the long-term health of the Linux kernel.
