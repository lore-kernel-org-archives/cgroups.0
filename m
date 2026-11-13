Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607546;
	b=h3mLSkcfu+ltKejWf635qkETm19MvqxA/Yme/RhErhP6XzbeeMGKCVb63V0AtyE9pYVG
	 pkl0rblevB/fZ0nRmrHf9+wKBUsA/dN21kbR/bof8J5EF8ZzQgYmVr6Cr0cdjamYdB7cy
	 KgkuwHVeMwZNZPp90XONwfflIgI9LT9b3EUDd+TCmnbs0efQ4jsm6ZtJY8oFp/kBovsCH
	 NNYNslIYXyDe/mh/iGMzhGXXCRGmUVe37dWd9rygvJkhAd43fVPaDCFsPXmZJHRMDKoM8
	 QlGRkmSmnoS7R6/GMv5HnsMVZWKy6bSXMKUfk/hv0mCy+Lmiz6OekWKlspU0EuBbvow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607546;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2L0U74R9+mkRFuCmWnre9IxfyFESeJ4+6hhn8GJhTV0=;
	b=kWZAbmI0VpMuD3RmWX+aYywB9S+XNj3sa5wvpVAZYZ9oIN7s06phx7OuDOd8kc9cWRfj
	 jZemCvO7ZDprtimcJEWJxiItGm2OAPMYUgMUw4SM84kmxBApKTuP8ZBq2WbnamlHbMIHK
	 5rpfrO6xgxUI+xyhdxfEORzToOwQb7ecWu+xhAv6PT1FrX1+2Y1YM9RRZhQMlcUdSjPEi
	 tWRSBFGVA8J+Hc4v9KpagBLmGGwnnvP7YUpUtjvfh8wiTZUPOuo7OxCRjvOAfNBe1e1Ud
	 BFGrot0liS5hHEvBt4ERDARUhBBfb1VNUy6qzHCOK++T4364Z4ZeVHnzOHPFx/MFmFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F8h1G0PU;
	arc=none smtp.remote-ip=209.85.128.175
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1E1606A331
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 22:05:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C1E1606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F8h1G0PU
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b309147589so14431237b3.1
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 14:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607542; x=1795212342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2L0U74R9+mkRFuCmWnre9IxfyFESeJ4+6hhn8GJhTV0=;
        b=F8h1G0PUEaWPWMOKfakJC6dT16YkfO2TZGOFcY7Hi7Cbl7fMq0t89V1I3Ehy8TMXkh
         DiXTsRyxenwGnuTE+Z48qQaC8PkUm/L+qxRlFPMphxhVq+RTIaT4TRKFQMN7nHnQsnx0
         EKWK6xh4uOOkCQvX9eXEv1AHB6e29MFAqdUacWxDw7NbT5D2reidDtIR0QLfTrGYtcHS
         8ZoBjP2cRjn2TmMqNtKfLSp4SmBNiw9thqJ8ecYczzZfPKkcs6rHsKYdaFT1mgZK+9wm
         7D7onApjJhzN66WYnpJlpsW2QjFWSGFMY1qGRXtz1cAVcJhQ++qQHvb2s3blyqy7uK7c
         Sr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607542; x=1795212342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2L0U74R9+mkRFuCmWnre9IxfyFESeJ4+6hhn8GJhTV0=;
        b=Hqpoy6S1e9EcfVpZN+exlCbI3AEkclHdB2omof2bUrVR4QyQZmDe79Q/ocn1riMQV7
         UGyq5UaAhm+xDjBbPY4KGve5rK/f1kPmSYXDfVsTEMditIlzL3L0jEjIqjG39AqyJQ+G
         JeEzjvO2sDchQocYDTL8RtGj2sEA3cLLnWN+mOnl2jD9gb1doAHuJfx96DhdGxpX1kSy
         rfd2a3zFHjptxAzFvkQAtcvlTC2gEZEKJrjD3GFvtKRpLp62OU88tej2+JVRw4mJK39M
         /jqh7TztVCqrZ38znfqYJF6UuBvZzOn1QwOXBbr9xHCcziLJCbTDoEGsc4Oc20YE0Hv9
         j+xg==
X-Forwarded-Encrypted: i=1; AL+hErFQt+5kwc0rwsu8WMAam2RiqdabFwumC5YtPX2xZsgiD/4LCs1Od7e6cwEfypFxhFK7qFjQ638r@vger.kernel.org
X-Gm-Message-State: APuU4Z/N36f5G0Vr6UgVn7a1qjOKCAYAzAYU2KLbgyZRAjf6UexPikON
	aasmXyUbiOHJ49oXzl/eCMUKYpKf+3Y9xlsYvnJJovulaj7ZhrlpK6yz
X-Gm-Gg: AYBFou2hpnb9+TJnsRDxzU5yx5+uSkGEgFUhsAOZjfKg8tGsa1OpZNGSWTcO5krNkbU
	4kLAxMml8SogCSfkkjrm97U0AMheVQPLLPMI0i58QvtpqGMaz4mEXPWEN12LownztNt9qACabPw
	9li9reId4ajG6q7bBx010afhsMYyxMKFmMmhsB0fApQ4CC51OztqHnlsNgwxQaJvquBVsAt3BYu
	Z6U7IpFeUzCzoZCUs8oZbNlzmnQOKDQd4VA0jF2mH0OS2Us8N5Xcq5e5dL9cK7eaRExN30zlMk3
	QnJlWbZMbZF4srQF5z3cwrOvrWTrs9v97ATFdxr1SS9hIY5ipkp3Zwdvo7e3GkhsD9gi5/TRT7P
	z6V3r/KJDD1O+nLy9oSE5u3M8MoY1FQbL4GwhNXxyMBOe25JVmMUu12Fwxfcqnqyjp8VjjrLT3N
	IL8lunFYUeNuYsV6us4TeDa9nSG9ZvIeyo0SlKIIDS245V1VqMxA9hTOM45tLmVBhMKCaHkK/uN
	b2PlqKzq+YzOc1TjWmox2CVPxEy/Ebx/3Eh+RGVJDyxfTyFAX+407fawYCFxGTbI3nXSG3NhLh5
	hJhBci9UiLNhNHiM9v8oRD7sQVNOws7KnOhLJRcpyCLRIOwQE7MetckmnnngeifCcJRZDl/kuvu
	KYToFOg==
X-Received: by 2002:a05:690c:e284:20b0:8b3:8c44:26df with SMTP id 00721157ae682-8b4aa26fccdmr19298447b3.34.1794607541274;
        Fri, 13 Nov 2026 14:05:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:11::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aaa1361fsm30354847b3.43.2026.11.13.14.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:40 -0800 (PST)
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
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 0/7] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 13 Nov 2026 14:05:27 -0800
Message-ID: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
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

v8 --> v9
=========
- Rebase onto mm-new as of 11/13/2026
- Fix draining issues raised by Sashiko for 7/7. Drop the lazy drain of
  disabled stock, instead relying on slot ruse, drain_all_stock, or
  CPU hotplug, just like any other stale stock.

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
  concurrent refills, etc.) gets drained just like any stale stock.
- Exact charging for non-spinning callers.
- Stocks only exist for the memory and memsw page_counters as before.
  Other page_counters (swap, v1 kmem, v1 tcpmem, hugetlb_cgroup, dmem)
  don't stock as before.

EFFECT ON CGROUP V2 USERS
=========================
Currently when a cgroup becomes a parent, it doesn't drain the stock.
Rather, it just prevents new charges from accumulating by nature of
parent cgroups not usually having processes. We can do a little better.
When a cgroup becomes a parent, schedule drains right away, in addition
to making sure parents don't accumulate new charges.

Note that it was possible for interior cgroups to use stock before
(reparented objcgs, swapins, etc). We remove those to not strand stock
charge in interior cgroups.

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
 mm/memcontrol.c              | 435 +++++++++++++----------------------
 mm/page_counter.c            | 227 +++++++++++++++++-
 6 files changed, 429 insertions(+), 289 deletions(-)

-- 
2.53.1-Meta

