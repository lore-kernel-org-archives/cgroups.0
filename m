Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717297;
	b=SNUFhCnGCg4ug3P/tz3si0CGGNnht8WwX5lYMlb9y6fdGKBj+EWlFMhPRSiI/+8I8PFi
	 MrjxHlrezlvaSInLIFGG60wy61m66Wl2GX/zbGwooHc7TkmR7Acb3JdZlzzs4xgHcm6Pt
	 NZsv7sQtnZDyAf274B7CKu/L7jIahGAfBxPkVk/NFvfndIg/6Vsh6dceJ5WXSIzFDrt5R
	 7B8hJ8n/cS7iRHIkyiu8azn2+/wqviGFMSUvMSkW8/6rH02szlosxbdb3/Fwk/wzjJQUe
	 m6fQmmqyxm/bGrS6l/7HvHBalruP6EY/oREIBKvwUa3BZhDz/3ZV1Z4Kw6q0ZjFnNaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717297;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=0Td4JZi2w+id+C91r1df/3sYplbTy8QIwHQVkHMEd4Y=;
	b=tNLML5feE7qjSFs6VV/ubzZT/qfNHrtFkjWJ+djvIM7xQrwPjmVqjVl0qvOhPSEm3aoz
	 bIiVRnIZie9TQXaTK3/r/jhxnYU8YflHNZzDEy/QDyBZB89J2t3TKkuMtxSE2HFyk88TJ
	 88ykHEcJKuUwkJWcmM/tMf8eQgxQwWT3WMC+J5z5Qnlug+aW7YtzlpSXusnXamd9pJ2xP
	 tu4kW7yeLlXxK2p1YspaCS+blRiQKbnJCN3s3Pb6LdlkGv0JoJT4xWkDzuvklO4y7C+7l
	 oplryHJDIIKT1OagxIr27gAV3SiBMA8k7UzALIlPwW3mov3RIp1fn7ll0BA6fWlMblw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EK0/vsNV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC00E60A6F72;
	Tue,  3 Nov 2026 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EK0/vsNV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7231D1F00919;
	Tue,  3 Nov 2026 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717296;
	bh=0Td4JZi2w+id+C91r1df/3sYplbTy8QIwHQVkHMEd4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EK0/vsNVB13SfzCl1rZBecIZcse/4JBWehfYgBqwpmG5oqD+xXe18TpP62x6fmfzH
	 hgIHV7c4uDapudMzSLqh8RVyG6f56qZJG58wnGntIv/hoPlUX1DrgfV0UrzJukmklC
	 KgCKk0m1/PdVRvYiFKdcdEaYieBaFf8F8jlGNkaAAoGATsVZWVu1OqmuzQgMY4s332
	 1sVrRaptCMgkDW7+sQN1y6UQh7XiYnQ8cYcGXCdRWzrzFO+FauFx2r7FxlUvV7cB+C
	 SXapQUyyOAVlBK+Av20/qX3mpbtsU1AYwwpMjnZfBWq8IKxDoLJNSKqjtWQYBzEG5G
	 8Y81ok+NYe1hA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:52 +0000
Subject: [PATCH for-next-fixes v2 3/5] mm/slab: call debug_locks and KCSAN
 checks in kfree_nolock()
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
Message-Id: <20261103-kmalloc-nolock-fixes-v2-3-19167cfe4779@kernel.org>
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

kfree_nolock() skips free hooks that may acquire spinlocks because it
can be called from any context. debug_check_no_locks_freed() and
__kcsan_check_access() are skipped as well.

However, they acquire a spinlock only when they report a bug.
debug_check_no_locks_freed() disables interrupts and walks
current->held_locks, and reaches printk only when a held lock is inside
the freed object. KCSAN takes report_lock only when it observes a race.

Just like KASAN, take the risk of potential deadlock for bug reporting.
Call debug_check_no_locks_freed() and __kcsan_check_access() regardless
of allow_spin.

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 36e7bb93418a..48415f24e115 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2707,19 +2707,25 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 
 	kmsan_slab_free(s, x);
 
+	/*
+	 * debug_locks, KCSAN, KASAN may acquire a spinlock to report a bug,
+	 * but otherwise don't acquire any lock. Take the risk of deadlock
+	 * for reporting.
+	 */
+	debug_check_no_locks_freed(x, s->object_size);
+
+	/* Use KCSAN to help debug racy use-after-free. */
+	if (!still_accessible)
+		__kcsan_check_access(x, s->object_size,
+				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+
 	/* Hooks that acquire locks or kmalloc_nolock() skips alloc hook counterpart */
 	if (likely(allow_spin)) {
 		kmemleak_free_recursive(x, s->flags);
-		debug_check_no_locks_freed(x, s->object_size);
 
 		if (!(s->flags & SLAB_DEBUG_OBJECTS))
 			debug_check_no_obj_freed(x, s->object_size);
 
-		/* Use KCSAN to help debug racy use-after-free. */
-		if (!still_accessible)
-			__kcsan_check_access(x, s->object_size,
-					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
-
 		if (kfence_free(x))
 			return false;
 	}
@@ -2727,13 +2733,6 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 	/*
 	 * Give KASAN a chance to notice an invalid free operation before we
 	 * modify the object.
-	 *
-	 * If KASAN finds a bug it will do kasan_report_invalid_free() which
-	 * will call raw_spin_lock_irqsave() which is technically unsafe from
-	 * NMI, but take chance and report kernel bug. The sequence of
-	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
-	 * -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
-	 *  is double buggy and deserves to deadlock.
 	 */
 	if (kasan_slab_pre_free(s, x))
 		return false;

-- 
2.54.0

