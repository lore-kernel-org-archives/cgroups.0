Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5F83ACF0F;
	Thu, 24 Sep 2026 11:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248335; cv=none; b=PvgBIM4KOJQV3z4GCewVQgOrszywyEsfAQdRHngiPl5G3yPzZiKihI8E7lt8ndc09kb7IkHTA6B+5N5CzcHdnQodkTRqbUrBhmuSWE4uJYOoVDDryy4miWtv21e1/kE0SeMeOveoXOnOC+zGowUyZC89ej5OblXlqLHgHqXIXjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248335; c=relaxed/simple;
	bh=R98odZAY++6LdgzPJiYgkeT2qsirtAoW5ulT9+MxFs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pqzOQbCWzTMbC92OKbvTGA19XMOGaTp6SXdlx35ES7O5C0Xn8J4iJy8DWe0Qml2iwVO3sPBoXJ1qioaYxPCZ18aqQpWbSaJiGQZCFBBlgOriFF81HktK7r278KrjOiglRV2qUGzeYUWohjxD7hQRfMUrZAFOPYVZIUHfrs0b+Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=LCULTzdf; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="LCULTzdf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=syNMsSRIXMzNTK8CHqG6k+F/HIohW8kB3DavqYIhYUI=; b=LCULTzdf8263borXvSDQI5jy3W
	rw74Sgai27+9eCCyh3Fh/MtSuDYm1mDtL1Hv8N0ziN2UFySWCo92acZcIJR+fCsyGsWRo57TQ9dlS
	ceqEQ5IzydrTme3QPgWkxv8NHYQu3qWe4zUOatc0R3B09ZNkynplM4tMr3CkNIih5KaYcP3oyNKtX
	csBf5i+yyfyTi1IZPwGpnQyzjL/omgKzKYsbvI5GW2IeZgaYstsejGzkVKWF9HxxISyADdFJEGkWJ
	+38vM50tpb5seSecjGHOpEWGNDjtYCloCrtvR3DddPkp+Ayd2CndOmV/RXj0L3s5MB1MdQaki5E6i
	DCjj4uKg==;
Received: from [151.115.150.205] (port=58226 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x9hN5-000000047uG-0ty9;
	Thu, 24 Sep 2026 13:12:11 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD=20?= <mkoutny@suse.com>
Cc: brads@mainlining.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2] cgroup: prevent css_set UAF after namespace publication
Date: Thu, 24 Sep 2026 11:10:37 +0000
Message-ID: <20260924111036.3330268-2-Jeremy.Jean@oss.cyber.gouv.fr>
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

copy_cgroup_ns() sets the root of a new cgroup namespace to the parent's
css_set. When the child is created in a different cgroup,
cgroup_post_fork() replaces that root with the child's css_set after the
namespace is visible.

Publishing the namespace before root_cset is final lets readers race with
cgroup_post_fork(). A reader can load the old root just before it is
replaced and its reference is dropped, then continue using the freed
css_set. KASAN reports:

  BUG: KASAN: slab-use-after-free in kernfs_get.part.0+0x47/0x60
  Write of size 4 at addr ff1100000379f320 by task ns-path-probe/69
   kernfs_walk_and_get_ns+0x1cc/0x280
   cgroup_get_from_path+0xfb/0x340
   nft_socket_cgroup_subtree_level+0x14/0x1a0

Finalize root_cset before adding the namespace to the tree. Allocate the
namespace ID at creation, add unshared namespaces after creation succeeds,
and only remove namespaces that were added.

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
Changes in v2:
- Finalize root_cset before publication.
- Defer tree insertion on fork.
- Handle unshare and failed forks.

v1: https://lore.kernel.org/all/20260923204935.2253203-2-Jeremy.Jean@oss.cyber.gouv.fr/

 kernel/cgroup/cgroup.c    | 22 +++++++++++++---------
 kernel/cgroup/namespace.c |  5 +++--
 kernel/nsproxy.c          |  5 +++++
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 227d09704ca5..78f6d235c19b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -7009,6 +7009,19 @@ int cgroup_can_fork(struct task_struct *child, struct kernel_clone_args *kargs)
 			goto out_revert;
 	} while_each_subsys_mask();
 
+	/* Publish a new cgroup namespace only after its root is final. */
+	if (kargs->flags & CLONE_NEWCGROUP) {
+		struct cgroup_namespace *ns = child->nsproxy->cgroup_ns;
+		struct css_set *rcset = ns->root_cset;
+
+		if (rcset != kargs->cset) {
+			get_css_set(kargs->cset);
+			ns->root_cset = kargs->cset;
+			put_css_set(rcset);
+		}
+		ns_tree_add_raw(ns);
+	}
+
 	return 0;
 
 out_revert:
@@ -7127,15 +7140,6 @@ void cgroup_post_fork(struct task_struct *child,
 		ss->fork(child);
 	} while_each_subsys_mask();
 
-	/* Make the new cset the root_cset of the new cgroup namespace. */
-	if (kargs->flags & CLONE_NEWCGROUP) {
-		struct css_set *rcset = child->nsproxy->cgroup_ns->root_cset;
-
-		get_css_set(cset);
-		child->nsproxy->cgroup_ns->root_cset = cset;
-		put_css_set(rcset);
-	}
-
 	/* Cgroup has to be killed so take down child immediately. */
 	if (unlikely(kill))
 		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, child, PIDTYPE_TGID);
diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
index ea4ee13936be..6c8ac36231d9 100644
--- a/kernel/cgroup/namespace.c
+++ b/kernel/cgroup/namespace.c
@@ -30,12 +30,14 @@ static struct cgroup_namespace *alloc_cgroup_ns(void)
 	ret = ns_common_init(new_ns);
 	if (ret)
 		return ERR_PTR(ret);
+	ns_tree_gen_id(new_ns);
 	return no_free_ptr(new_ns);
 }
 
 void free_cgroup_ns(struct cgroup_namespace *ns)
 {
-	ns_tree_remove(ns);
+	if (ns_tree_active(ns))
+		ns_tree_remove(ns);
 	put_css_set(ns->root_cset);
 	dec_cgroup_namespaces(ns->ucounts);
 	put_user_ns(ns->user_ns);
@@ -85,7 +87,6 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
 	new_ns->ucounts = ucounts;
 	new_ns->root_cset = cset;
 
-	ns_tree_add(new_ns);
 	return new_ns;
 }
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index d9d3d5973bf5..01c4dcf26993 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -238,6 +238,11 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 		goto out;
 	}
 
+#ifdef CONFIG_CGROUPS
+	if (flags & CLONE_NEWCGROUP)
+		ns_tree_add_raw((*new_nsp)->cgroup_ns);
+#endif
+
 out:
 	return err;
 }
-- 
2.47.3
