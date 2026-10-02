Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB5E42B301;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982694; cv=none; b=tP9v+bPHs+LeUp70BMQ5SoVNl1+SZD+D+2hGoFDWsnoH1Su2wyJy3CYO3pujdHGj+VcpAoJldxmUqOQQDj/oSmLMNMGd13wxps07zjO+vellnBg9t4i8KCwZTEPn29kNQy10mJr1maEigi8xQPsIefQsiVVWb/gR8wJV9bddZAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982694; c=relaxed/simple;
	bh=AuGTrggSMMdoLaFPyZC7inBFjquZSoja7nsY11s+2D0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NSMJg2nBzkOmv7Ax/RgcnGxT8X0ysWLanSk6QPnqOWuDH0ArsZciWi4/7nJetAYmp2vlD198ieGjwoKJeLylNthSZ/SQp+gCvQJn3jXEM4CUCcq5dMyEVIbOAhEmY/+QQwfaA2yOFYFTgSmKJsfNPt94LXWzMuwU/ZmWV53gHqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlKtFw36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlKtFw36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262921F00893;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=il8A1RVRfAP3LmRZEt7D66Nfnu4TVGi121lkczSMSiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlKtFw36eMlMokCbuuuhmSgbjFdvD0tBMPp4BfTVPh4znMWqlOezpIfvnGghA7Lt9
	 1/ulIEAd9JSdiW2+8S9+59b7c1R5f1loUnQMEet6ohlEp9rT80vC6BxYfkihNGWSHH
	 GhTejv/kjnALRVLtt7jKiCmLct37U6U78GlulMI4tRTIl3ioPWHlYZdpD39ONoDZjC
	 wGGtCMaf+yyp1cYUQzEsBgJOJUUtK5Z9hqmKDhrtNSomzwyGtE+YMUoz3AVBWmfhOz
	 jF0zD+5Jkk4eP3lU5K+TtK4ZF/29zAaLrA+ODnU+QiQXToxOyBESzh7HW6OflkMYDL
	 OhYhb6szA80uw==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v5 1/7] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Fri,  2 Oct 2026 16:11:21 -0700
Message-Id: <20261002231132.1646573-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1768; i=kees@kernel.org; h=from:subject; bh=AuGTrggSMMdoLaFPyZC7inBFjquZSoja7nsY11s+2D0=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrGSLN2YfELwjaF+9xSuq945av3Z70zMbxZzA3XpLR C84B2/oKGVhEONikBVTZAmyc49z8XjbHu4+VxFmDisTyBAGLk4BmMj/3wz/y/i2W0Ve4VA4uefW tHu/j8hE5eiVPDzOc8TywXvtMDvLFYwM0/k2L172aIVZ9fylfqsrn0V4f+0p/2MleMr164qMbzG F/AA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

kmem_buckets_create() had the same sentence about calling context as
kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
rendered in the body instead of as a "context" section.

Give it the missing prefix. Additionally fix the "a interrupt" typo
__kmem_cache_create_args() had.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Assisted-by: LLM
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..270408ce5a9d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -311,7 +311,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
  * by a grace period - see the full description before using.
  *
- * Context: Cannot be called within a interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
  */
@@ -422,7 +422,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
  *
- * Cannot be called within an interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
  * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
-- 
2.34.1

