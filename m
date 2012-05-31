From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Thu, 31 May 2012 09:57:18 +0200
Message-ID: <20120531075718.GB1371@cmpxchg.org>
References: <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
 <4FC70355.70805@jp.fujitsu.com>
 <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com>
 <4FC70E5E.1010003@gmail.com>
 <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com>
 <4FC711A5.4090003@gmail.com>
 <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp.google.com>
 <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fWKw@mail.gmail.com>
 <alpine.DEB.2.00.1205310028420.8864@chino.kir.corp.google.com>
 <4FC720EE.3010307@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FC720EE.3010307-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, May 31, 2012 at 03:42:38AM -0400, KOSAKI Motohiro wrote:
> (5/31/12 3:35 AM), David Rientjes wrote:
> >On Thu, 31 May 2012, KOSAKI Motohiro wrote:
> >
> >>>As I said, LXC and namespace isolation is a tangent to the discussion of
> >>>faking the /proc/meminfo for the memcg context of a thread.
> >>
> >>Because of, /proc/meminfo affect a lot of libraries behavior. So, it's not only
> >>application issue. If you can't rewrite _all_ of userland assets, fake meminfo
> >>can't be escaped. Again see alternative container implementation.
> >>
> >
> >It's a tangent because it isn't a complete psuedo /proc/meminfo for all
> >threads attached to a memcg regardless of any namespace isolation; the LXC
> >solution has existed for a couple of years by its procfs patchset that
> >overlaps procfs with fuse and can suppress or modify any output in the
> >context of a memory controller using things like
> >memory.{limit,usage}_in_bytes.  I'm sure all other fields could be
> >modified if outputted in some structured way via memcg; it looks like
> >memory.stat would need to be extended to provide that.  If that's mounted
> >prior to executing the application, then your isolation is achieved and
> >all libraries should see the new output that you've defined in LXC.
> >
> >However, this seems like a seperate topic than the patch at hand which
> >does this directly to /proc/meminfo based on a thread's memcg context,
> >that's the part that I'm nacking.
> 
> Then, I NAKed current patch too. Yeah, current one is ugly. It assume _all_
> user need namespace isolation and it clearly is not.

Actually, it only chooses the memcg version for tasks that are not in
the init pid namespace.  Tying this to the pid namespace is a bit
ugly, but would probably end up doing the right thing most of the
time.  A separate namespace would be better.
