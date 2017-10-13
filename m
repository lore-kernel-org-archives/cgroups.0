From: Roman Gushchin <guro@fb.com>
Subject: Re: [v11 3/6] mm, oom: cgroup-aware OOM killer
Date: Fri, 13 Oct 2017 14:32:19 +0100
Message-ID: <20171013133219.GA5363@castle.DHCP.thefacebook.com>
References: <20171005130454.5590-1-guro@fb.com>
 <20171005130454.5590-4-guro@fb.com>
 <alpine.DEB.2.10.1710091414260.59643@chino.kir.corp.google.com>
 <20171010122306.GA11653@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
 <20171010220417.GA8667@castle>
 <alpine.DEB.2.10.1710111247390.98307@chino.kir.corp.google.com>
 <20171011214927.GA28741@castle>
 <alpine.DEB.2.10.1710121415420.76558@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=GW+x6f38nPcLKb0TASV01dMQ+OmlKjU4RMxlr+7qDjk=;
 b=ihv7F1XboOJu13IYRamhfq5KNzktPd/4D+JqH6PJBiL+EtwIj6hxS7Kyixp39/xYz1Hs
 Y1VD5oyIVJw41Rnkd34nT+SS0Eewqza5VvuQIfLlXS9s/PGOSzu2A/8Tojd3h3L1mkiu
 C5Ks/5S4fbUCNNXyHWNE6UWUFY3dMIGhNS0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GW+x6f38nPcLKb0TASV01dMQ+OmlKjU4RMxlr+7qDjk=;
 b=Uyti8NDKRhjggGwzUY6BYOEv7tCdHhoFMzivH7Pf6ctwcmGUinLTbgrU6a6Av4VxLwv6lUY/EHgUmFpxaukh6m++q2ec18R4Wp31fXaVEh/0kk4p7co3CgogEsTTWr2RmVGv/rIjACoz3CLqeFiCCP86w8bqMpXiCLvpqJRshJA=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710121415420.76558@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Oct 12, 2017 at 02:50:38PM -0700, David Rientjes wrote:
> On Wed, 11 Oct 2017, Roman Gushchin wrote:
> 
> Think about it in a different way: we currently compare per-process usage 
> and userspace has /proc/pid/oom_score_adj to adjust that usage depending 
> on priorities of that process and still oom kill if there's a memory leak.  
> Your heuristic compares per-cgroup usage, it's the cgroup-aware oom killer 
> after all.  We don't need a strict memory.oom_priority that outranks all 
> other sibling cgroups regardless of usage.  We need a memory.oom_score_adj 
> to adjust the per-cgroup usage.  The decisionmaking in your earlier 
> example would be under the control of C/memory.oom_score_adj and 
> D/memory.oom_score_adj.  Problem solved.
> 
> It also solves the problem of userspace being able to influence oom victim 
> selection so now they can protect important cgroups just like we can 
> protect important processes today.
> 
> And since this would be hierarchical usage, you can trivially infer root 
> mem cgroup usage by subtraction of top-level mem cgroup usage.
> 
> This is a powerful solution to the problem and gives userspace the control 
> they need so that it can work in all usecases, not a subset of usecases.

You're right that per-cgroup oom_score_adj may resolve the issue with
too strict semantics of oom_priorities. But I believe nobody likes
the existing per-process oom_score_adj interface, and there are reasons behind.
Especially in case of memcg-OOM, getting the idea how exactly oom_score_adj
will work is not trivial.
For example, earlier in this thread I've shown an example, when a decision
which of two processes should be killed depends on whether it's global or
memcg-wide oom, despite both belong to a single cgroup!

Of course, it's technically trivial to implement some analog of oom_score_adj
for cgroups (and early versions of this patchset did that).
But the right question is: is this an interface we want to support
for the next many years? I'm not sure.
