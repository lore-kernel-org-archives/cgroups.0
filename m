Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604724848A6
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 09:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586849; cv=none; b=uo9E4+1i+gus3qm7BnwHlKaIzwZhwTURm9vph+wA7YQIB40jbLLbySOxaLD3Xx5hXDKF/6LTxPi4rIKNJ1JU6BdjK4Rlsc864AuMie7nVzyuJc8T0l3WIcdqSCuLpvZHwIM8QqOy+CvHkoA1n1baBo4nfrZALR6JZWwqN1p+OyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586849; c=relaxed/simple;
	bh=5TaJW5SEGsrCqfe0Z/3dxlImw0PREoqRYlnBxTBh6fY=;
	h=To:References:Content-Type:Subject:Mime-Version:In-Reply-To:Cc:
	 From:Date:Message-Id; b=utPJu1W/ZXJl2p+oWdqSDE5itkk0ECrdhGK8MPyPMcmLUBV0hIHCw+v3AG7TERGgqRgUQkKnivq8dZF/he0w1kUHNiJeV5zs5ET6xXJY2Oc3iGknhnLJdOCe0jG9LTNiQ1MRuVXE1okjKaPW81s+GfPPS8s2EEOfRHp07tl6shs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=EOf3Odjf; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="EOf3Odjf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790586720; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=oFKIfEpZiWdUmftWTQZ+UXe0u3N9BTu1HIzjt4MGous=;
 b=EOf3Odjf6PROF5Fd4TlCjszG4GktRLcuRCBxAPvQLvDCncu7kMz58sCiI8q5MV6uGFbQAy
 SHcjzXa98hBWsWCpF9ZjsPVkWXlUE10VvHheNTYSW9OKgX7OariVFlnsncQ2BfOFlkzwp0
 EZCE59OqpDzrQCN+VFA5Lv0iNO3aU1zbucLGJfQa2fvcy4qvsXh3DQRPs7OO3FWPGCA1Kh
 k3U92fGmIVFA7lqaee6oLiBpo3FIX0jAwdhn8tka5tGKkRK7oQtTIMF7s2vYqkrXmWBs6P
 PontegMv4+pgi6X/eF4Lf3TCRbsUYOHeB7/s0skyKRrdupVoNiKH2JV+oHtUcg==
To: "Kairui Song" <kasong@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH RFC v2 00/15] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aba2f5e+a41b86+vger.kernel.org+liuxiang.277@bytedance.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
X-Original-From: Xiang Liu <liuxiang.277@bytedance.com>
Cc: "Kairui Song" <ryncsn@gmail.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, "Yu Zhao" <yuzhao@google.com>, 
	"Barry Song" <baohua@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, 
	"zhaozhengzhuo" <zhaozhengzhuo@uniontech.com>
From: "Xiang Liu" <liuxiang.277@bytedance.com>
Date: Mon, 28 Sep 2026 17:11:44 +0800
Message-Id: <20260928091144.818739-1-liuxiang.277@bytedance.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 7bit

Hi Kairui,

I tested the complete MGLRU-FG RFC v2 series on an x86_64 machine with
a SATA SSD. I found that the LevelDB Scan/Get result changes with the
relative intensity of GET and SCAN.

Setup: base commit 9958290885035431e2494159f555e332c3c14906, about
28 GiB LevelDB, 2.5 GiB memcg, swap off, Zipf 0.99, SCAN length 10000,
240 seconds warm-up plus 240 seconds measurement. Each untraced ABBA
sample used a fresh database copy, page-cache drop, reboot and cooldown.

Untraced ABBA results
=====================

Workload                  GET/SCAN   Baseline       FG     Delta
1 SCAN + 3 GET                92.5    4688.62  4425.82    -5.61%
4 mixed workers, 99.5/0.5    195.2    6200.60  6385.57    +2.98%
1 SCAN + 7 GET               237.2    9574.97  9831.70    +2.68%

The first workload is the original four-thread layout: one continuous
SCAN thread and three GET threads. The second is a custom workload in
which every worker chooses 99.5% GET or 0.5% SCAN per request. The third
keeps one continuous SCAN thread and increases GET threads to seven.

In the original workload, FG changed GET throughput by -5.74% and SCAN
throughput by +6.91%. The two ABBA position pairs were -6.21% and
-5.00%. A separate 5 GiB memcg repeat was also negative: -9.07% and
-7.67%.

Traced results
==============

I ran one fresh-boot baseline/FG pair for each workload. To limit probe
overhead, I selected about 1/1024 of file offsets using a stable hash of
inode and page index.

Initial placement of newly loaded GET folios
--------------------------------------------

We tracked new file pages loaded by GET requests and recorded where
MGLRU initially placed each page: the oldest generation or the
second-oldest generation.

Workload / kernel       Sampled   Oldest        Second-oldest
1S+3G / baseline           1452    186 (12.8%)   1266 (87.2%)
1S+3G / FG                 1371   1052 (76.7%)    319 (23.3%)
Mixed / baseline           1782    199 (11.2%)   1583 (88.8%)
Mixed / FG                 1662   1312 (78.9%)    350 (21.1%)
1S+7G / baseline           2719    469 (17.2%)   2250 (82.8%)
1S+7G / FG                 2677   2107 (78.7%)    570 (21.3%)

For example, the original 1-SCAN/3-GET baseline run sampled 1452 newly
loaded GET folios. Of these, 1266 entered the second-oldest generation
and 186 entered the oldest. With FG, 1052 of 1371 sampled folios entered
the oldest generation.

The same change appears in all three workloads: mainline places most
new GET folios in the second-oldest generation, whereas FG places most
of them in the oldest generation.

FG promotion was active in all three workloads:

Workload              Later GET       Moved to the promoted generation
                      changed gen     during reclaim scan
1 SCAN + 3 GET              38              548
4 mixed workers             32              558
1 SCAN + 7 GET              70              936

However, FG also removed more sampled GET folios before another GET
reused the same in-memory folio:

                         Removed after one GET      Later reloaded
1 SCAN + 3 GET            81.5% -> 88.4%           44.7% -> 48.6%
4 mixed workers           73.4% -> 90.2%           48.3% -> 52.7%
1 SCAN + 7 GET            84.5% -> 88.2%           56.2% -> 61.1%

The arrows show baseline -> FG. "Later reloaded" means a later GET
demanded the same file offset after it had been removed from page cache.

The request-level counters explain why the final results differ:

FG change per request       GET cache miss   GET I/O wait   SCAN cache miss
1 SCAN + 3 GET                    +2.29%          +6.87%           -15.97%
4 mixed workers                   -5.68%          -4.19%            -6.93%
1 SCAN + 7 GET                    -2.89%          -0.32%            -8.26%

FG improved the SCAN side in every workload. In the original workload,
the GET miss and I/O increases were larger than the SCAN gain, producing
the 5.61% total regression. When GET was denser relative to SCAN, GET
misses also decreased and FG became a net win.

My interpretation is that FG introduces a cold-start window for a new
GET folio:

  first GET -> oldest generation
            -> a later GET promotes it, if it is still present
            -> otherwise reclaim removes it first

The outcome depends on whether GET reuse arrives before the continuous
SCAN stream consumes the oldest generation. The trace shows that both
promotion and early removal occur in practice.

This machine uses SATA, while the positive results in the cover letter
used NVMe. Storage latency may also change the timing among page-cache
insertion, LRU drain, the next GET and reclaim.

Is this cold-start window an expected trade-off of the current design?
Would limited initial protection for refs=1 folios, or a decision based
on observed refault/reuse distance, be worth testing?

I have preserved the workload source, ABBA results, kernel configs,
probe programs and raw traces and can share them if useful.

Thanks,
Xiang Liu
liuxiang.277@bytedance.com
