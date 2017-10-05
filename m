From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v10 5/6] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Thu, 5 Oct 2017 15:14:19 +0200
Message-ID: <20171005131419.4o6qynsl2qxomekb@dhcp22.suse.cz>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-6-guro@fb.com>
 <20171004200453.GE1501@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171004200453.GE1501-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 04-10-17 16:04:53, Johannes Weiner wrote:
[...]
> That will silently ignore what the user writes to the memory.oom_group
> control files across the system's cgroup tree.
> 
> We'll have a knob that lets the workload declare itself an indivisible
> memory consumer, that it would like to get killed in one piece, and
> it's silently ignored because of a mount option they forgot to pass.
> 
> That's not good from an interface perspective.

Yes and that is why I think a boot time knob would be the most simple
way. It will also open doors for more oom policies in future which I
believe come sooner or later.

> On the other hand, the only benefit of this patch is to shield users
> from changes to the OOM killing heuristics. Yet, it's really hard to
> imagine that modifying the victim selection process slightly could be
> called a regression in any way. We have done that many times over,
> without a second thought on backwards compatibility:
> 
> 5e9d834a0e0c oom: sacrifice child with highest badness score for parent
> a63d83f427fb oom: badness heuristic rewrite
> 778c14affaf9 mm, oom: base root bonus on current usage

yes we have changed that without a deeper considerations. Some of those
changes are arguable (e.g. child scarification). The oom badness
heuristic rewrite has triggered quite some complains AFAIR (I remember
Kosaki has made several attempts to revert it). I think that we are
trying to be more careful about user visible changes than we used to be.

More importantly I do not think that the current (non-memcg aware) OOM
policy is somehow obsolete and many people expect it to behave
consistently. As I've said already, I have seen many complains that the
OOM killer doesn't kill the right task. Most of them were just NUMA
related issues where the oom report was not clear enough. I do not want
to repeat that again now. Memcg awareness is certainly a useful
heuristic but I do not see it universally applicable to all workloads.

> Let's not make the userspace interface crap because of some misguided
> idea that the OOM heuristic is a hard promise to userspace. It's never
> been, and nobody has complained about changes in the past.
> 
> This case is doubly silly, as the behavior change only applies to
> cgroup2, which doesn't exactly have a large base of legacy users yet.

I agree on the interface part but I disagree with making it default just
because v2 is not largerly adopted yet.
-- 
Michal Hocko
SUSE Labs
