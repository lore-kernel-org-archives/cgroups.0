From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Wed, 21 Sep 2022 21:14:35 -0700
Message-ID: <20220922041435.709119-1-namhyung@kernel.org>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date;
        bh=z8K8JabQHxvWke1wLuSNQQKC0Zp7p6L1teN9v6xkDP8=;
        b=GZpjOi0ytaP2Q0bSJ8LGmg2pmd5KvjScrRWewswVinGIz3c/zhvb+1l/h2psEwXYaB
         rkShb2F5lWekTtP+LgZDTxg/pbOKMJWns05QG0lgHnwch5fCx0x5MstVObxATaeeFrw7
         lMg1vYE2HDHCqKbxqTeG+KIZlrwSfd+gSnxqUL/VxJAz1TLnACv0ommsz0DE04xROqJw
         EV+zodAOmFwbyqfZpBTpL5Fo8GqljGs583mTwmEvMiwZdeapXtJCQHHniv5KC1ONVs71
         /k1jbqX2Lf9MLz7KlT8Hyddd6h8YFEhEkSx0EGXYcNusCziPsYfnBb8M21UnUzOcxbtD
         1Dog==
Sender: Namhyung Kim <namhyung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The recent change in the cgroup will break the backward compatiblity in
the BPF program.  It should support both old and new kernels using BPF
CO-RE technique.

Like the task_struct->__state handling in the offcpu analysis, we can
check the field name in the cgroup struct.

Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Arnaldo, I think this should go through the cgroup tree since it depends
on the earlier change there.  I don't think it'd conflict with other
perf changes but please let me know if you see any trouble, thanks!

 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c | 29 ++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
index 488bd398f01d..4fe61043de04 100644
--- a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
+++ b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
@@ -43,12 +43,39 @@ struct {
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
 
 int enabled = 0;
 int use_cgroup_v2 = 0;
 
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
@@ -70,7 +97,7 @@ static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
 			break;
 
 		// convert cgroup-id to a map index
-		cgrp_id = BPF_CORE_READ(cgrp, ancestors[i], kn, id);
+		cgrp_id = get_cgroup_v1_ancestor_id(cgrp, i);
 		elem = bpf_map_lookup_elem(&cgrp_idx, &cgrp_id);
 		if (!elem)
 			continue;
-- 
2.37.3.968.ga6b4b080e4-goog

