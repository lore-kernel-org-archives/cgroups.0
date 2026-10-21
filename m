Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792583244;
	b=zUG3mWGxzlTEWvdLuMDAYYYFCvZUHTJL4kjWpYua+F04pnUTUcoF24xyHFWyMPVQEVq0
	 QlwSxDZHzVgXcj9wZEbSkO7qDf2osbGY8v9peIpftP48RaJA+6wDvqozYLCpOu8OysSJr
	 //bMmS8VB8ysMlHbVpp77vW3Z9RMChVItvFdGkBhaM79fPN5/O8ur2mS0dgapWg4TqaZa
	 Dx5oXIbwPR4oEhMOr0Yn1f5gaBavx7euh97dFUyRvX6Pzmp9ZPfQLiKOIHPk0H9aIdc6+
	 lBsqJ17eltepHW8xhNoDYbTAnFSGULIgbH7szGm/p3uUgWtkr4ul0DqfKSG+O0pEMLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583244;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer;
	bh=ni/h9FbFXhjgUwMn3rSI6p6WKM6vJUoZQ7p4kXWNy5U=;
	b=H9y4nQ9fdSCMdOUlpX+oHX51SzCJ0oL7a3YO23aktKQm/wZE57FOA8OB+dD5Whb7c7d8
	 a681kX16kGq7ot3wVb+K3eWr6bU2e0JJgtwtSQE+p9DN2/6YP2ACBQ7FlYZC7+2Cltlc7
	 62JsjD85xMP7pluOrQvwWnyLHxM4eUX04PQgSABHrodpE+yKAyAuh50rItXgGi32QlDLO
	 w23wRm6jEzC9QV/NojWGiOkdphVsy2DCGmBDhv0VjaiPjWae4Kt8e9siruldYHr59brFE
	 WZiEmK+5VfQSQ1aY57U/TcyGEgwHOfv7lt2kJ1vmBVIj1CkQcGhFGqJ+uxr7OXiO83w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CYoDM5Pa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028E3606A336;
	Wed, 21 Oct 2026 11:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CYoDM5Pa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6273E1F000C9;
	Wed, 21 Oct 2026 11:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583243;
	bh=ni/h9FbFXhjgUwMn3rSI6p6WKM6vJUoZQ7p4kXWNy5U=;
	h=From:Subject:Date:To:Cc;
	b=CYoDM5Pavgm81Nyqql/3raaF54bJHC58QBIN2LWkciYwVz/5h0B59Mzqf+MizWhuG
	 jz1jqdZBrCVcOiuBlNKByULWJ1opgAfsu6rGbrXchF6lDKL0n3E7YBPLDmlvH4SomP
	 EwK6xf91kUvpKSYBLoN93tqkZEIIM+EQDd/MtGC+CkW8ELRb6JoLU0YWJID6o1xYYu
	 ytarFAlqWQwFi5zehp/FR0wZedTqnzpswlsUkOJFSN4QGs/PJzNH/hWIdpDpjg095M
	 iA9tNi2+MjR+D9YSXEgR0LJTuWJVOUDhF/C3a3+5nVsnJMgWNwZEK8lVMtS2+tpncg
	 hi/X40TnN+WtA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: [PATCH slab/for-next 00/14] mm/slab: mandate SLAB_MAY_ACCOUNT for
 __GFP_ACCOUNT allocations to avoid wasting memory for slab metadata
Date: Wed, 21 Oct 2026 12:46:41 +0100
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIACGm2GoC/yWN2w7CIBBEf6XZZzf2go31VxofFliUhkIDqE2a/
 rtUHyczZ84GiaPlBLdqg8hvm2zwJTSnCtST/IPR6pKhrdu+qRuBM8/kXFC4xGBQB5/xQykzJkc
 yyAl5zWWUSVMm7IQZRMdm6C9XKJ9LZGPXn2+EgzibENEXBu7/Or3kxCofTtj3Lz+lqCygAAAA
X-Change-ID: 20261014-memalloc-prof-dont-waste-slabobj-ext-metadata-34f943ef9658
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
 Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, 
 Willem de Bruijn <willemb@google.com>, 
 Mina Almasry <almasrymina@google.com>, 
 =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, 
 linux-arm-kernel@lists.infradead.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 linuxppc-dev@lists.ozlabs.org, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Niklas Schnelle <schnelle@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Chen-Yu Tsai <wens@kernel.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
 Samuel Holland <samuel@sholland.org>, iommu@lists.linux.dev, 
 linux-s390@vger.kernel.org, linux-sunxi@lists.linux.dev, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 cgroups@vger.kernel.org
X-Mailer: b4 0.16.0

The purpose of this series is to convert existing slab users that
specify __GFP_ACCOUNT on allocations to specify SLAB_MAY_ACCOUNT on
cache creation, to reduce memory waste for slab metadata with
CONFIG_MEMCG=y && CONFIG_MEM_ALLOC_PROFILING=y.

Currently, there are two ways to charge slab objects to memory
cgroups: 1) specify SLAB_ACCOUNT during cache creation, or 2) specify
__GFP_ACCOUNT on allocation. The latter method made it impossible to
assume that certain slab caches are never charged to memory cgroups.

Since commit d4404b0f5b8b ("mm/slab: stop allocating objcg pointers when
unnecessary"), slabobj_ext allocates the space for the objcg pointer
only for caches with SLAB_MAY_ACCOUNT. However, kmem_cache_create() sets
the flag on every cache, because any cache may be used with
__GFP_ACCOUNT.

As a result, sizeof(struct obj_cgroup *) bytes are wasted for each
unaccounted slab object when both memalloc profiling and memcg are
enabled. This is suboptimal when memalloc profiling is used to
profile memory allocations on production.

So, let's make memcg charging opt-in and stop wasting memory!

New rule for slab users: a cache must specify SLAB_MAY_ACCOUNT
(explicitly or implied by SLAB_ACCOUNT) for its objects to be charged
to a memcg. Otherwise __GFP_ACCOUNT is ignored and triggers a warning on
debug kernels (CONFIG_DEBUG_VM=y).

The approach is quite straightforward, but converting all caches that
may pass __GFP_ACCOUNT without SLAB_ACCOUNT at once is not.
As a best-effort approach, I swept the whole tree (with help of an
LLM) for paths that pass __GFP_ACCOUNT into slab allocations either
directly or indirectly.

While I tried to make sure the sweep is exhaustive, there can be a
missing conversion. However that is not a correctness problem:
the objects are just no longer charged to memcgs. Patch 13 adds
VM_WARN_ON_ONCE in __memcg_slab_post_alloc_hook() to catch such a
missing conversion.

Patch 1 allows passing SLAB_MAY_ACCOUNT to kmem_cache_create(),
patches 2-12 specify SLAB_MAY_ACCOUNT for the caches found by
the sweep, and patch 14 stops setting SLAB_MAY_ACCOUNT on all caches.

On an idle x86 VM with both memalloc profiling and memcg enabled,
slabobj_ext memory (the alloc_slab_obj_exts entry in /proc/allocinfo)
drops from 1,280KB to 910KB (-29%) after boot. The savings are expected
to be larger on real workloads, which allocate far more unaccounted slab
objects (8 bytes per unaccounted slab object).

Each tested cache was verified with the warning in patch 13:
I confirmed that 1) the warning is triggered without the conversion,
and 2) specifying SLAB_MAY_ACCOUNT resolves it. However I could not test
io-pgtable_armv7s_l2 and sun50i's pt_pool caches due to lack of the
hardware and emulation support. So they are compile-tested only.

  cache                  tested  environment
  ---------------------  ------  -----------------------
  radix_tree_node        yes     x86
  maple_node             yes     x86
  buffer_head            yes     x86
  skbuff_head_cache      yes     x86
  fanotify_*_event       yes     x86
  smack_rule             yes     x86
  io-pgtable_armv7s_l2   no      compile-tested only
  thread_stack           yes     ppc64le (64K pages)
  pgd_cache (arm64)      yes     arm64 (64K pages)
  PGT_CACHE (powerpc)    yes     ppc64le
  PCI_DMA_*_tables       yes     s390x (zPCI + vfio)
  hostfs_inode_cache     yes     UML
  sun50i pt_pool         no      compile-tested only

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
Harry Yoo (Meta) (14):
      mm/slab: allow passing SLAB_MAY_ACCOUNT to kmem_cache_create()
      lib/maple_tree: specify SLAB_MAY_ACCOUNT for maple_node cache
      lib/xarray: specify SLAB_MAY_ACCOUNT for radix_tree_node cache
      fs/buffer: specify SLAB_MAY_ACCOUNT for buffer_head cache
      net: skbuff: specify SLAB_MAY_ACCOUNT for skbuff_head_cache
      kernel/fork: specify SLAB_MAY_ACCOUNT for thread_stack cache
      arm64/mm: specify SLAB_MAY_ACCOUNT for pgd_cache
      powerpc/mm: specify SLAB_MAY_ACCOUNT for pgtable caches
      iommu: specify SLAB_MAY_ACCOUNT for slab-backed page table caches
      fanotify: specify SLAB_MAY_ACCOUNT for event caches
      smack: specify SLAB_MAY_ACCOUNT for smack_rule cache
      hostfs: specify SLAB_MAY_ACCOUNT for inode cache
      mm/memcontrol: do not allow charging objects without SLAB_MAY_ACCOUNT
      mm/slab: do not set SLAB_MAY_ACCOUNT for all caches

 arch/arm64/mm/pgd.c                |  2 +-
 arch/powerpc/mm/init-common.c      |  3 ++-
 drivers/iommu/io-pgtable-arm-v7s.c |  2 +-
 drivers/iommu/s390-iommu.c         |  4 ++--
 drivers/iommu/sun50i-iommu.c       |  3 ++-
 fs/buffer.c                        |  2 +-
 fs/hostfs/hostfs_kern.c            |  2 +-
 fs/notify/fanotify/fanotify_user.c | 10 ++++++----
 include/linux/slab.h               | 16 +++++++++++++---
 kernel/fork.c                      |  3 ++-
 lib/maple_tree.c                   |  2 +-
 lib/radix-tree.c                   |  2 +-
 mm/memcontrol.c                    |  6 ++++++
 mm/slab.h                          |  2 +-
 mm/slab_common.c                   |  8 +++-----
 net/core/skbuff.c                  |  2 +-
 security/smack/smack_lsm.c         |  2 +-
 17 files changed, 45 insertions(+), 26 deletions(-)
---
base-commit: d15d7703166daf7bd62c844a3cb1b3a6279adb4c
change-id: 20261014-memalloc-prof-dont-waste-slabobj-ext-metadata-34f943ef9658

Best regards,
--  
Cheers,
Harry / Hyeonggon

