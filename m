Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213438;
	b=UE3+FNxE7IAMWdvU2UB6p90nKV/2u/PO001E3zbMej1hU+UV2DP6n8ql9Bggb2t5s2an
	 yhHVn/F96lLPzvsf02osHknF24B35ombOs8CKtil9lzqSh0vMmJ6LQqdepL1Die1LbWzR
	 xxOycPmTGZkSK5M7Tu8tfBWQRWxJGZS4Nb8P9KSR7xsc3B2OS0u/chmk7B4wJbYwuytd4
	 uexPfo+ZJScTi53Ua5D5cyf7WWr5gPkOwsB8UglYL34+SunXxRsCzhy+57ZJ1Bn8mF2ai
	 KYXO8VMCT2up/QXRMlBg1PJp61GEfWM8HazLi8dWNhqNXcDP0G7JU4MVPOFLTHSZaoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213438;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=oIMB3N52PjEiZOXgBhouwuUAXoicMhfnhRe1LhEdpEU=;
	b=i2yrs4TJKFFuzjsToTVEWxdTUdODF641Oc4PHeTLdV6b9UX+IHXM5c44A6OUiBy8di6S
	 yMkyPA6zdKZQxm13Otnn8t0qyzh3/1ATt1kYlWjmG3p7VNtmF4LrqJp7HTuerL7s7FFIG
	 mGvIYbt1ij6DKc6bIL4oMl5S1Q3PcDW+p82Q2IVhLY6phbUKhN0HwVHqfTl9REcLIIuYx
	 J8FCB5FPDZjHBeI2YXXDoQlbE07623hIB0d9C0BHRAuaoQuLG9cL2X72wLQxFDUZHnhBf
	 KcHxlOYT0ORvNcaKeIvpELQDFz1HMm24ttAv3WM97T1xIjc6oqDWbCYrz6xlfoxMGtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MRx2iCjq;
	arc=none smtp.remote-ip=209.85.214.197
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16131606A31C
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16131606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MRx2iCjq
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e9d52f684fso11803865ad.2
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213437; x=1793818237; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oIMB3N52PjEiZOXgBhouwuUAXoicMhfnhRe1LhEdpEU=;
        b=MRx2iCjqq9NrL8e4uRwL7XB9jb0aKvZJ7QxmqXjCHTYWsy+mfaP5k81Nd5C9Uzfn2V
         cNn1gYnzGzYt5Pl2VcPaudQZe0qR6bKlmcEfL6W7QGSG4T2tVhcYHxI5iCaVHRx/T8dJ
         K7i5UKWl2E2uHEI4f9yJ2gTBaLLLd0O3UP+FVNc6V0x1pf1gnRxLfS4MAM6RjzgGP6hk
         3IzH+S3leRlibaY83vHd+WNjTSRmqKMlZ+NfntpPIaMTBoA9DJHDOZeE3VEZCVyKSRHt
         WtvYybY77Z74vd5dj8xfR8FY7H7Rt//RStbQ19tmLfL9xmfiB+mHTBcOfXCC4MoJsDgC
         W2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213437; x=1793818237;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oIMB3N52PjEiZOXgBhouwuUAXoicMhfnhRe1LhEdpEU=;
        b=yCFj9aRO1JSQ5dQ1jjjR7/17P3DSA9zUXJEbcRHuYhMXEu1ptbyLbVXTeXbJaBeny5
         JVssBYvpBOQ6s+94NpbM6soizVCuVKrG42IRN9wyGErhOy2FXnNs47Lfhmmp4f90bBtr
         PjJF++LvPLEexLI4KAH7zFhktd/noMDepiitECK3zc0RpP1rCI/pTdzVYvt5Ye+XSRVj
         pYZcBNaQ7EtWvyfrv2TJKpOfmsjGpY/NePA9TRga3xXLj1jM9bzfPIHPR1LbmvlU6NCd
         bEuFq6uPf9ClGCAqMgQZ8QU0h24bNqnWckZ/lQBlPvPsX6vW+xlJwuwx581pNlhD+mBE
         Xckg==
X-Forwarded-Encrypted: i=1; AKwUvBwh4zxSfYeYBeQhRNP5xEimp7O0RgT94qyufoKpflddHROBUo1ARmxe+gijem838cnr/YbZoLDC@vger.kernel.org
X-Gm-Message-State: AFq9FYLCbKpldMhWkXROOSQF24DvalqeV1/jxYfK1dFQwZnufUBJ6Gm8
	0ti+nrQCrpRvwgsPAODTpdapoEgZFGuLhejPUnXcuYjaHn0Nz6FpFf1pGaei3QTEi9QeDEGcU11
	PJJ5btw==
X-Received: from plad19.prod.google.com ([2002:a17:902:e153:b0:2e8:486b:aed])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:120c:b0:2d8:d4d0:7930
 with SMTP id d9443c01a7336-2eb004f3928mr28395135ad.20.1793213436894; Wed, 28
 Oct 2026 11:50:36 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:12 +0000
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-1-kuniyu@google.com>
Subject: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On our production fleet, we saw mem_cgroup_sk_charge() spent over
3x the cycles of try_charge_memcg() although the former should be
a thin wrapper of the latter.

Looking at perf during tcp_rr, most of the cycles were spent in
mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
due to cache line misses. (see patch 4)

Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
many core machine. (see patch 5)

This series adds nr_sock[] to struct memcg_stock_pcp to batch
mod_memcg_state() for MEMCG_SOCK and move heavy operations to
out of local_lock(&memcg_stock.lock).

With this series, tcp_rr w/ 10000 flows achieves 31% more
throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
Processor (Zen 2 Rome, 2 sockets, 256 vCPU)

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |        Patched |    Diff
  ---------------------------+----------------+----------------+--------
  Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
  Latency Mean (us)          |         478.46 |         363.71 | -23.98%
  Latency p50 (us)           |         453.96 |         356.68 | -21.43%
  Latency p90 (us)           |         669.00 |         479.56 | -28.32%
  Latency p99 (us)           |         969.38 |         617.80 | -36.27%


Changes:
  v2:
    * Rebased on mm.git/mm-new
    * Add patch 5 for flaky throughput issue
    * Patch 4:
      * Benchmark again after rebase and update numbers
      * Check in_nmi() in __refill_stock()

  v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/


Kuniyuki Iwashima (6):
  memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
  memcg: Reduce nesting in consume_stock() and refill_stock().
  memcg: Annotate slow paths in consume_stock() and refill_stock().
  memcg: Batch mod_memcg_state() for MEMCG_SOCK.
  memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
  selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.

 mm/memcontrol.c                               | 178 +++++++++++++-----
 .../selftests/cgroup/test_memcontrol.c        |   8 +
 2 files changed, 139 insertions(+), 47 deletions(-)

-- 
2.56.0.313.g2479322e68-goog

