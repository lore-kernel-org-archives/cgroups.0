Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED17C519DEB
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 14:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419282; cv=none; b=lU/P7wvv72Nwh8S5GDsoSAFJZVfvUtZHMUEtraXGkgjTEgHhij5UiShyh616Z4YPdVP7xOruh5BCNIunB+8+MicWvJpnWsnkgTA0+tQv2Mo6Sk6NNWiMdAmuinBpb4a3ishqLEE1k7s/38cjndm/lJzLIBmTORtilciW8+7IDkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419282; c=relaxed/simple;
	bh=YjfefJJvAYRwzQCu02KQ/kD9JBVwvA3WGC1yZzhSfYE=;
	h=Content-Type:Subject:Message-Id:To:From:Cc:Mime-Version:Date; b=HLaRvyKmVKGsX3WWfUAwmcWLK5ztMClWlAvTHptjeqWLleGTOsUwf354/We+8YMv4hCdW1KoDxGaRTPwNiDcFixIlqjh0tbuU3XLBppd3Lafz2H7kYktuA+SBmUmWYnh2RSKA7GXZLAcOeM+v3/esnd8RTqGySN3zMxKVWmjPeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=pkCr5SgV; arc=none smtp.client-ip=209.127.231.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="pkCr5SgV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792419274; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=NEJJZ34u4qlgZ0S11fm90eLB3kl92LQqge8z3SZGpCM=;
 b=pkCr5SgVpY/fkEsaSTxA1aExg629LbsxsWL7xtWlLYD0CZzDQYSgfjSwZpQWL3NtonnSeA
 QohqjsMml6fyi7jjmkJfTCp41NUSmff9WOsUACribH49LNTUcnuaZIKAtxlr6KpLRq8c/G
 1zrA4EO6tqW2UOi3LMLFJPyP7tnSrqddCNdb7RXcZ5q3j5RX4u7LZs77f+yocKmxooC/tR
 psYFsaXVYAXhtGBKBRPw2UrxVkCAtMKxEukvimqUos1xbR7xvCgHObekHGZo5iV3K/N4j2
 k2jEEUMExr3e0ozf69DoSaMZL3Sb8jA38tpu/wgpcwJb80VR01GgCxGllOKQhg==
Content-Type: text/plain; charset=UTF-8
Subject: [RFC 0/2] mm: add source selectors to memory.reclaim
Message-Id: <20261019141401.11927-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ad625c7+e7ed1e+vger.kernel.org+lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Mon, 19 Oct 2026 22:13:59 +0800

memory.reclaim is a useful proactive reclaim interface for memcgs, but
tiered memory makes "reclaim N bytes from this memcg" underspecified for
userspace controllers that manage memory placement across tiers. The
kernel's reclaim policy is aging-based, and on tiered systems aging may
demote folios before they are eventually evicted. Without a way to
declare where reclaim pressure should start, userspace can only reclaim
from the memcg as a whole and observe one aggregate progress value.

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
declares only the source on which the existing memory.reclaim aging
pipeline should be applied. It is not a demotion target selector, not a
demotion-only goal, not an eviction-only goal, and not a change to the
existing completion accounting. Leaving source unspecified preserves the
existing memory.reclaim behavior.

In that sense, this series extends node-scoped reclaim pressure to the
memcg memory.reclaim interface. The existing node memory_reclaim
interface can apply pressure to a node, but it is not scoped to a
particular memcg. This series lets userspace apply the same kind of
source-scoped pressure to a cgroup's resident memory on selected nodes
or tiers, while still using the normal memcg reclaim path.

The main benefit of this series is to give userspace a steering knob
for per-node and per-tier memory placement control. A tiering controller
can observe the resident memory distribution across nodes or memory
tiers, and then apply reclaim pressure to the source that should be
relieved. For example, it can apply pressure to top-tier nodes so that,
under the existing tiering policy, cold folios can be aged and usually
demoted to lower tiers, or reclaim from a terminal tier when it needs
actual charge reduction.

The existing memory.reclaim interface cannot express this. It applies
pressure to the memcg as a whole, so on a multi-tier system the kernel
may make progress in a tier different from the one userspace is trying
to control. That makes feedback control of tier ratios ineffective: the
controller can observe that a specific tier is over its desired resident
footprint, but it cannot direct the next reclaim request to that tier.

Patch 1 adds source=nodes:<nodelist>, which is the basic source
selector. Patch 2 adds source=tier:<N>, where N is the memory_tierN id
exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
only a convenience layer over the same source semantics: it resolves the
current tier nodelist at write time and then uses the same source-scoped
reclaim path as source=nodes:<nodelist>.

The remaining issues from the old discussion are intentionally left out
of this series. If userspace needs to control demotion targets, that
should be a separate target/demotion-policy ABI rather than folded into
source=. If userspace needs a strict "bytes actually uncharged"
completion mode, that should be discussed as a separate accounting or
goal extension because it would change the observable meaning of
memory.reclaim progress. This series only adds source selection for the
existing reclaim policy.

References:
[1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/

Li Zhe (2):
  mm: add source selector to memory.reclaim
  mm: add tier source selector to memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst | 29 +++++++++++
 include/linux/memory-tiers.h            |  6 +++
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 +++--
 mm/memory-tiers.c                       | 24 ++++++++++
 mm/vmscan.c                             | 64 +++++++++++++++++++++++--
 7 files changed, 133 insertions(+), 10 deletions(-)

-- 
2.20.1
