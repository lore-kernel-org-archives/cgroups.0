Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C252D12EC;
	Fri, 28 Aug 2026 10:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912799; cv=none; b=eJ+vMZO/8Ns0r+e8QLczvKEQ17R1DnYA/yz8G6GnzBan2tfE/UsEBt/RXe3qOHCpO1SVOp6bXihS/XFr3wHE0+20Tje8jrl/7rZ83cuV3b1Mb91ymcHnAa+QhC/fQybLIEuEUWEMNQDMBmmaAG8XU1eNK6jKaSPkj9YrlYyEhh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912799; c=relaxed/simple;
	bh=th+xDhiEl14/LOf5lAn3kUndTlrg/FM615RgBOH1ttA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE01tyXN0d4iFUj4OQvFMFr3UNfoADhndxzgxE+enB6cdALwrxmcztd6FS1O9vwFiK+4u5b87LdodEsKhpaYDfIdXT5zBrZj9p8Z1aJb1dfB+wAbx7INtqKpdIIUaAdZBeB4SPMWdHTZVuT45l8dF1wt3qGoUz0sE31p+7ePZCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=NUMHHltd; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="NUMHHltd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787912784;
	bh=TUv1RmQ2miGU/9mk3aHLymUw+hTO6Btwj2zASn4n3FU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=NUMHHltdvus25AuXUm6KcbE7dR2l+Tcoake/fGcY7xqewUlWblCr2lTP6H+GP1kwJ
	 XUJRIY/UHEMwfTtH2rIGf7/u4pYPb6bxsKIJZ7UiKpfRIODh7ACQEdmhdo67o2nYv1
	 diaPyDZ+h4SWoDNdCRjrTEx3/J8rQ2r3CyebObkQ=
X-QQ-mid: esmtpsz10t1787912769t0a67fde2
X-QQ-Originating-IP: Czl82io0r6bpdd1Si+MKx9FHyKA59c9FLNXUn3Mf4Gg=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 28 Aug 2026 18:25:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4164784022623513556
EX-QQ-RecipientCnt: 44
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: Kairui Song <kasong@tencent.com>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 00/15] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Date: Fri, 28 Aug 2026 18:23:44 +0800
Message-ID: <92DCEFFD13221261+20260828102344.1537874-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MBP203HMaIGdS4t2riyk4hrnWePLTaO2MwfXTI9yPd8+iuD/p4vFHwTt
	vGeR1qsp+f8WOVYB/aq4BwJjIp6sNJ7QTWdUtfP/Y1UdrDXvHa7q/E1wMo8Q9Nm0Bav0bPQ
	0zTi0rXF2o/2bKHShO26ZiVSRyfj97A3yWOtaCrZ6dZaaqJG7rp6gRnB+ZdTtTvau8PijJ7
	9rcKDCOkSpgu7DdeKCUexKb1HA28gSLIcVO3PCu4Zw+W1GMwZ5q2c0x6fsOE5R9h6EF3oxS
	59ku5adNikI833tIjb6XyO3wQ9QxuEHCtdZ1mnP2oo9uAJ/b1UBB3Rbx6PjX8vc7LChY5YA
	5YyneA5DMmRIOHVebpsUXiY2AYtAp1Rkv6YJxncwCyh/vdz0gFztxGtpBPlhTPvpf+REfUX
	C6uc672g7VzGhpv4TeNm/76FqImUbgTEc4oqeTBAjJ402duMCGXU3vB44i8vE+B/1Bv5S/h
	53R8bja9qBILyzwJIqjFGQV3luI34nhzufsluFQlupIm7M1P04yRMCHDvAl51+PNsh7Lapa
	W8zaz/nu9D0Xa5UuSYTBGhziIHX0ikfC+gAM+hp593lva8ol39a9B0nu0x381YyJavXTvYP
	R64hUmc47T7MKXoKnYh/1lqkmLkUdHwET3K/IlqJVJUX0AZFntctQdj6izXNkzU/bd8qeSt
	gbRxKVhwKt3k9ae8zU8F3F5rb9lCLHLNPN7FCdge9XfMMQ37VSUEWSqK0hBjNPtDSgmIXiY
	uyQ7fnECLYYgGkSBGhkAU0vGfjYAOV5FQAIQH3ZCEqsB3VW6KqNSydIe2HpUFaJcmM2qRo0
	jCjujSeGDr6ugeJmUwQbUf/S/8anm9R0f1sOHY3mDkthWJzHH3Tzf3+uMKOZd+AfWL1c2xU
	C60HEK0kWLwol3zXdjKNDSLLT1BdtSRrFVVXtwRKcWPPBvf3SP1Vwy005zpN6ZBdtdwXqu+
	qyqj/6v2mOD94vcGwSVviJufJJ4rY7RHca3K4+6ZyewO3QDnOEwVORvFoJ0X5JQts069UDV
	EteFrVp2WLX22RqdpYEX+fMpGqoAWqAvbnrwReRUG5RHk15nFRuVPAy05LdnXM7wXaZQ2CU
	2eIxpSRDK3Vp4ils52ycU9QpJhB8XbsN7KA7hgnnlxtXWadWqC33yI=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Hi Kairui,

Thanks for the MGLRU-FG series - it is a very interesting and
well-written piece of work. I ported it locally and ran a subset of the
benchmarks from your cover letter on our test VM. The results are
positive and consistent with yours, so I wanted to share them as early
feedback. I would be happy to test the next posted revision directly
and provide a formal Tested-by tag then.

Test environment
----------------
- Host:    96 physical cores / 192 threads
- Storage: VM images on a 4 TB Netac SATA SSD (no NVMe); VM disks
           are virtio-backed image files on that SSD
- VM:      96 vCPUs, 128 GiB RAM (KVM)
- Baseline: mm-new @ a032d41a86cb
- MGLRU-FG squashed into local commit 9fc6ff682d08
- NOTE: the port additionally contains a local guard in
  folio_inc_lru_refs() for non-LRU folios, so this is not an exact
  bit-for-bit test of the posted series.

1. fio, Zipf 0.9 buffered 4 KiB random reads (all IO through the
   page cache), 40 GiB total files, 16 jobs, 16 GiB memcg,
   45 s ramp + 600 s run:

                        run 1       run 2       run 3       median
   CLRU                 797.64      796.74      800.21      797.64 MB/s
   MGLRU before         766.88      273.75(*)   769.81      766.88 MB/s
   MGLRU-FG             838.16      840.26      367.92(*)   838.16 MB/s

   Median improvement over MGLRU before: +9.30% (cover letter: 11.1%).
   The two marked runs entered an unexplained low-throughput state;
   CLRU stayed at 797-800 MB/s, and a reboot restored MGLRU-before to
   769.81 MB/s, so I kept the outliers visible rather than dropping
   them. I am investigating whether this is related to MGLRU
   history/state across hot switches.

2. MongoDB 4.0.23 / YCSB 0.17.0 workload B
   20 M records, 6 M operations, 48 threads, 16 GiB memcg, 8 GiB
   WiredTiger cache:

                        run 1       run 2       run 3       median
   CLRU                 18695.72    18673.44    18438.05    18673.44 ops/s
   MGLRU before         17517.69    16196.08    18180.28    17517.69 ops/s
   MGLRU-FG             19871.70    19721.86    19321.00    19721.86 ops/s

   MGLRU-FG improved median throughput by +12.58% (cover letter:
   10.3%). Median read latency / p95 / p99 improved by 11.35% /
   12.30% / 26.06%, respectively.
   Caveat: the master DB was loaded with w=0 and stopped too soon, so
   each run had about 22.7k READ NOT_FOUND results (~0.4% of reads).
   Every variant was cloned from the same XFS reflink master, so I
   think the relative result is still valid, but I will redo it with a
   fully settled master.

3. SQLite hot lookup + cold grep stream (sqlite-grep test, 90,000 cold
   files, 300 MiB memcg); median of run-medians for the hot lookup:

   MGLRU before:         277.18 ms
   MGLRU-FG:              13.74 ms   (-95.0%)

   Eight of ten MGLRU-FG samples were about 13-14 ms, whereas most
   MGLRU-before samples were 249-322 ms. Grep time itself changed by
   only about +1%. Compared with MGLRU before, MGLRU-FG also reduced
   file refaults by about 21%, direct scans by about 17.5%, and pgpgin
   by about 15.1%. This was the clearest reproduction of the intended
   protection against a one-shot cold stream evicting hot data.

General observations
--------------------
- No memcg OOM kills, and no kernel BUG / Oops / Call Trace / panic in
  dmesg across all completed runs.
- Confirmed that folio_inc_lru_refs() is exercised at high frequency
  under the fio workload.
- make -j48 / 3 GiB memcg / disk-swap (CLRU side only) completed in
  2h18m59.9s with 20.9M file refaults and 48.1M anon refaults, no OOM
  kill. This VM builds about 13.4k objects and many modules, so its
  absolute time is not comparable with the machine in the cover letter.
  The before/after MGLRU sides are still running; I can send the
  same-machine comparison separately.

One thing I want to flag: my local port adds a guard in
folio_inc_lru_refs() for non-LRU folios. I noticed that syzbot
reported a WARNING in folio_inc_lru_refs() on this series
("!memcg && !mem_cgroup_disabled()" in the exit_mmap path). I am not
sure whether the two are related, but if it helps, I can check whether
my guard's trigger path matches that report.

Because this was a local port plus an additional guard, I am reporting
these results without a Tested-by tag for now. I would be happy to test
the next posted revision directly and provide a formal Tested-by then.

Thanks and best regards,
zhaozhengzhuo
zhaozhengzhuo@uniontech.com
