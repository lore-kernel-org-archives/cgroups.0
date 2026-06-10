Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D386413612;
	Wed, 10 Jun 2026 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106030; cv=none; b=LyotXgSsRih7sa0wdVAekd8jU8nrB4CwTwI1OR1H7AJdD//aa7l10sHbPtA+2dHNfyS3WkMTQA7fH1+aCYsKycp23Itcvqg9ogLFi3GAoy5oCH3JU9VmNd5PWiQZrZtgOpECBWx4L84bjtLV7DMDQf0ydy9jOnhHW0ZcB+7kwT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106030; c=relaxed/simple;
	bh=elxlxlkWq/7LRTBB0hu0idyCoKOuy0FeQXq5wzcu6io=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EhY1yKDTwHwVXRxkmI8GK0EWJJ49PbOocinj5t7Eele395uy4YNvH6s02TPVz25/sZPjgqD5ZcYIhRxuo3TD/hDpwjvl0+S6l/uS24GFPDftU2Y9mUl/LO6MG3leF1cPKi7UwaGYBZtWoQ2D7kJxoLjbhtX77IGbr2yHYV7ZPUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEYUC121; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEYUC121"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119E41F00899;
	Wed, 10 Jun 2026 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106028;
	bh=EcPADI751DZUFmAf8tMZbq8OK7pAbO29bPO2oNj30UI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SEYUC121sf/7PG2uBKmnFs6RVfZUcO9yIuyUGVekneIQcQDdInxcAael6nek53to7
	 OWDpMOwTekAxg2MUzrujVjDdFt9FLj40D+spbz2KEUqE3j6X6Ny1RHH+I0XUqxZoei
	 ysoQaGoHsOJSu6fINHXSgWRiMcemPkOXRnsqNuPxfIkrb1lMyd67U5atQNkKqeRcwb
	 T5YWpOd1i98Ijvk4JyrVX6LWWmzrninQe1gP+7mGwW0lqBlMiWmRcE6D5cCtc95wno
	 NItL0t3TzcaOWPAXW1sFVOuxprpWbxzV17wOoQkkVMqAdBgfr0op1nU2QIhqjGYScW
	 psTFj/44omEEQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:03 +0200
Subject: [PATCH v2 01/16] mm/slab: do not limit zeroing to orig_size when
 only red zoning is enabled
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.15.2

When init (zeroing) on allocation is requested, for kmalloc() we
generally have to zero the full object size even if a smaller size is
requested, in order to provide krealloc()'s __GFP_ZERO guarantees.

But if we track the requested size, krealloc() uses that information to
do the right thing. With red zoning also enabled, any unused size
became part of the red zone, so it must not be zeroed.

However the check is imprecise, and will trigger also when only
SLAB_RED_ZONE is enabled without SLAB_STORE_USER. This means enabling
red zoning alone can compromise krealloc()'s __GFP_ZERO contract.

Fix this by using slub_debug_orig_size() instead, which is the exact
check for whether the requested size is tracked. We don't need to care
if red zoning is also enabled or not. Also update and expand the
comment accordingly.

Fixes: 9ce67395f5a0 ("mm/slub: only zero requested size of buffer for kzalloc when debug enabled")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 63c1ef998dd3..e2ee8f1aaccf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4574,15 +4574,17 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	gfp_t init_flags = flags & gfp_allowed_mask;
 
 	/*
-	 * For kmalloc object, the allocated memory size(object_size) is likely
-	 * larger than the requested size(orig_size). If redzone check is
-	 * enabled for the extra space, don't zero it, as it will be redzoned
-	 * soon. The redzone operation for this extra space could be seen as a
-	 * replacement of current poisoning under certain debug option, and
-	 * won't break other sanity checks.
+	 * For kmalloc object, the allocated size (object_size) can be larger
+	 * than the requested size (orig_size). We however need to zero the
+	 * whole object_size to handle possible later krealloc() with
+	 *__GFP_ZERO properly.
+	 *
+	 * But if we keep track of the requested size, krealloc() uses that
+	 * information. Additionally if red zoning is enabled, the extra space
+	 * is also red zone, so we should not overwrite it. So limit zeroing to
+	 * orig_size if we track it.
 	 */
-	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
-	    (s->flags & SLAB_KMALLOC))
+	if (slub_debug_orig_size(s))
 		zero_size = orig_size;
 
 	/*

-- 
2.54.0

