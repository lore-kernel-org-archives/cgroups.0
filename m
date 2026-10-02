Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BE64BA1D6;
	Fri,  2 Oct 2026 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982696; cv=none; b=Lk0I3mNcCIK95dFfz5sbtgO3lNjWY2gZ4+S5l5Jyz/o+5+QM4OldHnXlvoWwjVxO6idCdDVVNU49X/FlCt/mpcVdutjEWcEuviRy2++Ec2Fl3PMowKLru9idpmuZSAqdoxue5W6lImmEDZk808RTjjPo6HkbPS6o4fCzL4BPQ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982696; c=relaxed/simple;
	bh=bjKkE0PS44xIIBmXfOgrzZyg+bEE8UE2hoDOlBTc8gA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RFXqXUduOaosEMfSVOhDrreXD25SWgiQf8yBkLldXrhiHP6gJ8f5IjONp+35E+zL13Wsi1+zYb/a9z/ZcINIZbaEV4pNXXUD46BuLm9kWRvlQt7IEVr6vMiDYVTFZZ3lsmS+61jV4sasqW4qOSUXouTQCBe6xDchqMr1iLwmieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZwDDJgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZwDDJgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F0F1F00A06;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=2S6KB+pb+BQT5oUBqFqBJ538QVfRgtrf68Zq5YYeGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZwDDJgAQSghfefVAcf1aopBete44JcDPrKGL6PJwJzfBYFU8vMxVqCe6UyXBmz/x
	 TNQeNLWMRwMUN6KJG15N/2h49A9XaujWv7NDH6MJZ720SGkGECRdDU990p97hf1aLN
	 wAG6n7Qf+ekX54iwAG64JAb0SfxnTUZU0ru3PwUjtQYvvLu2bltbmU8PIsXEvWyi1J
	 FcQVEDnLZz+hh18WTUf3Y+ZIDWphF2xeYyAF9qJWzxbt7uWdJHiwOm/AYHppugfpFU
	 YqLeFIvXsYj6Ah3zUyhGN1j2oAN4O/dEO9yCtD3zJGrV75IJQB8zw3Mt7Zd+4wiy0l
	 hyQT9D+tFV0Yw==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	netdev@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: [PATCH net-next v5 7/7] net: skb: isolate skb data area allocations into a separate bucket
Date: Fri,  2 Oct 2026 16:11:27 -0700
Message-Id: <20261002231132.1646573-7-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3039; i=kees@kernel.org; h=from:subject; bh=6RSadgWMGYr7w5XXzzDRtJ8OGCSMMWfVJU83WYKH/TQ=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrOT9qv5cV5CaV7MmgWXeH1HWxZ+47u33u886tfcO4 5dt0X7bOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACai/JGRYWrn6d6I6MO9V+1E U86tY6maqum/cdUiy7XHdti1hjKz5zP8Mw/kaXirdKske23hPeVWuZSW3raY3fPuW9cr3hX8+b2 ACQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

From: Pedro Falcato <pfalcato@suse.de>

SKB data area allocations (as done from alloc_skb()) use kmalloc().
These allocations can be variably sized and their contents can be more
or less controlled from userspace, which makes them useful for attackers
that want to overwrite a use-after-free'd object from the same kmalloc slab
(which often just requires the sizes to roughly match into the same kmalloc
bucket). [0] is an easy example of an exploit that uses netlink skb
allocation to target another similarly-sized accidentally freed object.

While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
probabilistic. Use the existing kmem buckets API to further isolate these
allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.

Ask for the accounted kmalloc type as well as the normal one. AF_UNIX
sets sk_allocation to GFP_KERNEL_ACCOUNT, so without it every AF_UNIX
skb data area would fall back to the general caches, and those are the
ones most worth isolating. GFP_DMA is left to fall back, being passed to
an skb allocator only by rare devices.

Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 net/core/skbuff.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 966af3beed94..e0660b2dbc19 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -586,6 +586,8 @@ struct sk_buff *napi_build_skb(void *data, unsigned int frag_size)
 }
 EXPORT_SYMBOL(napi_build_skb);
 
+static kmem_buckets *skb_data_buckets __ro_after_init;
+
 static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 {
 	if (!gfp_pfmemalloc_allowed(flags))
@@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 	if (!obj_size)
 		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
 					     flags, node);
-	return kmalloc_node_track_caller(obj_size, flags, node);
+	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
+						    flags, node);
 }
 
 /*
@@ -634,7 +637,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(obj_size,
+	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (likely(obj))
@@ -5235,6 +5238,10 @@ void __init skb_init(void)
 						0,
 						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
+	skb_data_buckets = kmem_buckets_create_types("skb_data", 0, SLAB_PANIC,
+						     0, INT_MAX, NULL,
+						     BIT(KMEM_BUCKET_NORMAL) |
+						     BIT(KMEM_BUCKET_CGROUP));
 	skb_extensions_init();
 }
 
-- 
2.34.1

