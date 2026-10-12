Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFBF420472;
	Mon, 12 Oct 2026 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831747; cv=none; b=Iq1/jDi5A8oXus7bBchLGixcuZdnfm5PszwLrd0seL99HsHyTYy0Vy2DPBNDEHdixMYQ+SLBogmtY2T9jLMo9mEERjWnMdZdLFooPhoBggiKrmaGmqycrCxLPtWbdDZl9ET1zQOyezK07mtmb/JjYWyoTWur/BoOUqN6mMB1hmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831747; c=relaxed/simple;
	bh=O20IeZuQ0t4WiEr9b4+pYGIZLXgdXfHpYPHyFrlntGk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=eV7yVm7oStSkUndhXp0lj8V73Yr+iBT2E+3BzR4P1ISUstFO5GdgguTh+gK1STdMis84sDuJ+qTNBmXhz1FdPMF3qp86tGeiD9tNc6jvy1W6u4oJHPV8z69T8RToRpzutc8Y00AebJvhl+gvH+MChTmSEq2Fb2L1LMkLXYnBBfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=X3rIjyNk; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="X3rIjyNk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=TXj8/VoAkqWg7zJ5Ke96bOOeVqkiYrZSnKzKjHh+uRg=; b=X3rIjyNkyQloVWqZtBL
	HSVhEcHZiptUCbCiJRyxJK7qZFiCQh6CcZ1DrRp6broaOL03YiuFMNkAuXpEOMhLRxiz7OKoLB2Rk
	nlSSk1fxDi8bO234lZUd0M3qx1lFixoHP9MfMCSE21tQ7N8yXxkkH+FWe0EzEikh/MCU1/a6Oz6Qa
	Ii+ymUYtmZ8V8xz+2udrKEu9blr4/OLVaik/U/OfTMbm5NnoaS6FPe6PEYDnAXM4xuvT2u2QDXIEc
	4p0vK5ODGcjWF/E60ZrdJblrH6tzyW+163DK5ghPHfS5sbG6xdQeotBilzwuUTkhdIUr04VZTnFa7
	DLn/yPAoBpTc1Sg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLEY-007syj-0z;
	Mon, 12 Oct 2026 21:02:11 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/2] mm/shrinker: make per-memcg shrinker units cheaper
Date: Mon, 12 Oct 2026 21:02:12 +0200
Message-Id: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALQuzWoC/yXOQQ6CQAyF4auYrm3CwIjRqxhDADtSTaakHcBIu
 LujLr/N+98KRspkcN6toDSzscQMt99BP7TxTsi3bCiLsnaFc9h5HJVGnC2JovP+6A5o/Ca0QTk
 +SRuOQZopcsIk2OIoCylKwLQInkJJha9cXbUBciRvBX79Dlyuf9vUPahP3yps2wddmykCogAAA
 A==
X-Change-ID: 20261011-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-9f2e043163af
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3896;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=O20IeZuQ0t4WiEr9b4+pYGIZLXgdXfHpYPHyFrlntGk=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS66Mbuywrlv6b2Dga7MuM9youcxt8Vx1wIJ5
 lq/7ffk9FuJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uugAKCRBRlgpH+WFc
 KpE4EACo74AgOEnkO3qJHOGQLzIj17YnQoqIWXyrYHfISup6c56/SLLlgvPatitCEByRJY8O5Sq
 YmKB0NDngFCa55W1vs6Yo1QVq2B1aPs6opekbQGZ+5xLcuQoakSxGlyWRdbCXpswOgwwYkooYlT
 r8Yk1q+VjAR5QfTZkijBBP97z0RKJb/tW9gsizCCo2O0c+gvz+/8d7efzv+DSZ2gdmj2y6pxCKk
 t4+8IaiaLfgtX61MCl0ZQukDI+rFR4fgjPTTeOYj05BZ8vNHyxKqdUPBchEMO6SGc+iOuyhxcfr
 Fh8K94NHgLw62HR3m/7HWK/ljn4D7sde6poa5Z0S7JNpBCNDjAA0TBxAQXrgqd+ieyarEJZvsQC
 auQjYgcnRRYB3ys2fPCAxrnStWoFAkth+A5oclP1Dp7FE07WNqia3S0TG2kV+FmPwT0w1wUVKKH
 K3fyaoK2czaRZnL5KjCBFTE64L4+g0s20EK+8NsnUEjAoEpCfPCPj7/TAbmtHghnNX97Z8E0JZd
 goSjgLIOnSbo1H9oP0nplE5KGYpxk+6/5hILoZ6Ijla52W20o2Iu9MTGyJJhKakegG2boo8kmcn
 RY4iLgvXky2STntOuf6JA2mYYVDiFGExuTmEM3OT1DYhFVAGbw1gHblwX30iJN1aroXyFTkXz+r
 ZKrDXHy2P6cnkMw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
ever charges an object to those shrinkers. Every superblock registers
such a shrinker, so the cost is

  memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB

because the unit is 520 bytes and comes from kmalloc-1k.

Page cache reclaim does not make this go away:

- Live cgroups keep their units until they are removed.
- The units are not charged to any memcg, so memory.max does not see
  them and a delegated subtree creates cgroups at the host's expense.
- A dying cgroup keeps its units until the last reference to it is
  dropped, for instance by cgroup writeback, a swap entry or a socket.
  Nothing reclaims it for the sake of the units, and MemAvailable
  counts them as unreclaimable.
- shrinker_nr_max never comes down: after a burst of mounts every new
  cgroup pays for the peak until reboot.
- Both factors grow with the number of workloads on the host.

Patch 1 lets a unit cover BITS_PER_LONG - 1 ids so it fills a 512-byte
slot exactly: half the memory, nothing else changes.

Patch 2 allocates a unit only when the cgroup gets a list on that
shrinker's list_lru, which is where map bits are set: a cgroup pays for
the shrinkers it holds objects of, not for every superblock on the host.
The units stay uncharged, but how many a cgroup makes the host allocate
is now bounded by the shrinkers it uses. The unit pointer array in
shrinker_info still grows with shrinker_nr_max, at 8 bytes per 63 ids
per node. Patch 2 relies on commit fafaeceb89a5 ("mm: switch deferred
split shrinker to list_lru") and is not meant for stable.

On a host running a few hundred containers (45000 memory cgroups, most
of them dying, shrinker_nr_max 52480, 4 nodes) the units took 145 GB of
377 GB.

Reproducer without containers: 48 CPUs, 4 nodes, v7.3-rc6, fresh boot
per kernel. 8000 tmpfs mounts raise shrinker_nr_max to 8064, then 2000
empty memory cgroups are created. Active objects added to the 512-byte
and 1-KiB kmalloc caches, and slab per cgroup:

                  objects added       slab per cgroup
  base            1011518 x 1024 B    548 KB
  + patch 1       1023787 x  512 B    289 KB
  + patches 1-2       136 x  512 B     42 KB

The 42 KB left is the same on all three: the memcg's own structures and
8 KB of shrinker_info pointer arrays at this shrinker_nr_max. A cgroup
that looks up names on two filesystems gets 8 units (4 KB) with both
patches, and so does each ancestor that had none. Writing a page of a
file in each cgroup and removing the cgroups keeps the same amounts
pinned by the 2000 dying cgroups until the cache is dropped.

Tested with selftests/cgroup test_kmem and test_memcontrol, a check that
memory.reclaim reaches 140 ext4 superblocks with consecutive shrinker
ids, and unit installs from 64 cgroups racing with 3000 mounts that keep
growing shrinker_nr_max. On a kernel with lockdep, KASAN and DEBUG_VM the
same runs leave nothing in dmesg. test_memcg_sock fails there now and
then, with and without the series: memory.stat's sock counter is not
flushed yet when the test compares it with memory.current.

---
Konstantin Khorenko (2):
      mm/shrinker: size shrinker_info_unit to a power of two
      mm/shrinker: allocate the per-memcg shrinker units on demand

 include/linux/memcontrol.h |   2 +
 include/linux/shrinker.h   |   9 ++-
 mm/list_lru.c              |   6 ++
 mm/shrinker.c              | 161 ++++++++++++++++++++++++++++++++++++---------
 4 files changed, 147 insertions(+), 31 deletions(-)
---
base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
change-id: 20261011-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-9f2e043163af

Best regards,
--  
Konstantin Khorenko <khorenko@virtuozzo.com>

