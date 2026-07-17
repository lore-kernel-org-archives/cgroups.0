Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECE8175A6C
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 12:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784291130; cv=none; b=lEuQYaWx4xGhaqj1QCsyaa3dHgHxiaV6amzGbSGh1myqn1XK36NPudR907gVUde7osU9SL6QhANR68xj0p89H6W/dmLMc/S/eG73tKobsrQVo8PgpyVIl4m5GWuTuJoF160nbiJVgid33NYNodw7BIcNgF/w4CxS35XbDqmZSAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784291130; c=relaxed/simple;
	bh=oLorK+LxEyupzNsUWqzCNFytexEf17Pn09yRRkDe3Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pINOUrN2h/2P4rqUvf68K5LcaYhWsNTs9f+AzRZXTw1lFwXI1c6KI7OqDGACEGM+Wl5HJvJRgr3C0gQVuJYbACvG4RhJG6yxbw9DkwIcS1fH9XoR8kfqvfjh2r3p6p074pXEiTMXGrVntlfUTgWROZXsRdTe6kXcKDwX0Vhv0Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MmJSoDiG; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmJSoDiG"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cc8311c6ddso11007495ad.0
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 05:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784291128; x=1784895928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eGUWxXnglDTUtUcRkSiLT7t0UILlbF4NCt/KjcnaPhQ=;
        b=MmJSoDiGUXXjwprQZQdALy13oD5dtzNj10BKrjBnIhJTH/sI2MShb/3Jf7SLU918YX
         MFq12Ce0SFH/LXMTGgLOHyCogRD/J3aBc9R8ScTM6r5CEVqYr953E0UuAvcGoKuoeWIz
         3KQbpTlLYL0M79xNQebKtgsP4KUtsfz+M9fROan6audij5s8FpbH9nwy0mM8edZoleoG
         sF2nnPz8ms499Sij6RYN0z1IHyfyRw59UL2JNtABPFxSRnk/5hPFfx5CJOJx4cF+Jfd9
         UHC1eseKkJkjZB9Te95YPKNxJb0Dr9JPx0fkrO/GE4ZCIT0FbwUwfLJOSaQIYKIbDJ39
         KxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784291128; x=1784895928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eGUWxXnglDTUtUcRkSiLT7t0UILlbF4NCt/KjcnaPhQ=;
        b=BvE/+z9bT74Mls7hG+XvILpDu6SjWuu7taVbH+FZG+a1q+Lv3Xw012awSh86ICAzSo
         xubgDxyAV8BWi/jp0kLNbL41P11xOZ3qmCc3gDv0EQjXQYOR0um24eZ2QQu4VodcRWPg
         G9rEi3yukZ/sZln+EhMUaX7OhP4+AcgMz06Lz4tD1f0KwOiD7Bq4vZF4QIn5T3/gNWKq
         6dQ9O2xw0LX8/QSwPbFB176QePUWuXfgWu0mVoNbS++Tsx5HT4cReYqWsBS4BFqqQ8Rh
         Q9s1F8YPPQIv6Z3GfsFxIhtafa2Jclq6pk+9pxJTCnSljcRqdJbs8QXhDmYt3HOZ4Zu8
         MYzA==
X-Forwarded-Encrypted: i=1; AHgh+RqE+oUnTXrKbtAb498mylibWMdWbZZnCTZw3wW2/P0o3uCk08p9q/TkiGf9svSd2Hw/7AmbS0Sp@vger.kernel.org
X-Gm-Message-State: AOJu0YzznQ1lYOw4r9cJdlFulaRrmPi4ULbujoxLwJRwqpm7sP/38YzI
	NVsBQChDhsuXK2uY0FnE6JTCnm04OuiM77MBgJhvZKG1Fshi4hs4jN28
X-Gm-Gg: AfdE7ck0hYA2N0vSgT/9EHQNM8oIjldbjyt6kY79wMxziPxd48o8rIKLcCQcTn96wbU
	bJm5qVqHUfp4e7m2D0VnZBbqCGRTO9qI7yWYCG6te/KQaTQ2HMrXK0ltgFlNZ2V/DCp1DooWnV1
	GI9M2LWjrLPDSYrD14Wf9+r7fzH54x2PhQsr6IPU0QLnvboTkBFcDIvbW3Zui6PHOhj/ptZDiXU
	maffkZA65HMiwZoMiBXE043Nyxaj5BanjRdsCmb68g9rbuEYtYv3rSrxvNYuACS/cJfQz6gxaTt
	Fbew51EwDUeAvOH+Aan+3+uMWB2MKqsay0v1gRXorMA70X8Q6DoMcQZKkA85gM11TaPSSb7+XL7
	gIT6tgNQrqhjvZTFySs31EZDivRGSSnOradmyZYegxX+ZREYjPZjVGabbUgE5dizCeRpg8KKjDs
	HTJrI85Yld32XMCbA4etmRuX2eSZiPRF7avqsz8T7PHUR0PLs62kyrGOg=
X-Received: by 2002:a17:902:ced1:b0:2ce:aea4:5e80 with SMTP id d9443c01a7336-2cf34a02b31mr21394265ad.6.1784291128242;
        Fri, 17 Jul 2026 05:25:28 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347119dfsm9935955ad.56.2026.07.17.05.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 05:25:27 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
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
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v3 0/4] mm: avoid large folio splits when swap is unavailable
Date: Fri, 17 Jul 2026 20:25:10 +0800
Message-ID: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an RFC v3 of Barry's original RFC patch, "mm: Avoiding split
large folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This version keeps that behavior, but makes folio_alloc_swap() classify
the failure. The helper has both the swap allocation result and the memcg
swap charge result, so callers only need to split when folio_alloc_swap()
reports that a smaller folio might still be swapped out.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 uses that helper in the memcg swap path and lets
folio_alloc_swap() distinguish large-folio swap allocation failures:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including memcg swap
    charge failures with no remaining swap capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and avoid
destroying the large folio when no smaller part can be backed by swap
either.

Patch #4 applies the same contract to shmem_writeout(), which previously
split a large folio on every folio_alloc_swap() failure. It now enters the
split fallback only on -E2BIG; other failures redirty and reactivate the
folio as before.

RFC v2 -> RFC v3:
- Use Johannes Weiner's original page_counter_margin() patch and preserve
  his authorship. Move the mem_cgroup_get_nr_swap_pages() conversion into
  Patch #1 so the helper addition remains a pure refactoring.
- Add Patch #4 to make shmem_writeout() split large folios only on -E2BIG,
  as suggested by Baolin Wang.
- Previous version:
  https://lore.kernel.org/r/20260709145124.764807-1-xueyuan.chen21@gmail.com

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
 include/linux/swap.h         | 10 ++++++----
 mm/memcontrol.c              | 19 ++++++++++++-------
 mm/page_counter.c            | 17 +++++++++++++++++
 mm/shmem.c                   |  6 ++++--
 mm/swapfile.c                | 21 +++++++++++++++------
 mm/vmscan.c                  |  7 +++++--
 7 files changed, 60 insertions(+), 21 deletions(-)

-- 
2.47.3
