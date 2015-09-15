From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: always enable kmemcg on the default hierarchy
Date: Tue, 15 Sep 2015 11:20:25 +0200
Message-ID: <20150915092025.GA6812@cmpxchg.org>
References: <20150828220158.GD11089@htj.dyndns.org>
 <20150828220237.GE11089@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828220237.GE11089-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Aug 28, 2015 at 06:02:37PM -0400, Tejun Heo wrote:
> On the default hierarchy, all memory consumption will be accounted
> together and controlled by the same set of limits.  Enable kmemcg on
> the default hierarchy by default.  Boot parameter "disable_kmemcg" can
> be specified to turn it off.
> 
> v2: - v1 triggered oops on nested cgroup creations.  Moved enabling
>       mechanism to memcg_propagate_kmem().
>     - Bypass busy test on kmem activation as it's unnecessary and gets
>       confused by controller being enabled on a cgroup which already
>       has processes.
>     - "disable_kmemcg" boot param added.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The old distinction between kernel and user memory really doesn't make
sense and should not be maintained. The dentry and inode caches are a
significant share of overall memory consumed in common workloads, and
that is memory unambiguously coupled to userspace activity. I'd go as
far as removing CONFIG_MEMCG_KMEM altogether because it strikes me as
a completely unreasonable choice to give to the user (outside of maybe
CONFIG_EXPERT).

What CONFIG_MEMCG should really capture is all memory that can grow
significantly in size and can be associated directly with userspace
behavior. If there are types of memory that turn out to be very costly
to account and track, we can still go back and conceive an interface
that lets the user select the types of memory he doesn't need tracked.

But the KMEMCG differentation is an arbitrary, and mostly historical
distinction that we shouldn't continue to present to users.
