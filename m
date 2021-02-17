From: Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH 1/4] cputime,cpuacct: Include guest time in user time in cpuacct.stat
Date: Wed, 17 Feb 2021 15:00:01 +0300
Message-ID: <20210217120004.7984-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1613563134; bh=vUwCClxuuPybLqdPXj4P31Jz2tCAVBtC1IxfWOO/Vmo=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=f68LnMvHOlCg6quWIKcZyZHX1xm+vHio8tQ99b5GUIsKWZL55IUH9Qq9xkdV02GIx
         Kt3aenj8gShgJqIQ37KU2unY949lU83vp9SfBRG/xly8nM4F5jP5lZrXDH5zFBWfq2
         qkdOjGQ7+9Xc8bYgPe9QG33aP/rVCZpLMxbFAkKc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Boris Burkov <boris@bur.io>, Bharata B Rao <bharata@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org

cpuacct.stat in no-root cgroups shows user time without guest time
included int it. This doesn't match with user time shown in root
cpuacct.stat and /proc/<pid>/stat.

Make account_guest_time() to add user time to cgroup's cpustat to
fix this.

Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Cc: <stable@vger.kernel.org>
---
 kernel/sched/cputime.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5f611658eeab..95a9c5603d29 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -139,8 +139,6 @@ void account_user_time(struct task_struct *p, u64 cputime)
  */
 void account_guest_time(struct task_struct *p, u64 cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
 	/* Add guest time to process. */
 	p->utime += cputime;
 	account_group_user_time(p, cputime);
@@ -148,11 +146,11 @@ void account_guest_time(struct task_struct *p, u64 cputime)
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += cputime;
-		cpustat[CPUTIME_GUEST_NICE] += cputime;
+		task_group_account_field(p, CPUTIME_NICE, cputime);
+		task_group_account_field(p, CPUTIME_GUEST_NICE, cputime);
 	} else {
-		cpustat[CPUTIME_USER] += cputime;
-		cpustat[CPUTIME_GUEST] += cputime;
+		task_group_account_field(p, CPUTIME_USER, cputime);
+		task_group_account_field(p, CPUTIME_GUEST, cputime);
 	}
 }
 
-- 
2.26.2

