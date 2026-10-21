Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792623318;
	b=HWtQjUHJKWMdxWfjG4qk3Aw5IV1RmXfzcc+l6W+Y81eIDGY2Y1mzspQ3GD+4QCiAYMw0
	 pfPZ7lk0gIF1C4csIhRHgrvALkwqi6QuWiXwf40P3LVfXDLmO2EmyIviVNaP8XCxdbyPB
	 bhPM5xBhql1TlIiIx7XGSKDhomeWN1qDuVzYYDE3SoUtWT6J3GeT4zbgwZB9Tvr3J8pEL
	 SPbx/sd7E2zmztNJ5VGPGfhv96Y04TntrgHGvucZZwV6BiWDMRHDxXWg3zaYaoVJEYCG9
	 UXtdgWCL+jVr8YI8Rb59qopu+t2C/uEVHCzFI9KypF05mB5bxpWl/IzYeK7+lIyeSig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792623318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ojYKRRox9AI6+Vsc6Ju99ox5/83lSqiRHyNpYAnar/c=;
	b=zSlQ8eP0w7SGtljXWDoq+ANq1M7ALAUawIMfMPqH2TmgQocEG6qn2zuMLh49uaeCVgoc
	 1iXRzF8JKvMOkbbgksN0otdzDL0JUxXzMfxgNCB3E/rD4FUaUMZxXYegTuQzpST73ECYS
	 8WEdDxF8iRucaaRK+AhbKyw0VAi0BykymsnCR6A25xA7QPwHsnM/ObeSmS+rM8lvR71oD
	 biaLr2hdIe98gzjXzcrJ/FlMgUSJOMu4cn/iNWKC0GXxA8n0IYJZ05/QnUjrk4Lx7Ez3i
	 xrxNUXvcbJLLVMJhEVVp9lqhW4/DsbOankU5UgUfY2qPNwEaBt9zF1CPPAxGEp4MXpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XTIkwx5c;
	arc=none smtp.remote-ip=74.125.224.49
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952A0606A31E
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 22:55:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 952A0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XTIkwx5c
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6790844c9b0so1026506d50.2
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623317; x=1793228117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ojYKRRox9AI6+Vsc6Ju99ox5/83lSqiRHyNpYAnar/c=;
        b=XTIkwx5cMqrzkwOg6qh+ym2h+sbuZmFAVVgVO8OJ9Pod6y6Lzuloqvt/fyNNtK3hcR
         dik5ARGZ+MUzStdAbVwon62Kg+uai0/iYYzMR0VH/xRc9mP98ZSPRrTej/mLaHyg/YUl
         Rr5XuimzOLvObWxyiEwdGLqOIhcpaxF7W4/T6REweVPb7b1xujqtiCboMR9ZJNcOs8ml
         /rUMUuW8/ur/jSNcYBEuYk83Fg2wnD48cA9avXknoygxjS2nTULm2G8MzNWDiFQg3Q1N
         6QLb14ror+ptcUyWmiA8MvPtQOfWHJlmNfVdJs+myUOC4r+In8rNLp8LbM8iS77WsTfH
         4wVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623317; x=1793228117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ojYKRRox9AI6+Vsc6Ju99ox5/83lSqiRHyNpYAnar/c=;
        b=el+37DFIvuzaeK1TJgDmtYMAaMVuIYlJWxhx+DVtXfGIuwps5kwVpuJd/NZzQvaCgg
         3BKh4S3h+9r1xaU1UH4hYexwsXC4LtTZFMOcvccu/qhcsVwqu9bt0FCTe7vX5FU6calZ
         LffTk9OaYnS3Q/exgMm9ue95EyxjqsKAeoCOwIDs91uIeAzLmJG8ii98idIKLuju/FTA
         kG4uef/gorcFdPjKrSNiJsKfxgBEPYHFAnMbi53psKKdDwbND11XFuOu29LJ7sY8jGMI
         rOh6BOU2f3wd0XsQBq4emdXhA6uNw8JwBOGNmf5mCgPCgJ3/1H9zlxKBr4sDDeU4Fs3A
         feaw==
X-Forwarded-Encrypted: i=1; AKwUvByzA3CfO3tz9TwpHZ+G1MxzgPdlkeGLmz0iEndfiD9uDrJrKfG+mQsOZaupScvbK+mqYiJbkufd@vger.kernel.org
X-Gm-Message-State: AFq9FYJ/u8xfPMGLtHuwQ3QgqMQh/Dyet5ldLtWTJrtCYh3anFSWNjor
	jZalReh2ISBmT6cOvRDoLAwTTZpnO8FRQmi34x4WYpb+kjUjm/wvPDJQ
X-Gm-Gg: AYBFou0c7OieL0YZAdUlyGGy7TiCEX/CI3B+htKrNAab/4bGxaHFCoSmSRRrUm8n8ic
	k+7vxom15D9uYx4OAxQ5J7kjxnFqYl7eGuWAQ1OTk7CuB7kjoxdi1HAosmXywlNDh71k6UpATXx
	dEYjSJ1MMkCQMrscdYKE9jlIgHO++A1hptpIXZ+w9ZEGoxjOso37jCrlK38BAnkAD0C4nooEdUH
	B5VFvp78013uxrHmNjdyRDepFKkuueKYqyaCkYqE/mnjT+7ksLBlXdKYih2aW2ODDNpDEYRzNFh
	dU7k9Pch63Wz8ENRmeP0DZuPqg3ef3VsV3MYq/gKucgV3KLj5lbASyeqguNy0geiXsYwu1dgvIC
	LNxXtEP8kjll4MgoW4xQzhKyngJy92u5uBxkKFOAibxU8kZD7PVrmYS/kFROdCttwdIOBsG+SUF
	jfsZI3k31GJW9i+rOXDdoYVBi5CFXvt2nef4knBDZ75zGLy0EuRQ41N2j/NUxBy1GxXDyWP6mdN
	mmDQA64bREyA38KEpGwAUhVriEZgm5rjrNqTj5Myw9/COhjoDrSEJAVq5T11bGus1X/Q2dnto7V
	Tded7dF77fqwDRuzf+fBh5QkpHyh54If
X-Received: by 2002:a53:c349:0:b0:677:c075:a57a with SMTP id 956f58d0204a3-67a0e57efb3mr1569403d50.108.1792623317429;
        Wed, 21 Oct 2026 15:55:17 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1301045a3sm18422467b3.28.2026.10.21.15.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:17 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Wed, 21 Oct 2026 15:55:09 -0700
Message-ID: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v6 --> v7
=========
- Preserve two cgroup v1 proprerties that previously followed implicitly
  from sharing a stock:
  - memory.usage_in_bytes <= memory.memsw.usage_in_bytes
  - Reclaim does not swap when memory and memsw have equal limits.
- Wordsmithing commit messages for 4/5 and 5/5 to document the
  cgroupv1 divergence (bounded) between memory and memsw caused by
  independent stock.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small, frequent
allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation is within memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast
path behavior.

This matters for future work like my tiered memcg limits series [1]
which introduces multiple new page_counters to memcg. Without making
stock a page_counter-level property, it means that every memcg charge
now goes through multiple page_counter hierarchy walks, instead of
being able to cache these charges.

To make future page_counters scalable and performant, move stock from
mem_cgroup to page_counter so that each page_counter can opt into its
own per-CPU cache of pre-charged pages.

We get an added benefit of simplifying try_charge_memcg(), which now
has all the stock management handled transparently within the
page_counter layer.

EFFECT ON MEMCG V2 USERS
========================
This series has no functional changes intended for memcg v2 users. We
preserve all draining, refilling, and (un)charging behavior, including
the uncharge path's refills / direct uncharges.

EFFECT ON MEMCG V1 USERS
========================
For memcg v1 users, the decoupling of the memsw and memory stock means
that each of them now manage their own independent stocks and can lead
to a different size of precharged cache for each.

Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
than or equal to memory.usage_in_bytes, because memsw is a superset of
memory. With separate stocking, this could have been broken in scenarios
where the memory stock is bigger than the memsw stock, leading to
memory usage appearing to be inflated and greater than memsw usage,
even though the real usage preserves the invariant.

Preserve the user-visible invariant by reporting memory.usage_in_bytes
as the smaller of the raw memory and memsw values. Both counters are
upper bounds on charged memory, so this remains a bounded stock-related
overestimate and importantly does not affect limit enforcement.

Based on latest mm-new as of 10/21/26:
fcec4f4bcc110 "riscv: mm: fix concurrency in mark_new_valid_map()"

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

Joshua Hahn (5):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter

 include/linux/page_counter.h |  35 +++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  17 +-
 mm/memcontrol.c              | 352 ++++++++++++-----------------------
 mm/page_counter.c            | 209 ++++++++++++++++++++-
 6 files changed, 361 insertions(+), 256 deletions(-)

-- 
2.53.0-Meta

