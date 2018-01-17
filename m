From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Wed, 17 Jan 2018 07:41:55 -0800
Message-ID: <20180117154155.GU3460072@devbig577.frc2.facebook.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801161814130.28198@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EPqYbciQrTG0JihwLZlFLm1Z1NQ+//IP+c3PY1vqSO0=;
        b=ZFJM0WSDeIVHnV7tbiWvgdAwX/mUNkYDZ6iF0qLnV8tC5KSJHG8KIklOC+ZPmLZBJN
         CDhbY/Is//AFf92AYeH4Y/WATVZ4DTgvOe8RRWUQ+3BA/vDH8CQFryCwBHeWvcFD3C79
         /at7svThF8qQolNyEym7Ly/FF4Yd3PXZh2YzpAPclm4lGbZDKz/OnAojhMgteay4T+5h
         VIW/s6ONZF9Urkxtnsyr0SAxFbb8RQDiBmYu/KfXgi+wC2IHYHBwCiDCcImXUUNzLk6q
         6Sus6PsmS1Q1oezDXVNX8khI8WtAQWMgh9maIapaibG8pTHzGkYt5x3jd0QNvEvlXoED
         +wkQ==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1801161814130.28198@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello, David.

On Tue, Jan 16, 2018 at 06:15:08PM -0800, David Rientjes wrote:
> The behavior of killing an entire indivisible memory consumer, enabled
> by memory.oom_group, is an oom policy itself.  It specifies that all

I thought we discussed this before but maybe I'm misremembering.
There are two parts to the OOM policy.  One is victim selection, the
other is the action to take thereafter.

The two are different and conflating the two don't work too well.  For
example, please consider what should be given to the delegatee when
delegating a subtree, which often is a good excercise when designing
these APIs.

When a given workload is selected for OOM kill (IOW, selected to free
some memory), whether the workload can handle individual process kills
or not is the property of the workload itself.  Some applications can
safely handle some of its processes picked off and killed.  Most
others can't and want to be handled as a single unit, which makes it a
property of the workload.

That makes sense in the hierarchy too because whether one process or
the whole workload is killed doesn't infringe upon the parent's
authority over resources which in turn implies that there's nothing to
worry about how the parent's groupoom setting should constrain the
descendants.

OOM victim selection policy is a different beast.  As you've mentioned
multiple times, especially if you're worrying about people abusing OOM
policies by creating sub-cgroups and so on, the policy, first of all,
shouldn't be delegatable and secondly should have meaningful
hierarchical restrictions so that a policy that an ancestor chose
can't be nullified by a descendant.

I'm not necessarily against adding hierarchical victim selection
policy tunables; however, I am skeptical whether static tunables on
cgroup hierarchy (including selectable policies) can be made clean and
versatile enough, especially because the resource hierarchy doesn't
necessarily, or rather in most cases, match the OOM victim selection
decision tree, but I'd be happy to be proven wrong.

Without explicit configurations, the only thing the OOM killer needs
to guarantee is that the system can make forward progress.  We've
always been tweaking victim selection with or without cgroup and
absolutely shouldn't be locked into a specific heuristics.  The
heuristics is an implementaiton detail subject to improvements.

To me, your patchset actually seems to demonstrate that these are
separate issues.  The goal of groupoom is just to kill logical units
as cgroup hierarchy can inform the kernel of how workloads are
composed in the userspace.  If you want to improve victim selection,
sure, please go ahead, but your argument that groupoom can't be merged
because of victim selection policy doesn't make sense to me.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
