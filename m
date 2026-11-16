Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827045;
	b=bWC2VcUpx4XbaQ+OOokz2t3i3U99kdjQnuHSF9WPBtnmNgvSd8aRAYUi3r7L5+YeEvqZ
	 1R/sWobJB8i9nN9UqpH/6uaE0Y7Mw6VFvdKHy9v7T8wZMBSK97XLavurVs174GXYN3jwF
	 gWXL/oS2DE/JWZe0m9o9PVh3GS+33ctIxKY2hgoKtavbHwobDJJH/ZboQyxJ9LCq2+9nc
	 /5xNo2kq/rHFPW79oDwZRdkahmt2LgP7A6RKbCHH135ZjPrZP883aCeygjkNYQiJLFBF8
	 XqCSnTXhr3nKr1zLio+SOnXevgaEV+6USyVIjaJKQJl8KHEG95YOtvM57SxlkEC8mIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827045;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOptmx/nKaTXpVpA1qDUtPfxFqOvBUlo8nEFPXsgeb8=;
	b=tjw6jR/EF0NU3FRstN5e8awHBkrfZxWToNe1A5LAjta1zGh5qtxvmAOqO7Oau9q9j7tE
	 NE+/TA8GzNRs4X4KaUVaEStmErPFRRDG8SHpolMZEe+ys/r8Aj2RrjY5Tzxl95TfLRUQw
	 0otamWcLaGvKGu3/bJKrzfjDmIuHk1ObhNfkRuioKNMVMruWQfrw3eXdAb/oCg+y9O7uI
	 kmIslCjlWVveQUuwDYxAHnIn/CUtu4ScVEGirRXZf5wXz9JV1krGBylPCXwcTe6MuL+gy
	 +wJp7nv86/Wy8Qv+Q7nLZ9hcyUlr1dyRmJroWKnocGkqUW9GelCEnfRMkbIw6nIa0Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WfZtEIBJ;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16656606A886
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16656606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WfZtEIBJ
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b3b4bcbfc9so3658371c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827043; x=1795431843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FOptmx/nKaTXpVpA1qDUtPfxFqOvBUlo8nEFPXsgeb8=;
        b=WfZtEIBJXA6so34JmNa94rsAwXws9h2i9FirISYmtZFrbiOGVyQa9FzxeMMx/w/N3Q
         IFBbEwzQOzF5VhUogJhWDRy0hD3WAPRcBC6iBsM225zEZ7EegeX5oX0T7sQi36kbBHZU
         VvV/IhVaARkKlvQGTcOdkAT+XKMrDMr4Hcqpos2E0aM0d7T9+nYqQA+87RAyvNfqpiyw
         lIQ3Vs2EhWkPg56n1AINxfTjIEVX/XVHAvZl1b8kCFF0UXgDnLZmRcQ5MgcdscV6Ti9T
         paBdAtWl37cI8/FlF21X4E1ftx6kuq00BkF4bJYTIJBgVTOfMMSrNLxU0eqP+81SP1Fj
         bJ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827043; x=1795431843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FOptmx/nKaTXpVpA1qDUtPfxFqOvBUlo8nEFPXsgeb8=;
        b=TuKl4RPeT6oEW+O0cuzu5dXkYAb9Lt17bPVAzTSLmRjr9Fw8C/Rt2esbVc7orpVgIb
         0NAhgs8W+BrIdn3Qdc18tD7iTBEKX8t5HII/A40HLW0U06KtIQMmCruOt+jtt6bwkwrP
         fog7gfkqFvmSqXVLBqWH6ZUGZSAGEa+oMwayCUJdaw1u5uGyqAB9JDs6wjua9J/MLLJh
         2fS9GCjghKxWw9g0Bmg02Dfk0si+Qg4rNrZUoUYzK3djpAg06RlDUGomuv9GWep2xQCk
         6h7LmH+yePVVql+T4LsHrFHX83DlPhMZ+kyahnPIYc5qw0yQY7JXeR8m5FSREjtpXMKx
         6syQ==
X-Forwarded-Encrypted: i=1; AL+hErFI8xEmxIaYIiWf6ccZe112T9cs8glhHO67k88XdB0tnTxWQaRJt5ywkv4uhI+CdjvWtn8t9tq2@vger.kernel.org
X-Gm-Message-State: APuU4Z8JpiT+/2sf/VvCYc8mZQbxEQt5UW3MkOje28HLiBbvB2lr1svM
	AZ/A3r6FIiZFn6ZVioIRkfqpMJP+RkRTJp5k0sl0U39F0p6s9N1D2wDc
X-Gm-Gg: AYBFou3Zow935ztKJzdx+/egLggQVvoVSLESzg0ZwF5YjDoLGjci9ZzvOFfSOZ0xSwn
	vjb9ZAHDR4DWz44a7LfCIMz32tb4k75wt5rhacjfONBCL5hR9hwVrVx/TQ+u9Lm0hvYNfS66M3f
	7rDDTHcSYvHPVIO+NxO5BwMCmx8vz7Qvl+DkH37189uHpYBZEHZHxT2PNKIdonhUDav5eHg1Hw/
	/AR3P8MjETkA6FglM8fHWh+lKNnWA2v5BN2TZrH9nFe7EsVCwLWUGHZAUzhO3WXezJ2PzlyWNDe
	1tHUpUkLffZJ0VmMtRIy0zyokJM72rRShTwis0oiZVEuugFLFxI6Y/uulIckQEFaZHlFVhkJkOL
	nebtEOBUAHLZ7XSuw5+DpdIkxNjwizjaZSgwImQYpulwz611CBEAKX9w8x/P2Acwkn3JKMFYpPz
	OWC4wQIVB/vt9HxmPPznNuAil25m+Hxml67AGQkMSjoI9bDG06kRCklm99QCiGEbJBvv/sCzjgx
	MIAkAiH6oOeaLmfKkwJC/X963h9Rk1F+EG3gvr4C8fVAyiCFyU/KvdVPMHCbca7MvtZ/Di9vqci
	rMTSYDupLpbD9gSZQk9OCFLIaEi/YLZFVZZ/ptoeGJ6psc8YEIn0DllgITJjBVyQlqld
X-Received: by 2002:a05:7022:f50a:b0:1a4:c892:b130 with SMTP id a92af1059eb24-1b5031152eamr10336840c88.15.1794827043076;
        Mon, 16 Nov 2026 03:04:03 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:02 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 05/16] mm: memcomp: charge compressed pages to the source memcg
Date: Mon, 16 Nov 2026 19:01:11 +0800
Message-ID: <20261116110122.309748-6-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
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

Reclaim can execute in a different memory cgroup from the folio that
owns the contents. Charging compressed storage to the reclaiming task
can move memory usage away from the cgroup that supplied those pages.

Capture and retain the source folio's object cgroup for resident records
and per-key storage. Charge allocated metadata and payload bytes to that
owner, including allocator-sized metadata where applicable. Nonzero
same-filled slots have metadata but no allocated payload; the zero
domain has neither a slot nor a payload charge.

Reserve payload charges outside the token lock with non-reclaiming
allocation flags. Transfer a charge only when its payload is published,
and refund it when allocation or revalidation prevents publication.
Refresh releases the superseded payload charge while preserving the
ownership needed by its replacement.

Release payload charges with their backing, and retain metadata charges
and owner references until their corresponding records, segments,
clusters and keys are freed. RCU readers must not outlive the metadata
or its accounting owner. Leave restored-folio charging to the ordinary
memory-management paths rather than adding a separate cgroup quota.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/memcomp.c         | 22 ++++++++++++++++++----
 mm/memcomp/storage.h | 22 ++++++++++++++++++++--
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/mm/memcomp.c b/mm/memcomp.c
index 80b71e217ff5a6a2fa1d033edf6079a670a55020..8944fa081f3e35bfacf00d3a1c09c8bb32a9db18 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -663,29 +663,43 @@ static void memcomp_zs_free(u8 pool_idx, unsigned long handle)
 
 static struct obj_cgroup *memcomp_objcg_get(struct folio *folio)
 {
-	/* Compressed objects do not have an accounting owner yet. */
-	return NULL;
+	return get_obj_cgroup_from_folio(folio);
 }
 
 /* Hold an additional metadata owner without bypassing the test model. */
 static __maybe_unused void memcomp_objcg_get_ref(struct obj_cgroup *objcg)
 {
-	/* No accounting owner was acquired. */
+#ifdef CONFIG_MEMCG
+	if (objcg)
+		obj_cgroup_get(objcg);
+#endif
 }
 
 static void memcomp_objcg_put(struct obj_cgroup *objcg)
 {
-	/* No accounting owner was acquired. */
+	obj_cgroup_put(objcg);
 }
 
 static int memcomp_objcg_charge(struct obj_cgroup *objcg, gfp_t gfp,
 				size_t size)
 {
+#if defined(CONFIG_MEMCG)
+	if (!objcg || !size)
+		return 0;
+
+	return obj_cgroup_charge(objcg, gfp, size);
+#else
 	return 0;
+#endif
 }
 
 static void memcomp_objcg_uncharge(struct obj_cgroup *objcg, size_t size)
 {
+#if defined(CONFIG_MEMCG)
+	if (!objcg || !size)
+		return;
+	obj_cgroup_uncharge(objcg, size);
+#endif
 }
 
 #include "memcomp/format.h"
diff --git a/mm/memcomp/storage.h b/mm/memcomp/storage.h
index bae605f20e79bec5d6dc5573f3148ef15e95ee84..f11aad87a1773c0e2f16b1bb3d506cb4caeb7386 100644
--- a/mm/memcomp/storage.h
+++ b/mm/memcomp/storage.h
@@ -223,8 +223,26 @@ static inline void mc16_retained_empty_dec_locked(void)
 static inline void *mc16_kmalloc_owner(size_t bytes, gfp_t gfp,
 				       struct obj_cgroup *objcg)
 {
-	/* Metadata remains unaccounted until a source owner is introduced. */
-	return kmalloc(bytes, gfp & ~__GFP_ACCOUNT);
+	struct mem_cgroup *memcg = NULL, *old;
+	void *ptr;
+
+#ifdef CONFIG_MEMCG
+	if (objcg)
+		memcg = get_mem_cgroup_from_objcg(objcg);
+#endif
+	old = set_active_memcg(memcg);
+	/* An unaccounted/root source must not charge the submitting task. */
+	if (objcg)
+		gfp |= __GFP_ACCOUNT;
+	else
+		gfp &= ~__GFP_ACCOUNT;
+	ptr = kmalloc(bytes, gfp);
+	set_active_memcg(old);
+#ifdef CONFIG_MEMCG
+	if (memcg)
+		css_put(&memcg->css);
+#endif
+	return ptr;
 }
 
 static inline void *mc16_owner_alloc(size_t bytes, gfp_t gfp,
