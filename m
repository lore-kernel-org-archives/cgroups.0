Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835032;
	b=FnK/jwoXjUIB8Stp9xEZ3gbqQyKgUmnDZY/zEBnYNWaJaT0HnunLTFx9eBJau2d/uKHR
	 Eaf4H8+eAxIrLHxSJ+KhkgRe/iQuXdsCOkP6KA9ejM0kXPj5LbulXUHxOenxx7oEFM3Kw
	 ZvMCTiXbxdqXqAgbLmhquuMKAzxL9B+7bXDoxNh685RGTXWr87yOnRcbzNuElKYhiYZwe
	 nOl4DJBTxalUWqUh41XZUgJP+em4WZ9WonXh4as54wakXd80lb3TZ/m7oeXIQHaSdKMEF
	 oF7Im8/Xa8BUv+KAFhANTwrVR5sNPJ0WnG1HxE6Hro1LF/0qW466yaB+IbdJDOhYymg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835032;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=S8O6n4wkP+hVSces6SjRurqbVke5VUdfxmmLz5pPN8Y=;
	b=L9N9tlqfuazzhqwskIX0Bvn8wtFd06m1QMvJrNYvVNTFzHo+ZRvfFDljWGvruxFPQ+7v
	 Im2q5NfmpqeagGHCp1BTEo8QKP948JxPrHiq1aO3RgMwcS/RRcBIU+uNgqpmCrurnGZhq
	 Fr06OU6DboFtYwZdgOH+GJToelLyUamiAaljLpXTzpVWHM61/tTBsxDzE6Vv2W3tscD54
	 qk9jFPgOjCy6RBlyVyBZGog3DzpG2DQlYUxauompQ6S5F6aNJHMgWJiL8cjPwNvfVbo0x
	 SUKgUMkfy97dO50RT+/eoZS/qtLmjHCsQCmEnL3lc33Pa9cg44oedW0UyIIBGxNr7Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EvVroBtT;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50FB606A31B
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A50FB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EvVroBtT
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b3299aed39so2491097b3.1
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835031; x=1794439831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S8O6n4wkP+hVSces6SjRurqbVke5VUdfxmmLz5pPN8Y=;
        b=EvVroBtTUWmi89p91aNwajO2iOtdAzpDF2ekbCdoJVtZHDfPYgSoI2hlQ2izInR8og
         +7E2vLPSzN/N/32IE22A1H23aBNd+93++Kok+aXo3VUg3Lz5eUfXZTxJpBDGjdqI9Yvf
         FrrH4f3hzLOemmSb9dvqNy8/iH9ddiLuB/w6ZM4r1Y5/DCFnyTAuwBu9RcGVr4u4+FS1
         ahJeZeUlP1H5xeeyHe1bm2mDb3bfrEUyb6ShOeA0DPtQILnvCpOchxvwLmEMVVI5u+b/
         XhtS30DjvF0+LfgL4VfA1hgTxvlZLCecWvF+uHypcbpm80tgKVOuk5zG/zS7PfdspKQm
         jUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835031; x=1794439831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S8O6n4wkP+hVSces6SjRurqbVke5VUdfxmmLz5pPN8Y=;
        b=ogwgczlCYmv2ylP7O/WHi2/rLeVpzBeFjyQGuE9bN1LU206IcPWa9e8Hl0KwY+g1iZ
         a62/mULMUyaHD4WacnpYG3AqErsoPASkh9WNDI4goom7z4KzfJBs7yXe8iGHhuoWfyoy
         frg0I6lTMJ0vziGdKQWzPz6q3jJieGc8LBhgB0w5rybx7EyYhB6YpJuQrUqhRBVWNNW4
         LHUcV+Mt7MUyEM2hCGsgo7VDf16vtnBI/L+vrXkd3u70BLI0lh22tR4RsUpuZzdSPxAm
         e4GHyOt+68XRqAkSqvDpPoTRDzBdWf3ifj4mqBNI0S11taEY/YG7lHk5eqa/znwrBKbq
         Nw3w==
X-Forwarded-Encrypted: i=1; AKwUvBzC4wOrrLNA7ObWeitknFjU0pxIN6Q3NvQyzMpwdAay5R59TOE7px2lZMEOGOUHlZhILF8mvPIk@vger.kernel.org
X-Gm-Message-State: APuU4Z/MaXgiM3738s383Tz85eXmCBLBf2Z8lwdBpCdX9MUs1VJD7D7c
	sc7vwVINL46B/BtiITsZQuPadMXkvq5dbufnBHxyZA5aWtOr1qczOHzT
X-Gm-Gg: AYBFou2UEzvqonXuaH/+/OGYEWsIjjbrj1492Dbzi9w1z1cuoDli7OilpOepDIuh28g
	BmYMyqTxy2A6c3ysZhtKC0mnkq5M9Vtso4QpyTyRAjfo0DFx1acMRfiVIUF9+xP9mXQPXHIWGeM
	s2E0T7JOrZ79NlNpIXzoGIp4KGarQo18xk8blO7sAp0DD2CIsJKwSCfN6HobeHhRRvsf4oW16Nc
	xaGwbP/ul4TGSGbFRsYyVe4z2N8liIIbYgqYCuHDtoxrsXS1oIaVR7XImLLvIL5NC37qe23xdiR
	huwEIyATLPYVRkNj7Sjn/nbbITxxmcODtajLx1L+l77mQMTbZK17enKZPFb51h7g2yGGwrncwJy
	MW3vBSzg/dZ5vvK04RVEzwACpVcbiUQHFlHETxv7WQJBR7Jo1xogHfU75f9X5pWVGzseY5wO9G0
	xhHyEI4/dZlP4gKic01paF+yNG3OMQLHp+2xGEcu820xg72OOTu+QrviAM3QXAIwuQp+viN/xIp
	DgAESPxDd9vX4pnexLo9plaKxKasGQTI3N4MUKAA5Z9b80gf5SoI9A/mFR+bIi51lfzkfm1faFk
	V7VItD8Lu6hM/z2Xp8U1sooinQo08Pklja8jkw4xn7qLqK62gApg++XiX7L9
X-Received: by 2002:a05:690c:e210:10b0:8b0:a30a:7f05 with SMTP id 00721157ae682-8b2b6774969mr71427577b3.84.1793835030478;
        Wed, 04 Nov 2026 15:30:30 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30997aa84sm29045837b3.29.2026.11.04.15.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:29 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 0/7] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Wed,  4 Nov 2026 15:30:21 -0800
Message-ID: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
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

v7 --> v8
=========
- Rebase onto mm-new as of 11/03/2026. This picks up two memcg series
  that required some rework:
  - Kuniyuki Iwashima's memcg stock cleanups were worked into the
    series, so the changes now live in page_counter code instead.
  - Shakeel Butt's memory.high rework. Commit 4/7 folds in his
    PF_MEMALLOC change into the page_counter checks. This change was
    suggested by Shakeel.
- Commit 7/7 is new. It brings back an optimization from an earlier
  version of the series to let stock charge only accumulate on leaf
  cgroups.
  - To accommodate this change, sprinkle in READ_ONCE() for
    counter->stock reads since the pointer can change at runtime now.
- Cover letter rework as suggested by Michal Hocko.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small and
frequent allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation lives in memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast path
behavior.

This series moves the stock into the page_counter layer.
page_counter_try_charge() consumes the stock, charges a batch to the
hierarchy on a miss, and refills the stock with the surplus. Memcg no
longer manages the stock in try_charge_memcg.

So the stock keeps the existing layout, which is still a per-CPU bank
of 7 slots, each holding a count of precharged pages that it hands out.
It maintains exclusion using local locks on each CPU, and for remote
drains we schedule on the memcg workqueue.

This change gives us the following benefits:
- Separate charge caching (page_counter) from charge policy (memcg).
- Makes it simple to keep stock out of interior cgroups on cgroup v2.
- Prepares for future work for stock improvement, which can now be
  isolated from memcg changes.

With this change, make sure to preserve:
- All locking behavior is unchanged from before.
- Non-leaf cgroups do not hold stock. Specifically, their stock is
  drained when they become a parent, and remaining stock (isolated CPUs,
  concurrent refills, etc.) gets drained lazily on future stock misses.
- Exact charging for non-spinning callers.
- Stocks only exist for the memory and memsw page_counters as before.
  Other page_counters (swap, v1 kmem, v1 tcpmem, hugetlb_cgroup, dmem)
  don't stock as before.

EFFECT ON CGROUP V2 USERS
=========================
Currently when a cgroup becomes a parent, it doesn't drain the stock.
Rather, it just prevents new charges from accumulating by nature of
parent cgroups not having processes. Here, we can do a little better.
When a cgroup becomes a parent, schedule drains right away, in addition
to making sure parents don't accumulate new charges.

Everything else is preserved. We preserve all draining, refilling,
and (un)charging behavior, including the uncharge path's refills
and direct uncharges.

EFFECT ON CGROUP V1 USERS
=========================
The memory and memsw counters now have separate stocks, which can hit,
evict, and drain independently. Their raw values can therefore drift
apart by the stocked amounts, even though every charge is applied to
both.

To preserve the user-visible property that
memory.usage_in_bytes <= memory.memsw.usage_in_bytes, the memory
value reports the smaller of the two values. Both raw values are already
upper bounds on real usage, so this stays within the fuzz that
usage_in_bytes always had (and this is also already documented, see
section 5.5 usage_in_bytes in Documentation/admin-guide/cgroup-v1/
memory.rst).

TESTING
=======
This series should not have big changes to performance, so I ran some
benchmarks to verify that. I did testing on a 16-CPU, 32G machine VM.
I ran repeated anonymous memory faults and MADV_DONTNEED to measure the
CPU time spent per page. So + number is worse. I ran each experiment
5 times, with 4 workers.

+-----------+-----------+--------------+-------+
|           | base (ns) | patched (ns) | delta |
+-----------+-----------+--------------+-------+
| cgroup v1 |     890.6 |        901.8 | +1.2% |
| cgroup v2 |     893.5 |        902.2 | +1.0% |
+-----------+-----------+--------------+-------+

Based on mm-new as of 11/03/26:
74d73ffcffe03 "riscv: mm: fix concurrency in mark_new_valid_map()"

Joshua Hahn (7):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: check PF_MEMALLOC after trying the limits
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter
  mm/memcontrol: restrict memory stock to leaf cgroups on v2

 include/linux/page_counter.h |  35 ++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  17 +-
 mm/memcontrol.c              | 430 +++++++++++++----------------------
 mm/page_counter.c            | 233 ++++++++++++++++++-
 6 files changed, 430 insertions(+), 289 deletions(-)

-- 
2.53.0-Meta

