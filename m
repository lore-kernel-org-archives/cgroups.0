Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F97409E0A
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 12:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414205; cv=none; b=q410M8fE0alxLMgcKnhEh0mWXwXbT7MrE7+0Ukh4y7m8CWUynIJBoZ8JUmQT5tML6ESoP7zpgI3AdiRcbMI0MpWiPj59O7OD/e1pQ4DBr7Pq/bpYmigkhfWKx10m0GohklQM1IDJZG+OLTRBWLCizKYJqbhqQDQ1MBXNygIpatk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414205; c=relaxed/simple;
	bh=J2wmxivQKVYrVgWMn8sB9HSR8s3yk5nPXX0yB3PXo5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l5ERYCX1ZD94+uTq8AaY2mVfdXkMi1CFAeQ/ZZ1SZfs8jPHhvs8gbVaqIZtNF5dve+XMkYNIYbWL6BQXyjdmqCf0uab7AL+0vJbGq6ZPjZcY2L9EtrCPuq1KreEldw1qgmvrT9YHl31r4kU6VYy9dMYVSxBpiuNqxDswFjqGZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbvY8dQz; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbvY8dQz"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3856d4015e0so176818a91.2
        for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 05:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414204; x=1786019004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e+6hzrmSQg0II38t+n9rvv6qBh0adksxkagJYoybTiU=;
        b=jbvY8dQzVI1Nvsaz9UajqV2x6pX/royMFZ6TstlSEdBWuLeAgsn+mJy9jaSeeeruZW
         Ojj44IIo2Z4/30iOd6WZKqdT4RnYsO0rOtXwgaTkU0qJm+dKpAd/7Wiodp/gixskzae+
         6y57uuhFwhTJCW8JUDSdCawfX47YYRqpSBBogr6OHQRlJDcXx37LdUtS2Jo/eFBs7xVk
         lV6oHaeUVoXM13e3HAVSAGBJe406LOULvI07N+FHGdlV7XKf2IIB0DDkV0VBbOlChb4d
         onSetIkARzI5I8YlK53WOTtWD6ArBHbrvH1LVxELGPjWDr4DyiPsZs04ypHprVXpHEE+
         APkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414204; x=1786019004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e+6hzrmSQg0II38t+n9rvv6qBh0adksxkagJYoybTiU=;
        b=WkNoCUn/bmqylMOHEPVipQzEcO2kDRAUHEUqfsHNIM3iF2Zkna7ZEjnTHXSlBCVYyE
         BmkpLEJ/FeBhq/+n1jWgJApToE5PvSK4CV58D5yRw6Cg2JckLHzQG+F3DgshVFAzq4o1
         1jWv9FdN2J1HvH7xVUJNqGD0kE+QDY5GQ3H032TcTuhCHoDlM2RiNWqu/ZKnYEXbJ0WF
         88EZ7rLtWknKIEWrzS36+3hIwUDL2coEPoOzbcGG9C0EbZp/dV5tyTNzoyeNZUmuzSdh
         eb3H3VqfIizb6j8Tcl1kdpn2ieVh1DY4QmjUcxFt5AgjEPU4TRN4E3VDSdcvXMmFvZSc
         7ctw==
X-Forwarded-Encrypted: i=1; AHgh+RoHD1uL4muLTemvKxi5vZ+pkBMBNqrOgyOx4hvEM7kJ0rWRMF1zAQ4gbmRdPpqy53Q00j7NDOaM@vger.kernel.org
X-Gm-Message-State: AOJu0YytZGjnza9amVtKeZGDQPqFjXY5ac6R5JvZM0DCPZt6zs3DeU36
	o9s2LuichnRQtdSiZ4+rgQh6A6m8Do0qKZUkNoo9btVfZ8gk/6ypysAG
X-Gm-Gg: AR+sD119+f00SwbeUqbORSQ8v3N9zhWDfAFGzOaFc7PstYCJDp13CkAHITQAp9YTWF4
	8YvFGdMHvW3Yub02x+9l0XVDXiKy2qbSTHD+hEEBJ9zmFlpKz3No+fzAjZE+bJgrHpdpZTv00k+
	Lj0Oi/Zg8xLz83vRxzyvywmqVKPVaiPj36drFyRtOJG4ETJdvXqPQfeMu80KiGQ1QZiw4CCNAId
	3aAsBQuzCkh0gYZfVBXORDe+qD3oZULbniCNpNwI97h1krzruKp9dy1MYEte53L1ym8V4NMHkPb
	OgInH8Qs52Qw6iZDBSgMPQjOT0jVYSJh1EipBHvJw+WeS0gu78gC0daOqSD72Ol/KsC6mjGPIUg
	jBmUZqLO2S3mOCOkl6UxmC+DGhA8JmaDrsp5zQ7wPNLDTAtoAu5uqlGvDLB1h1o5AINQ1H2P9xQ
	tpBQHtgRoNuGiWCCtW3gwSAg5dJO7QELhSarIdeYc73H4HnNNCY4djcsTQsDxafraTOJBD+75D9
	2qckAPvx+aZo4jxlFOxRpU+LXmT6jg6aaZJ0JFCdkz1YJco6Ej2
X-Received: by 2002:a17:90b:47:b0:38e:ab3f:2c99 with SMTP id 98e67ed59e1d1-38f9be63443mr3215947a91.2.1785414203345;
        Thu, 30 Jul 2026 05:23:23 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:23:22 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: [RFC PATCH v5 0/4] mm: avoid large folio splits when swap is unavailable
Date: Thu, 30 Jul 2026 20:23:00 +0800
Message-ID: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is RFC v5 of Barry's original RFC patch, "mm: Avoiding split large
folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This version keeps that behavior, but makes folio_alloc_swap() classify
the failure. The function sees both the swap allocation result and the
memcg swap charge result, so callers only split when a smaller folio
might still be swapped out.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 lets folio_alloc_swap() distinguish large-folio swap allocation
failures:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including memcg swap
    charge failures with no remaining swap capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and
avoid destroying the large folio when no smaller part can be backed by
swap either.

Patch #4 applies the same contract to shmem_writeout(), which previously
split a large folio on every folio_alloc_swap() failure. It now enters
the split fallback only on -E2BIG; other failures redirty and reactivate
the folio as before.

RFC v4 -> RFC v5:
- Fix Patch #3 to jump to activate_locked, not activate_locked_split, when
  folio_alloc_swap() fails with an error other than -E2BIG. The folio has
  not been split in that case, so activate_locked_split would incorrectly
  adjust nr_scanned and nr_pages as if tail pages had been split out.
- https://lore.kernel.org/r/20260730021630.2235914-1-xueyuan.chen21@gmail.com

RFC v3 -> RFC v4:
- Keep global swap availability and memcg swap margin separate, following
  feedback from Barry Song, Johannes Weiner, and Youngjun Park.
- Handle early rejections and memcg charge failures with the refined
  folio_alloc_swap() return-value contract.
- Apply the requested vmscan and shmem condition layout changes.
- https://lore.kernel.org/r/20260717122514.51514-1-xueyuan.chen21@gmail.com

RFC v2 -> RFC v3:
- Use Johannes Weiner's original page_counter_margin() patch and preserve
  his authorship. Move the mem_cgroup_get_nr_swap_pages() conversion into
  Patch #1 so the helper addition remains a pure refactoring.
- Add Patch #4 to make shmem_writeout() split large folios only on -E2BIG,
  as suggested by Baolin Wang.
- https://lore.kernel.org/r/20260709145124.764807-1-xueyuan.chen21@gmail.com

RFC v1 -> RFC v2:
- Split the RFC into helper, swap allocation, and vmscan patches.
- Add page_counter_margin() and use it for hierarchical memcg swap
  capacity checks.
- Make folio_alloc_swap() return -E2BIG only when a smaller folio may
  still be swapped out.
- Return -ENOSPC for no global swap space and -ENOMEM when splitting is
  not expected to help, including memcg swap exhaustion.
- Make vmscan split large folios only on -E2BIG from folio_alloc_swap().

Barry Song (Xiaomi) (1):
  mm/vmscan: avoid pointless large folio splits without swap

Johannes Weiner (1):
  mm: add page_counter_margin()

Xueyuan Chen (2):
  mm: distinguish large folio swap allocation failures
  mm/shmem: split large folios only on -E2BIG

 include/linux/page_counter.h |  1 +
 include/linux/swap.h         | 16 ++++++++++----
 mm/memcontrol.c              | 41 ++++++++++++++++++++++++++++++------
 mm/page_counter.c            | 20 ++++++++++++++++++
 mm/shmem.c                   |  7 +++---
 mm/swapfile.c                | 32 +++++++++++++++++++++-------
 mm/vmscan.c                  |  7 +++++-
 7 files changed, 101 insertions(+), 23 deletions(-)


base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3
