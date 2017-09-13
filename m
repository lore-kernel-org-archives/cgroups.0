From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Wed, 13 Sep 2017 13:46:08 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709131340020.146292@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=QaCYaXKgW8GRpiIz93kgj/cJtEm0C5Ps3NeCHsL2N/U=;
        b=GSh+PSsH6ZTaqV9xZmyoLQU3tjKSBVoU7r+/A+EZO/yMW1P2Gu7weLFnTAbVhf4QG4
         g62NgsPnA2me8jigs8TjCrSPWSd9tIXa/Chs/DP5kqroCdA2/Xak/IdiUoz6FAidVxw3
         trwvoMmO5TzL55IRNJefL2dt23S9wVc6Ya2wS9MfSB0NN8R3WookDyoyd1GlyRcXxBb5
         7kJCzxWMlcyQPpBbfj0ISXdLFHmUXZBDMTaGEqZfh4yo7EO5duyfS//Br+u9e0gRFn/r
         o17CCQwsZ59BbkYsd9SjSHTpotfKe+iBGDoHHC8w4+v8+tLyT2CmiKS4Z65El4rntwPu
         /Emw==
In-Reply-To: <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 13 Sep 2017, Michal Hocko wrote:

> > > This patchset makes the OOM killer cgroup-aware.
> > > 
> > > v8:
> > >   - Do not kill tasks with OOM_SCORE_ADJ -1000
> > >   - Make the whole thing opt-in with cgroup mount option control
> > >   - Drop oom_priority for further discussions
> > 
> > Nack, we specifically require oom_priority for this to function correctly, 
> > otherwise we cannot prefer to kill from low priority leaf memcgs as 
> > required.
> 
> While I understand that your usecase might require priorities I do not
> think this part missing is a reason to nack the cgroup based selection
> and kill-all parts. This can be done on top. The only important part
> right now is the current selection semantic - only leaf memcgs vs. size
> of the hierarchy). I strongly believe that comparing only leaf memcgs
> is more straightforward and it doesn't lead to unexpected results as
> mentioned before (kill a small memcg which is a part of the larger
> sub-hierarchy).
> 

The problem is that we cannot enable the cgroup-aware oom killer and 
oom_group behavior because, without oom priorities, we have no ability to 
influence the cgroup that it chooses.  It is doing two things: providing 
more fairness amongst cgroups by selecting based on cumulative usage 
rather than single large process (good!), and effectively is removing all 
userspace control of oom selection (bad).  We want the former, but it 
needs to be coupled with support so that we can protect vital cgroups, 
regardless of their usage.

It is certainly possible to add oom priorities on top before it is merged, 
but I don't see why it isn't part of the patchset.  We need it before its 
merged to avoid users playing with /proc/pid/oom_score_adj to prevent any 
killing in the most preferable memcg when they could have simply changed 
the oom priority.
