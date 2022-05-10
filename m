From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH bpf-next 5/9] bpf: add bpf_map_lookup_percpu_elem() helper
Date: Tue, 10 May 2022 00:18:03 +0000
Message-ID: <20220510001807.4132027-6-yosryahmed@google.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PLe94BZhE80q/pDQVvt5DmK8lXFEEEfCjMN3zuEnNPw=;
        b=b2rDa5+JQZQE63OVUadnzrDA9sRT5AyfXJyIIB31LrDJUWYPfnBVOfa5ojXs9imp6d
         DwF4Awnj/fUwKBhjAsgQY8m/yjkmSpC8h+esfZ2DRrbYeFr9Z/TmnLxUNToiDS3GuWhL
         I1CZcBuzvF+TZLDnC8IEwjt7q1mTj3TCig5j9p1Ib8ZD2Ruj1aVOM/uCMLOLMW0lhB+V
         JFmWTSNEtcFtJ3hkLXygufK/9TBzOJNp+Fh6TscWo5hSpcL6vJVLjYxwh5He67lJ6S5P
         g9h25soVq8JfMXLQ4xTp/9u3XVMKLP8/QyHCB1uSKJk2RK02ZF3mB9ksJ9Py4vK/Ika7
         3aDA==
In-Reply-To: <20220510001807.4132027-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add a helper for bpf programs to lookup a percpu element for a cpu other
than the current one. This is useful for rstat flusher programs as they
get called to aggregate stats from different cpus, regardless of the
current cpu.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       |  9 +++++++++
 kernel/bpf/arraymap.c          | 11 ++++++++---
 kernel/bpf/hashtab.c           | 25 +++++++++++--------------
 kernel/bpf/helpers.c           | 26 ++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |  6 ++++++
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 7 files changed, 71 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bdb5298735ce..f6fa35ffe311 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1665,6 +1665,8 @@ int map_set_for_each_callback_args(struct bpf_verifier_env *env,
 				   struct bpf_func_state *caller,
 				   struct bpf_func_state *callee);
 
+void *bpf_percpu_hash_lookup(struct bpf_map *map, void *key, int cpu);
+void *bpf_percpu_array_lookup(struct bpf_map *map, void *key, int cpu);
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fce5535579d6..015ed402c642 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1553,6 +1553,14 @@ union bpf_attr {
  * 		Map value associated to *key*, or **NULL** if no entry was
  * 		found.
  *
+ * void *bpf_map_lookup_percpu_elem(struct bpf_map *map, const void *key, int cpu)
+ *	Description
+ *		Perform a lookup in percpu *map* for an entry associated to
+ *		*key* for the given *cpu*.
+ *	Return
+ *		Map value associated to *key* per *cpu*, or **NULL** if no entry
+ *		was found.
+ *
  * long bpf_map_update_elem(struct bpf_map *map, const void *key, const void *value, u64 flags)
  * 	Description
  * 		Add or update the value of the entry associated to *key* in
@@ -5169,6 +5177,7 @@ union bpf_attr {
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
 	FN(map_lookup_elem),		\
+	FN(map_lookup_percpu_elem),	\
 	FN(map_update_elem),		\
 	FN(map_delete_elem),		\
 	FN(probe_read),			\
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 7f145aefbff8..945dae4c20eb 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -230,8 +230,7 @@ static int array_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
-/* Called from eBPF program */
-static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
+void *bpf_percpu_array_lookup(struct bpf_map *map, void *key, int cpu)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	u32 index = *(u32 *)key;
@@ -239,7 +238,13 @@ static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
 	if (unlikely(index >= array->map.max_entries))
 		return NULL;
 
-	return this_cpu_ptr(array->pptrs[index & array->index_mask]);
+	return per_cpu_ptr(array->pptrs[index & array->index_mask], cpu);
+}
+
+/* Called from eBPF program */
+static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	return bpf_percpu_array_lookup(map, key, smp_processor_id());
 }
 
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 65877967f414..c6d4699d65e8 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2150,27 +2150,24 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.iter_seq_info = &iter_seq_info,
 };
 
-/* Called from eBPF program */
-static void *htab_percpu_map_lookup_elem(struct bpf_map *map, void *key)
+void *bpf_percpu_hash_lookup(struct bpf_map *map, void *key, int cpu)
 {
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l = __htab_map_lookup_elem(map, key);
 
-	if (l)
-		return this_cpu_ptr(htab_elem_get_ptr(l, map->key_size));
+	if (l) {
+		if (htab_is_lru(htab))
+			bpf_lru_node_set_ref(&l->lru_node);
+		return per_cpu_ptr(htab_elem_get_ptr(l, map->key_size), cpu);
+	}
 	else
 		return NULL;
 }
 
-static void *htab_lru_percpu_map_lookup_elem(struct bpf_map *map, void *key)
+/* Called from eBPF program */
+static void *htab_percpu_map_lookup_elem(struct bpf_map *map, void *key)
 {
-	struct htab_elem *l = __htab_map_lookup_elem(map, key);
-
-	if (l) {
-		bpf_lru_node_set_ref(&l->lru_node);
-		return this_cpu_ptr(htab_elem_get_ptr(l, map->key_size));
-	}
-
-	return NULL;
+	return bpf_percpu_hash_lookup(map, key, smp_processor_id());
 }
 
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value)
@@ -2279,7 +2276,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
-	.map_lookup_elem = htab_lru_percpu_map_lookup_elem,
+	.map_lookup_elem = htab_percpu_map_lookup_elem,
 	.map_lookup_and_delete_elem = htab_lru_percpu_map_lookup_and_delete_elem,
 	.map_update_elem = htab_lru_percpu_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index d124eed97ad7..abed4e1737f6 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -45,6 +45,30 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
 	.arg2_type	= ARG_PTR_TO_MAP_KEY,
 };
 
+BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key,
+	   int, cpu)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_PERCPU_ARRAY:
+		return (unsigned long) bpf_percpu_array_lookup(map, key, cpu);
+	case BPF_MAP_TYPE_PERCPU_HASH:
+	case BPF_MAP_TYPE_LRU_PERCPU_HASH:
+		return (unsigned long) bpf_percpu_hash_lookup(map, key, cpu);
+	default:
+		return (unsigned long) NULL;
+	}
+}
+
+const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto = {
+	.func		= bpf_map_lookup_percpu_elem,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_MAP_KEY,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
@@ -1414,6 +1438,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 	switch (func_id) {
 	case BPF_FUNC_map_lookup_elem:
 		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		return &bpf_map_lookup_percpu_elem_proto;
 	case BPF_FUNC_map_update_elem:
 		return &bpf_map_update_elem_proto;
 	case BPF_FUNC_map_delete_elem:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d175b70067b3..2d7f7c9a970d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5879,6 +5879,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_TASK_STORAGE)
 			goto error;
 		break;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		if (map->map_type != BPF_MAP_TYPE_PERCPU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_LRU_PERCPU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_PERCPU_ARRAY)
+			goto error;
+		break;
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index fce5535579d6..015ed402c642 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1553,6 +1553,14 @@ union bpf_attr {
  * 		Map value associated to *key*, or **NULL** if no entry was
  * 		found.
  *
+ * void *bpf_map_lookup_percpu_elem(struct bpf_map *map, const void *key, int cpu)
+ *	Description
+ *		Perform a lookup in percpu *map* for an entry associated to
+ *		*key* for the given *cpu*.
+ *	Return
+ *		Map value associated to *key* per *cpu*, or **NULL** if no entry
+ *		was found.
+ *
  * long bpf_map_update_elem(struct bpf_map *map, const void *key, const void *value, u64 flags)
  * 	Description
  * 		Add or update the value of the entry associated to *key* in
@@ -5169,6 +5177,7 @@ union bpf_attr {
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
 	FN(map_lookup_elem),		\
+	FN(map_lookup_percpu_elem),	\
 	FN(map_update_elem),		\
 	FN(map_delete_elem),		\
 	FN(probe_read),			\
-- 
2.36.0.512.ge40c2bad7a-goog

