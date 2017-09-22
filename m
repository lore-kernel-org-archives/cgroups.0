From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Fri, 22 Sep 2017 13:53:47 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709221340280.68140@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170921142107.GA20109@cmpxchg.org> <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com> <20170921215103.GA23772@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Zzr7eMJqpdlXt556hY+24/d4U7k6Lp9VR7EL4KlbTRE=;
        b=J6qIoettuMg4numJSc2Y/UW4wNshOkpgpqSUTFLMwy6hCI+xMdhqRnKxNqVt4t/4Nt
         sYJMFX+g+QS5V51m6pJoCA38FyNn+0Q7za+vYePjJ+3a0zQ0lUPSyESNTK43yhYF87Ml
         eDXWyv+pl3CjPw+BvCaZlRa5hHGyfWHapaeZQMM/Pqa3isptB2N8Ak+liAPyGCN5NM+Q
         gDuGusIuBVglsCNJksNFm1Ni7X7vnGYjPdEuI3XBrf6Tt/FBGxKnN1x1K+kuDQWi1bYB
         hQnMWS1zFMk4S6XgQ1l7ws5FUVNgPQzT8wc0xC0jfjRkefU8dTRyvJPBA3R4kHZ2+RXu
         ufhw==
In-Reply-To: <20170921215103.GA23772@cmpxchg.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 21 Sep 2017, Johannes Weiner wrote:

> > The issue is that if you opt-in to the new feature, then you are forced to 
> > change /proc/pid/oom_score_adj of all processes attached to a cgroup that 
> > you do not want oom killed based on size to be oom disabled.
> 
> You're assuming that most people would want to influence the oom
> behavior in the first place. I think the opposite is the case: most
> people don't care as long as the OOM killer takes the intent the user
> has expressed wrt runtime containerization/grouping into account.
> 

If you do not want to influence the oom behavior, do not change 
memory.oom_priority from its default.  It's that simple.

> > The kernel provides no other remedy without oom priorities since the
> > new feature would otherwise disregard oom_score_adj.
> 
> As of v8, it respects this setting and doesn't kill min score tasks.
> 

That's the issue.  To protect a memory cgroup from being oom killed in a 
system oom condition, you need to change oom_score_adj of *all* processes 
attached to be oom disabled.  Then, you have a huge problem in memory 
cgroup oom conditions because nothing can be killed in that hierarchy 
itself.

> > The patchset compares memory cgroup size relative to sibling cgroups only, 
> > the same comparison for memory.oom_priority.  There is a guarantee 
> > provided on how cgroup size is compared in select_victim_memcg(), it 
> > hierarchically accumulates the "size" from leaf nodes up to the root memcg 
> > and then iterates the tree comparing sizes between sibling cgroups to 
> > choose a victim memcg.  That algorithm could be more elaborately described 
> > in the documentation, but we simply cannot change the implementation of 
> > select_victim_memcg() later even without oom priorities since users cannot 
> > get inconsistent results after opting into a feature between kernel 
> > versions.  I believe the selection criteria should be implemented to be 
> > deterministic, as select_victim_memcg() does, and the documentation should 
> > fully describe what the selection criteria is, and then allow the user to 
> > decide.
> 
> I wholeheartedly disagree. We have changed the behavior multiple times
> in the past. In fact, you have arguably done the most drastic changes
> to the algorithm since the OOM killer was first introduced. E.g.
> 
> 	a63d83f427fb oom: badness heuristic rewrite
> 
> And that's completely fine. Because this thing is not a resource
> management tool for userspace, it's the kernel saving itself. At best
> in a manner that's not too surprising to userspace.
> 

When I did that, I had to add /proc/pid/oom_score_adj to allow userspace 
to influence selection.  We came up with /proc/pid/oom_score_adj when 
working with kde, openssh, chromium, and udev because they cared about the 
ability to influence the decisionmaking.  I'm perfectly happy with the new 
heuristic presented in this patchset, I simply want userspace to be able 
to influence it, if it desires.  Requiring userspace to set all processes 
to be oom disabled to protect a hierarchy is totally and completely 
broken.  It livelocks the memory cgroup if it is oom itself.

> To me, your argument behind the NAK still boils down to "this doesn't
> support my highly specialized usecase." But since it doesn't prohibit
> your usecase - which isn't even supported upstream, btw - this really
> doesn't carry much weight.
> 
> I'd say if you want configurability on top of Roman's code, please
> submit patches and push the case for these in a separate effort.
> 

Roman implemented memory.oom_priority himself, it has my Tested-by, and it 
allows users who want to protect high priority memory cgroups from using 
the size based comparison for all other cgroups that we very much desire.
