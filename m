Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755438;
	b=he3fKUSOm0QncrbZbjLByqDQpjhbJA6J0KPNXmB+8zRAzEu+oIhwGOV9VEvrXZKBAEW8
	 8QBBrrRn+/zVznhjK999xXNONEy6+gSAO8y2SK5lBJARN1EKeSDyvI99mOEHaR09jbp/d
	 171ys482wP2MhN2LluPONgkVcidjGPavjLsTcO2selulEn67/hxj9B3f8TUyd+qLq0/wb
	 zxxlIhQ3NKganzRQtEOu+sGkMY9ZAo5GLQfPHr032phbOqaEG/Fi+woV5XzU4zdD2/EvS
	 g4eBJJOku78C1aLEGNMJ7rONykGB+DinQ0oSaFAroEP9NWbhEc47pdqq/NxpPd/Y+Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755438;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=3fbpIVRiCk4avhKbwmmnYtrqYq/PlxIo76wpkvP2jGk=;
	b=M6if9KFD4qiEMPfjkP9p8OWeOG8WJ637Lyx8jItVpOSJLvQIg7UnlN7yDpXnHr2lBJiO
	 XbskfhCKWYGzmodaXhbgO6PnsQwOIT9YoK7J+iGmaPUjY4mUawEBf6oOg49aQHwz5PSUp
	 ApdqsBX1CgB7A3NSPAEzPviqbtoIK97O+HEsqgungepAS+W5cBGiQdt0oQUWYIllKPSPJ
	 Chh1jH/8kOmL26Kgdg6oLKBbABlKYr4GgKZx4VBX9yCF4Mw2BEStyWFN4bjAJknUCSmgL
	 DJn5kWzaCnMuvS5yybEQM2m4eCngZPV696cULtm/KiOwfhHtQ5gIjj5bdJlYbnyotEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uv2N2fvQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21030606A31E;
	Sun, 15 Nov 2026 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uv2N2fvQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B237B1F000C4;
	Sun, 15 Nov 2026 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755438;
	bh=3fbpIVRiCk4avhKbwmmnYtrqYq/PlxIo76wpkvP2jGk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Uv2N2fvQO0dvY9WeWOp6oelXg6agl14Zeyyfme5Hd9fHuZsOPVlBBfafNEsIMKpAw
	 mW4/g3vEo7feyp6XN/xtTCkl78QBFYXH11l3NlKooyR4T7MeAaA6TmmTV8uVI1Ngcy
	 LI7Ii0dJzxIlCJG95deRuOoX5rySwZmbD19ZTjvbflV0pGRtk+C6DmxkD6e5xgJswl
	 ZhOXy8hfgH3yPBpHjjlkvk0sBQkGQAEixBFrBQZ6RmuTnr4r8cdQDKj1Eyf3v2Dlhe
	 oorXOXCYArgsbzrGFo/yg+lRCZIzi93EcXvl169MisOGBpHvE9DuzCKKBL1C+/ya0o
	 IBlJQu6LADCbQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:41 +0000
Subject: [PATCH for-next v3 7/7] mm/slab: call debug_locks and KCSAN checks
 in kfree_nolock()
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
Message-Id: <20261115-kmalloc-nolock-fixes-v3-7-9034dd4ecaab@kernel.org>
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
index fd3de3bee1de..fad19ec6af4b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2708,19 +2708,25 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 
 	kmsan_slab_free(s, x);
 
+	/*
+	 * debug_locks, KCSAN, KASAN may acquire a spinlock to report a bug,
+	 * but otherwise cannot deadlock. Take the risk of deadlock for
+	 * reporting.
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
@@ -2728,13 +2734,6 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
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

