Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DA742EEC7
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576171; cv=none; b=BeNxmq8KwDafRY0hlCO0r/byGwRiW7qlxOgjHgOYFXaZ4fn8kumtVnplbY7AL1lVRAFicDum91LnwKH+HxMUZbIZYZMIWZSUzDEAyQSs/3EbW8DSMv+ie9WlrJ38vghSmK/nIXGPbHWbkj9Eb3b2ghs5J3Hh3itL8kggnepTFWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576171; c=relaxed/simple;
	bh=17uSNxWNbNfWeu2defMnk2WRNed4MZXXsNWHp0EQmes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENN2AAfXR7VSpPFhxXpq7EmrQIjnbJNHi0E0uzwU/5ho141rud+uHvQCEYJ4CvPHMggM+QZN16W4GMhEOychsM67Xwe/qP0xUW/MDKbvjl4ZNNNSbGyy93Rseo22qjHdpSFZNGtYY42Q24wenhnBwoUI7gVBKnkgXWrv7YNyNTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=gyG5iNuS; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="gyG5iNuS"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e65e18969so422892785a.1
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576166; x=1785180966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DV5Z1tJXaWxvckL3peka95N+5/TymDiplHxo+CY2ByI=;
        b=gyG5iNuSRpUpNeoHOEe2cC0+VGaK4vcuw6B6u+zHFEOQ+XXJPsurLkz3WSlKsBHxHL
         n04qReqwTShdXg9tHAGgMk0GrWDqCQTPsLk0huQFsLFMu8Gs4eKuBR6NJqZ51IGrjJ5g
         e5OzhE8xe3+INxF0UGvolPJOyBIG4MD3rqNgoE3UE9bJTlv9fHG4609DiiwoHMNKMS0K
         WcAdY7fDktxKMyzvigpUx7GWuLQcPYUjaSDhZMx2h45Rt6leWZmHTjAmZUgDB2yQVC0L
         Xrn77+ChnmzDUs1g7YsC2mGcmTs7JMni6INFnOvFNgUwkoqh3gHz8pzAZwGUZjd5W71t
         rxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576166; x=1785180966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DV5Z1tJXaWxvckL3peka95N+5/TymDiplHxo+CY2ByI=;
        b=emphb9e2uQHjHb++Vk6Kky8/2xG9VYDSvYivFEmmQQAhtEAuIebVKFIvdtRNJ5k74X
         mWlf5sGhLQWNSoW6eCQPK+Vvw1cC51Y/3JT/7qf2ZkE6d+AaR6kCl4GU96F+OQPs2A5a
         RHdoCW/eqNnUvObVz0LZqvT5RdPDLVISyDMqd7zJx35daVgWAwsTf4NiYPxmI6w6odIv
         KWnw02+JVfMoQDnE+5N7rZfDmvYUMf/sSrqmlqafNw7vIXapSetvAyvo9HlfOObP41Wo
         syK/fYzRy0+l1ciAKlveu0mlmCkaY/qnOeU7hOa44bEoJT7oPHKf+UAaDc7xhAyfgRzA
         w/WA==
X-Forwarded-Encrypted: i=1; AHgh+RruQgDPdP9VhSJhLXCH8TbpmKbhEu1UlVAEEjkPRUilnBWtiHRwqgJ4NSEYWeJ33j0Y+9w1jZlu@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi23XVklsCsqAsNIVoMQ4FnOiB04ZMztjy4333FvTob/evsPWg
	jcGe77rETLq8fsDA/N9VYZbbxdU8IrA8/VNBvDJdt69toKaWF91Eo20gDtTkU0Dag+I=
X-Gm-Gg: AfdE7cnEtlKVPijjlB6pV/eFn72rW2a7xuSLherV9qBOep08jLlGRdPOhLOmUQeudTV
	m2RtWRUC5zVYq8SEjRW+gbxo+92asqwzacx/e25x/YfaWAJin5rjsPU+doiKBjHcCtYAr/E21+z
	G7e9OoPxubmUCdznsEs9kQwW7CUWh5k1Kb7XW+qLb3hx1CqnPp2AQfMnLPJ6xLP3v83RbK04q2v
	YkN8k/9kzamN9VarJPuUlPrLycELJ2EXEW/8olWt/0GSVTkpmqkS6gG3nB8Z2Y2reYZZsMkW5R1
	HAZ/EcqRjHXzCD+6AmDGxDQdoxpzLfy3iqGAH+oP1fwDDPE9D1kF3y0e9Bsa1Gj4Ghf4WoPeCyz
	y9TVfMs9qvi8pkm0yEYt53Su+gzCC9o1I2/eq15CrKVXXvYHfSruZQ+ymOFXYLvCzTZ/du9sFom
	8q5IDQ6dIgnN/hKA0SGvFnB5cHjGbHy+PJdWCSti/4pMPNea4Ul4pCYxGaXYu2IHU=
X-Received: by 2002:a05:620a:171f:b0:930:5a34:3882 with SMTP id af79cd13be357-930b482d3d6mr1498824485a.2.1784576165506;
        Mon, 20 Jul 2026 12:36:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:05 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 33/36] Documentation/mm: describe private (N_MEMORY_PRIVATE) memory nodes
Date: Mon, 20 Jul 2026 15:34:27 -0400
Message-ID: <20260720193431.3841992-34-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a design overview of private memory nodes:
  - the isolation model (structural zonelist exclusion)
  - ZONELIST_PRIVATE
  - driver provisioning API
  - capability opt-in model and its dependency rules
  - observability surfaces

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/mm/index.rst              |   1 +
 Documentation/mm/numa_private_nodes.rst | 160 ++++++++++++++++++++++++
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/mm/numa_private_nodes.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 13a79f5d092c0..f60704df6104c 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -65,6 +65,7 @@ documentation, or deleted if it has served its purpose.
    mmu_notifier
    multigen_lru
    numa
+   numa_private_nodes
    overcommit-accounting
    page_migration
    page_frags
diff --git a/Documentation/mm/numa_private_nodes.rst b/Documentation/mm/numa_private_nodes.rst
new file mode 100644
index 0000000000000..3b27a2e24b086
--- /dev/null
+++ b/Documentation/mm/numa_private_nodes.rst
@@ -0,0 +1,160 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Private memory nodes
+====================
+
+A *private memory node* is a NUMA node whose memory is hotplugged by a driver
+and deliberately hidden from the kernel's normal memory management.  Such a
+node is marked ``N_MEMORY_PRIVATE`` instead of ``N_MEMORY``; the two states
+are mutually exclusive, so a private node is never considered by the page
+allocator's normal or fallback paths.
+
+The intent is to give a driver a block of NUMA-addressable memory that the rest
+of the kernel will not allocate from on its own, while still letting that memory
+be mapped into processes as ordinary, struct-page, LRU-managed folios -- and to
+let the driver re-enable individual mm services it is capable of allowing.
+
+Preconditions
+=============
+
+``N_MEMORY_PRIVATE`` and ``N_MEMORY`` are mutually exclusive, so the backing
+memory must come up on a node that has no DRAM of its own (otherwise the node
+would already be ``N_MEMORY``).
+
+In practice the memory is provided by a device driver or a DAX device whose
+target node has no other memory, and usually no CPUs.
+
+Isolation model
+===============
+
+Isolation is *opt-in by exclusion* and is **structural**: by default nothing in
+the kernel can place memory on a private node because the node is absent from the
+zonelists an ordinary allocation walks.
+
+Zonelist exclusion
+    The kernel page allocator depends on the ``FALLBACK`` and ``NOFALLBACK``
+    zonelists to allocate memory.  A normal ``N_MEMORY`` node's zones (except
+    ``ZONE_DEVICE``) appear in these lists and allow allocations to fall-back
+    to less preferable locations if the preferred location is pressured.
+
+    ``__GFP_THISNODE`` is used during normal operation to switch between
+    ``FALLBACK`` and ``NOFALLBACK``, where ``NOFALLBACK`` only contains the
+    zonelists of the preferred node.
+
+    ``N_MEMORY_PRIVATE`` nodes are **excluded** from both ``FALLBACK`` and
+    ``NOFALLBACK`` zonelists.  Instead they are added to ``ZONELIST_PRIVATE``,
+    which includes both ``N_MEMORY`` and ``N_MEMORY_PRIVATE`` nodes.  This is
+    the only zonelist that contains private-node zones, and so the only way
+    to acquire private node allocations is to explicitly request that zonelist.
+
+    Even an allocation carrying ``__GFP_THISNODE`` cannot access the node's
+    memory without also explicitly passing the private zonelist.  This prevents
+    incidental allocation of private memory by users of possible/online
+    nodelists.
+
+    When ``CONFIG_NUMA`` is disabled ``ZONELIST_PRIVATE`` aliases
+    ``ZONELIST_FALLBACK`` and is never selected.
+
+The user_numa path
+
+    ``MPOL_F_PRIVATE`` is an internal user_numa flag (never accepted from
+    userspace) marking that a mempolicy has a private node in its nodemask.
+
+    When ``CAP_USER_NUMA`` for a private node is set, user-sourced mempolicy
+    (``set_mempolicy(2)``) and migration (``move_pages(2)``) operations are
+    allowed to include that node in nodemasks and targets respectively.
+
+    ``mbind(MPOL_MF_MOVE)`` is both a mempolicy and a migration operation,
+    so placement and migration share the same capability.
+
+    The mempolicy component uses ``MPOL_F_PRIVATE`` at fault-time to select
+    ``ZONELIST_PRIVATE`` and makes the node's memory available for allocation.
+    It is otherwise an ordinary, relaxable mempolicy: an unsatisfiable request
+    (an unmovable allocation on a movable-only private node) simply falls back.
+
+
+cpuset interaction
+==================
+
+cpuset.mems does **not** partition private nodes.  cpuset neither grants nor
+denies access, and rebinding cpuset.mems nodemasks do not affect a private node's
+residency in any nodemask.
+
+Likewise, a private node's inclusion in a nodemask does not affect cpuset.mems'
+filtering of any ``N_MEMORY`` - they remain partitioned according to cpuset.
+
+
+Provisioning
+============
+
+A driver brings memory up as private with::
+
+  add_private_memory_driver_managed(nid, start, size, resource_name,
+                                    mhp_flags, online_type, np)
+
+which onlines the range and registers the driver-owned ``struct node_private``
+(``np``) describing the node, including its capability bitmap (see below).
+
+Only one driver/service may register a ``struct node_private``, which
+heavily implies a "one-node-per-device" design of the system.
+
+The node leaves ``N_MEMORY_PRIVATE`` only when the last range is offlined.
+
+.. kernel-doc:: mm/memory_hotplug.c
+   :identifiers: __add_memory_driver_managed
+
+.. kernel-doc:: drivers/base/node.c
+   :identifiers: node_private_register node_private_unregister
+
+Capabilities (per-service opt-ins)
+==================================
+
+Because the default is "no mm service touches the node", each service a driver
+wants back is requested explicitly through a capability bit in
+``np->caps``.  The mm side checks the matching ``node_allows_*()`` /
+``folio_allows_*()`` predicate before acting:
+
+.. list-table::
+   :header-rows: 1
+   :widths: 35 65
+
+   * - Capability
+     - Re-enables
+   * - ``NODE_PRIVATE_CAP_RECLAIM``
+     - reclaim of the node's folios, by the mm and by userspace
+       ``MADV_COLD`` / ``PAGEOUT`` / ``FREE`` (userland-driven reclaim)
+   * - ``NODE_PRIVATE_CAP_USER_NUMA``
+     - all userspace-directed placement and migration: ``mbind()`` /
+       ``set_mempolicy()`` / home node, and ``move_pages()`` /
+       ``migrate_pages()`` to/from the node
+   * - ``NODE_PRIVATE_CAP_HOTUNPLUG``
+     - hot-unplug via migration
+   * - ``NODE_PRIVATE_CAP_DEMOTION``
+     - reclaim-driven tiering demotion onto the node (the node joins the
+       demotion hierarchy)
+   * - ``NODE_PRIVATE_CAP_NUMA_BALANCING``
+     - access-based NUMA balancing scan/migration of the node's folios
+   * - ``NODE_PRIVATE_CAP_LTPIN``
+     - ``FOLL_LONGTERM`` GUP pins
+
+khugepaged never operates on private-node folios (like ZONE_DEVICE), and DAMON
+does not act on them; ``MADV_COLLAPSE`` is covered by ``CAP_USER_NUMA``.
+
+Dependencies between capabilities are enforced **once**, by
+``node_private_register()`` at hotplug, rather than by whatever sets the bits:
+
+* ``DEMOTION`` requires ``RECLAIM`` (a demotion target accumulates demoted
+  pages, so without reclaim as a safety valve it would just fill up).
+
+Capability flags are expected to be stable at runtime.
+
+Observability
+=============
+
+A private node is reported through:
+
+* ``/sys/devices/system/node/has_private_memory``
+* ``/proc/<pid>/numa_maps`` -- per-node residency includes private nodes
+* ``/proc/kcore`` -- private-node RAM appears in the kcore RAM map
+* memcg per-node statistics account private-node memory.
-- 
2.53.0-Meta

