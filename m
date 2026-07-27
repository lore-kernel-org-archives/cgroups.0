Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5003E44EC;
	Mon, 27 Jul 2026 12:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156859; cv=none; b=uWgjkvpDY1cuyS7jWp75s+ko1h6fSHhXGSs6s6SMVMPN8MdGiqR330gqXOGDw4lkjudi3MaUU4Vfe1lUN6pjctXXsViGdX+GbLNDlW9M20oKwqv0QqQ8XeUWCntxt9kKWL1Vp+Mf8FG6v4LBJMV4H80ExyH9m4hHXgHyH3DOJT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156859; c=relaxed/simple;
	bh=K0Y02sWTwKplUJPEEQWntKXQ0g6XO52I9NYyXnW8/O4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nUKUJV8JYCPfW3yPooGB9lZKzGw6uSKuPQYW7dxoJZ1BcLg/cwWEeQKvfPfQ0BAIyy2cK1uQbUjQOt2OmXOOgd4HK9kCUAS2jun1En4+6J8cGIev/pYR/TxUTo6kwLPbOnfXsLDe8Vb6BdXOMxl9q4c6L3hi1WMHvUHlT/hP0xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sl1IICew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sl1IICew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DA41F00A3A;
	Mon, 27 Jul 2026 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156854;
	bh=AkNplhM/y3R+94Fey7CDvmc5bFFT4YcdBJTslgRYoxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Sl1IICewU5fK/CFdCu+iGLgFr/fFrUa9aNFj7OSJINXRLQgNvIe2aAu1rP8r9YYQV
	 4STcTsikq063EJKQuLl1rJyK5DrioXdkBKJV0unvCWHr8/Jq0PdhkpF/D+Eod3XUXc
	 NLRzJHrxyttwxK8JeA1qh6Pdmdsh5TejMiQxEDIowmpecijin89SEbjwrPjuKGv/rY
	 VcP5D78yCjxoIsEtP+VTVQKq9NhFq43iMPL36RD4BdBuaL6Cf3ld4ATp72l8/pRw4Z
	 iYHIqiJ+AZzJ0jH/I4ocGrRMGuP2HgwuIOvAMhhkBc0918hNWZtPFsyMw4bPHQB4gw
	 M68a92q4jC1BQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:56 +0200
Subject: [PATCH v3 02/13] mm/slab: remove objs_per_slab()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260727-b4-objext_split-v3-2-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

The function has an unused kmem_cache argument and almost nothing uses
it anyway; doing slab->objects is simpler. Remove it with the last two
users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
to a bit-field" but we don't need to keep a wrapper just for that.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasayan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/kfence_test.c | 2 +-
 mm/slab.h               | 6 ------
 mm/slub.c               | 3 +--
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index de2d0f7d62b1..9867c03ef0ae 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 			 * memcg accounting works correctly.
 			 */
 			KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc), 0U);
-			KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
+			KUNIT_EXPECT_EQ(test, ((unsigned int)slab->objects), 1);
 
 			if (policy == ALLOCATE_ANY)
 				return alloc;
diff --git a/mm/slab.h b/mm/slab.h
index f5e336b6b6b0..01535e1e2d3c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
 	return __obj_to_index(cache, slab_address(slab), obj);
 }
 
-static inline int objs_per_slab(const struct kmem_cache *cache,
-				const struct slab *slab)
-{
-	return slab->objects;
-}
-
 /*
  * State of the slab allocator.
  *
diff --git a/mm/slub.c b/mm/slub.c
index d702d273253c..b94482830637 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2130,7 +2130,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags)
 {
 	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
-	unsigned int objects = objs_per_slab(s, slab);
 	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
 	unsigned long new_exts;
 	unsigned long old_exts;
@@ -2186,7 +2185,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, objects);
+	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
 
 	if (new_slab) {
 		/*

-- 
2.55.0

