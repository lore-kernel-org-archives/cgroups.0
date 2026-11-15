Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755414;
	b=E9TClRPADR7ALa8SF6MucgkMIuAkjPndVn1bxeH4alSN9QbAaumPk5Mgj/7iq9CgNYVG
	 yT89LlpIwN/qdt01HgI80ucyscztDxSYP5YHsz93XY4Ek0puXFdZxd1Pbm213D1TMIS+A
	 dz8Ze0g7iQX9krXxKCf5U9G0P3n4nZrVZVoGLkiD+lEYL8Po+Bv7bBUCU75lqlyGtmH6Y
	 IRPigYRSVHQ+BnEM4JyzZ37IEO3Zr5UFu9QOHRQAE/LIjQxjZxF3YQ1ftkAbzCCdEI4O1
	 x6tDJKTyYWNfoYl9MhMtbvhM/U2dLuN8t0v9Ij3Un4QLczq7MZbJTX0BDX2DoyL177w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755414;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=eGGUUoDWezoH61vuB7bjTkJkeuRE15lGC86Qhoj1cWA=;
	b=w8HtCIrtsmKMgCcEHzL5+W5CwwKA9AxV0y0is6ca8ejaJi0fw49V1qj4uk27u2/0DU9K
	 nCPNw1SiBygX9oPiyaxQmqQFU0h4b1ca+Z1RnrAPS1dnjHWfMRc2Rq/yd/YdcvcwjGF2m
	 bNYNsTZEtp6lCXEGMPrrykHDUYowCVf/QaZN/GuaEktkeO3NEgNsArCSh+FxAJwp8qT06
	 0hc6sZ62ggmXIJj99SczGQUlyp/jpXDvEei5baZpASeDy0+JD0yB314nF59Npjh3+prG2
	 CaRqMB1EWuu3YIdMgM6+gckLVyBE6rnkx7HajWtX5b1PJAkLMWDSO791fXCv/GXhuMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUV2UKX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3D606A31E;
	Sun, 15 Nov 2026 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUV2UKX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661A31F000C4;
	Sun, 15 Nov 2026 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755414;
	bh=eGGUUoDWezoH61vuB7bjTkJkeuRE15lGC86Qhoj1cWA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GUV2UKX52jTlvG4MAjLtGvc7d7oXopyJfi8DACbmtAXhwW1udGofbt5NBnG3SDEFG
	 5XZInAURePG9W6g0tk5IiMWhdLevavLPV9cNOsSwSdB+0IORQnZHqjRandZ48z47qt
	 cXcBfLzjo7U1IANXJ2gVCgMHZhTPR5ZlHIk7TsG2NwH/iAg9mgrSuYFSi8fRxAlp1T
	 FYUMoUTm6qYbgqG0fCwedVXp7wbnYceBjfTGFXsfHS7juNS0MfJWW5P13/IiBeTWHo
	 Ym2J6iZusW6c1Z3uCPC0Pog4/aA/Scp42cUA+HtwuPq6AxGAenVyWgdmSoZ0hcMAbf
	 dKcTr99T/EW0w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:35 +0000
Subject: [PATCH for-next v3 1/7] mm/memcontrol: defer obj_cgroup_release()
 to irq_work
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-1-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
X-Mailer: b4 0.16.0

obj_cgroup_put() can be called from any context.
__memcg_slab_free_hook() puts a per-object reference on
every accounted free, and draining a per-cpu objcg stock slot puts
the cached reference. When it drops the last reference,
obj_cgroup_release() takes objcg_lock, frees percpu memory
(pcpu_lock, via percpu_ref_exit()) and calls kfree_rcu(). Each of
these can deadlock when the current context interrupted a holder of
the respective lock.

Defer the release to irq_work. llist_add() and irq_work_queue() are
NMI-safe, and the irq_work runs in a context where acquiring a
spinlock is allowed.

Add a separate llist_node instead of reusing the list/rcu union
because the list stays linked until the deferred release. struct
obj_cgroup grows from 56 to 64 bytes, but both are served from
kmalloc-64, so no memory is additionally consumed.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 include/linux/memcontrol.h |  2 ++
 mm/memcontrol.c            | 27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..4d5c634daef8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -185,6 +185,8 @@ struct obj_cgroup {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
 	};
+	/* Used to defer obj_cgroup_release() to irq_work */
+	struct llist_node release_node;
 	bool is_root;
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..c53147a88580 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -147,9 +147,8 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 		memcg_uncharge(memcg, nr_pages);
 }
 
-static void obj_cgroup_release(struct percpu_ref *ref)
+static void __obj_cgroup_release(struct obj_cgroup *objcg)
 {
-	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
 	unsigned int nr_bytes;
 	unsigned int nr_pages;
 	unsigned long flags;
@@ -190,10 +189,32 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	list_del(&objcg->list);
 	spin_unlock_irqrestore(&objcg_lock, flags);
 
-	percpu_ref_exit(ref);
+	percpu_ref_exit(&objcg->refcnt);
 	kfree_rcu(objcg, rcu);
 }
 
+static LLIST_HEAD(objcg_release_llist);
+
+static void objcg_release_workfn(struct irq_work *work)
+{
+	struct llist_node *head = llist_del_all(&objcg_release_llist);
+	struct obj_cgroup *objcg, *tmp;
+
+	llist_for_each_entry_safe(objcg, tmp, head, release_node)
+		__obj_cgroup_release(objcg);
+}
+
+static DEFINE_IRQ_WORK(objcg_release_work, objcg_release_workfn);
+
+static void obj_cgroup_release(struct percpu_ref *ref)
+{
+	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
+
+	/* The last put may come from a context that cannot take spinlocks */
+	if (llist_add(&objcg->release_node, &objcg_release_llist))
+		irq_work_queue(&objcg_release_work);
+}
+
 static struct obj_cgroup *obj_cgroup_alloc(void)
 {
 	struct obj_cgroup *objcg;

-- 
2.54.0

