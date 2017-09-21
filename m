From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Thu, 21 Sep 2017 14:17:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170921142107.GA20109@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=kixQKskYuLbiLBpI2ZIbpYjXMHjo9Sn3S4ur3I3aSOI=;
        b=lrSyprE2ibLMzQl5isVqDH0qcmi3rLaPZ7XZlBWZIfhvJuVWCE9UcP+RgLEOpO4AbE
         hNfqxQaehTWz6M/Z3n8dPF5UcR8CKdk+T2/53MWtdAgnA9EefHnwp8bHRSljEFiyit1O
         2rfJQVcrv16JZ8nbPhV7l7quXOlOxaItH1pjg75mnUM0bjEcQcMHmYnYNsRJ+Sqi7I6O
         kPhATAtAcBjxBixIgHgKn5TBhyeD706hueCq3pmhzcXyQYMbEHZdF2h2pd/6djL2drCm
         PtChI4rVoNCpqpo6KnDEvDy+S/LN2GTRX31TIZ2lyj4KRedJYVKwycGgHW0eSHSsFuf6
         z9IA==
In-Reply-To: <20170921142107.GA20109-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 21 Sep 2017, Johannes Weiner wrote:

> That's a ridiculous nak.
> 
> The fact that this patch series doesn't solve your particular problem
> is not a technical argument to *reject* somebody else's work to solve
> a different problem. It's not a regression when behavior is completely
> unchanged unless you explicitly opt into a new functionality.
> 
> So let's stay reasonable here.
> 

The issue is that if you opt-in to the new feature, then you are forced to 
change /proc/pid/oom_score_adj of all processes attached to a cgroup that 
you do not want oom killed based on size to be oom disabled.  The kernel 
provides no other remedy without oom priorities since the new feature 
would otherwise disregard oom_score_adj.  In that case, userspace is 
racing in two ways: (1) attach of process to a memcg you want to protect 
from oom kill (first class, vital, large memory hog job) to set to oom 
disable and (2) adjustment of other cgroups to make them eligible after 
first oom kill.

It doesn't have anything to do with my particular usecase, but rather the 
ability of userspace to influence the decisions of the kernel.  Previous 
to this patchset, when selection is done based on process size, userspace 
has full control over selection.  After this patchset, userspace has no 
control other than setting all processes to be oom disabled if the largest 
memory consumer is to be protected.  Roman's memory.oom_priority provides 
a perfect solution for userspace to be able to influence this decision 
making and causes no change in behavior for users who choose not to tune 
memory.oom_priority.  The nack originates from the general need for 
userspace influence over oom victim selection and to avoid userspace 
needing to take the rather drastic measure of setting all processes to be 
oom disabled to prevent oom kill in kernels before oom priorities are 
introduced.

> The patch series has merit as it currently stands. It makes OOM
> killing in a cgrouped system fairer and less surprising. Whether you
> have the ability to influence this in a new way is an entirely
> separate discussion. It's one that involves ABI and user guarantees.
> 
> Right now Roman's patches make no guarantees on how the cgroup tree is
> descended. But once we define an interface for prioritization, it
> locks the victim algorithm into place to a certain extent.
> 

The patchset compares memory cgroup size relative to sibling cgroups only, 
the same comparison for memory.oom_priority.  There is a guarantee 
provided on how cgroup size is compared in select_victim_memcg(), it 
hierarchically accumulates the "size" from leaf nodes up to the root memcg 
and then iterates the tree comparing sizes between sibling cgroups to 
choose a victim memcg.  That algorithm could be more elaborately described 
in the documentation, but we simply cannot change the implementation of 
select_victim_memcg() later even without oom priorities since users cannot 
get inconsistent results after opting into a feature between kernel 
versions.  I believe the selection criteria should be implemented to be 
deterministic, as select_victim_memcg() does, and the documentation should 
fully describe what the selection criteria is, and then allow the user to 
decide.

> It also involves a discussion about how much control userspace should
> have over OOM killing in the first place. It's a last-minute effort to
> save the kernel from deadlocking on memory. Whether that is the time
> and place to have userspace make clever resource management decisions
> is an entirely different thing than what Roman is doing.
> 
> But this patch series doesn't prevent any such future discussion and
> implementations, and it's not useless without it. So let's not
> conflate these two things, and hold the priority patch for now.
> 

Roman is planning on introducing memory.oom_priority back into the 
patchset per https://marc.info/?l=linux-kernel&m=150574701126877 and I 
agree with the very clear semantic that it introduces: to have the 
size-based comparison use the same rules as the userspace priority 
comparison.  It's very powerful and I'm happy to ack the final version 
that he plans on posting.
