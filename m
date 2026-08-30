Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C7B214812
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 04:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064170; cv=none; b=DZKAI93OkYh4CKhCNcE9MA75HyhtaMBY+yD9f981YrFz3FPM49fGUnAw9PgAig057UIW9GjgeuM/PlsBdWPbQO+L6K3ZneTR3nkc1AIxat3T1WflsK2FruKvg9c1CTR9PI29xN5L3009Er2EzSs0KOxdN1kVJxD99wvdZNbqr8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064170; c=relaxed/simple;
	bh=O/lKz//erVnwd1XOCFd8Bk3wkmE9YF+3nlNQAs+Q1G4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K6m1giSbFKHPvksMduzxwBIwiDWKqEtd7LMZEMCO1mrTEQAXAWieXsswfbLI/LfDeXDNdEwkDLy2PVVnfBKDGmIdlhBxt8juHQC478tWi591XOoLGvvQU0sPMOHdeFWdrgbpYSlYDoWiRnPPCPEG8vXFZ7jGwwa2sTNDLLamhs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dkvdz6W1; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkvdz6W1"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cbedaf975a3so431945a12.1
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 21:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064168; x=1788668968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Xlgh6vQbD4bTs7SCk5VD/YGUSfPcjuafvIL7aXc420=;
        b=dkvdz6W10MDZqzI4D9EbO4KnFwrmw9u36DyRMR/XCpEMub3s4WFASh+yR9D3bWNj3b
         aodjvAEwicj40Lf2S+si0FoWzaKfzrGFYg71pVFZ2BmvA4TEjoGFZGcS+L63EFfBxeTi
         BoXaQ1uijVA4DNfIZc7cBtXN2L1e1guBW+G+q3JLIPbIuDYIFoQCXEdJzgNu1SPmubeC
         nxPaSW7V9dmXEZMT221D4mTCuvVHVmdUz13tMA69iqduTrtvUhi1SLiHioiE40U3Fi6j
         ekyWSjmUiEMQRGlAB+XxzEM3pMMKSgiQtuARQrpg+TZNJD1z+OBDZNj63Zx0UJ5Cwq2u
         Q3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064168; x=1788668968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Xlgh6vQbD4bTs7SCk5VD/YGUSfPcjuafvIL7aXc420=;
        b=IxaEXjk3Sp5Wf5CIFU3Ikk2ctbdnG6ExElqhdTTTg8mXvvCMkcUxVm8OeLoqv3+xC7
         0IaCaPcqsbFyn71rdLYj2E9cv7ADhxcCSJtWbxpnTTOu2Z13RyPRA6rbkTl3CTaDMz5I
         3H5TfLgecpM3saUWkviiU4dbAmPDfDlt+U0hHd3ju+jROnA7HQNCnQQTJbYSxTYpoUIW
         nf/EEHYyFRxzkVDafe4afFhlsT+Xf9iQAJCp3nB4LvBdnBmxCz0rUO+sZsAn882Pg/DY
         lpKhyJ/Ln2kQveb+Mw5RqxdMCZKLcQZyV0ayV7nmcN8LLcb80OmtGA8HVsxknyxDEcU0
         V+wA==
X-Forwarded-Encrypted: i=1; AKwUvBwPlj3zWgJJooVhvoIa4XLRz1grmBWzes0IzV4RYKIsuMejovi537PeXgS5oBOPlccnyeet55IG@vger.kernel.org
X-Gm-Message-State: AFuF++kXczFt8XuKpxV9vV7BYH5jn57jLk0RNuL8tPhIv7P1R+7Zhlzn
	CsfvYuEPIL6c1ernBBL68gBj/yR2GYv+cyXSAA2xswGWKXJiqOnKjw96
X-Gm-Gg: AYBFou0xI3vjfsTH7cQX01J8jkCRc7gWlOq57DASOmwoFciIjGxvpyYLL6uH3a6RpcX
	iJR7fpUJjeucPvzr+1itvqKB3xyWxXHMcTVgihtTWGX5vRKcNvdiX5xuJNpitz1rbUukTOh4yOT
	htBfGsqNVGXjxZe8N+HjYY6sN6+Yh1KEnKeQPGqqoZKHAqwHDOKzPG0Mhwc0i4to8k/evZhAzlR
	N2OS/OOJ0qr64TOKP0Dv/t+XAZd5kWFWW7YBLKVBKZn6OFyOYGaA9lKF8cjqXNEe/xn5WGAApVd
	gdTVW4ehqF3m9/bU3PgwQswiSKZOiHNtvVhGNob44zNEq3W8iv5r3yDEMKSGYyIXRC0Sh1vbQIO
	JmgUgkeiUd376wxFikF+83WnFXCRBzpNFCBb5eeRf+T/S+GCYjwnw49giBW1BNZxegPu/EDZXQc
	ADAb1bGca3/tF6YXcYCoHRUjw6GIvd30U2yRBFJhizSf3dDRRaiGfQVX2CMYr0LQyBXkL/pekqB
	c90ZaxxHxvyVAuZ+1NGzQxZKBWED7nw4jDwKJf8QQreY0ZO5Ys=
X-Received: by 2002:a17:903:3093:b0:2d8:d29b:c1e5 with SMTP id d9443c01a7336-2d8d29bcb42mr73839805ad.0.1788064168222;
        Sat, 29 Aug 2026 21:29:28 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:27 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 0/4] mm: avoid large folio splits when swap is unavailable
Date: Sun, 30 Aug 2026 12:29:16 +0800
Message-ID: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v7 of Barry's original RFC patch, "mm: Avoiding split large
folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This series makes folio_alloc_swap() classify failures according to
whether splitting a large folio might allow swapout to make progress.
Callers can then avoid destroying the large folio when neither global
swap availability nor the folio's memcg swap hierarchy has capacity for
even a smaller folio.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 establishes the folio_alloc_swap() return-value contract:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including when the
    folio's memcg swap hierarchy has no remaining capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and
avoid destroying the large folio when no smaller part can be backed by
swap either.

Patch #4 applies the same contract to shmem_writeout(), which currently
splits a large folio on every folio_alloc_swap() failure. It now enters
the split fallback only on -E2BIG; other failures redirty and reactivate
the folio as before.

Testing:

With a 1GB anonymous mapping backed by 16KB mTHPs and
memory.swap.max=0, the patch reduced the median latency of 30
process_madvise(MADV_PAGEOUT) runs from 743.8 ms to 181.7 ms, while the
number of large-folio splits per run dropped from 65536 to 0. Neither
kernel swapped out any pages.

I also ran DaCapo h2 under swap pressure and found no statistically
significant change in wall time or CPU time. The overall benefit appears
minor and workload-dependent.

v6 -> v7:
- Add test results and clarify that the overall benefit is minor. No code
  changes.
- https://lore.kernel.org/r/20260813075025.1406585-1-xueyuan.chen21@gmail.com

RFC v5 -> v6:
- Simplify Patch #2's failure handling following Kairui Song's review,
  avoiding additional plumbing through the memcg charge path.
- https://lore.kernel.org/r/20260730122304.2496440-1-xueyuan.chen21@gmail.com

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
 include/linux/swap.h         |  6 ++++++
 mm/memcontrol.c              | 32 ++++++++++++++++++++++++++------
 mm/page_counter.c            | 20 ++++++++++++++++++++
 mm/shmem.c                   |  7 ++++---
 mm/swapfile.c                | 26 +++++++++++++++++++-------
 mm/vmscan.c                  |  7 ++++++-
 7 files changed, 82 insertions(+), 17 deletions(-)


base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3

