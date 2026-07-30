Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF63376466
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 02:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377828; cv=none; b=jVmNESzZoYLEdj5RyTf6QdJi4tZu7Nfh60SjNNz7X8r6h7AJH/4+k0utJK7CnMhz8PoEnkexE/BKI2k93Zz9pRgbwE9Q1YndvFrm4inhlnoCdxkfIYCFXlgm82WR59ym0I0BxwISE9wPgekPU/qDoC6wtnzF5TRHVUin8Cu2Bj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377828; c=relaxed/simple;
	bh=PzMU/czoSo34qcntibbAb0Rk9laJnPSzXQ2myoIvhaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FmaMYMTkFgkyUw9q9glgiG7toho6+wSpYBpKzi7HuyrRl7RkbJ89Q37YVHABkOiB3j3mAPTyAGxnA+3OhmmA/o9yrHQBFWWB5syj0qcXdsmX7Bbta2h+jWUy7uuRLxt/HYG3yz8Z21VI1AxxkGkc6v0vzGGrrIRZuLylSstfj2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RU2H44Q/; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RU2H44Q/"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8485ab7c382so236727b3a.1
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 19:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377812; x=1785982612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CEvVzpQ7maBnqXzDlrKpFAxRq67Wh1PJdH6/rY1eZq0=;
        b=RU2H44Q/09yvPhkMaC1rpv0J+oWEcoBn62dUe5j+8HQF0mc3G4aaPbmnV7O3YCxRWf
         Flbp05WhSvLev21cUru8ziSLSpQOjDka/8b22lqMT/PMLeM7AIB0sC+2GVyHjIPCebDj
         F1fow68LtlVkqcMjHKbnRXXaKf8vsZF3RUkeOZxaNJKaNPkfFD1zyc0H7IkmA6Wxy71i
         WVwFyUg02IO2roC85EqGaqomdMpEgQIJDznxYt2G542eAAEXz3J+7AQDZbjmm/f4iqKF
         GRB8z34D/w37OQ7Q6+J3YMQHZu1CgeFlVj8NOV4zCkHWLHWVL+WBGCmwV1eW6sWyXq9e
         7tDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377812; x=1785982612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CEvVzpQ7maBnqXzDlrKpFAxRq67Wh1PJdH6/rY1eZq0=;
        b=skq6FfCxnKewdh9OXXbGY9CpcnNIjgI3BJzkDp8ndXOntFoVudK7mpdelIxkx3XKhk
         GP6qgQILz869skwT0j62czoqn2mz5eveeDN3L0sg3lOcsgpCpQVH58N7VGXBoawqYb4R
         skY273V/VIRV1H8w1XpJbHH8X1XWwTEQYbwc+KKBbrBC3MfqPINV1zgFf+7Pm50FiEG1
         FJcrmvKv5vdkF/nu0od1X2jJ0KleUqV35632XmTYiUFELAgesbMuvmYQQsaeh7+YJaaL
         z+xgucINtAq4HPRDZ/1C0xxM0INSYupuV9Xe6OjgvWX/0V7dxeV8E9u/UHXYZdnsPGNt
         wWng==
X-Forwarded-Encrypted: i=1; AHgh+RrzNmcFvZLanqGHURcUTBRbiOkcsWagLcdjnUsPqXpFdAN1Jt36XFo3SvXttB/UgzLCzVR2r7fz@vger.kernel.org
X-Gm-Message-State: AOJu0YxpDUmxzCLoaQ1ZW6K1XsV6XYxtx3C4sQsGI/wfwpVeKH5aS6U5
	v7HR5OiYFlMqlI+yn4F4+93QyoPmLugRS/3+mP6OEL/Qdbuq9Ae8hah1
X-Gm-Gg: AR+sD13a4dCrGU9Rc5CD3qDIASfp5KCCWKdpaMEmaBBUlJ344PAmCaYnRnI0eJDqn8n
	5rGllWM8kl6TyGcbSHfRSqOiPdiK0UkpVSGprq5Q99Nq3Pgh3fvb2pHoW2PhhkTbAKKOqLSDa/E
	n64QYLEQLsu5F5N05XqgtMxNsemwT8YYg8IEQf9ONnZEAeGMHD0mns8td8+XVzl+Ht5ugL1PKSv
	LqPqbc01YpD0ynDsvFeCdvl2rytfQWjvPy3iMAFSQbErE+PlT8Ca2YcLn0i+KiDByQiANCpmByb
	QxDzyRBJvUBtCwKiq+8Q+rHUR7NHY78Re1HhH8umpeA78Y3qj/CQUf/KrotTeTHf8SNeNBsfc1W
	nuXWKSzrWnKCdQbZm+5miI1RtMYhYBsJUnX13r2Zj3lWhZWdV34EMf1ey4vkiN6A1ZQxVxBOcR9
	e0kuuhLySZZ47IoMXADDqO63LwGVfN/bBddBnl0Lvx62zI9wz6Vus5ObZ7x7TnELVNQRfZH6Jyv
	FC0ltL2DD8aVpfe13fXNM8uxnFCSJVj7Y9ky3/B9lu6gFruoa/ZKpqWziuVWbY=
X-Received: by 2002:a05:6a00:1887:b0:848:3dbd:5cb0 with SMTP id d2e1a72fcca58-84ebc3d2e0dmr1029530b3a.2.1785377811642;
        Wed, 29 Jul 2026 19:16:51 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:16:51 -0700 (PDT)
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
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 0/4] mm: avoid large folio splits when swap is unavailable
Date: Thu, 30 Jul 2026 10:16:26 +0800
Message-ID: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is RFC v4 of Barry's original RFC patch, "mm: Avoiding split large
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

Testing:
- make -j16 W=1 mm/page_counter.o mm/memcontrol.o mm/swapfile.o
  mm/vmscan.o mm/shmem.o
- scripts/checkpatch.pl --strict --git akpm/mm-unstable..HEAD
- git diff --check akpm/mm-unstable..HEAD
- scripts/kernel-doc -none mm/page_counter.c mm/memcontrol.c mm/swapfile.c
- Apply-check the exported series against akpm/mm-unstable

Runtime testing is pending.

Barry Song (Xiaomi) (1):
  mm/vmscan: avoid pointless large folio splits without swap

Johannes Weiner (1):
  mm: add page_counter_margin()

Xueyuan Chen (2):
  mm: distinguish large folio swap allocation failures
  mm/shmem: split large folios only on -E2BIG

 include/linux/page_counter.h |  1 +
 include/linux/swap.h         | 16 ++++++++++----
 mm/memcontrol.c              | 41 +++++++++++++++++++++++++++++------
 mm/page_counter.c            | 20 ++++++++++++++++++
 mm/shmem.c                   |  6 ++++--
 mm/swapfile.c                | 32 +++++++++++++++++++++-------
 mm/vmscan.c                  |  7 +++++-
 7 files changed, 101 insertions(+), 22 deletions(-)


base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3
