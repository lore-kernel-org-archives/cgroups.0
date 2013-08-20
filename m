From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v5] Soft limit rework
Date: Tue, 20 Aug 2013 11:14:14 +0200
Message-ID: <20130820091414.GC31552@dhcp22.suse.cz>
References: <1371557387-22434-1-git-send-email-mhocko@suse.cz>
 <20130819163512.GB712@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130819163512.GB712-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon 19-08-13 12:35:12, Johannes Weiner wrote:
> On Tue, Jun 18, 2013 at 02:09:39PM +0200, Michal Hocko wrote:
> > Hi,
> > 
> > This is the fifth version of the patchset.
> > 
> > Summary of versions:
> > The first version has been posted here: http://permalink.gmane.org/gmane.linux.kernel.mm/97973
> > (lkml wasn't CCed at the time so I cannot find it in lwn.net
> > archives). There were no major objections. 
> 
> Except there are.

Good to know that late... It would have been much more helpful to have
such a principal feedback few months ago (this work is here since early
Jun).
 
> > My primary test case was a parallel kernel build with 2 groups (make
> > is running with -j4 with a distribution .config in a separate cgroup
> > without any hard limit) on a 8 CPU machine booted with 1GB memory.  I
> > was mostly interested in 2 setups. Default - no soft limit set and - and
> > 0 soft limit set to both groups.
> > The first one should tell us whether the rework regresses the default
> > behavior while the second one should show us improvements in an extreme
> > case where both workloads are always over the soft limit.
> 
> Two kernel builds with 1G of memory means that reclaim is purely
> trimming the cache every once in a while.  Changes in memory pressure
> are not measurable up to a certain point, because whether you trim old
> cache or not does not affect the build jobs.
> 
> Also you tested the no-softlimit case and an extreme soft limit case.
> Where are the common soft limit cases?

v5.1 had some more tests. I have added soft limitted stream IO resp. kbuild vs
unlimitted mem_eater loads. Have you checked those?

[...]
> > So to wrap this up. The series is still doing good and improves the soft
> > limit.
> 
> The soft limit tree is a bunch of isolated code that's completely
> straight-forward.  This is replaced by convoluted memcg iterators,
> convoluted lruvec shrinkers, spreading even more memcg callbacks with
> questionable semantics into already complicated generic reclaim code.

I was trying to keep the convolution into vmscan as small as possible.
Maybe it can get reduced even more. I will think about it.

Predicate for memcg iterator has been added to address your concern
about a potential regression with too many groups. And that looked like
the least convoluting solution.

> This series considerably worsens readability and maintainability of
> both the generic reclaim code as well as the memcg counterpart of it.

I am really surprised that you are coming with this concerns that late.
This code has been posted quite some ago, hasn't it? We have even had
that "calm" discussion with Tejun about predicates and you were silent
at the time.

> The point of naturalizing the memcg code is to reduce data structures
> and redundancy and to break open opaque interfaces like "do soft
> reclaim and report back".  But you didn't actually reduce complexity,
> you added even more opaque callbacks (should_soft_reclaim?
> soft_reclaim_eligible?).  You didn't integrate soft limit into generic
> reclaim code, you just made the soft limit API more complicated.

I can certainly think about simplifications. But it would be nicer if
you were more specific on the "more complicated" part. The soft reclaim
is a natural part of the reclaim now. Which I find as an improvement.
"Do some memcg magic and get back was" a bad idea IMO.
Hiding the soft limit decisions into the iterators as a searching
criteria doesn't sound as a totally bad idea to me. Soft limit is an
additional criteria who to reclaim, isn't it?
Well, I could have open coded it but that would mean a more code into
vmscan or getting back to "call some memcg magic and get back to me".

> And, as I mentioned repeatedly in previous submissions, your benchmark
> numbers don't actually say anything useful about this change.

I would really welcome suggestions for improvements. I have tried "The
most interesting test case would be how it behaves if some groups are
over the soft limits while others are not." with v5.1 where I had
memeater unlimited and kbuild resp. stream IO being limited. 

> I'm against merging this upstream at this point.

Can we at least find some middle ground here? The way how the current
soft limit is done is a disaster. Ditching the whole series sounds like
a step back to me.
-- 
Michal Hocko
SUSE Labs
