From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cgroup: no need for cgroup_mutex for /proc/cgroups
Date: Sun, 24 Oct 2021 23:19:16 -0700
Message-ID: <20211025061916.3853623-3-shakeelb@google.com>
References: <20211025061916.3853623-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RvvgnIVJ5IfhyMI13kBptnFJgKfIo/YKqj1muP3uFSI=;
        b=aZ8ak0XSK/nUIpVaIxYsqvQ3bOgvICTgXeDUq5NeDeyr5OL7iUyvWts44akfikGFMn
         1aspFDXj9W11lkB0NYioB51giV7uGch6f5v0x3OT6iQNLR/94F1Q9CfGiv5uJETPK3Wo
         RRNHaOTJwxbXyS/U62bh0IfOpVfp/MIyVQf0ZW7p3kUyjf0LKjh2h1ARVySaMSbTyMe7
         fA1J+fHVAQrVVtfefQBHFwfSBMuFXgCIbm5oT2pCpy38ZaGkIqX1DuqV9iahGkUIKOjS
         auBFJhXgVautfW4go+wrMVBb33tzy+CoC1yxOEPEifacHzz2s5Hoc259+ifLMsOwWif1
         QPXQ==
In-Reply-To: <20211025061916.3853623-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On the real systems, the cgroups hierarchies are setup early and just
once by the node controller, so, other than number of cgroups, all
information in /proc/cgroups remain same for the system uptime. Let's
remove the cgroup_mutex usage on reading /proc/cgroups. There is a
chance of inconsistent number of cgroups for co-mounted cgroups while
printing the information from /proc/cgroups but that is not a big
issue. In addition /proc/cgroups is a v1 specific interface, so the
dependency on it should reduce over time.

The main motivation for removing the cgroup_mutex from /proc/cgroups is
to reduce the avenues of its contention. On our fleet, we have observed
buggy application hammering on /proc/cgroups and drastically slowing
down the node controller on the system which have many negative
consequences on other workloads running on the system.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index fd14a60379c1..81c9e0685948 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -659,11 +659,9 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
 	/*
-	 * ideally we don't want subsystems moving around while we do this.
-	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
-	 * subsys/hierarchy state.
+	 * Grab the subsystems state racily. No need to add avenue to
+	 * cgroup_mutex contention.
 	 */
-	mutex_lock(&cgroup_mutex);
 
 	for_each_subsys(ss, i)
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
@@ -671,7 +669,6 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
 
-	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

