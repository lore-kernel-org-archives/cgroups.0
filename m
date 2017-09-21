From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Thu, 21 Sep 2017 17:51:03 -0400
Message-ID: <20170921215103.GA23772@cmpxchg.org>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170921142107.GA20109@cmpxchg.org>
 <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ET5L3o5VhJpjjcet3JVeehzvmPlk0XlHhJGj1KboPbQ=; b=3GQVdFMa2rwppah8bmQDqNO90r
	Hv6ASe7d8qAVFhpW1Of0rIxcF0iWKHMbgLkMVwZra13Vi2cx7BM9ojUm1CSqWlhmLrGb90jyJc7+U
	caM31MAGbvyMpTcY96RkK9RBJ4FmgRZdendfw/qPKUVF6de1EExEqclmYktaVskUtw6o=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 21, 2017 at 02:17:25PM -0700, David Rientjes wrote:
> On Thu, 21 Sep 2017, Johannes Weiner wrote:
> 
> > That's a ridiculous nak.
> > 
> > The fact that this patch series doesn't solve your particular problem
> > is not a technical argument to *reject* somebody else's work to solve
> > a different problem. It's not a regression when behavior is completely
> > unchanged unless you explicitly opt into a new functionality.
> > 
> > So let's stay reasonable here.
> > 
> 
> The issue is that if you opt-in to the new feature, then you are forced to 
> change /proc/pid/oom_score_adj of all processes attached to a cgroup that 
> you do not want oom killed based on size to be oom disabled.

You're assuming that most people would want to influence the oom
behavior in the first place. I think the opposite is the case: most
people don't care as long as the OOM killer takes the intent the user
has expressed wrt runtime containerization/grouping into account.

> The kernel provides no other remedy without oom priorities since the
> new feature would otherwise disregard oom_score_adj.

As of v8, it respects this setting and doesn't kill min score tasks.

> The nack originates from the general need for userspace influence
> over oom victim selection and to avoid userspace needing to take the
> rather drastic measure of setting all processes to be oom disabled
> to prevent oom kill in kernels before oom priorities are introduced.

As I said, we can discuss this in a separate context. Because again, I
really don't see how the lack of configurability in an opt-in feature
would diminish its value for many people who don't even care to adjust
and influence this behavior.

> > The patch series has merit as it currently stands. It makes OOM
> > killing in a cgrouped system fairer and less surprising. Whether you
> > have the ability to influence this in a new way is an entirely
> > separate discussion. It's one that involves ABI and user guarantees.
> > 
> > Right now Roman's patches make no guarantees on how the cgroup tree is
> > descended. But once we define an interface for prioritization, it
> > locks the victim algorithm into place to a certain extent.
> > 
> 
> The patchset compares memory cgroup size relative to sibling cgroups only, 
> the same comparison for memory.oom_priority.  There is a guarantee 
> provided on how cgroup size is compared in select_victim_memcg(), it 
> hierarchically accumulates the "size" from leaf nodes up to the root memcg 
> and then iterates the tree comparing sizes between sibling cgroups to 
> choose a victim memcg.  That algorithm could be more elaborately described 
> in the documentation, but we simply cannot change the implementation of 
> select_victim_memcg() later even without oom priorities since users cannot 
> get inconsistent results after opting into a feature between kernel 
> versions.  I believe the selection criteria should be implemented to be 
> deterministic, as select_victim_memcg() does, and the documentation should 
> fully describe what the selection criteria is, and then allow the user to 
> decide.

I wholeheartedly disagree. We have changed the behavior multiple times
in the past. In fact, you have arguably done the most drastic changes
to the algorithm since the OOM killer was first introduced. E.g.

	a63d83f427fb oom: badness heuristic rewrite

And that's completely fine. Because this thing is not a resource
management tool for userspace, it's the kernel saving itself. At best
in a manner that's not too surprising to userspace.

To me, your argument behind the NAK still boils down to "this doesn't
support my highly specialized usecase." But since it doesn't prohibit
your usecase - which isn't even supported upstream, btw - this really
doesn't carry much weight.

I'd say if you want configurability on top of Roman's code, please
submit patches and push the case for these in a separate effort.

Thanks

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
