Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642797;
	b=JjuEmCGDAy7Vy7V7PIf5C4U7MmdTl7XJEF0adZ/df9bCZ1EkSk9BSmwmu/wVvf/WidlM
	 a6RuCObg4lSPXY1KmDfCcVHUVNyvzWyrggklRst9V4Wpue8hZrAdRuvUOPLg4LkGx7ozR
	 yEUQCe2XXkMfvjOInv+LfvqDNkdDKKTC5o7fifMdC8+bglXuwlcZO4Kj8BtDo7pLI/OpV
	 9ZVjkDxaBiwhnzNiYnJm9EVC/08AWBB+4UHJnrgezUCuKoFjixhVsEkxGW9/M7bjFrWQV
	 pcTw+t6PjOhgzJsOxZEUUosE6izLHbpYZOWbVi4xVJB97So4AL04jiWHAfZ0NAXWCjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642797;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=5x95mFtq9SsOz7VWm3eLFqsSut3QNXOjHk0FlS/OEJY=;
	b=VboMGiZuJ+Pg/3yQx6B80uFccTbW3evBBtr1hWA5ScvXITHEJKl0eh+xOh0+gLZFhnS0
	 te0stextwEQ1z2pyQ6GiNd26dQ3L4+tdQaVOJQeVzmO4XN3SbAfDYabMqgcnJDkYbf0cf
	 HlcB3JlFTEANSxPDZC9AJSn3UHuCIsGhATsTcUXndBfHtBZmMGYxL09dCCQWHirCxAiXi
	 QPONNmUbBwuDYP9oV19dgIitMEzr2fQrtUpn+TzZi2uVgS0OIvAfPvey4kEbNFz34hPnP
	 M3z2MGyBYDRIoEpiGhXabaKNFVU56ijsWTI621aasWYZIOTl7XWOrym5Lf0eY8RxCGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gR7IJgfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FB3606A323;
	Wed, 25 Nov 2026 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gR7IJgfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1478B1F000C6;
	Wed, 25 Nov 2026 21:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642796;
	bh=5x95mFtq9SsOz7VWm3eLFqsSut3QNXOjHk0FlS/OEJY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gR7IJgfOkEVQt+Kjd5Lhv9/b2kVV8yRkGEde2GpliNCOVGS04lYkQSSULOJDv53Px
	 2Jekw39TzKqHcUDkbuoYJCn4S1gmvYLWPkpuJUCpoFdw3elJJ7zWe1+xTfJHApgEiK
	 P/qQpkx14FJESeSKPtOdFd17NKyU3J6ilRq5E+0WakHtwQXwFkW8NGI4pXgUznisYD
	 rHkqysyl38T7vPQqLMCGxrCLYc15vSWMv8Mtbx/OlEhREtZmOooXaG3WLLIMn7ebg7
	 Sv768LnK5Hpwl/Tk+Rc/AyiB0N22eVUhJz1rai3YDYmpTQusukjx69daAQV6QwFd6R
	 NEmZ1eWYWrp6w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:14 +0000
Subject: [PATCH slab/for-next v2 13/14] mm/memcontrol: do not allow
 charging objects without SLAB_MAY_ACCOUNT
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
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-13-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>, cgroups@vger.kernel.org
X-Mailer: b4 0.16.0

Objects of a cache without SLAB_MAY_ACCOUNT cannot store the objcg
pointer once slabobj_ext space is no longer reserved for every cache.
Skip charging when __GFP_ACCOUNT hits such a cache, and warn once under
CONFIG_DEBUG_VM to catch callers that did not opt in.

Refusing the charge here is sufficient for correctness: an object that
is never charged does not access the objcg slot again, and the free
path already skips such caches via slab_needs_objcg().

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a07cc73acfc7..0eddb16173fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3707,6 +3707,12 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	if (unlikely(*p == NULL))
 		return true;
 
+	/* Do not allow __GFP_ACCOUNT without SLAB_MAY_ACCOUNT */
+	if (unlikely(!cache_needs_objcg(s))) {
+		VM_WARN_ON_ONCE(1);
+		return true;
+	}
+
 	flags &= gfp_allowed_mask;
 
 	if (lru) {

-- 
2.54.0

