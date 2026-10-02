Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA193EB7F4;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982694; cv=none; b=FudiHm4h7K7BI+eVtPlXNkFFS8vBNDiH2NSPYja8QOq/BMUY/lF4Usy6n2iYEDuFst3iRVkLBkdo8hFNbgKZG3Y1wAFQZ3RcYLwQORTapDmIn+Z2BxHV3DyhDqUmz3y0cdGH+TvZCmGw58aqQsj4P/oBt2L5qloAU0CpI/UiXlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982694; c=relaxed/simple;
	bh=QjrjRWiPlStTZ9Cuw3ASdtaVlT3rP0Cd9M68tzV6oRw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G4E2SocMYfgELOeBRi7hJfzFu9ETe52XVx3NLAKVnUZ6sdFxjLoRxCZzxklPCibS+yv7FedpMhh9VSYV8fNCZaLuasiVt0NGVTV4iSlG5MM8T3whchxu4cHkPHr1iqlTvThPc5R/Q7ZbeshGJl3SkBK6iyeYOJWAyT1GlKkFSHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WX9OTQZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WX9OTQZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2404D1F000FF;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=7sFn9nTy/0M8Manz3Ov3zjSMZmnOUPsuIFDC5cAOrJM=;
	h=From:To:Cc:Subject:Date;
	b=WX9OTQZ5f8MIdYmno3tB9LVcEkBK9w0haMdscxstPKJcdFV4qOehzGOmGJNwZlcwt
	 dMFoUuAYtDw2pltFdFTdaIKCTyfF1ajGwCNP9RPaX3y7MrzsuyMR2hSoMKiEK+tb6T
	 oMuiVqkKd2l3QX4RPkoOrEV9yi8CyffejJPJYXBpeYgSZO+i3hJze3d0VszgUBrkwk
	 nlcBMCsndQzgKso02eemH/h1Y3dcUreRZrur82oIvV2Q/sR9OWdWTu4nOB2DZPT6P0
	 N1Je91CKwthhBMW5rx9tB4vxCPp4R56z69aQDnYkkgIOB4yb24VDs9kmrnb7nwXT2x
	 Uv9B0rGCD9jaA==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
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
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH net-next v5 0/7] net: skb: isolate skb data area allocations into a separate bucket
Date: Fri,  2 Oct 2026 16:11:20 -0700
Message-Id: <20261002231120.late.500-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2360; i=kees@kernel.org; h=from:subject:message-id; bh=QjrjRWiPlStTZ9Cuw3ASdtaVlT3rP0Cd9M68tzV6oRw=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrGR9+dt+TX8RuXLy0ftnen5dUAvbvKa9NHnuvgfvT ypcdj9U2FHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjCRpcwM/wwnFZT98rzaMseu b8rJo/eubXjut/Gj8kRtPh2x/nurWJsZGXbFVO0SknljvMD45Yfpx6w3Hz+7deXGkC+T22bxZU1 fwsEJAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi!

This gets the buckets able to handle memcg (GFP_KERNEL_ACCOUNT) with
isolation (since it's common due to AF_UNIX), and GFP_DMA with fall back
(since it's rare). It gave me an excuse to build out bucket kunit tests
too, and that (and LLM review) found a couple other issues that needed
fixing too.

The bulk of this is mm/slab, but the final patch is netdev, which Paolo
acked in v4, so I'm hoping this whole series can go via slab?

Thanks!

-Kees

 v5:
 - 2/7: kmem_buckets_create() and kmem_buckets_create_types() take an
   alignment, where kmem_cache_create() has it; 0 keeps v4's behaviour,
   the alignment of the kmalloc cache being mirrored. All callers pass 0.
   New subject: "mm/slab: Let kmem_buckets_create() take an alignment"
   (Harry)
 - 4/7: test that an explicit alignment is honored.
 - 5/7: export mem_cgroup_kmem_disabled() for KUnit only, fixing a
   modular build of slub_kunit (Harry).
 - 6/7: commit log shows the per-set cost of indexing rows by
   kmalloc_cache_type; test that an explicit alignment reaches the
   accounted row too.
 - 7/7: pass the new alignment argument.
 - Collected tags on 1/7 (Harry, Pedro, Hao) and 7/7 (Paolo).
 - v4..v5 diff: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/diff/?id=dev/v7.3-rc2/skb-buckets/v5&id2=dev/v7.3-rc2/skb-buckets/v4
 v4: https://lore.kernel.org/all/20260921075811.too.775-kees@kernel.org/
 v3: https://lore.kernel.org/all/20260702170728.168755-1-pfalcato@suse.de/


Kees Cook (6):
  mm/slab: Mark the kmem_buckets_create() context as a Context: section
  mm/slab: Let kmem_buckets_create() take an alignment
  mm/slab: Add kmem_buckets_destroy()
  mm/slab: Add tests for the existing kmem_buckets behaviour
  mm/slab: Provide kmalloc type fallback for bucket allocations
  mm/slab: Let a bucket set handle __GFP_ACCOUNT

Pedro Falcato (1):
  net: skb: isolate skb data area allocations into a separate bucket

 include/linux/slab.h   |  66 ++++++-
 mm/slab.h              |  44 ++++-
 ipc/msgutil.c          |   2 +-
 lib/tests/slub_kunit.c | 397 +++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c        |   2 +
 mm/slab_common.c       | 173 +++++++++++++++---
 mm/util.c              |   2 +-
 net/core/skbuff.c      |  11 +-
 8 files changed, 663 insertions(+), 34 deletions(-)

-- 
2.34.1

