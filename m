From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/12] cgroup: rstat: Make cgroup_rstat_cpu_lock name readable
Date: Tue,  8 Feb 2022 11:43:14 -0800
Message-ID: <20220208194324.85333-3-namhyung@kernel.org>
References: <20220208194324.85333-1-namhyung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ufb8JerL9tDT7g1v4aJC4XJXyEpEyj9Y7QxoUEiNuQM=;
        b=l8GUnslAu32x2n2gXuW8E6fzALxUMJ0TwywQoY3fKUoNyKJBqq58O/62kH0swgU77u
         DbHskTdVQLu0Tdr9fEJ2kCUH9L/S//grixVe8rw4M3vpH1XFpXDTqUJYyKMEILKF1MkG
         hNgLMNVINDbz/fRhL7lq0u7gY3Q1eRgLlyHbu5XWBWVJD7moK9FcLDHoF21NtVZMRtp5
         wWo93xO3wzaNO8NKVWPxd2UX00xbuNMSUxt45F9VVuVGAAxCzn4Ya+E2pjQbOiAsQzlG
         YHCeOJSR/NtzKWhs/gvZ0VKN22ynW8TsN+SOc0Ur0FgHjnIbTvjt2eQHzwWd/JDEO7iN
         CgtA==
Sender: Namhyung Kim <namhyung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20220208194324.85333-1-namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

The raw_spin_lock_init() uses the argument to name its lockdep map.
But passing per_cpu_ptr() macro directly makes it a very very long
name as it expanded like below:

  ({ do { const void *__vpp_verify = (typeof((&cgroup_rstat_cpu_lock) ...

Let's fix it by passing a local variable instead.  With this change,
the name now looks like:

  cgrp_rstat_cpu_lock

Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/rstat.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 9d331ba44870..371f54a59c38 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -286,9 +286,17 @@ void cgroup_rstat_exit(struct cgroup *cgrp)
 void __init cgroup_rstat_boot(void)
 {
 	int cpu;
+	raw_spinlock_t *cgrp_rstat_cpu_lock;
 
-	for_each_possible_cpu(cpu)
-		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
+	for_each_possible_cpu(cpu) {
+		/*
+		 * raw_spin_lock_init() uses the argument to name the lock in
+		 * lockdep results.  Passing per_cpu_ptr() directly created a
+		 * cryptic name as the macro was expanded before stringified.
+		 */
+		cgrp_rstat_cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
+		raw_spin_lock_init(cgrp_rstat_cpu_lock);
+	}
 }
 
 /*
-- 
2.35.0.263.gb82422642f-goog

