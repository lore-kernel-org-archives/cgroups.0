Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A5931E84B;
	Mon, 27 Jul 2026 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785161278; cv=none; b=O2NTNexKLEEPJDEF6tPVbklMtt6iIOZNCFW/Dys9theOoNb+figXJ95dZ7lZ1WQt5VgkCn2Pj9Y9/ApyKKafjvget3We73QQtPwmMFtj1HZDOZNh4pE9CaE2dnkjj+90rTHAYk5WofqsUXDqTDZsC1fkDNhduRw/5bNP2igoGQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785161278; c=relaxed/simple;
	bh=fqhtf8/poTe76mGT0CEj6NkC+z6PYPtW4o/8YmagKFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OvR1n3z8Ez5u49+KjHzWAGqRyepdadjGDmiog1OXLwmZav4WmhgVqo1qydqJVz6IXaPTYf8bnKflUf9F+GjbNxbVA9tafVnF9bR4LcGVb01hvfgRkoXL5Dw4ieLSb/IuvlDKrsA3KAdOgyh/Hcy9SqVG+Bya8Ws/r+fG3wQXXAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3c9g3He; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3c9g3He"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7571D1F000E9;
	Mon, 27 Jul 2026 14:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785161272;
	bh=bFngan34C8XC/I/ltda4v335UXHHYW7UMmFonxgLfhA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R3c9g3He0o5WGk89tpAUxBFjudEq92ibp7Txaa8h8Dv8i2Nl5HMUKdKm+/nf9WQmO
	 tf9qs5WmWAqRopAYu/KGFIqJ8ktlm1CMEOOyp1inAjelI5h2UMk3RaHmUxpfDVS/Qy
	 aamQ3Uu6sMJBxb3dwXkV5q1vwda0XDgo9aZpJSj/tpaUh1idk4zsvhai5LP/8jucsB
	 DOA+3W+y1nIsegg+jr5MfIzL/I9NLUBXq+EY31BD4pLwuCGIEY0GnS4ee5h+eBpgqx
	 CYpQcPYOH7VK16MaWwUF4LREkQfHzHZhsvOhJ3HPb9cHDnGXJEx/TnjM4hNy03lLTU
	 38MXYiR/3rerA==
Message-ID: <11f5028a-3fdc-47b4-9712-559c065b87ba@kernel.org>
Date: Mon, 27 Jul 2026 16:07:48 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-10-c29ef0f1f257@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260727-b4-objext_split-v3-10-c29ef0f1f257@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Per sashiko [1], a fixed up version below. Couldn't trigger the issue
although seems to me it's real. Perhaps can happen only with SLUB_TINY
otherwise the sheaf can't have obj_exts allocated from objcg charge path.

[1] https://sashiko.dev/#/patchset/20260727-b4-objext_split-v3-0-c29ef0f1f257%40kernel.org?part=10

----8<----
From 905c6500e597a8ecf123ad167698f0a0c1a764bd Mon Sep 17 00:00:00 2001
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 8 Jul 2026 17:04:36 +0200
Subject: [PATCH] mm/slab: reduce slabobj_ext memory with allocation profiling
 disabled

When memory allocation profiling is compiled in but permanently disabled
on boot with (implicit or explicit) "never" parameter, stop allocating
(thus wasting) memory for the codetag_ref parts of slabobj_ext metadata.

Do this by using the new slab_obj_ext_has_codetag() helper in
cache_obj_ext_size().

Additionally add slab_obj_ext_has_codetag() checks in
mark_obj_codetag_empty() and handle_failed_objexts_alloc(). The
functions might get called with memory allocation profiling disabled,
when the obj_ext array is allocated for objcg pointers only. Setting
codetag refs as empty is unnecessary in that case, and with them not
allocated anymore would now result in memory corruption.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 2 +-
 mm/slub.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8f352d9f4d91..f86d4ed3f2be 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -591,7 +591,7 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 	if (IS_ENABLED(CONFIG_MEMCG))
 		sz += 1;
 
-	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+	if (slab_obj_ext_has_codetag())
 		sz += 1;
 
 	return sizeof(struct slabobj_ext) * sz;
diff --git a/mm/slub.c b/mm/slub.c
index 67958f2b3bab..ec3997582f31 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2064,6 +2064,9 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	struct slab *obj_slab;
 	unsigned long slab_exts;
 
+	if (!slab_obj_ext_has_codetag())
+		return;
+
 	if (is_kfence_address(obj))
 		return;
 
@@ -2099,6 +2102,9 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
 {
 	unsigned int stride;
 
+	if (!slab_obj_ext_has_codetag())
+		return;
+
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this
-- 
2.55.0

