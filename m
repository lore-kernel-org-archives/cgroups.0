Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC65542F6F1;
	Mon, 20 Jul 2026 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557025; cv=none; b=O4zi1l3zLyzO0CcITY1rUBGvwQCXThm62ww8ZaEl4t7CYfyxWhTyteR5yltMUXVwudUMIYbmfnJ9nmMHOclc6QPJAxVMWvZNC2v8lFS6vYO27GVUKdCi1OnOodNcs1pBzB3N4ebL5PEHTS6HmPnU4RPlz4+qsp+0P1r2G/QBrxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557025; c=relaxed/simple;
	bh=yOyOx1Af/unlEzIdYJngHCqv6wVo6jclyAheX9qKGk4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ehMY7B/Ppkn9xMaruEASCpr+HrTyAG0ZG+JQMpUoauhbDZBqOsZXCwx5rAqSFHDV40tviU5IfHxQg7VmBktjpq4Uv9sWG0QLk4CE4imTCyTdryUk0Wde/C4IrXOdOFI/EwC7rBtzsGxvzs5Fu7Yvum59UIvDvvnR3+Col8gT0+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egnIImWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egnIImWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38C1F000E9;
	Mon, 20 Jul 2026 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557022;
	bh=J2QHy+8aDvUuK1lYAmgQR7tOtfpX0R/pRz+K12b83rg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=egnIImWAjekWM0hyh5G7FSbHakblC40grDwPP0aXTYu/nLY3GNOU4WJwFVBI8QzvF
	 NpjLHTmr9QdDTg1pR3ejvqLf0NPsYbOGW74VEYYtfiVp1V4h5V1UWYu2nv+z0z5J0w
	 XNAm20w1ucPg26aUEcjVxU0L20wNDXViVjPkoOnaBoKziKP6ZSZ2b3VZ6P8J5DUegw
	 iaItZCo24oMkV/NtY1OO1xYeBqmQ1WpUgas+y4ly2QnGzsX6NkWIjxmHBb18fgDIZJ
	 GwoTUKeNPa0trKdMm9oyPvukyGBv5Cc81mEQ7X9+0umyyPbdlGhBhH/RNCjSk54t8P
	 qQPvI4ATQTkFQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:25 +0200
Subject: [PATCH v2 11/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-11-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

When memory allocation profiling is compiled in but permanently disabled
on boot with (implicit or explicit) "never" parameter, stop allocating
(wasting) memory for the codetag_ref parts of slabobj_ext metadata.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 983cb1119a76..c5f37a46434e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -591,7 +591,7 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 	if (IS_ENABLED(CONFIG_MEMCG))
 		sz += 1;
 
-	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+	if (slab_obj_ext_has_codetag())
 		sz += 1;
 
 	return sizeof(struct slabobj_ext) * sz;

-- 
2.55.0

