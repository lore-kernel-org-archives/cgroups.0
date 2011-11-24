From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 0/8] mm: memcg fixlets for 3.3
Date: Thu, 24 Nov 2011 10:45:32 +0100
Message-ID: <20111124094532.GF6843@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <CAKTCnzk0Jzq+o1Qv9hOO5ssO7U_xe1ZqUaWDhWEeJAQQPjPudg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKTCnzk0Jzq+o1Qv9hOO5ssO7U_xe1ZqUaWDhWEeJAQQPjPudg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 24, 2011 at 11:39:39AM +0530, Balbir Singh wrote:
> On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>=
 wrote:
> >
> > Here are some minor memcg-related cleanups and optimizations, nothi=
ng
> > too exciting. =A0The bulk of the diffstat comes from renaming the
> > remaining variables to describe a (struct mem_cgroup *) to "memcg".
> > The rest cuts down on the (un)charge fastpaths, as people start to =
get
> > annoyed by those functions showing up in the profiles of their thei=
r
> > non-memcg workloads. =A0More is to come, but I wanted to get the mo=
re
> > obvious bits out of the way.
>=20
> Hi, Johannes
>=20
> The renaming was a separate patch sent from Raghavendra as well, not
> sure if you've seen it.

I did and they are already in -mm, but unless I miss something, those
were only for memcontrol.[ch].  My patch is for the rest of mm.

> What tests are you using to test these patches?

I usually run concurrent kernbench jobs in separate memcgs as a smoke
test with these tools:

	http://git.cmpxchg.org/?p=3Dstatutils.git;a=3Dsummary

"runtest" takes a job-spec file that looks a bit like RPM spec to
define works with preparation and cleanup phases, and data collectors.
The memcg kernbench job I use is in the examples directory.  You just
need to put separate kernel source directories into place (linux-`seq
-w 04`) and then launch it like this:

	runtest -s memcg-kernbench.load `uname -r`

which will run the test and collect memory.stat of the parent memcg
every second, which you can then further evaluate with the other
tools:

	readdict < `uname -r`-memory.stat.data | columns 14 15 | plot

for example, where readdict translates the "key value" lines of
memory.stat into tables where each value is on its own row.  Columns
14 and 15 are total_cache and total_rss (find out with cat -n -- yeah,
still a bit rough).  You need python-matplotlib for plot to work.

Multiple runs can be collected into the same logfiles and then fold
ever-increasing counters with the "events" tool.  For example, to find
the average fault count, you would do something like this (19 =3D
total_pgfault, 20 =3D total_pgmajfault):

	for x in `seq 10`; do runtest -s foo.load foo`; done
	readdict < foo-memory.stat.data | columns 19 20 | events | mean -s

Oh, and workload runtime is always recorded in NAME.time, so

	events < `uname -r`.time

gives you the timings of each run, which you can then further process
with "mean" or "median" again.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
