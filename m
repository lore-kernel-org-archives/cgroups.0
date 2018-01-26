From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Thu, 25 Jan 2018 16:00:16 -0800
Message-ID: <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
	<alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com>
	<alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, 25 Jan 2018 15:53:48 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> Now that each mem cgroup on the system has a memory.oom_policy tunable to
> specify oom kill selection behavior, remove the needless "groupoom" mount
> option that requires (1) the entire system to be forced, perhaps
> unnecessarily, perhaps unexpectedly, into a single oom policy that
> differs from the traditional per process selection, and (2) a remount to
> change.
> 
> Instead of enabling the cgroup aware oom killer with the "groupoom" mount
> option, set the mem cgroup subtree's memory.oom_policy to "cgroup".

Can we retain the groupoom mount option and use its setting to set the
initial value of every memory.oom_policy?  That way the mount option
remains somewhat useful and we're back-compatible?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
