From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/12] cgroup: rstat: Make cgroup_rstat_cpu_lock name readable
Date: Tue,  8 Feb 2022 10:41:58 -0800
Message-ID: <20220208184208.79303-3-namhyung@kernel.org>
References: <20220208184208.79303-1-namhyung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DVqQIGXek9gqjDYZ5x5feEwzLs2GJZs4gUa7i+kzwxU=;
        b=eZkvb8+7UyFnR21L5G1zcGI8qmb7Z6a9FPI1whMSBLG+SQouRtRGXHvgWofofksj4X
         gZB5sFr6ghXQvJW/Qq3wOP/ubVYRVVqZWpEXOJmHLHA+9yVi2iic/bTxbCgLKsYFNUWx
         nWOGj1PItndZXy9CxHYxkoPIZYgXs+AvTDgCbI5hEiHLb/9u/ASKrijJAysQub7y88RG
         FMA3a1+KBL0mqLyGYcIfSihA58L1nbkquzmiHjIu9u28yKitN1sxuU6vO4J9BW61CWiX
         1gvLzqO7GENqtEdf8SQH8I9Z6MeL3HfDxjye5PqXcFHWOAn5lm2GV0kMVKD8KMbkYT/q
         pwKg==
Sender: Namhyung Kim <namhyung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20220208184208.79303-1-namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, "Paul E. McKenney" <paul.mckenney-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The raw_spin_lock_init() uses the argument to name its lockdep map.
But passing per_cpu_ptr() macro directly makes it a very very long
name as it expanded like below:

  ({ do { const void *__vpp_verify = (typeof((&cgroup_rstat_cpu_lock) ...

Let's fix it by passing a local variable instead.  With this change,
the name now looks like:

  cgrp_rstat_cpu_lock

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/rstat.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 9d331ba44870..d1845f1196c9 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -286,9 +286,12 @@ void cgroup_rstat_exit(struct cgroup *cgrp)
 void __init cgroup_rstat_boot(void)
 {
 	int cpu;
+	raw_spinlock_t *cgrp_rstat_cpu_lock;
 
-	for_each_possible_cpu(cpu)
-		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
+	for_each_possible_cpu(cpu) {
+		cgrp_rstat_cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
+		raw_spin_lock_init(cgrp_rstat_cpu_lock);
+	}
 }
 
 /*
-- 
2.35.0.263.gb82422642f-goog

