From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/7] cgroup: introduce cgroup_parse_percentage
Date: Mon, 8 Apr 2019 14:45:35 -0700
Message-ID: <20190408214539.2705660-4-songliubraving@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=PeE9Rwo7wGOWQ5q9OAqfNdhcUhps+PHukzw37s+pWWU=;
 b=MhNsOP+MRfkIrNIaqiAHzdp0fdKp6DRltSzGP2He0iJnV9QGWfHatu+4xGZBL6Mi+beM
 gg6zzRafbnNPUCUg/lfKa3/BvfIYL9UKl91oXdYV9n4uhgMe38zi64c/qqK5GLC/fQ2J
 B1wPlZ6idY8iKtHEpc/Umtl5ZaZmTdA4nP8= 
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, morten.rasmussen@arm.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>

This patch introduces a helper to parse percentage string to long
integer, with user selected scale:

   long cgroup_parse_percentage(char *tok, unsigned long base)

Valid tok could be integer 0 to 100, decimal 0.00 to 100.00, or "max".
A tok of "max"is same as "100".

Base is the desire output scale for input "1".

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup/cgroup.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 81f58b4a5418..b28f8a41c970 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -110,6 +110,7 @@ int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cftype *cfts);
 void cgroup_file_notify(struct cgroup_file *cfile);
+long cgroup_parse_percentage(char *tok, unsigned long base);
 
 int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b0df96132476..2e48840ff613 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3967,6 +3967,43 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
 }
 
+/**
+ * cgroup_parse_percentage - parse percentage number
+ * @tok: input string contains the token. Valid values are "00.00" to
+ *       "100.00", or "max"
+ * @base: number "1" in desired output scale
+ *
+ * Returns:
+ *    @base * 100 for "max";
+ *    @base * <0.00 to 100.00> for valid inputs;
+ *    -EINVAL for invalid input.
+ */
+long cgroup_parse_percentage(char *tok, unsigned long base)
+{
+	unsigned long val_int, val_frag;
+
+	if (strcmp(tok, "max") == 0) {
+		return base * 100;
+	} else if (sscanf(tok, "%lu.%02lu", &val_int, &val_frag) == 2) {
+		/* xx.1 yields val_frag = 1, while it should be 10 */
+		if (val_frag < 10 && strstr(tok, ".0") == NULL)
+			val_frag *= 10;
+		goto calculate_output;
+	} else if (sscanf(tok, "%lu", &val_int) == 1) {
+		val_frag = 0;
+		goto calculate_output;
+	} else {
+		return -EINVAL;
+	}
+
+calculate_output:
+	if (val_int > 100 || (val_int == 100 && val_frag > 0))
+		return -EINVAL;
+
+	/* round up val_frag by 0.5, to avoid repeated rounding down */
+	return (val_int * base) + div_u64((val_frag * 10 + 5) * base, 1000);
+}
+
 /**
  * css_next_child - find the next child of a given css
  * @pos: the current position (%NULL to initiate traversal)
-- 
2.17.1

