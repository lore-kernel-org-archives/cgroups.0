Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3BE437476
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 07:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607447; cv=none; b=uep69LMRofNAA2XCwUmIJ/B/jTCmiATB5OPYZx/H45v661L8VuCq25mlFv6PQFJDR7+IfbB/aeG47QsLs4qAVUk57DzTgqIqxQildNhlrFF1QIyWsYp9pUnu/JQ+7IANb8gd/HWzRXVMjB/aREnIwkDExOUoGmc7Ku2E9KdBQdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607447; c=relaxed/simple;
	bh=X3pWwzXz6LM7NKN/VFK8RbsCxTx80nIWgYsmVGxFN14=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jSRKY9C6KZkqQSWJEMcFNL0q61k0MnfCvuSmRjacrb/amex1yLRkqQElqJgL/TFD9AAjtfcwOzWxm/5oEql9p2ajuEz9D8+ed8FXEoTTCjvtNMGmyobYMNZ8ai20IkPOtqco/SJriLD+HJiV+7LQN52z8z6TFFm4kX3Zpfh8xaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2NhG8Z2; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2NhG8Z2"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf49dc28ccso3475015ad.0
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 00:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607436; x=1787212236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vybgwr57dhXTQ4T97gW4mcEW3yCv848zk80C4ArbMUM=;
        b=U2NhG8Z2oqBAEkPW8XyLF1anGiLzvJ1VN2bL6U6lEzdIGQXEU+FzAP+zK+s86kTWH9
         r1tWwPALJIiK2W+zaOQPxjLvF8/yHxbscHmc/YhFoTeoSPPCCxBpkwEj7apMJAseTF0U
         AvreSv8bMhooL3oWP8b73LvzOs+OeGSYYYAbMYnht8bqAm7OYZeT8YaN0UvlkaXNOQaR
         8QA2d6o6dbYF9pjsEN2NFJSzTcGdblk2l6Da+4ncLVc1xdmsxZIt9OX+Jd9P1WiZ7NKx
         9MK2ei2+k96rK1wmpxIbWExFmCTocYcs8k8EPPaW1p0T1wEpCa8iDGOEoEnZbuszBtlq
         DYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607436; x=1787212236;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vybgwr57dhXTQ4T97gW4mcEW3yCv848zk80C4ArbMUM=;
        b=Emg4aomxbNfaAJEhJ8kboSh9RsudszJ0us2mMU4SqLbN5poxM69VQho9J28ORH8EBJ
         el1ZYC/kyfMNYBRpHuTEkJ5KUmmTSey1kay61kHva0hK3EAs/ACnkm5FkwgZCWth1s4D
         z++PpnQjJUEwfyLP9ZSTrTSw3zE79V35toYVM9jdfyLosfDWUBK00uBaB3ezP6Zf/32Z
         2WzcO6KVETmAH/I+Cxi9NsxpycEkbImqxs8E7lm5lofEFFPn7fFEUPVIkPsoaGLMTsI5
         qI7bX9Hp/YUt8uzbu6RtPxhUQVEwYU5MiltQkvRVNurvmccEYG31vGYjrLOsVl3yoOUX
         sl1w==
X-Forwarded-Encrypted: i=1; AHgh+RoMia5N3/TfwHRYGJMtvpBMht+hg/4/ymHLOO6y7OYBdQAogWw1Qyo3GKPC+c0Rs+BvDpre0daW@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjtaw7F2m9u2Rp90IfqNFiQGYku/RDUQTVKDOh+QCzP0uw4D/T
	dJlIb2BwcPYKcGcGhhm+egGEXVjIvvHDvobnw8UkxRYmWWhknrMItdHo
X-Gm-Gg: AR+sD11XrFM/MVzElUXRqRvFZLkBQcBYPmuyxMRxG0IYStjFR/cARsfMW2HA3HqpHAq
	nC/CvtenewaGgwLdHqm1DMGLsCRtBJyU9MEaqACQtMcgTolBXZvMhBW1VnMjJ058aSVd2BXTD1/
	Ra1uykzp5c2TyD4Pcc2gRi3Rn1S6Dd2ukDSUkhbeFZ8TfO/b84LABpk41VYJ4NAwlkvMWifRBxa
	/n9yRrfpNCtAevsRj8nYoAaILAWloU324Vh2eXTVU07iwBeiWzGEuBW9ZCLMdT09vp6N35YfG4h
	ERRejmc3JDgbAlIx+EuNwsC/xJ+AklNm+++csiQRPnPNcByAYhouDfgL0FbrsxzKBCAlsfHmecd
	CAgfYMP7Gp9e7/uzYkvk+ZJD3H0diBSezLpoFM9grUZNh4lWDdbspWkZDRoMFlU++p2kKdo1udk
	udNQVqvz0dNi1QFAqJbM0anfsul+l34CXoPrnXm0Yt3kCUc+Sg31QlykFmtIl8Zr8IFrgalsNjx
	vRYcEW82DBwe96E75mObBYFtHvE8hhdfrv6fEqb5Tey1w4xam1qeW5O2XTtQQr2jRVeqq87EeCz
	is0lqA==
X-Received: by 2002:a17:903:19e6:b0:2cb:2b50:d9da with SMTP id d9443c01a7336-2d389b61bdemr28772985ad.3.1786607436131;
        Thu, 13 Aug 2026 00:50:36 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:35 -0700 (PDT)
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
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 0/4] mm: avoid large folio splits when swap is unavailable
Date: Thu, 13 Aug 2026 15:50:21 +0800
Message-ID: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v6 of Barry's original RFC patch, "mm: Avoiding split large
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
