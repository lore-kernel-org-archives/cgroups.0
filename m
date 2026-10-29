Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303095;
	b=m8xTv7NoeAWAR5Qx9CJaefk9l2TMEE1ndkTpW6mcxflCEBNqwsS4j2VOV/UrCHtW+Fwc
	 3dWLox5fgrnlWH0zCSQ6C+Qo0eoH7ZPywoTtmUdKaeHydfWvZ7m9X0osqKquThlB3KODd
	 /p9YIQMEhsEGS+TyIiPEtwc4TGA2YCeZaPMXKd9DfaNxrBdQcr4H1MELxGNDwC0Fks6Qf
	 /g62UafDoM+Ppl8ao6Q2Mqto0eGRVexuDLwY0ARVfCHjiDMM1M9dMC6y3RtLbzrJNIzgg
	 0DqrWQ85gr2+g00wGl/4bkXX8vPPiHV654hasmTNp7oWnL0WJ986Foj2kZXegRL8Yog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303095;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=xzpdASVHedhqOKgMw1KD3RU+Tfm1fLmwQdc26sVHTJY=;
	b=yWLEyPC5IiMrwhRgBD4pZHFJUOcwkL4K0l2SNVmHfZLtBXbrhRktKfPnymunheKSX0RT
	 6TB25PyUwwvX4SLbUIt8v1x9DEQ/9zpnxR2ubYOsVEAOxgk9MM/zEsfWnBBu2Xh/VziBH
	 kGdFsiKQCnmhLyu7vu8DQn4mdjQI6XGmBBUxsR7TvNeusiDtS4jJ06DDOO7IYw9Qa70i9
	 lCL5I2cPNWtxm5Utci4nVCavITlFPqjsry6fHLqrOtG5uYCpzSUifF5qdf55qKWE13eDl
	 F+Wp1QzakUVBshVedVyflf49UyO9FBLJpLnK5SzE2lp5idonlGKDiNCiLeEtzSwjJDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cbrgW8KS;
	arc=none smtp.remote-ip=209.85.216.70
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC491606A327
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC491606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cbrgW8KS
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ac8f449d1bso2204279a91.3
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 12:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303094; x=1793907894; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xzpdASVHedhqOKgMw1KD3RU+Tfm1fLmwQdc26sVHTJY=;
        b=cbrgW8KSDQrU5+G1phw9auRm0KBhsNOrkkuRmv0LrT8MMEUxFdheMqH9drkzcc7hN/
         evq/4T5/FoIL/bZ5acdou81vyAjiGAakHYwRODHJMqZXBzJYyBkQXtTaoy42yT5eHu/E
         d7ToCFNyLgqOgnjG7CqxbhZD/d3elcOjL9roNhPwYa2toWhj+1WjHL8JRd2bP/te84To
         oivIVMWdgt09Q+rm4zh8rOr4RF2KSrLU3saTGa0QAIO8LN/5BgM10zZ07HUtam44sxoJ
         BAj9X0kYEYy31h01tlWXmntKxgMG3uAi0k47WM1fBM2hYBCXy9Fs9/oAAkQ+lD/+nSGS
         N4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303094; x=1793907894;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xzpdASVHedhqOKgMw1KD3RU+Tfm1fLmwQdc26sVHTJY=;
        b=lSvfD0S9Z4BwEzbTLyOT5w/zFEu8VjZ567Qzdqir+P4Cf7boJsqI5Mkqx9nbISCelt
         9Hcfm7mCOAusxRc2wHR2acOYNwi/kXW6qZPQ+E6ZZdi+1eAosuRohpU+GsmYC9OYKdiE
         LYfL8Ky2iX3MM6crZ7ZN7/2q/0A4bF2MNCD2CrAf0EFA3WzysNu3GoX3+3d4C4gp+6GW
         /rcyqj3UeuKgOvmtbltJoqIBWcwT64jvCtBmBcr4H2qz+syHN0iH9rVFnurG2oyIADgh
         c4/Pf31sZOhOuvPb4NCMHYFJ5uKVUpfMwuJdmcBO1NvxPb9lNYE6v/lI+1k4p/5J+s/6
         u5tQ==
X-Forwarded-Encrypted: i=1; AKwUvBx9kmm7t6TnqPms8mwvxKQNxt+whErS0SoZ+ezgXBd6t+oWoBP7Ty6R+o7kaFFKLkp2+7TX2KK5@vger.kernel.org
X-Gm-Message-State: AFq9FYII2Fz67BH8gAExOd/xlsjNDSvvS3jAHhijRTy/id5SGSZbE9Sc
	o2Ld7NXYZ39JZBTgAea/MNlF4+eVj2xiHRSZNIon3/6hdLJFHstup0vPoO7dcR7RlcuhG6XBjB3
	9M8eEjw==
X-Received: from pjl16.prod.google.com ([2002:a17:90b:2f90:b0:3ae:825a:57e3])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4e83:b0:3aa:f4af:1e0f
 with SMTP id 98e67ed59e1d1-3ae89536c2emr24913a91.8.1793303094029; Thu, 29 Oct
 2026 12:44:54 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:11 +0000
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-1-kuniyu@google.com>
Subject: [PATCH v3 0/4] memcg: Misc cleanup and perf improvement for TCP.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
degrades by ~50%, 32M -> 17M~27M.

In the bad case, the number of involuntary context switches
was extremely high by 12x (241733 -> 3093367).

The root cause was that refill_stock() calls memcg_uncharge()
or drain_stock() while holding memcg_stock.lock.

Patch 1~3 are misc cleanup for better asm output and patch 4
moves heavy operations to out of local_lock(&memcg_stock.lock).

This series removes the flakiness and gives ~3% gain on the
512 vCPU platform.

In addition, on machine w/ AMD EPYC 7B12 64-Core Processor
(Zen 2 Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves
36% more throughput with lower latency.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |    Patched |    Diff
  ---------------------------+----------------+------------+--------
  Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
  Latency Mean (us)          |         478.46 |     351.07 | -26.63%
  Latency p50 (us)           |         453.96 |     343.04 | -24.43%
  Latency p90 (us)           |         669.00 |     479.57 | -28.32%
  Latency p99 (us)           |         969.38 |     593.92 | -38.73%


Changes:
  v3:
    * Drop MEMCG_SOCK batching patch
    * Patch 1: Be more specific in sentence 1
    * Patch 3: Mention Clang 23 and restore asm output
    * Patch 4: Add a new benchmark result without batching stats patch.

  v2: https://lore.kernel.org/linux-mm/20261028185034.3607746-1-kuniyu@google.com/
    * Rebased on mm.git/mm-new
    * Add patch 5 for flaky throughput issue
    * Patch 4:
      * Benchmark again after rebase and update numbers
      * Check in_nmi() in __refill_stock()

  v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/


Kuniyuki Iwashima (4):
  memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
  memcg: Reduce nesting in consume_stock() and refill_stock().
  memcg: Annotate slow paths in consume_stock() and refill_stock().
  memcg: Uncharge pages outside memcg_stock.lock in refill_stock().

 mm/memcontrol.c | 95 +++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 38 deletions(-)

-- 
2.56.0.317.g454f8302e1-goog

