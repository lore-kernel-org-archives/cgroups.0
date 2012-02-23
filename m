From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Thu, 23 Feb 2012 15:59:44 +0800
Message-ID: <4F45F1F0.2010102@cn.fujitsu.com>
References: <20120221211938.GE12236@google.com> <20120222163858.GB4128@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120222163858.GB4128-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> Trying to make all the controllers uniform in terms of their treatment
> of cgroup hiearchy sounds like a good thing to do.

Agreed.

Apart from nesting cgroups, there're other inconsistencies.

- Some controllers disallow more than one cgroup layer. That's the new
net_prio controller, and I don't know why it's made so, but I guess
it's fine to eliminate this restriction.

- Some controllers move resource charges when a task is moved to
a different cgroup, but some don't?

- Some controllers disallow task attaching under some circumstances.
So if we have a single hierarchy with all subsystems, the chance
that attaching a task to a cgroup fails may be bigger.

> Once that is done,
> one can probably see if it is worth to put all the controllers in a
> single hierarchy.
> 
