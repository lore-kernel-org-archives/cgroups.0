From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH linux-next] cgroup: fix suspicious
 rcu_dereference_check() usage warning
Date: Sat, 12 Mar 2022 14:34:45 +0100
Message-ID: <20220312133445.GA28086@worktop.programming.kicks-ass.net>
References: <20220305034103.57123-1-zhouchengming@bytedance.com>
 <20220312121913.GA28057@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d7N9wsNuqkZgK1+eKcOkZTC3C9GRGbNq5Ad3wwuX278=; b=JAgaT3p5mES5x2vTc50l81A/DB
        EfXJ8ZAn7+PI9x974nNSvog0QkLWoGopkOCd7o7eTeEaaBNbP2v3QilphZ2Rl/SGRB8mVQfV0Ffpj
        OMEG9fkNHugB0DJ7/oHB/HiP984qdWzoySy9d2q+zRTLdUTzKySOyuzUyID2IhePt/k/CFTrHSJ+q
        CAg0hfpNXy4Xd/4j9C+34pNiNr/j5MBP8Kq/lsIad/5QH2Ygn7PYm1i84BIpyeRJ6gZNid+ke9wIv
        BEWXD5rAG4q9Csv1MRUZ7qf4zPX60fwuCOsBAxjFQtoRy8PwYwkXkYrYCwgcAcBawTnfDy427BEOT
        x3Xa8Upw==;
Content-Disposition: inline
In-Reply-To: <20220312121913.GA28057-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Linux Kernel Functional Testing <lkft-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, syzbot+16e3f2c77e7c5a0113f9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sat, Mar 12, 2022 at 01:19:13PM +0100, Peter Zijlstra wrote:
> On Sat, Mar 05, 2022 at 11:41:03AM +0800, Chengming Zhou wrote:
> > task_css_set_check() will use rcu_dereference_check() to check for
> > rcu_read_lock_held() on the read-side, which is not true after commit
> > dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock"). This
> > commit drop explicit rcu_read_lock(), change to RCU-sched read-side
> > critical section. So fix the RCU warning by adding check for
> > rcu_read_lock_sched_held().
> > 
> > Fixes: dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock")
> > Reported-by: Linux Kernel Functional Testing <lkft-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Reported-by: syzbot+16e3f2c77e7c5a0113f9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> > Tested-by: Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Thanks, I'll go stick this in sched/core so it's in the same branch that
> caused the problem.

FWIW I never saw this patch because it doesn't instantly look like a
patch I should be interested in. It's classified as 'for-next' and I
don't run -next, sfr does that. Then it's tagged as cgroup, which I also
don't do.

Nowhere does that look like a patch that wants to go in sched/core and
fixes a cpuacct issue.

On top of that, I still don't agree with this, I really think
rcu_dereference_check() itself should be changed.
