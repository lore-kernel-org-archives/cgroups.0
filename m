Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717289;
	b=m4qpDs+MaDuBmBjXOjEcWpbX4bk9dQ/HqK4nm0knkKVF/HdaVdaSFblw5M8jEgpe2y1w
	 AABjXdafZ40vpTNvF20zFimIoyIndfylHbnj4NgSM4sXhJjf3VX5BXQeA/0TLovAFaVK/
	 vFFzN6r24+7aJBNMNrrUZsDGArMSYoj0r5kH/hyyaMMrcIBBmEKvzQMvqJo272VI5hoKF
	 eEpkEwSZhhNk1a3GKh8Af8fKAr+ZnSic6G+p5R5upNq8AS2tlZXV/AmWkydQkJ+NF98W4
	 mBqfIX8nVhq/GzqzzJTS+8uy7bTPnvFzj+4H1M4+sIkm6SAOXcLoz6fO85sCIJqy8kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717289;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=TRYCAHukSEy8Nlux487+3bB9VsozJiJ3Md/iLi5A+o0=;
	b=IIgov6S4bquitLyduZL29W0PTT4DsFAOm7ko63wW79YhbtKvnGhpimXcFk+TkhKXjEVP
	 LR0qLU2fJoGMCIDhSOwerQDzzHJLIEvX8AWHpim6LfAt9dgjykdQSF00ZVsaS+RJKTbyb
	 zGNCY2xCA972enEFKjr4ZGEXSLpv0Tu96SpOuyjHOVrRvHRfpK+Tgerwh9PUeYOuq3nXI
	 x/NJZ58gz4R0OOmjtOpYdvC+kh19HnJQuWX/av4y/TOh0YznQFKgXibW08/ed4XoY8lhz
	 1A2swUtUirk5+X4ZrXGM2pt+i3aq4cPy/6Dj/vYYtfY8NjL8EhXdefbNgR3rbD1Kp8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0vzLjqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9252F60A5BCE;
	Tue,  3 Nov 2026 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0vzLjqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DC81F00A1C;
	Tue,  3 Nov 2026 14:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717289;
	bh=TRYCAHukSEy8Nlux487+3bB9VsozJiJ3Md/iLi5A+o0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m0vzLjqYTpK1EbN/fTydMgFoS/z5nHZTsYBZsw1T5XJ9ViV+aI78cI5RkK+ePGR9T
	 1WWI9HMrFw6Sk1fwUk7QRcj84+uVSBjV98QC5uh7BUTDiHGCcfGwiT9bt6mxgeRedb
	 /hSsW/1uQTn2YAE1FIS6dxtPDQPD8N3pTFlw8gBwHeO4Ox3pMMUxDbEIhrKWDAAdLG
	 WscNxw671ntJftgHHJy39wS0Ii6wzberbnaK5b5f0eElTUQ54l88hQnN82ZpW8+SWJ
	 uECJS4SaGCainqrTUrVMh3t2VXvcc35Qk0mG7C/vz4QPAM3nRc6L9yj7/WiPwWGF7e
	 Z1inegJzbVciA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:50 +0000
Subject: [PATCH for-next-fixes v2 1/5] mm/memcontrol: defer
 obj_cgroup_release() to irq_work
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
Message-Id: <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
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

Closes: https://lore.kernel.org/20261001044056.75079-3-kmehltretter@gmail.com
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
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

