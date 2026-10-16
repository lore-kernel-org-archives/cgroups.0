Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669E33769E9
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 05:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792128496; cv=none; b=OgaFpVlWyCadBAHS2eUsl5XUpBXx5kNpvFb7pAwJaussHovd3dtlwHhKVkjENPqQo5IJBhE30ov/q5B+fWZj1ZG4VoBwDW2NnilLChw6wtCUSttYhcZswyGe1hclMhPujTM60sES52B5NOoP6ZbmwZ73oV3nzWcva5TdRoxVmUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792128496; c=relaxed/simple;
	bh=GRHu9tivzXr4rEaQNfDTUQTIj2SbecUrIuJLV3ZRjCI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=g7ygmnOi/pN31NADKA8wV5QHvIJ5F/6Q0HxiFoUZ57YIxsZaM5dE6n+gDsZ3mXqZfFJcHDUv44kKb0yiCJrFpK0Fjc2M5CP+3zc0/fy3y1ZGmQaU7A8VBUNEe2QrPWOTJVjpPlPLtFU6MR4KWPXyGD6rfjJ1Blab9W4l7+Ms38c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DdSE3st3; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DdSE3st3"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89b52a188c1so1020534b3a.0
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 22:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128495; x=1792733295; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=M4ahsKpEByLpjYwM5E8QdP6uFfaxDfM+kbphj7puBv0=;
        b=DdSE3st3z3tm4MttYcFDilhLsT0rjqYVtwmEgZOME9BxcVL3lKmLvhizfeS070ZHk2
         HBgrP6/woNZtFQqKPBfkywKXCE69ltMIPDJdli7o4l3DiIlKgfPuDpWArriXAwknhITz
         TbOiGR2UIvRxabbe0zOEfacOEoDGtqCgne3z/Ob76uvDFCkZuIHxKI0cPJjqbI1vPGFD
         TqssiLgFvgSPi+BtNDpWTdo4gkJmc9NKWHq9IpYOxX8+VqyEfZLamMGUPiLEqVcsuI4o
         ASTRxdcpXKW9kdJeOrflA18pdqoZN41w9bDPgrDSm5iNJbgF1aNGRMdYj87AeRNjrnj0
         Dzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128495; x=1792733295;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M4ahsKpEByLpjYwM5E8QdP6uFfaxDfM+kbphj7puBv0=;
        b=NmR5UI+dfBuzg5S996X8XSOOAg71kbGe5PaQewNSNsAuBcjh7C0n/0F+8m3iXVuS6g
         JMBiXGUvfU84Yk8OgFOKYIkhDGkwb3ni+6XWKoStn4lXzq2vyxfNQ+DeI7ckEEMDyhHv
         RyQEa1xKjdOofOdgr/tV+7gCiYMEQZIOvNqS12t+TR1DLMjht3xv22ffV/i21+Bx/zjO
         BDCL9vVkFN5FmqZhfhwvmP4s3pADueZcVkCnCx/rmQUA479U1ocLCT7y+PrCbUYG4Hv4
         n1hhgNgkFmUSjRN/RrGIETBqpHHLD3CBtPSjCjiWFKjs6+l6oZUYXSo6rVIQCjpx4xCb
         L9Sg==
X-Forwarded-Encrypted: i=1; AKwUvBy86jj3RuEI+XzPbQxo8AFGVXa+b/K3nkemItUiGrQ9/DHY9E2lhpgS3SkcmjumeVxJrYQtLz5H@vger.kernel.org
X-Gm-Message-State: AFq9FYK+PLmn5RnLAzlcxL0lrzFfXbfY/rhCVZ/EUZK6XaTkhSXPT9K/
	jqk/h47V06dE9h3IKw7pTB+28aYfjAY2/bW8vUgib2bD/3yrG3cH/5NWvnHF3Z2VNYs4a8lvDUk
	IYzdAJg==
X-Received: from pfbcl10.prod.google.com ([2002:a05:6a00:32ca:b0:89d:8f0c:4f51])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:188c:b0:886:cae0:fb66
 with SMTP id d2e1a72fcca58-897c71084a7mr20396628b3a.16.1792128494333; Thu, 15
 Oct 2026 22:28:14 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:44 +0000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-1-kuniyu@google.com>
Subject: [PATCH 0/5] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On our production fleet, we saw mem_cgroup_sk_charge() spent over
3x the cycles of try_charge_memcg() although the former should be
a thin wrapper of the latter.

Looking at perf during tcp_rr, most of the cycles were spent in
mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
due to cache line misses:

  mem_cgroup_sk_charge  vmlinux [Percent: local period]
  ...
     1.74 =E2=94=82       mov     cpu_number,%esi
     0.70 =E2=94=82       movslq  %ebx,%rcx
     0.31 =E2=94=82       mov     0x518(%r14),%rdx
     8.99 =E2=94=82       add     %rcx,%gs:0x18(%rdx,%rax,8)
                  ^-- this_cpu_add(memcg->vmstats_percpu->state[i], val);
                      in mod_memcg_state()
 >> 31.21 =E2=94=82       test    %ebx,%ebx
     0.05 =E2=94=82     =E2=86=93 je      97
          =E2=94=82       mov     %r14,%rdi
          =E2=94=82     =E2=86=92 call    __css_rstat_updated
     0.31 =E2=94=82       mov     0x518(%r14),%rdx
          =E2=94=82 72:   test    %rdx,%rdx
     0.06 =E2=94=82     =E2=86=93 je      97
          =E2=94=82       mov     this_cpu_off,%rsi
     0.17 =E2=94=82       mov     0x10(%rsi,%rdx,1),%rax
     6.59 =E2=94=82       mov     0xc18(%rax),%eax
                  ^-- atomic_read(&vmstats->stats_updates)
                      in memcg_vmstats_needs_flush()
 >> 26.02 =E2=94=82       mov     __num_online_cpus,%ecx
 ...
     0.65 =E2=94=82 e5:   mov     %r14,%rdi
          =E2=94=82       mov     %edx,%esi
     1.88 =E2=94=82       mov     %ebx,%edx
          =E2=94=82     =E2=86=92 call    try_charge_memcg
     1.56 =E2=94=82       xor     %ebp,%ebp
     0.18 =E2=94=82       test    %eax,%eax
     0.22 =E2=94=82     =E2=86=91 jne     9f
          =E2=94=82     =E2=86=91 jmp     31

This series adds nr_sock[] to struct memcg_stock_pcp to batch
mod_memcg_state() for MEMCG_SOCK.

With this change, tcp_rr w/ 20000 flows achieves ~9% more
throughput and the TCP stack spends far fewer cycles on memcg.

  tcp_rr (20000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |        Patched |    Diff
  ---------------------------+----------------+----------------+--------
  Throughput (RPS)           |     22,408,523 |     24,360,262 |  +8.71%
  Latency Mean (us)          |         891.92 |         820.31 |  -8.03%
  Latency p50 (us)           |         877.22 |         744.10 | -15.18%
  Latency p90 (us)           |       1,085.43 |       1,082.02 |  -0.31%

  perf cycles (20000 flows, 10s, average of 3 runs):

  Server (M cycles / %)      |           Baseline |            Patched |   =
 Diff
  ---------------------------+--------------------+--------------------+---=
-----
  Host Total Cycles          |        4,994,342 M |        4,793,242 M |   =
-4.0%
  tcp_rcv_established()      | 213,968 M (4.283%) | 210,418 M (4.390%) |   =
-1.7%
  mem_cgroup_sk_charge()     |  12,322 M (0.247%) |   6,390 M (0.133%) |  -=
48.1%
  try_charge_memcg()         |   8,326 M (0.167%) |       0 M (0.000%) | -1=
00.0%
  mem_cgroup_sk_uncharge()   |   7,492 M (0.150%) |   5,752 M (0.120%) |  -=
23.2%
  refill_stock()             |   7,988 M (0.160%) |       0 M (0.000%) | -1=
00.0%
  Charge Total               |  20,648 M (0.413%) |   6,390 M (0.133%) |  -=
69.1%
  Uncharge Total             |  15,480 M (0.310%) |   5,752 M (0.120%) |  -=
62.8%
  Memcg Sock Total           |  36,128 M (0.723%) |  12,142 M (0.253%) |  -=
66.4%


Kuniyuki Iwashima (5):
  memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
  memcg: Reduce nesting in consume_stock() and refill_stock().
  memcg: Annotate slow paths in consume_stock() and refill_stock().
  memcg: Batch mod_memcg_state() for MEMCG_SOCK.
  selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.

 mm/memcontrol.c                               | 155 +++++++++++++-----
 .../selftests/cgroup/test_memcontrol.c        |   9 +-
 2 files changed, 118 insertions(+), 46 deletions(-)

--=20
2.56.0.212.g129ede20d9-goog

