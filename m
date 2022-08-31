From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: add pids.peak interface for pids controller
Date: Wed, 31 Aug 2022 15:49:03 -0700
Message-ID: <20220831224903.454303-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=Ipn4iHe/yg+mxny4c01g7Po8t+R0aRPugnC10Z422Fk=;
        b=p2AFOEi5vGtb1tUhtbYlZ00F68mil8VLs1Lo6ATVSmPdszXyCTRaayeQPRhLYq+tb4
         2BU0EHsinRDXn7QQtVcOjaYfomxoAKYknKBD/vtrXVN00hCBJSPaxOJXQWffslTgrkw+
         9PlpVdZoxZ4xyvUiGv3eo5+6U+maaN+achNbh1vmJDxZuCtb86Zb55Qwz0ZVC8EUh0Xc
         AFvv8Eb0w/a3rfdHIS9BfzXyfcV9staK9ZdwJxgpBoIm0r+mhmLAXCtvBWpRphL2UbBQ
         klas0NiDWrY1Qstm9kx09OPX3GwNhdNGfUwlRwXQwp3forhXV6wko2ESn8fqSQ+kA0zN
         MG1g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

pids.peak tracks the high watermark of usage for number of pids. This
helps give a better baseline on which to set pids.max. Polling
pids.current isn't really feasible, since it would potentially miss
short-lived spikes.

This interface is analogous to memory.peak.

Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/pids.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index 511af87f685e..7695e60bcb40 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -47,6 +47,7 @@ struct pids_cgroup {
 	 */
 	atomic64_t			counter;
 	atomic64_t			limit;
+	int64_t				watermark;
 
 	/* Handle for "pids.events" */
 	struct cgroup_file		events_file;
@@ -85,6 +86,16 @@ static void pids_css_free(struct cgroup_subsys_state *css)
 	kfree(css_pids(css));
 }
 
+static void pids_update_watermark(struct pids_cgroup *p, int64_t nr_pids)
+{
+	/*
+	 * This is racy, but we don't need perfectly accurate tallying of
+	 * the watermark, and this lets us avoid extra atomic overhead.
+	 */
+	if (nr_pids > READ_ONCE(p->watermark))
+		WRITE_ONCE(p->watermark, nr_pids);
+}
+
 /**
  * pids_cancel - uncharge the local pid count
  * @pids: the pid cgroup state
@@ -128,8 +139,11 @@ static void pids_charge(struct pids_cgroup *pids, int num)
 {
 	struct pids_cgroup *p;
 
-	for (p = pids; parent_pids(p); p = parent_pids(p))
-		atomic64_add(num, &p->counter);
+	for (p = pids; parent_pids(p); p = parent_pids(p)) {
+		int64_t new = atomic64_add_return(num, &p->counter);
+
+		pids_update_watermark(p, new);
+	}
 }
 
 /**
@@ -156,6 +170,12 @@ static int pids_try_charge(struct pids_cgroup *pids, int num)
 		 */
 		if (new > limit)
 			goto revert;
+
+		/*
+		 * Not technically accurate if we go over limit somewhere up
+		 * the hierarchy, but that's tolerable for the watermark.
+		 */
+		pids_update_watermark(p, new);
 	}
 
 	return 0;
@@ -311,6 +331,14 @@ static s64 pids_current_read(struct cgroup_subsys_state *css,
 	return atomic64_read(&pids->counter);
 }
 
+static s64 pids_peak_read(struct cgroup_subsys_state *css,
+			  struct cftype *cft)
+{
+	struct pids_cgroup *pids = css_pids(css);
+
+	return READ_ONCE(pids->watermark);
+}
+
 static int pids_events_show(struct seq_file *sf, void *v)
 {
 	struct pids_cgroup *pids = css_pids(seq_css(sf));
@@ -331,6 +359,11 @@ static struct cftype pids_files[] = {
 		.read_s64 = pids_current_read,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+	{
+		.name = "peak",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_s64 = pids_peak_read,
+	},
 	{
 		.name = "events",
 		.seq_show = pids_events_show,
-- 
2.37.2.672.g94769d06f0-goog

