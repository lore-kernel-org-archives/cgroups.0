Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25F8381AE7;
	Tue, 18 Aug 2026 02:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020470; cv=none; b=BoSzXpBmQs/bAxZDHNu4+M9bSeAeDZ7VndZY9fGOtwtmqOJQs+8Zpps57kiQf/vKnEOh5C8Jp1BZq2QrrBNCTzkZ3/u893hpmaCvjaf8vi+1T0kLYBU31xNlgKLF7CM4LBuyL1VTXL/EZ7xKiVSU3BaNoGFVCsMfRAkZrT8VKis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020470; c=relaxed/simple;
	bh=uaRBqcR9lHQHawpp7+rRKsRE1Rn90J8ljpANikUIZeU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oYX33N4bbdHkandoCmEoUL4SNN2i/x39TyZSX9zm4/jw4QOcDZLkJzTttXBOy5Q3Al2VeHhMuds1AccCfbtTuskWV1D0PA6qn3HnpvZkGptE+U6i+H7S94NQtgq/AFV8e5RbthtagdTWhLhwlpf4/qCxHT8C6fxAKoNuppFfzCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 508344ca9aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:54965268-4203-4b57-b4ff-b1cd1b4b2efd,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:54965268-4203-4b57-b4ff-b1cd1b4b2efd,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:f6d94200ad9876474a8648ca9f656496,BulkI
	D:260818103421R58TZA7K,BulkQuantity:0,SF:10|66|78|102|123|127|136|850|865|
	898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:99|1,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 508344ca9aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 896177119; Tue, 18 Aug 2026 10:34:19 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Tue, 18 Aug 2026 10:31:13 +0800
Message-Id: <20260818023121.100613-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiqi Liu <liuqiqi@kylinos.cn>

This RFC introduces per-tier memory cgroup accounting. Each cgroup
tracks its memory usage per memory tier (e.g. DRAM, CXL), exposed
through a new memory.tier control file that reports per-tier usage
and accepts independent high (soft) and max (hard) limits per tier.
By default these limits are auto-derived from memory.high / memory.max
based on per-tier capacity ratios, and can be manually overridden.

The implementation integrates with the existing memory tiering and
demotion infrastructure. Per-tier usage (anonymous and file) is tracked
via dedicated page counters, and cross-tier migrations (e.g. demotion
from DRAM to CXL) correctly re-account charges. When a tier hits its
high limit, async reclaim is triggered within that tier's NUMA nodes;
exceeding max enforces reclaim scoped to the tier's own nodes, or OOM.

The feature is fully opt-in. When disabled, no extra counters or
charge/uncharge paths are created, memory.tier reads empty, and there
is no measurable overhead.

Why per-tier limits?
-------------------

On tiered memory systems, memory.max constrains total usage but cannot
express "keep fast-tier usage under X". Without per-tier limits, a
workload can monopolise DRAM, pushing other cgroups onto slower tiers.
This series gives each cgroup independent high (soft) and max (hard)
limits per tier, exposed and set through a new memory.tier file.

By default those limits auto-derive from memory.high / memory.max by
capacity ratio; writing memory.tier pins a tier.

This series takes a different approach from Joshua Hahn's toptier RFC [1],
tracking a separate page_counter per (memcg, tier) for N-tier support and
exposing writable per-tier limits under a cgroup mount option.

Patch structure
---------------

  1/8  mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
  2/8  mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
  3/8  mm/memcontrol: add per-tier page counter infrastructure and lifecycle
  4/8  mm/memcontrol: add per-tier charge and uncharge
  5/8  mm/memcontrol: add per-cpu stock for tier charge/uncharge
  6/8  mm/memcontrol: add memory.tier control file
  7/8  mm/memcontrol: auto-derive tier high/max from memory.high/max
  8/8  cgroup: add memory_tiered_limits cgroup mount option

Patches 1-2 are infrastructure (helpers in memory-tiers and vmscan).
Patches 3-5 add the core accounting: counter lifecycle (3),
per-page charge/uncharge (4), and stock batching (5).
Patch 6 adds the userspace file. Patch 7 adds auto-derivation. Patch 8
gates everything behind a mount option + kernel cmdline, so the feature
adds no measurable overhead when not opted in.

Usage
-----

Boot with:

  cgroup_memory_tiered_limits=1

Or remount at runtime (affects newly created cgroups only):

  mount -o remount,memory_tiered_limits /sys/fs/cgroup

Per-tier limits and usage can then be read from and written to
memory.tier.

Scope and limitations
---------------------

- Only LRU folios (anonymous and file pages) are tier-accounted. Kernel
  memory and socket buffers are not yet accounted per tier; support for
  these is planned as follow-up work.
- Per-tier memory.min and memory.low protections are not implemented.
  These can be added later by extending the per-tier interface to
  expose and enforce min/low protection.
- The command-line parameter mirrors cgroup_favordynmods; automatic
  enablement via the cgroup mount path is left to userspace.

Testing
-------

Tested on QEMU with fake NUMA (DRAM tier 4 + CXL tier 22), with
cgroup_memory_tiered_limits=1 on the kernel command line and demotion
enabled.

Set up a cgroup, apply per-tier limits, and run a memory-intensive
workload:

  $ mkdir /sys/fs/cgroup/mycgroup
  $ cd /sys/fs/cgroup/mycgroup
  $ echo "tier4.high=200000000" > memory.tier
  $ echo "tier4.max=300000000" > memory.tier
  $ echo 1 > /sys/kernel/mm/numa/demotion_enabled
  $ cgexec -g memory:/mycgroup ~/stream --ntimes 5 --malloc &
  $ cat memory.tier
  tier4.current=296488960
  tier4.high=199999488
  tier4.max=299999232
  tier22.current=1625464832
  tier22.high=max
  tier22.max=max

DRAM (tier4) usage stays under tier4.max (hard limit, no OOM) but exceeds
tier4.high (soft limit, suggesting that async reclaim is in progress);
CXL (tier22) absorbs the overflow via demotion.

Also verified:
  - tierN.current tracks per-tier usage (anon + file).
  - Cross-tier migration (demotion) correctly re-accounts.
  - memory.high / memory.max auto-derives tierN.high / tierN.max.
  - Manual override (writing a number to memory.tier) pins the limit.
  - Tier max enforcement triggers reclaim scoped to the tier's nodes.
  - Feature fully off (no mount option): no counters, no charge/uncharge,
    memory.tier exists but reads empty.

Open questions
--------------

- Should kmem/slab tier accounting be included in this series or deferred
  to a follow-up?
- Should per-tier memory.min and memory.low protection be part of this
  series or left for later?

[1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>

Qiqi Liu (8):
  mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
  mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
  mm/memcontrol: add per-tier page counter infrastructure and lifecycle
  mm/memcontrol: add per-tier charge and uncharge
  mm/memcontrol: add per-cpu stock for tier charge/uncharge
  mm/memcontrol: add memory.tier control file
  mm/memcontrol: auto-derive tier high/max from memory.high/max
  cgroup: add memory_tiered_limits cgroup mount option

 include/linux/cgroup-defs.h  |   5 +
 include/linux/memcontrol.h   |  26 ++
 include/linux/memory-tiers.h |  12 +
 include/linux/swap.h         |   6 +
 kernel/cgroup/cgroup.c       |  21 +
 mm/memcontrol.c              | 786 ++++++++++++++++++++++++++++++++++-
 mm/memory-tiers.c            |  58 +++
 mm/vmscan.c                  |  26 +-
 8 files changed, 936 insertions(+), 4 deletions(-)

-- 
2.43.0

