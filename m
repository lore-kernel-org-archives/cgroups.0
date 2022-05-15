From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH bpf-next v2 4/7] bpf: add bpf rstat helpers
Date: Sun, 15 May 2022 02:35:01 +0000
Message-ID: <20220515023504.1823463-5-yosryahmed@google.com>
References: <20220515023504.1823463-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZEXZ/QXFU/CsHogdpQ7ZUfr7HZOPm4+DGygzngWTcUA=;
        b=VzJ/P7BnyJakBf09tKg7be86cJFVoS7xh60Ky83Z8pkc38jrbA7tPJVJDl0Eavb7sy
         6F0n1AOFaVZODO+9LdufUSnZkesvSAeupz5vDNamKzKRiTYHyTYai/WNfIMjDTAPfFNc
         Df5vg2u6DjfW9LoKqgIgpQaHkfgIflGFQUkUGRPCgIruOzPU5oIaRAlLNLehj6bhk8sk
         /DQRFoHI8weERppdosnMt3A10xwHidKLIGP7oJNURDjePFeKujvw6ulliemweAxKJGmQ
         tKuDQylnBRQnE0Vw3efTiKkc99W1cN+ZX4CZpBVRrBxeS97ufLx7uvBUZVh+hsinhp8C
         t4lQ==
In-Reply-To: <20220515023504.1823463-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add bpf_cgroup_rstat_updated() and bpf_cgroup_rstat_flush() helpers
to enable  bpf programs that collect and output cgroup stats
to communicate with the rstat frameworkto add a cgroup to the rstat
updated tree or trigger an rstat flush before reading stats.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       | 18 ++++++++++++++++++
 kernel/bpf/helpers.c           | 30 ++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  4 ++++
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++++
 6 files changed, 74 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5061ccd8b2dc..ca908a731cb4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2205,6 +2205,8 @@ extern const struct bpf_func_proto bpf_sock_map_update_proto;
 extern const struct bpf_func_proto bpf_sock_hash_update_proto;
 extern const struct bpf_func_proto bpf_get_current_cgroup_id_proto;
 extern const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto;
+extern const struct bpf_func_proto bpf_cgroup_rstat_updated_proto;
+extern const struct bpf_func_proto bpf_cgroup_rstat_flush_proto;
 extern const struct bpf_func_proto bpf_msg_redirect_hash_proto;
 extern const struct bpf_func_proto bpf_msg_redirect_map_proto;
 extern const struct bpf_func_proto bpf_sk_redirect_hash_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 968e3cb02580..022522174286 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5175,6 +5175,22 @@ union bpf_attr {
  * 	Return
  * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
  * 		was found or *cpu* is invalid.
+ *
+ * void bpf_cgroup_rstat_updated(struct cgroup *cgrp)
+ *	Description
+ *		Notify the rstat framework that bpf stats were updated for
+ *		*cgrp* on the current cpu. Directly calls cgroup_rstat_updated
+ *		with the given *cgrp* and the current cpu.
+ *	Return
+ *		0
+ *
+ * void bpf_cgroup_rstat_flush(struct cgroup *cgrp)
+ *	Description
+ *		Collect all per-cpu stats in *cgrp*'s subtree into global
+ *		counters and propagate them upwards. Directly calls
+ *		cgroup_rstat_flush_irqsafe with the given *cgrp*.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5373,6 +5389,8 @@ union bpf_attr {
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
 	FN(map_lookup_percpu_elem),     \
+	FN(cgroup_rstat_updated),	\
+	FN(cgroup_rstat_flush),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index d5f104a39092..88ed26cf45e2 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -416,6 +416,36 @@ const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BTF_ID_LIST_SINGLE(bpf_cgroup_btf_ids, struct, cgroup)
+
+BPF_CALL_1(bpf_cgroup_rstat_updated, struct cgroup *, cgrp)
+{
+	cgroup_rstat_updated(cgrp, smp_processor_id());
+	return 0;
+}
+
+const struct bpf_func_proto bpf_cgroup_rstat_updated_proto = {
+	.func		= bpf_cgroup_rstat_updated,
+	.gpl_only	= false,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_cgroup_btf_ids[0],
+};
+
+BPF_CALL_1(bpf_cgroup_rstat_flush, struct cgroup *, cgrp)
+{
+	cgroup_rstat_flush_irqsafe(cgrp);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_cgroup_rstat_flush_proto = {
+	.func		= bpf_cgroup_rstat_flush,
+	.gpl_only	= false,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_cgroup_btf_ids[0],
+};
+
 #ifdef CONFIG_CGROUP_BPF
 
 BPF_CALL_2(bpf_get_local_storage, struct bpf_map *, map, u64, flags)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7141ca8a1c2d..e5a4f1b6e00d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1255,6 +1255,10 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_current_cgroup_id_proto;
 	case BPF_FUNC_get_current_ancestor_cgroup_id:
 		return &bpf_get_current_ancestor_cgroup_id_proto;
+	case BPF_FUNC_cgroup_rstat_updated:
+		return &bpf_cgroup_rstat_updated_proto;
+	case BPF_FUNC_cgroup_rstat_flush:
+		return &bpf_cgroup_rstat_flush_proto;
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 096625242475..9e2b08557a6f 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -633,6 +633,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct cgroup',
     ]
     known_types = {
             '...',
@@ -682,6 +683,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct cgroup',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 968e3cb02580..022522174286 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5175,6 +5175,22 @@ union bpf_attr {
  * 	Return
  * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
  * 		was found or *cpu* is invalid.
+ *
+ * void bpf_cgroup_rstat_updated(struct cgroup *cgrp)
+ *	Description
+ *		Notify the rstat framework that bpf stats were updated for
+ *		*cgrp* on the current cpu. Directly calls cgroup_rstat_updated
+ *		with the given *cgrp* and the current cpu.
+ *	Return
+ *		0
+ *
+ * void bpf_cgroup_rstat_flush(struct cgroup *cgrp)
+ *	Description
+ *		Collect all per-cpu stats in *cgrp*'s subtree into global
+ *		counters and propagate them upwards. Directly calls
+ *		cgroup_rstat_flush_irqsafe with the given *cgrp*.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5373,6 +5389,8 @@ union bpf_attr {
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
 	FN(map_lookup_percpu_elem),     \
+	FN(cgroup_rstat_updated),	\
+	FN(cgroup_rstat_flush),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.36.0.550.gb090851708-goog

