From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.11] cgroup: disallow cpuacct if sane_behavior
Date: Wed, 5 Jun 2013 19:46:26 -0700
Message-ID: <20130606024626.GT10693@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=d5s7nZWhF+q4zH4e4EbiP7Dgdl4/PnDRuios4sUofrI=;
        b=msK+hxspstfmpMYPIyF1O4muIBqc+6EM6FVWRgOiwMmOlqfGIS1KAhKGGVN73CM/5c
         7zSPAXcvAELcfUxun1dZ6wbZ7aVBBCB2Q0ST1riIBWkLoCcoV5qLuWBViwIq2tW1vRqK
         80xMQbPyB2WcSIDR5JJREyLUyNfP16Y2sEBeucHxQODcar3L/dgTWfdltRgEy1wfpqgb
         49e1XmilKIYDIEn6GOcYKzvy6Xls5prVuEAMmqLN1+3pFNqHfwjM0uK6ESP9QhahLmOp
         e3OVPCF5nPrjwblaLgyJD0CAiVmRWQ2OMWDPfDvnyiiJAKI2hpv6rqpqHUsTByxXoFFA
         M5lA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@openvz.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org

cpuacct causes duplicate accountings on the scheduler and cpu will
provide equivalent stats.  Optimizations for cases where cpu and
cpuacct are co-mounted are being worked on but we want to deprecate it
eventually.  Let's disallow cpuacct if __DEVEL__sane_behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/cgroup.h |    3 +++
 kernel/cgroup.c        |    5 +++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d0ad379..6c3bbdb 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -280,6 +280,9 @@ enum {
 	 * - memcg: use_hierarchy is on by default and the cgroup file for
 	 *   the flag is not created.
 	 *
+	 * - cpuacct: No longer supported.  cpu will have matching stats.
+	 *   Use those instead.
+	 *
 	 * The followings are planned changes.
 	 *
 	 * - release_agent will be disallowed once replacement notification
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bc53d50..5c746eb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1256,6 +1256,11 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			pr_err("cgroup: sane_behavior: clone_children is not allowed\n");
 			return -EINVAL;
 		}
+
+		if (test_bit(cpuacct_subsys_id, &opts->subsys_mask)) {
+			pr_err("cgroup: sane_behavior: cpuacct is no longer available, use stats from cpu instead\n");
+			return -EINVAL;
+		}
 	}
 
 	/*
