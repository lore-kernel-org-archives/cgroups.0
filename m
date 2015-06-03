From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Wed, 3 Jun 2015 12:44:10 +1000
Message-ID: <CAOviyaiDnL_xKTk4Zgde59LP7=CHxRxM4KSWGbHX11Xc=utcJA@mail.gmail.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
	<1431960667-26593-9-git-send-email-cyphar@cyphar.com>
	<20150519080055.GA3644@twins.programming.kicks-ass.net>
	<CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA@mail.gmail.com>
	<alpine.DEB.2.11.1505191508530.4225@nanos>
	<CAOviyaiwGQZbA8w_TV0wXF7JaQK1LHGn8BC40R7ARR+mHHQf=Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOviyaiwGQZbA8w_TV0wXF7JaQK1LHGn8BC40R7ARR+mHHQf=Q@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>> That's complete and utter nonsense. What has the parent limit to do
>> with the overflow of the child limit?

I didn't read this sentence properly. It's because you're migrating
*from* the parent to the child. If you have the right to attach to the
child from the parent, then you also have the right to change the
limit of the child.

--
Aleksa Sarai (cyphar)
www.cyphar.com
