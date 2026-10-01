Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CEE3E168C
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 04:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790829746; cv=none; b=sBalxn9GFMWiO3W8B9vSTzlMjd6Hc6kyHlqlOao1hK+y7w4W0/DYE92m1Py/zAob1FybhaFWSc0o/iB9PA8Fv4RPv1wu7xwtz0uJd6PXTyIi+/J4DAwkWNmf8tU73f3Z8l84F0kzYnIY410CNktPQ2ZhYE9JBjaijcVTJ5YkzEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790829746; c=relaxed/simple;
	bh=lR2KR3l1NhxaZrni+JXs85cU0OVhYTgsr4rI2+bzgd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oBZdoikCAzGVKmMLUok+SLbJ4RQVqb07Zp+5hBpqCNOY6MWrFCb+ZlR+hpRwuMk8sMdu/qVnvAqppo7STruzuUCZgGnDFSX4dcZ2RgGopCD7bD9edpC6gle3Gg1fqjltTzWz5dQpJ5GNttdljfJhDm+Zu0QenrV48kmlkoad0iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRmijR51; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRmijR51"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ff9642c57so11796515e9.0
        for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 21:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829741; x=1791434541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XIBJllRq9Qoioyf410EUtaPM6Z2WKPJiq8KVjKLjAxE=;
        b=aRmijR51yOyyCtCCwbHbWb10p89odJZDw9W2SGJLeBVsRTTNFMcQr7O926Gv40ZgiI
         EYkuPU3BWHK7RS/gGM1RnL7AxYcbo/jC2fyILXXboHswYLgkhMA1tKwxSB1pDJOB69Tt
         Z8/LZdmc7fcjQ59WLRYWIFsyXp0ykgd0zKJDBtoHByeAeQc2+MFcoxzanfIAag9Pshvj
         i3ph2Zant6UtYNxAmNpCfdkMK8CcR7FtWM6Ko17TysdTjquzfQSaQxMrwbLb8VMnzHJv
         qbdsUrxjgFcwbr6KBy5yh0E8gEdWQSmXRtQpga3fnXAdvoIHG/K28a3MpgG/dZeebKI0
         zdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829741; x=1791434541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XIBJllRq9Qoioyf410EUtaPM6Z2WKPJiq8KVjKLjAxE=;
        b=PV8Tq1hLcrSBpNJx3PgVTOsiBWpPh8A8UfwF0+Z2HevMVwyklH7sKF7rRyioEPw7cV
         GoD9FZlkyCC5evP9peBPsBhwr4+twqWFIv6S1YDKXHL/ZrrveQ3Hk7g4P5ylD3y6gyQc
         jZ6ZPHUoTN4/wGogDXbkNrlgKJQZhudQ0ErpoZS+6LrX+bHSt1PamJ8nmP6sFRMAHDbl
         ozxW7qkcIjjSA+OsBLHJBcFKaI9goGSgmCnPT2JqoB9DQ4Zmo48/syTOEiUsG4tdx5rI
         T3oKUWCAECxo40OdbhD/KgsBIECVQZcBW5mlYWYI8/koCflJCQovj5mkX+Gc97wy11ki
         iFxw==
X-Forwarded-Encrypted: i=1; AKwUvBxkuvD6LpHl3sDhttZePXoPFpCQYwAmb3C6haCpeAiQCR3e+F4YzTSRku/jGLKtNtvK1a2MJryo@vger.kernel.org
X-Gm-Message-State: AFuF++lI8zajNZHdhhBgFtccGkmplSKmoSr/YPMMn2oI4MLeEhA+aFNw
	aEm8xGQ19i4FihtPWGKN8k0rkXJRw+ZKixYpJXyxxprNhyp5V+31qS1v
X-Gm-Gg: AYBFou2YgKu20p624aFEv175E7pvn8a2igCDZB4Fg0+2QsT6QF2lHK2V99cSp3ejsJX
	GsbyFM2m88GrTG/qUZ+YUj1ToWxguqswMHUZC89Otw+KRghkzkUyPFodlz1hbxmOzrwJZK084VI
	GJKgz4qf1I5Vb7N2elJRSBnYf0vaqcLkIVSqd0pJTK6wR6OOMAQUQWNER5mPaKGlMS3PJsiQ3Xf
	op4dXiiqOWhd01Vb8qq+t1YMClInk+fJyIVPfnSUbOJDHyZGTAarwVGQ3jF3zQx52ZZBILEvjzk
	hBgr0J4ZKf50din1FYzSXXFAPn17Q1K7yHbQFarMqDU+mQc48/SKLi1Rrlz1heaBziqh0ygGTqr
	G/Ymjj6T2RIw5yDOc818q3I6L3kkrDTX4CSs9fApuDgiMoO4+VJFxsKO4cQ5hcprtIJb8OXWUIU
	413rGs1ZyvWtWWC94uLiWqJHmuPAoONoNoeqFYLlpKoHU/TIRIVgJSpbZSBPk91Xys/Cw7Kk4KZ
	ajxSeov7RY4K/wP29j2zpF67jzkBooPMkXerOrV7lgbYcUIH6Gp9YmbESqbIxJJ3JO+pPjn1Uh+
	hJbfAC5auVWwoEn2kojr5zV5yipMIYSDJ8inES5jSmlJCLT/pP0=
X-Received: by 2002:a05:600c:83ca:b0:49e:6581:7baf with SMTP id 5b1f17b1804b1-4a01eaf59c6mr25440045e9.2.1790829741006;
        Wed, 30 Sep 2026 21:42:21 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-056-101.95.117.pool.telefonica.de. [95.117.56.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f6c5059sm32619515e9.0.2026.09.30.21.42.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 21:42:19 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 2/2] mm/memcontrol: defer final objcg release from no-lock frees
Date: Thu,  1 Oct 2026 06:40:56 +0200
Message-Id: <20261001044056.75079-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261001044056.75079-1-kmehltretter@gmail.com>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kfree_nolock() and free_pages_nolock() can drop the last reference to a
killed object cgroup.  percpu_ref then invokes obj_cgroup_release() in
the caller's context.  The callback can uncharge pages.  It then takes
objcg_lock, exits the percpu reference, and schedules an RCU free.  A
no-lock free can therefore enter regular locking.  On PREEMPT_RT this
can take a sleeping lock while the caller holds a raw scheduler lock.

Make the release callback add the object cgroup to an NMI-safe lockless
list and queue normal irq_work.  Drain the list outside the no-lock
caller's context.  On PREEMPT_RT normal irq work runs in irq_workd task
context.  On non-RT the work remains safe to run from hard interrupt
context, as required by the existing release path.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 29 ++++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a88..c755d946430b6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -186,6 +186,7 @@ struct obj_cgroup {
 	struct percpu_ref refcnt;
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
+	struct llist_node release_node;
 	union {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586cc..63b18c7f1965f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -33,6 +33,8 @@
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
+#include <linux/irq_work.h>
+#include <linux/llist.h>
 #include <linux/pagemap.h>
 #include <linux/folio_batch.h>
 #include <linux/vm_event_item.h>
@@ -146,9 +148,12 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 		memcg_uncharge(memcg, nr_pages);
 }
 
-static void obj_cgroup_release(struct percpu_ref *ref)
+static LLIST_HEAD(objcg_release_list);
+static void obj_cgroup_release_workfn(struct irq_work *work);
+static DEFINE_IRQ_WORK(objcg_release_work, obj_cgroup_release_workfn);
+
+static void obj_cgroup_release_one(struct obj_cgroup *objcg)
 {
-	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
 	unsigned int nr_bytes;
 	unsigned int nr_pages;
 	unsigned long flags;
@@ -189,10 +194,28 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	list_del(&objcg->list);
 	spin_unlock_irqrestore(&objcg_lock, flags);
 
-	percpu_ref_exit(ref);
+	percpu_ref_exit(&objcg->refcnt);
 	kfree_rcu(objcg, rcu);
 }
 
+static void obj_cgroup_release_workfn(struct irq_work *work)
+{
+	struct llist_node *node;
+	struct obj_cgroup *objcg, *next;
+
+	node = llist_del_all(&objcg_release_list);
+	llist_for_each_entry_safe(objcg, next, node, release_node)
+		obj_cgroup_release_one(objcg);
+}
+
+static void obj_cgroup_release(struct percpu_ref *ref)
+{
+	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
+
+	llist_add(&objcg->release_node, &objcg_release_list);
+	irq_work_queue(&objcg_release_work);
+}
+
 static struct obj_cgroup *obj_cgroup_alloc(void)
 {
 	struct obj_cgroup *objcg;
-- 
2.53.0
