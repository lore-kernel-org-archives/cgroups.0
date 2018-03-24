From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] mm, memcontrol: Make cgroup_rstat available to controllers
Date: Sat, 24 Mar 2018 09:08:58 -0700
Message-ID: <20180324160901.512135-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=/5W4tEGuJl5F9fX/iG/2IRtqWFchG4MaGrcZdTv8sqc=;
        b=BviaKImOmm2q26OJdXhINMQKyiibSB1uhy2ICPFgHW8fmFzE0xlq6Huk4h7vdiwLsk
         0QayE38roXocikOdtNaNM191EvUFQ7b30yyEelEVBJFDCxoJDQ2nhfCc9vpJG9o/ne5g
         OoHenddekoWGYVPcsr9Kt/clnYZozG5BmH7aWXKKjL++5ks0L605OLS4cv/pCI7iJA8x
         Opjbm4aVk1wAg781bJx5BnRcPgQt8j20m3LUXKQdda0F4ufrR1o5YUsNWxsSO7rj79FC
         YmVP8yBA+cqBvM51tq5nIswyXyAOojT5ZAovuaMZ5JgoAXNWkUfm+waPPtrm+ZyoDirr
         +0Xw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello,

Since a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
memory.stat reporting"), memcg uses percpu batch-overflowing for all
stat accounting.  While the propagation delay is okay for statistics,
it doesn't work for events.  If a notification for an event is sent
out, the relevant counter must reflect the event when read afterwards.
With the percpu batching, it's easy to miss, for example, an oom or
oom_kill event because it's still buffered in one of the percpu
counters.

cgroup already has a mechanism to efficiently handle hierarchical
statistics in a scalable manner, cgroup_rstat, and it now can be used
by controllers.

This patchset addresses the forementioned problem by converting event
accounting to cgroup_rstat.  While the stat part isn't broken, it's
also converted for consistency and a few other benefits.  Also, while
trying to convert lruvec_stat, I found out that it has no users.
Remove it too (not sure whether it's needed for some non-obvious
reasons tho).

 0001-mm-memcontrol-Use-cgroup_rstat-for-event-accounting.patch
 0002-mm-memcontrol-Use-cgroup_rstat-for-stat-accounting.patch
 0003-mm-memcontrol-Remove-lruvec_stat.patch

This patchset is on top of the "cgroup/for-4.17: Make cgroup_rstat
available to controllers" patchset[1] and also available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_rstat

diffstat follows.

 include/linux/memcontrol.h |  131 ++++++++++++------------
 mm/memcontrol.c            |  238 ++++++++++++++++++++-------------------------
 mm/vmscan.c                |    4 
 3 files changed, 180 insertions(+), 193 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/r/20180323231313.1254142-1-tj@kernel.org
