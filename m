From: Tejun Heo <tj@kernel.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Sat, 20 Apr 2013 19:23:21 -0700
Message-ID: <20130421022321.GE19097@mtj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420031611.GA4695@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=GxpSnhrqJCnTT+VzAOBu1OKuuE+PfyeQ//7XW/bqUTk=;
        b=tF6Zd2Dy/uwRZUEULL35GvQEJ2/2eBbbPHMFwfIjxEC+exIbBa34dA8FFtk6xqq5c8
         fU8P1DITzP94tCmV4PFprYtn3tCEAFZaXQKRvOXadxf6B5uuDj20bldIOBVzH5EN2b9e
         g/TwNiE1ARAXjcKG8wxsi88RE9cazRntO6GXkP9mAwmWp/TuNQzof/mj7PiHcM0n29lN
         SF70esJQGUqma0BdC2u0yFR5DZODQ4XgcgNJ1+FbpMlF5LfZK01GjrgmghrsvaSAONdj
         ElrEC926cS7amBvzCSwgZ8pYL0mhPZYqYQyPP6IZfo8kHd3fNE5FecZ7kolS+++UaFRY
         QS2A==
Content-Disposition: inline
In-Reply-To: <20130420031611.GA4695@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>

Hello, Michal.

On Fri, Apr 19, 2013 at 08:16:11PM -0700, Michal Hocko wrote:
> > For example, please consider the following hierarchy where s denotes
> > the "softlimit" and h hardlimit.
> > 
> >       A (h:8G s:4G)
> >      /            \
> >     /              \
> >  B (h:5G s:1G)    C (h:5G s:1G)
...
> > It must not be any different for "softlimit".  If B or C are
> > individually under 1G, they won't be targeted by the reclaimer and
> > even if B and C are over 1G, let's say 2G, as long as the sum is under
> > A's "softlimit" - 4G, reclaimer won't look at them. 
> 
> But we disagree on this one. If B and/or C are above their soft limit
> we do (soft) reclaim them. It is exactly the same thing as if they were
> hitting their hard limit (we just enforce the limit lazily).
> 
> You can look at the soft limit as a lazy limit which is enforced only if
> there is an external pressure coming up the hierarchy - this can be
> either global memory presure or a hard limit reached up the hierarchy.
> Does this makes sense to you?

When flat, there's no confusion.  The problem is that what you
describe makes the meaning of softlimit different for internal nodes
and leaf nodes.  IIUC, it is, at least currently, guarantees that
reclaim won't happen for a cgroup under limit.  In hierarchical
setting, if A's subtree is under limit, its subtree shouldn't be
subject to guarantee.  Again, you should be gating / stacking the
limits as you go down the tree and what you're saying breaks that
fundamental hierarchy rule.

> > Now, let's consider the following hierarchy just to be sure.  Let's
> > assume that A itself doesn't have any tasks for simplicity.
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> >       A (h:16G s:4G)
> >      /            \
> >     /              \
> >  B (h:7G s:5G)    C (h:7G s:5G)
> > 
> > For hardlimit, it is clear that A's limit won't do anything.
> 
> It _does_ if A has tasks which add pressure to B+C. Or even if you do
> not have any tasks because A might hold some reparented pages from
> groups which are gone now.

See the above.  It's to discuss the semantics of limit hierarchy, so
let's forget about A's internal usage for now.

> > Just like A's hardlimit doesn't impose any further restrictions on B
> > and C, A's softlimit doesn't give any further guarantee to B and C.
> > There's no difference at all.
> 
> If A hits its hard limit then we reclaim that subtree so we _can_ and
> _do_ reclaim also from B and C. This is what the current code does and
> soft reclaim doesn't change that at all. The only thing it changes is
> that it tries to save groups bellow the limit from reclaiming.

Hardlimit and softlimit are in the *opposite* directions and you're
saying that softlimit in parent working in the same direction as
hardlimit is correct.  Stop being so confused.  Softlimit is in the
opposite direction.  Internal node limit in hierarchical setting
should of course work in the opposite direction.

> > Now, it's completely silly that "softlimit" is actually allocation
> > guarantee rather than an actual limit.  I guess it's born out of
> > similar confusion?  Maybe originally the operation was a confused mix
> > of the two and it moved closer to guaranteeing behavior over time?
> 
> I wouldn't call it silly. It actually makes a lot of sense if you look
> at it as a delayed limit which would allow you to allocate more if there
> is not any outside memory pressure.

It is silly because it *prevents* reclaim from happening if the cgroup
is under the limit which is *the* defining characteristic of the knob.
Memory is by *default* allowed to be reclaimed.  How can being allowed
to do what is allowed by default be a function of a knob?  It seems
like this confusion is leading you to think weird things about the
meaning of the knob in hierarchy.  Stop thinking about it as limit.
It's a reclaim inhibitor.

> Actually the use case is this. Say you have an important workload which
> shouldn't be influenced by other less important workloads (say backup
> for simplicity). You set up a soft limit for your important load to
> match its average working set. The backup doesn't need any hard limit

Yes, guarantee.

> and soft limit set to 0 because a) you do not know how much it would
> need and b) you like to make run as fast as possible. Check what happens
> now. Backup uses all the remaining memory until the global reclaims
> starts. The global reclaim will start reclaiming the backup or even
> your important workload if it consumed more than its soft limit (say
> after a peak load). As far as you can reclaim from the backup enough to
> satisfy the global memory pressure you do not have to hit the important
> workload. Sounds like a huge win to me!

I'm not saying the guarantee is useless.  I'm saying its name is
completely the opposite of what it does and you, while knowing what it
actually does in practice, are completely confused what the knob
semantically means.

> You can even look at the soft limit as to an "intelligent" mlock which
> keeps the memory "locked" as far as you can keep handling the external
> memory pressure. This is new with this new re-implementation because the
> original code uses soft limit only as a hint who to reclaim first but
> doesn't consider it any further.

Now I'm confused.  You're saying softlimit currently doesn't guarantee
anything and what it means, even for flat hierarchy, isn't clearly
defined?  If it can go either way and "softlimit" is being made an
allocation guarantee rather than say "if there's any pressure, feel
free to reclaim to this point (ie. prioritize reclaim to that point)",
that doesn't sound like a good idea.

Really, don't mix "don't reclaim below this" and "this shouldn't need
more than this, if under pressure, you can be aggressive about
reclaiming this one down to this point".  That's where all the
confusions are coming from.  They are two knobs in the opposite
directions and shouldn't be merged into a single knob.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
