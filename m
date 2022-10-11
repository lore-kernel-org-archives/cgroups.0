From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] perf stat: Support old kernels for bperf cgroup counting
Date: Mon, 10 Oct 2022 22:28:08 -0700
Message-ID: <20221011052808.282394-1-namhyung@kernel.org>
References: <Y0Sx2KWX4gPlLytq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptih+RO6sVP3W/jBVYc29KEuxtFP8RFJxq2H7Lnlg7M=;
        b=RoB6MUgSotHIwjjtS/88cXgbrKPZSaYZ+eEQMxm65BA2KXats6SO7HK2nHMR58QCnI
         Z1TWj2ZmOiNAfJSMuHCKOur2hADW15ULjnSYzOkm4wA9cbN5OgOkSXL/EqoRdBmSjq39
         YqPAYT+3vttWdkVKHzH+dmBgIIf7y3Ps7KKy9ivND5wtO+CV6o87L4QCGIqJmpuhdJN3
         f8HFjxnpS0LQuV5e/X509t0CHIfRT0prGRrr67t2mXn2ceTOPvWc8QUc4A0a/H402Spb
         kI0nNxpqyAKe/j8u6Rs4fw8AcY7M6UI5ScpyDxvWgLHOBEuw5pFX8TnSfeuaBQuqF17V
         4MJA==
Sender: Namhyung Kim <namhyung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <Y0Sx2KWX4gPlLytq-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

The recent change in the cgroup will break the backward compatiblity in
the BPF program.  It should support both old and new kernels using BPF
CO-RE technique.

Like the task_struct->__state handling in the offcpu analysis, we can
check the field name in the cgroup struct.

Acked-by: Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c | 29 ++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
index 435a87556688..6a438e0102c5 100644
--- a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
+++ b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
@@ -43,6 +43,18 @@ struct {
 	__uint(value_size, sizeof(struct bpf_perf_event_value));
 } cgrp_readings SEC(".maps");
 
+/* new kernel cgroup definition */
+struct cgroup___new {
+	int level;
+	struct cgroup *ancestors[];
+} __attribute__((preserve_access_index));
+
+/* old kernel cgroup definition */
+struct cgroup___old {
+	int level;
+	u64 ancestor_ids[];
+} __attribute__((preserve_access_index));
+
 const volatile __u32 num_events = 1;
 const volatile __u32 num_cpus = 1;
 
@@ -50,6 +62,21 @@ int enabled = 0;
 int use_cgroup_v2 = 0;
 int perf_subsys_id = -1;
 
+static inline __u64 get_cgroup_v1_ancestor_id(struct cgroup *cgrp, int level)
+{
+	/* recast pointer to capture new type for compiler */
+	struct cgroup___new *cgrp_new = (void *)cgrp;
+
+	if (bpf_core_field_exists(cgrp_new->ancestors)) {
+		return BPF_CORE_READ(cgrp_new, ancestors[level], kn, id);
+	} else {
+		/* recast pointer to capture old type for compiler */
+		struct cgroup___old *cgrp_old = (void *)cgrp;
+
+		return BPF_CORE_READ(cgrp_old, ancestor_ids[level]);
+	}
+}
+
 static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
 {
 	struct task_struct *p = (void *)bpf_get_current_task();
@@ -77,7 +104,7 @@ static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
 			break;
 
 		// convert cgroup-id to a map index
-		cgrp_id = BPF_CORE_READ(cgrp, ancestors[i], kn, id);
+		cgrp_id = get_cgroup_v1_ancestor_id(cgrp, i);
 		elem = bpf_map_lookup_elem(&cgrp_idx, &cgrp_id);
 		if (!elem)
 			continue;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

