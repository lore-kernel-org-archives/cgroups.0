Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793603137;
	b=u1GC9nCPfnYH/H127e1IboBEBjAMXr5Oze9XjTSbgOM1x5/UU6+lGKskFkXkBdHegOGN
	 jqu2cg2BeUlUpou3jkJBDua15AZVJA2ZFXoPIpCQ24p12dGl4qg0mygtluMhvCLgdwREf
	 JAcj198KdjYcGR4ZlzLUurNxQpV6zhm8s2OsFR0aZFMfUCzmIOqn8HMq4sfaMN2ayAW0B
	 8835+lLGknte7Q5M5bcDzJRfH53j9R58ogTLBKoh4d0l1h7cHFxDu/89qjTVtRZUpNBhQ
	 oxQ2N65s5Fz2DF0T4udEHZkZnjRaQoaEzQEeQIou+rkWtyWZON6pcYPApUi7ZmQncPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793603137;
	h=DMARC-Filter:DKIM-Signature:To:Cc:Message-Id:From:Mime-Version:
	 Content-Transfer-Encoding:Subject:X-Mailer:X-Lms-Return-Path:
	 X-Original-From:Content-Type:Date;
	bh=9pzLVpw5HDbiXA/WRKY+RZLeQwbQg9GRKfExmkQd1tQ=;
	b=iM47zuttrfJ6EJYsb6s3z6tl0wsCX98jSW9kU2+lzj1NCXworSlbiLRKQ1kZ7tkQz3A1
	 9MwsyJYlgVJli7p6+R6pLYtohqRi8/kkdcgMyuN7WoWHI4Uy4SbnmxfXpj9CXjiMa+p2y
	 CDEudw2lYQs5jpqakR+55avKeZ6f3BRUIjQwFeNpsolnGytZztBhnMCHvDdaUOwG7woCq
	 c+1Xx3Pi4E3S/hVJYyAFtZFCHK0yrpJsukEY38ygx5N47wMzBWAKMJcxLATzbgwB0Pfpt
	 A50beLLYieHdkXJtBBlGz1po73JqebjIU2pgo2sTFPrBvtQ3IwlXH9nCrK/WmpJSPUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=OiWWvGUc;
	arc=none smtp.remote-ip=209.127.230.114
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10AD606A329
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 07:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F10AD606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=OiWWvGUc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793603129; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9pzLVpw5HDbiXA/WRKY+RZLeQwbQg9GRKfExmkQd1tQ=;
 b=OiWWvGUcycVItn39v4uVvnI+CgrbskeFEVGfmLnJm8FRtFz4mV/5O5XyplvZBV5nLWrdDn
 vDb4TJZtomzPX6EyE7D5p99nQ42GDZ6fgrfPjh+n9BlQ3cVBliRv3Naj5ngrkuKBh8uopH
 glO/5JlMiH7T9fgwivgDp0pqa9RGN61Mu2chU9Jnc79cL6F3ZiNThw9MCjEpSzFnzH+e9A
 VyaXCNJZ3ZEMY0mGpvhCSWl49xYDFM1NrboDXAtGgwO85HMQBHYRKNyR4maqjrFvKBCYnH
 ShaC3aFbBohHBdBfsluhvfoV5hcENXCYVfBvt5tHKi4+LQGZ5LLMbLMIImsaHg==
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <rakie.kim@sk.com>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261102070440.16262-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC v2 0/1] mm: add source selector to memory.reclaim
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26ae83637+050ae0+vger.kernel.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon,  2 Nov 2026 15:04:39 +0800

memory.reclaim is a useful proactive reclaim interface for memcgs, but
tiered memory makes "reclaim N bytes from this memcg" underspecified for
userspace controllers that manage memory placement across tiers. The
kernel reclaim path may demote some folios and evict others. Without a
way to declare where reclaim pressure should be applied, userspace can
only reclaim from the memcg as a whole and observe one aggregate progress
value.

There is prior history here [1]. The old nodes= proposal tried to let
memory.reclaim scan selected NUMA nodes, but the discussion left several
ABI questions unresolved:

- nodes= did not clearly say whether the mask was a source selector, a
  reclaim domain, or a demotion-target constraint.
- The implementation did not apply the mask to the whole reclaim path,
  so demotion could allocate outside the mask. If userspace interpreted
  the mask as a domain or target constraint, the ABI did not provide
  that.
- Selecting top-tier nodes could become an implicit way to request
  demotion without uncharge. That would make userspace depend on a
  particular reclaim policy and could make future policy changes hard.
- The separate completion-accounting question remained: demotion can
  count as reclaim progress even though memory.current is not reduced.

This series takes a narrower approach. It adds a typed source= key which
declares only the resident source to which the existing memory.reclaim
path should apply pressure. It is not a demotion target selector, not a
demotion-only goal, not an eviction-only goal, and not a change to the
existing completion accounting. Leaving source unspecified preserves the
existing memory.reclaim behavior.

In that sense, this series extends node-scoped reclaim pressure to the
memcg memory.reclaim interface. The existing node memory_reclaim
interface can apply pressure to a node, but it is not scoped to a
particular memcg. This series lets userspace apply the same kind of
source-scoped pressure to a cgroup's resident memory on selected nodes,
while still using the normal memcg reclaim path.

The typed source= form also follows a direction that has recently been
discussed for memory.reclaim. In the zswap proactive writeback series,
the interface was changed from a one-off zswap_writeback_only key to
source=zswap so that other reclaim sources could be selected in the
future [2][3]. This series uses the same extensible key shape, but
defines a different source class: resident NUMA nodes. source=zswap
bypasses ordinary reclaim and performs zswap writeback; source=nodes:
<nodelist> only constrains where the normal memcg reclaim path applies
pressure.

The main benefit of this series is to give userspace a steering knob for
per-node memory placement control. A tiering controller can still build
per-tier policy on top of it by translating a tier to its node list, for
example from /sys/devices/virtual/memory_tiering/memory_tierN/nodelist.
It can then apply reclaim pressure to the nodes that should be relieved.
For example, it can apply pressure to top-tier nodes so that, under the
existing tiering policy, cold folios can usually be demoted to lower
tiers. Another controller may first reclaim from lower-tier nodes so that
later top-tier reclaim has room for demotion. A controller can also
reclaim from terminal-tier nodes when it needs actual charge reduction.

The existing memory.reclaim interface cannot express this. It applies
pressure to the memcg as a whole, so on a multi-tier system the kernel
may make progress in a tier different from the one userspace is trying
to control. That makes a userspace feedback loop for tier ratios
ineffective: the controller can observe that a specific node or tier is
over its desired resident footprint, but it cannot direct the next
reclaim request to the corresponding source nodes.

This version only adds source=nodes:<nodelist>, which is the basic
source selector. More convenience selectors can be considered later, but
the tier use case is already expressible by resolving a tier's current
nodelist in userspace and passing that nodelist to
source=nodes:<nodelist>. Starting with the node-based interface keeps the
ABI smaller while preserving the source= namespace for future selectors.

The remaining issues from the old discussion are intentionally left out
of this series. If userspace needs to control demotion targets, that
should be a separate target/demotion-policy ABI rather than folded into
source=. If userspace needs a strict "bytes actually uncharged"
completion mode, that should be discussed as a separate accounting or
goal extension because it would change the observable meaning of
memory.reclaim progress. This series only adds source selection for the
existing reclaim policy.

Testing:

I ran a simple userspace feedback controller on a CXL test machine. The
machine had nodes 0-2 as the DRAM tier and node 3 as the CXL tier. The
basic matrix used node 0 as the DRAM source and node 3 as the CXL
source for the target memcg, with fio and stress-ng as the load
generators. The controller:

- read anon/file bytes from memory.numa_stat by node;
- aggregated them into DRAM and CXL resident bytes;
- targeted a 1:1 DRAM:CXL resident ratio for the target memcg;
- selected the side above 55%;
- wrote memory.reclaim with source=nodes:<selected nodes>; and
- slept for the configured control period before the next sample.

The controller loop was approximately:

while running:
        stat = read_memory_numa_stat()
        dram = resident_bytes(stat, dram_nodes)
        cxl = resident_bytes(stat, cxl_nodes)
        total = dram + cxl

        if dram > total * 0.55:
                source_nodes = dram_nodes
                excess = dram - total / 2
        else if cxl > total * 0.55:
                source_nodes = cxl_nodes
                excess = cxl - total / 2
        else:
                sleep(period)
                continue

        bytes = clamp(excess * gain, min_step, max_step)
        write(memory.reclaim,
              "$bytes source=nodes:<source_nodes>")
        sleep(period)

The requested reclaim size was proportional to the excess bytes, with
per-workload min/max bounds. I tested 1G, 5G, 10G, 20G and 50G
workloads with 1s, 2s, 5s and 10s control periods. A run was considered
within target when max(abs(dram_ratio - 0.5), abs(cxl_ratio - 0.5)) was
not greater than 5 percentage points.

Basic feedback-controller matrix, final deviation from the 1:1 target:

The 1s, 2s, 5s and 10s columns are controller periods.

The file-cache-CXL-high case used fio under numactl to create about 25%
DRAM and 75% CXL page cache. It reached within 5% by at most the
eighth control cycle, and all 20 runs ended within 5%.

size  1s     2s     5s     10s
 1G   3.96%  3.96%  4.45%  3.96%
 5G   2.65%  2.75%  2.65%  2.65%
10G   2.65%  2.68%  2.65%  2.69%
20G   2.65%  2.66%  2.66%  2.64%
50G   4.31%  4.31%  4.31%  4.31%

The anon-DRAM-high case used stress-ng under numactl to create
anonymous memory on DRAM and used swappiness=max so that the normal
reclaim path could demote or reclaim anonymous memory. It reached
within 5% by at most the seventh control cycle, and all 20 runs ended
within 5%.

size  1s     2s     5s     10s
 1G   0.15%  0.02%  0.16%  0.02%
 5G   3.16%  3.13%  3.14%  3.13%
10G   3.13%  3.13%  3.15%  3.12%
20G   3.12%  3.13%  3.12%  3.12%
50G   1.88%  1.88%  1.88%  1.88%

For comparison, I also ran the same controller and workloads without
the source=nodes selector. The controller still chose the side above the
target and computed the same request size, but wrote plain
memory.reclaim without a source constraint.

case                  final <=5%  reached <=5%  worst deviation
file-cache CXL high        1/20          1/20     50.00%
anon DRAM high            20/20         20/20      5.00%

This shows why the source selector matters for placement control. In
the file-cache-CXL-high case, plain memory.reclaim could not reliably
control the target ratio without source=nodes. In the anon-DRAM-high
case, plain memory.reclaim worked well. This is likely because, in this
setup, the whole-memcg reclaim walk reached DRAM nodes before CXL nodes,
so it already applied pressure to the over-target DRAM side first for
this workload.

I also ran a disturbed case with external reclaim and demotion activity.
The target memcg used stress-ng under numactl to create about 25% DRAM
and 75% CXL anonymous memory. NUMA demotion and zswap were enabled, and
watermark_scale_factor was raised to 3000 so background reclaim became
visible in a short run. A ballast cgroup kept DRAM free memory low, and
a separate CXL-heavy cgroup kept reclaim activity present on the CXL
tier. The result below was measured on the target memcg.

During the matrix, pgdemote_kswapd increased in 16/20 runs. The
CXL-free-down/DRAM-free-up/pgdemote pattern appeared in 13/20 runs.
Even with that external activity, the target memcg controller still
drove its own DRAM:CXL resident ratio toward 1:1.

Disturbed case, final deviation from the 1:1 target. The 1s, 2s, 5s and
10s columns are controller periods:

size  1s     2s     5s     10s
 1G   1.18%  1.11%  1.11%  1.42%
 5G   2.14%  2.06%  2.14%  2.14%
10G   2.13%  2.10%  2.15%  2.11%
20G   2.15%  2.23%  2.15%  2.43%
50G   4.87%  4.87%  4.89%  4.87%

All 20 disturbed runs reached within 5% by the third control cycle and
ended within 5%. This does not make memory.reclaim a one-shot footprint
guarantee, but it shows that source=nodes can act as a useful
feedback-loop actuator.

References:
[1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/
[2] https://lore.kernel.org/all/20260629112032.20423-1-jiahao.kernel@gmail.com/
[3] https://lore.kernel.org/all/20260629112032.20423-5-jiahao.kernel@gmail.com/

Li Zhe (1):
  mm: add source selector to memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst |  9 +++++
 mm/bpf_memcontrol.c                     |  3 +-
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 ++++--
 mm/vmscan.c                             | 49 +++++++++++++++++++++++--
 6 files changed, 70 insertions(+), 11 deletions(-)

---
v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedance.com/

Changes since v1:
- Reworded the cover letter and documentation to describe the interface
  as applying reclaim pressure to a selected resident source.
- Added the lower-tier use case where userspace reclaims from a lower
  tier first so that later top-tier reclaim has room for demotion.
- Dropped patch 2, the tier convenience selector, for now. Tier-aware
  userspace can resolve a tier to a nodelist and use source=nodes.
- Added references to the zswap proactive writeback discussion, which
  also uses the typed source= form to keep memory.reclaim extensible.
- Added CXL feedback-controller test results using fio and stress-ng
  load generators, including a no-source baseline.

-- 
2.20.1
