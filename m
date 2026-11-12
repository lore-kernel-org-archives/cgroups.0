Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794504484;
	b=sAA3hkkA/mHra/geWXIw+/IpVOT03e8lInyMkDNd7Ur4PGGwaYMsy/BNpH6Fv5hDPFW7
	 xBGZfUQnRb9o9CGrNBVM78ItaXJjJ68iv5QSVDjsPEAziEeYPSpMlMBrdasZFMcurzYKx
	 XKPYSLQpOooA6g30EylDcg3H9ddOv+Dt+3IrQLnkZ9AB5AiK2S69eazGuG8CCZ4gA5SSf
	 DW6ymiX66+KqeWADnyUGS0MfHHN5AdNa3zLa52UJh9GhO3OQfaOC5U1A2sXOerW3nFd8T
	 TmPjAFQSxdxPAl8zVb5s6rmPILrep22MEO1CvuOGPNCf8tSv+bxr+ioABzw5586cQXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794504484;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FclGLhWBTBuoPY0ZcoiAtTfjT5JxlUe1eeWPx4ix/ww=;
	b=OIjLV1GfltFM8A6mqJ0+8rI0mjDnRIXqJJPYJhSmr2VMfYd7IWIsPhSLNW2ACoSK+M2Z
	 7kVOvlbcC0j42XUVjZfRz1tfS6GPvgcWmgPQ7ARJ61p27y+gULMs4AnfQFoOMgkGtfn/h
	 En3SVgwTlpAWPR63ZK/ugsPxR59EkgCwI67zRa4HVNaKe8X56I+Wd1u1UlvHdkOhxe+PJ
	 FpAgxnJuLTquK6U4Izq/XkF6Yjortb+N0PVB2fkHtAxHD5fZWUO3Aqe1taKkWAWN+sw33
	 Ah6kYNFszBCBGT1UO6iM9R4BIosQiHb15SQOCEbgN62zMUsFH/ZR+luG4v8UnocRuPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Xzu/3aCs";
	arc=none smtp.remote-ip=95.215.58.184
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB00760A5BCA
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 17:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB00760A5BCA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Xzu/3aCs
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=reZCo5E7Rk3bQbCaPizi+yCP2wpim2UFM4B+RH4gf6Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794504481; v=1; x=1795109281;
 b=Xzu/3aCs3sevUpeF7wTtDkEt1VK5v5ISGrzmb/i7xG1a6TrTkLRt2434KJUCocoS53BBSOaJ
 kln9TDL4txGUVul2tNZEryDFX5kvibWaZyZOZ37NEpJ5w7J2o3PK42pZff/BN7kGvGLIhK4/ZD1
 RWxcBN4XYguqkQvMIJWXMyoY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e7680352f479124f;
	Thu, 12 Nov 2026 17:28:00 +0000
X-Mizu-Trace-ID: e7680352f479124f
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Amery Hung <ameryhung@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 3/3] bpf, cgroup: Protect cgroup_bpf state with its own mutex
Date: Thu, 12 Nov 2026 09:27:15 -0800
Message-ID: <20261112172721.440275-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112172721.440275-1-shakeel.butt@linux.dev>
References: <20261112172721.440275-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the Meta fleet, tasks that only read or free cgroup bpf state often
wait minutes for cgroup_mutex:

- In one day, hung-task reports (blocked over 120 seconds) showed this
  for BPF_PROG_QUERY on 1,075 hosts, the cgroup bpf release work on 458
  hosts and link info on 94 hosts.
- The query callers are a container manager's health checks.  Over 30
  days, 6,700 hosts reported one hung.  The typical wait is 11 minutes,
  the longest 75 minutes.
- The cgroup_mutex holder is almost always a cgroup mkdir or rmdir that
  is waiting for kernfs_rwsem.

Only attach, detach and replace need cgroup_mutex.  They update the
effective arrays of all descendants, so the hierarchy must not change.

Add cgroup_bpf_mutex for the bpf state.  Attach, detach and replace take
cgroup_mutex and then cgroup_bpf_mutex.  Everything else (query, link
info, the release work, dropping an LSM attach type, freeing a cgroup
storage map) takes only cgroup_bpf_mutex.

cgroup_bpf_inherit() still runs at mkdir with only cgroup_mutex, so mkdir
never waits for cgroup_bpf_mutex.  It writes the new cgroup, which no one
else can see yet.  What it reads from the ancestors changes only under
cgroup_mutex, and the release work can't run for them because they are
online.

The release work no longer waits for cgroup_mutex, so attach must check
that the cgroup is still alive.  The previous patch does that.

With a test delay that makes a mkdir hold cgroup_mutex for 5 seconds,
BPF_PROG_QUERY and link info now return in under a millisecond instead
of 4.6 seconds.  Attach and detach still wait.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/bpf-cgroup-defs.h |   1 +
 include/linux/bpf-cgroup.h      |   3 +
 kernel/bpf/cgroup.c             | 137 +++++++++++++++++++++-----------
 kernel/bpf/local_storage.c      |   8 +-
 4 files changed, 102 insertions(+), 47 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 0147b8bec973..671f27ba6a62 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -53,6 +53,7 @@ enum cgroup_bpf_attach_type {
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
+/* Locking: see cgroup_bpf_mutex in kernel/bpf/cgroup.c */
 struct cgroup_bpf {
 	/* array of effective progs in this cgroup */
 	struct bpf_prog_array __rcu *effective[MAX_CGROUP_BPF_ATTACH_TYPE];
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 02ef7f899b3d..dfa7a75507c9 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -421,6 +421,9 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
 	__ret;								       \
 })
 
+/* Take cgroup_mutex first if you need both.  See kernel/bpf/cgroup.c. */
+void cgroup_bpf_lock(void);
+void cgroup_bpf_unlock(void);
 int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype, struct bpf_prog *prog);
 int cgroup_bpf_prog_detach(const union bpf_attr *attr,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 334237096759..ae082ac86130 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -206,13 +206,53 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 	return ret;
 }
 
+/*
+ * cgroup_bpf_mutex protects the bpf state of all cgroups: prog lists,
+ * effective arrays, flags, revisions, storage lists, link->cgroup,
+ * link->map of struct_ops links and cgroup_lsm_atype[].
+ *
+ * Take cgroup_mutex first if you need both.  This mutex doesn't keep a
+ * cgroup alive or the hierarchy stable.  Attach, detach and replace walk
+ * the descendants, so they take both.  Everything else takes only this one.
+ *
+ * cgroup_bpf_inherit() runs at mkdir with only cgroup_mutex.  That's safe:
+ * it writes the new cgroup, which no one else can see yet, and what it
+ * reads from the ancestors changes only under cgroup_mutex.  The ancestors
+ * are online, and only rmdir, which needs cgroup_mutex, starts a release.
+ */
+static DEFINE_MUTEX(cgroup_bpf_mutex);
+
+#define cgroup_bpf_held()	lockdep_is_held(&cgroup_bpf_mutex)
+
+void cgroup_bpf_lock(void)
+{
+	mutex_lock(&cgroup_bpf_mutex);
+}
+
+void cgroup_bpf_unlock(void)
+{
+	mutex_unlock(&cgroup_bpf_mutex);
+}
+
+static void cgroup_bpf_lock_hierarchy(void)
+{
+	cgroup_lock();
+	mutex_lock(&cgroup_bpf_mutex);
+}
+
+static void cgroup_bpf_unlock_hierarchy(void)
+{
+	mutex_unlock(&cgroup_bpf_mutex);
+	cgroup_unlock();
+}
+
 #ifdef CONFIG_BPF_LSM
 static enum cgroup_bpf_attach_type
 bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
 {
 	int i;
 
-	lockdep_assert_held(&cgroup_mutex);
+	lockdep_assert_held(&cgroup_bpf_mutex);
 
 	if (attach_type != BPF_LSM_CGROUP)
 		return to_cgroup_bpf_attach_type(attach_type);
@@ -233,7 +273,7 @@ void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
 {
 	int i = cgroup_atype - CGROUP_LSM_START;
 
-	lockdep_assert_held(&cgroup_mutex);
+	lockdep_assert_held(&cgroup_bpf_mutex);
 
 	if (!cgroup_lsm_atype[i].attach_btf_id) {
 		cgroup_lsm_atype[i].attach_btf_id = attach_btf_id;
@@ -249,13 +289,13 @@ void bpf_cgroup_atype_put(int cgroup_atype)
 {
 	int i = cgroup_atype - CGROUP_LSM_START;
 
-	cgroup_lock();
+	cgroup_bpf_lock();
 	if (--cgroup_lsm_atype[i].refcnt <= 0) {
 		WRITE_ONCE(cgroup_lsm_atype[i].returns_errno, true);
 		cgroup_lsm_atype[i].attach_btf_id = 0;
 	}
 	WARN_ON_ONCE(cgroup_lsm_atype[i].refcnt < 0);
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 }
 #else
 static enum cgroup_bpf_attach_type
@@ -459,7 +499,7 @@ static void cgroup_bpf_release(struct work_struct *work)
 
 	unsigned int atype;
 
-	cgroup_lock();
+	cgroup_bpf_lock();
 
 	for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
 		struct hlist_head *progs = &cgrp->bpf.progs[atype];
@@ -480,7 +520,7 @@ static void cgroup_bpf_release(struct work_struct *work)
 		}
 		old_array = rcu_dereference_protected(
 				cgrp->bpf.effective[atype],
-				lockdep_is_held(&cgroup_mutex));
+				cgroup_bpf_held());
 		bpf_cgroup_array_free(old_array, atype);
 	}
 
@@ -489,7 +529,7 @@ static void cgroup_bpf_release(struct work_struct *work)
 		bpf_cgroup_storage_free(storage);
 	}
 
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 
 	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
 		cgroup_bpf_put(p);
@@ -665,7 +705,9 @@ static void activate_effective_progs(struct cgroup *cgrp,
 				     enum cgroup_bpf_attach_type atype,
 				     struct bpf_prog_array *old_array)
 {
+	/* cgroup_bpf_inherit() holds only cgroup_mutex, see cgroup_bpf_mutex */
 	old_array = rcu_replace_pointer(cgrp->bpf.effective[atype], old_array,
+					lockdep_is_held(&cgroup_bpf_mutex) ||
 					lockdep_is_held(&cgroup_mutex));
 	/* free prog array after grace period, since __cgroup_bpf_run_*()
 	 * might be still walking the array
@@ -687,6 +729,9 @@ static int cgroup_bpf_inherit(struct cgroup *cgrp)
 	struct cgroup *p;
 	int ret, i;
 
+	/* See the comment above cgroup_bpf_mutex */
+	lockdep_assert_held(&cgroup_mutex);
+
 	ret = percpu_ref_init(&cgrp->bpf.refcnt, cgroup_bpf_release_fn, 0,
 			      GFP_KERNEL);
 	if (ret)
@@ -747,6 +792,8 @@ static int update_effective_progs(struct cgroup *cgrp,
 	struct cgroup_subsys_state *css;
 	int err;
 
+	lockdep_assert_held(&cgroup_bpf_mutex);
+
 	/* allocate and recompute effective prog arrays */
 	css_for_each_descendant_pre(css, &cgrp->self) {
 		struct cgroup *desc = container_of(css, struct cgroup, self);
@@ -954,7 +1001,7 @@ static int insert_pl_to_hlist(struct bpf_prog_list *pl, struct hlist_head *progs
  * @revision: bpf_prog_list revision
  *
  * Exactly one of @prog or @link can be non-null.
- * Must be called with cgroup_mutex held.
+ * Must be called with cgroup_mutex and cgroup_bpf_mutex held.
  */
 static int __cgroup_bpf_attach(struct cgroup *cgrp,
 			       struct bpf_prog *prog, struct bpf_prog *replace_prog,
@@ -1100,10 +1147,10 @@ static int cgroup_bpf_attach(struct cgroup *cgrp,
 {
 	int ret;
 
-	cgroup_lock();
+	cgroup_bpf_lock_hierarchy();
 	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link, type, flags,
 				  id_or_fd, revision);
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 	return ret;
 }
 
@@ -1181,7 +1228,7 @@ static void replace_effective_prog(struct cgroup *cgrp,
 
 		progs = rcu_dereference_protected(
 				desc->bpf.effective[atype],
-				lockdep_is_held(&cgroup_mutex));
+				cgroup_bpf_held());
 		item = &progs->items[pos];
 		prog_list_replace_item(pl, item);
 	}
@@ -1209,7 +1256,7 @@ static bool cgroup_bpf_storages_compatible(struct bpf_prog *old_prog,
  * @new_prog: &struct bpf_prog for the target BPF program with its refcnt
  *            incremented
  *
- * Must be called with cgroup_mutex held.
+ * Must be called with cgroup_mutex and cgroup_bpf_mutex held.
  */
 static int __cgroup_bpf_replace(struct cgroup *cgrp,
 				struct bpf_cgroup_link *link,
@@ -1257,7 +1304,7 @@ static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,
 
 	cg_link = container_of(link, struct bpf_cgroup_link, link);
 
-	cgroup_lock();
+	cgroup_bpf_lock_hierarchy();
 	/* link might have been auto-released by dying cgroup, so fail */
 	if (!cg_link->cgroup) {
 		ret = -ENOLINK;
@@ -1269,7 +1316,7 @@ static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,
 	}
 	ret = __cgroup_bpf_replace(cg_link->cgroup, cg_link, new_prog);
 out_unlock:
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 	return ret;
 }
 
@@ -1340,7 +1387,7 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog_list *pl,
 
 		progs = rcu_dereference_protected(
 				desc->bpf.effective[atype],
-				lockdep_is_held(&cgroup_mutex));
+				cgroup_bpf_held());
 
 		/* Remove the program from the array */
 		WARN_ONCE(bpf_cgroup_array_delete_safe_at(progs, pos, atype),
@@ -1358,7 +1405,7 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog_list *pl,
  * @revision: bpf_prog_list revision
  *
  * At most one of @prog or @link can be non-NULL.
- * Must be called with cgroup_mutex held.
+ * Must be called with cgroup_mutex and cgroup_bpf_mutex held.
  */
 static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 			       struct bpf_cgroup_link *link, enum bpf_attach_type type,
@@ -1428,13 +1475,13 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 {
 	int ret;
 
-	cgroup_lock();
+	cgroup_bpf_lock_hierarchy();
 	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type, revision);
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 	return ret;
 }
 
-/* Must be called with cgroup_mutex held to avoid races. */
+/* Must be called with cgroup_bpf_mutex held. */
 static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			      union bpf_attr __user *uattr, u32 uattr_size)
 {
@@ -1488,7 +1535,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	for (atype = from_atype; atype <= to_atype; atype++) {
 		if (effective_query) {
 			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
-							      lockdep_is_held(&cgroup_mutex));
+							      cgroup_bpf_held());
 			total_cnt += bpf_cgroup_array_length(effective, atype);
 		} else {
 			total_cnt += prog_list_length(&cgrp->bpf.progs[atype], NULL);
@@ -1518,7 +1565,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	for (atype = from_atype; atype <= to_atype && total_cnt; atype++) {
 		if (effective_query) {
 			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
-							      lockdep_is_held(&cgroup_mutex));
+							      cgroup_bpf_held());
 			cnt = min_t(int, bpf_cgroup_array_length(effective, atype), total_cnt);
 			ret = bpf_cgroup_array_copy_to_user(effective, prog_ids, cnt, atype);
 		} else {
@@ -1559,9 +1606,9 @@ static int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 {
 	int ret;
 
-	cgroup_lock();
+	cgroup_bpf_lock();
 	ret = __cgroup_bpf_query(cgrp, attr, uattr, uattr_size);
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 	return ret;
 }
 
@@ -1629,11 +1676,11 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
 	if (!cg_link->cgroup)
 		return;
 
-	cgroup_lock();
+	cgroup_bpf_lock_hierarchy();
 
 	/* re-check cgroup under lock again */
 	if (!cg_link->cgroup) {
-		cgroup_unlock();
+		cgroup_bpf_unlock_hierarchy();
 		return;
 	}
 
@@ -1645,7 +1692,7 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
 	cg = cg_link->cgroup;
 	cg_link->cgroup = NULL;
 
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 
 	cgroup_put(cg);
 }
@@ -1672,10 +1719,10 @@ static void bpf_cgroup_link_show_fdinfo(const struct bpf_link *link,
 		container_of(link, struct bpf_cgroup_link, link);
 	u64 cg_id = 0;
 
-	cgroup_lock();
+	cgroup_bpf_lock();
 	if (cg_link->cgroup)
 		cg_id = cgroup_id(cg_link->cgroup);
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 
 	seq_printf(seq,
 		   "cgroup_id:\t%llu\n"
@@ -1691,10 +1738,10 @@ static int bpf_cgroup_link_fill_link_info(const struct bpf_link *link,
 		container_of(link, struct bpf_cgroup_link, link);
 	u64 cg_id = 0;
 
-	cgroup_lock();
+	cgroup_bpf_lock();
 	if (cg_link->cgroup)
 		cg_id = cgroup_id(cg_link->cgroup);
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 
 	info->cgroup.cgroup_id = cg_id;
 	info->cgroup.attach_type = link->attach_type;
@@ -2971,11 +3018,11 @@ static int __cgroup_struct_ops_link_detach(struct bpf_link *link, bool wake_poll
 	struct bpf_map *map;
 	struct cgroup *cgrp;
 
-	cgroup_lock();
+	cgroup_bpf_lock_hierarchy();
 
 	cgrp = cg_link->cgroup;
 	if (!cgrp) {
-		cgroup_unlock();
+		cgroup_bpf_unlock_hierarchy();
 		return 0;
 	}
 
@@ -2987,7 +3034,7 @@ static int __cgroup_struct_ops_link_detach(struct bpf_link *link, bool wake_poll
 			break;
 	}
 	if (WARN_ON_ONCE(!pl)) {
-		cgroup_unlock();
+		cgroup_bpf_unlock_hierarchy();
 		return -ENOENT;
 	}
 
@@ -3005,7 +3052,7 @@ static int __cgroup_struct_ops_link_detach(struct bpf_link *link, bool wake_poll
 	kfree(pl);
 	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
 
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 
 	return 0;
 }
@@ -3028,15 +3075,15 @@ static void cgroup_struct_ops_link_show_fdinfo(const struct bpf_link *link, stru
 	struct bpf_cgroup_link *cg_link =
 		container_of(link, struct bpf_cgroup_link, link);
 
-	cgroup_lock();
+	cgroup_bpf_lock();
 	if (!cg_link->cgroup) {
-		cgroup_unlock();
+		cgroup_bpf_unlock();
 		return;
 	}
 
 	seq_printf(seq, "map_id:\t%u\n", cg_link->map->id);
 	seq_printf(seq, "cgroup_id:\t%llu\n", cgroup_id(cg_link->cgroup));
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 }
 
 static int cgroup_struct_ops_link_fill_link_info(const struct bpf_link *link,
@@ -3044,15 +3091,15 @@ static int cgroup_struct_ops_link_fill_link_info(const struct bpf_link *link,
 {
 	struct bpf_cgroup_link *cg_link = container_of(link, struct bpf_cgroup_link, link);
 
-	cgroup_lock();
+	cgroup_bpf_lock();
 	if (!cg_link->cgroup) {
-		cgroup_unlock();
+		cgroup_bpf_unlock();
 		return 0;
 	}
 
 	info->struct_ops.map_id = cg_link->map->id;
 	info->struct_ops.cgroup_id = cgroup_id(cg_link->cgroup);
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 	return 0;
 }
 
@@ -3070,7 +3117,7 @@ static int cgroup_struct_ops_link_update(struct bpf_link *link, struct bpf_map *
 	if (!bpf_struct_ops_valid_to_reg(new_map))
 		return -EINVAL;
 
-	cgroup_lock();
+	cgroup_bpf_lock_hierarchy();
 
 	cgrp = cg_link->cgroup;
 	if (!cgrp) {
@@ -3103,7 +3150,7 @@ static int cgroup_struct_ops_link_update(struct bpf_link *link, struct bpf_map *
 	cgrp->bpf.revisions[atype]++;
 
 out:
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 	return err;
 }
 
@@ -3175,7 +3222,7 @@ int cgroup_bpf_struct_ops_attach(struct bpf_map *map, const union bpf_attr *attr
 	atype = bpf_struct_ops_map_cgroup_atype(map);
 	progs = &cgrp->bpf.progs[atype];
 
-	cgroup_lock();
+	cgroup_bpf_lock_hierarchy();
 
 	/* See the cgroup_is_dead() check in __cgroup_bpf_attach() */
 	if (cgroup_is_dead(cgrp)) {
@@ -3218,12 +3265,12 @@ int cgroup_bpf_struct_ops_attach(struct bpf_map *map, const union bpf_attr *attr
 	cgrp->bpf.revisions[atype]++;
 	static_branch_inc(&cgroup_bpf_enabled_key[atype]);
 
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 
 	return bpf_link_settle(&link_primer);
 
 unlock:
-	cgroup_unlock();
+	cgroup_bpf_unlock_hierarchy();
 
 cleanup:
 	kfree(pl);
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 83cd527a2542..2cfbddeb1c7e 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -345,14 +345,18 @@ static void cgroup_storage_map_free(struct bpf_map *_map)
 	struct list_head *storages = &map->list;
 	struct bpf_cgroup_storage *storage, *stmp;
 
-	cgroup_lock();
+	/*
+	 * Attach and cgroup_bpf_release() change the same cgroup storage
+	 * lists under other maps' locks, so take cgroup_bpf_mutex.
+	 */
+	cgroup_bpf_lock();
 
 	list_for_each_entry_safe(storage, stmp, storages, list_map) {
 		bpf_cgroup_storage_unlink(storage);
 		bpf_cgroup_storage_free(storage);
 	}
 
-	cgroup_unlock();
+	cgroup_bpf_unlock();
 
 	WARN_ON(!RB_EMPTY_ROOT(&map->root));
 	WARN_ON(!list_empty(&map->list));
-- 
2.53.0-Meta

