From: Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3 1/4] cputime, cpuacct: Include guest time in user time in cpuacct.stat
Date: Mon, 15 Nov 2021 19:46:04 +0300
Message-ID: <20211115164607.23784-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636994681; bh=IrYt5MMKvMGkiv1f4WYXd7ucQOljaPxik4BhGGjfmzQ=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=CWHoIMgtpMlSq2b3O2tN9O/rz0FXjrLJxj8NIqum8Vju46OaQouRWDpfwoECmB+t7
         xIJ2Kt4uCyGziCGgtO3iTxOIFLDS4sV1YfTxlaesYT8cnQZpE3LvfHLLCJCO9uFoYQ
         CV5lgUPqoysVecg/onWn8Fg1KNvNirOF7LTBZrmU=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrey Ryabinin <arbn@yandex-team.com>, Daniel Jordan <daniel.m.jordan@oracle.com>, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Schatzberg <schatzberg.dan@gmail.com>

cpuacct.stat in no-root cgroups shows user time without guest time
included int it. This doesn't match with user time shown in root
cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
in the same way.

Make account_guest_time() to add user time to cgroup's cpustat to
fix this.

Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
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
2.32.0

