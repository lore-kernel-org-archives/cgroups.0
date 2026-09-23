Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB6B46E00C;
	Wed, 23 Sep 2026 20:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790196631; cv=none; b=Bviao2ItsvgWfl0mBB0k2iSaHqtpG4WCnoP/Kp80/lwZG1SKUSISudJX6h6evYbmyuaPSWz1/yiVDnNmRvt5lBvSQiRIKm2wGwKW0CIFScxpu8L3qFNpjdLpZ5exFX89sjOz/S648By/x8I5C0sydfTnIZF1Ep1yaxyP6RRsh+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790196631; c=relaxed/simple;
	bh=MskGHjHbIjETEcV/BKWqSQntnW/cB4NNLGxB66AjGlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QrLrbxuE87weN1VvnjJ+3eUuBKqVKPWs8JEOnGv10BLr8o6q2hXRvDOuv4FXrO1fpnMgC/4Qs64H+ekicHRvnk/QH5d2VLZr2wcdB3KMpWbV3jlKrvaV7lu83Cxi7+ReyB5I6gtWgms+fJEEB31M/J6xv2NoLzmi0vb1JGbsao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=JgUJey8G; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="JgUJey8G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=pq71hKY9CITGO0PY0X9S14UfdhrOXTBG3pXv8Sw1ZEQ=; b=JgUJey8GddKqalbhGfJloh7mm7
	ntFCpXWgECeO/MJ1agSHK8YF/0JnCErgCcPRFxTC4qxRCjCUioH2LEnYSXfSbaz8qFG9wW39zuGQ/
	/Pyabs4x336cVUWnChCFQN80aIMfLaCBaiFzLT5zSA/rvKj/f6bmOCLYI98jFXEtswi9avak881Qo
	hNv7Xw4LMiUfDtgYMWSv7cK6+29676GBok/QPFFukexTsYJYWS8WR9ZvM+L6CY9NMX6KgEL34ef9U
	dxxReZHbXPm+NVsJnRN5FC4F3mZ19Euyg1sn7lM2+t20G6Vt3pRKNHYA76Q8eCQw4lrJECDlyOUNJ
	Pa24DYfw==;
Received: from [151.115.150.205] (port=56224 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x9Tv6-00000003eZ4-1X3R;
	Wed, 23 Sep 2026 22:50:22 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD=20?= <mkoutny@suse.com>
Cc: brads@mainlining.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] cgroup: prevent use-after-free during namespace root replacement
Date: Wed, 23 Sep 2026 20:49:36 +0000
Message-ID: <20260923204935.2253203-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

copy_cgroup_ns() pins the creator's css_set, but cgroup_post_fork()
replaces root_cset and releases the namespace's reference to that css_set
after the child is visible to pid and pidfd lookups. A task joining the
new namespace can race with this replacement and access the original
css_set or its cgroup after they are freed.

KASAN reports:

  BUG: KASAN: slab-use-after-free in kernfs_get.part.0+0x47/0x60
  Write of size 4 at addr ff1100000379f320 by task ns-path-probe/69
   kernfs_walk_and_get_ns+0x1cc/0x280
   cgroup_get_from_path+0xfb/0x340
   nft_socket_cgroup_subtree_level+0x14/0x1a0

Keep the initial root pinned until namespace destruction, taking a
separate reference to the final root only when the roots differ.

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 include/linux/cgroup_namespace.h | 2 ++
 kernel/cgroup/cgroup.c           | 9 ++++++---
 kernel/cgroup/namespace.c        | 3 +++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup_namespace.h b/include/linux/cgroup_namespace.h
index 78a8418..f36ec1a 100644
--- a/include/linux/cgroup_namespace.h
+++ b/include/linux/cgroup_namespace.h
@@ -9,6 +9,8 @@ struct cgroup_namespace {
 	struct user_namespace	*user_ns;
 	struct ucounts		*ucounts;
 	struct css_set          *root_cset;
+	/* Preserve the root observed before cgroup_post_fork() updates it. */
+	struct css_set		*initial_root_cset;
 };
 
 extern struct cgroup_namespace init_cgroup_ns;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 227d097..c3cb258 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -247,6 +247,7 @@ struct cgroup_namespace init_cgroup_ns = {
 	.ns		= NS_COMMON_INIT(init_cgroup_ns),
 	.user_ns	= &init_user_ns,
 	.root_cset	= &init_css_set,
+	.initial_root_cset = &init_css_set,
 };
 
 static struct file_system_type cgroup2_fs_type;
@@ -7131,9 +7132,11 @@ void cgroup_post_fork(struct task_struct *child,
 	if (kargs->flags & CLONE_NEWCGROUP) {
 		struct css_set *rcset = child->nsproxy->cgroup_ns->root_cset;
 
-		get_css_set(cset);
-		child->nsproxy->cgroup_ns->root_cset = cset;
-		put_css_set(rcset);
+		/* Both possible roots must remain pinned for namespace readers. */
+		if (rcset != cset) {
+			get_css_set(cset);
+			WRITE_ONCE(child->nsproxy->cgroup_ns->root_cset, cset);
+		}
 	}
 
 	/* Cgroup has to be killed so take down child immediately. */
diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
index ea4ee13..1153ea4 100644
--- a/kernel/cgroup/namespace.c
+++ b/kernel/cgroup/namespace.c
@@ -37,6 +37,8 @@ void free_cgroup_ns(struct cgroup_namespace *ns)
 {
 	ns_tree_remove(ns);
 	put_css_set(ns->root_cset);
+	if (ns->initial_root_cset != ns->root_cset)
+		put_css_set(ns->initial_root_cset);
 	dec_cgroup_namespaces(ns->ucounts);
 	put_user_ns(ns->user_ns);
 	ns_common_free(ns);
@@ -84,6 +86,7 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
 	new_ns->user_ns = get_user_ns(user_ns);
 	new_ns->ucounts = ucounts;
 	new_ns->root_cset = cset;
+	new_ns->initial_root_cset = cset;
 
 	ns_tree_add(new_ns);
 	return new_ns;
-- 
2.47.3

