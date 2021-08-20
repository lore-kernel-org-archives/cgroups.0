From: Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v2 1/5] cputime, cpuacct: Include guest time in user time in cpuacct.stat
Date: Fri, 20 Aug 2021 12:40:01 +0300
Message-ID: <20210820094005.20596-1-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452404; bh=FqDPCT9ctoYxeVdn5G+2qe+3q2FXvJMdHHVeOhYs3u8=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=jy6G9vh5Ch/oNVcH0z/JK48fJHzXflzju710tdCLdCo8ApeWTBvzIn/F3HSMc/rsc
         qkc/nAtOLdwiKLzP8BPA6XbWWf7Ru7NOCFcUCSqzvFQd02iyXst+kNkKTenaMYUwXI
         5ls5/RGTkYNGkqW8o1NmpHZUIF0qNUHbpxirZcrY=
In-Reply-To: <20210217120004.7984-1-arbn@yandex-team.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com, boris@bur.io, Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org

cpuacct.stat in no-root cgroups shows user time without guest time
included int it. This doesn't match with user time shown in root
cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
in the same way.

Make account_guest_time() to add user time to cgroup's cpustat to
fix this.

Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Cc: <stable@vger.kernel.org>
---
Changes since v1:
   - Don't CPUTIME_GUEST* since they aren't used cgroups
---
 kernel/sched/cputime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 872e481d5098..042a6dbce8f3 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -148,10 +148,10 @@ void account_guest_time(struct task_struct *p, u64 cputime)
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += cputime;
+		task_group_account_field(p, CPUTIME_NICE, cputime);
 		cpustat[CPUTIME_GUEST_NICE] += cputime;
 	} else {
-		cpustat[CPUTIME_USER] += cputime;
+		task_group_account_field(p, CPUTIME_USER, cputime);
 		cpustat[CPUTIME_GUEST] += cputime;
 	}
 }
-- 
2.31.1

