Received: from mail-oo2-f37.google.com (mail-oo2-f37.google.com [74.125.231.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922989463
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 00:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790986740; cv=none; b=T+w9Qdknh3abMyHgiU6MD7l8hw216vWSxmr55JOL2VoYzHp2YXIyUPUNu9rwpDuSjupSjHpIY2AHWpz9Q2DUsD5682qTJALU9GpdR1sqQJ20S8O0+6NWx9FYhpE348m804oyEIVJP/W9twLR9mU/RsuSbenmlmrdjLx+TB9kgFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790986740; c=relaxed/simple;
	bh=pMW3iFejtS+44ufI6erWJ8Iethh8fw59A2sZQM0gROo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uVU0xLhFwq1Ux37OLXUmnmPVtceg/LYZ8nLj3RlwWmeu/6lGss4xdGgPIBry1lqpZFy1ELf3e28BINCZdyuxBfNbY520fZeQRvpHyeNZCBVlBVCrAGJ4v3i147vnlsn/oel5BVo1mIupQg/zeD4sRaCFsva4rTneDc/QhG7gMac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eA25sq3J; arc=none smtp.client-ip=74.125.231.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eA25sq3J"
Received: by mail-oo2-f37.google.com with SMTP id 46e09a7af769-8137b129131so360201a34.2
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 17:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790986737; x=1791591537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dOJAo01xD+ma9V3F3JPbMavctw9FJP4/KhHqsKCIBZc=;
        b=eA25sq3Jn438ny0AbW46qCMW3LiSZQXKiRJP0vi8kNfA+Lp7hOmwtkPIOgj/0fgcn1
         bbo35GWQQB82JuwDHGS+0po0wWFHwO6tANSBNnjfLc2rOP5MYViQl4pxLVXlgcPtYUQL
         FaxSJDgkiNdjUpj22qiBrbUkCgWLkBdkAFOdqklPZ7Ba1tutVffFAwH8PHdqIh433UIq
         96ExDRJF9YgTYdWEnsiKOjfppdWacdPQJg0fLeGXMioY7lSSDUP6ydGqmcIMRG5BlJIP
         lWB+oWS+tiGnJz/XbjD3QDfGGIwwRYyhW9OJvu9z5RcpW/FnLueHYyPNGwl3uROVfFPN
         Zr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986737; x=1791591537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dOJAo01xD+ma9V3F3JPbMavctw9FJP4/KhHqsKCIBZc=;
        b=1dkebfsxBXw01fJzs63vk7a/DdPy6fFgnIQi5qcVA2W4FT0Dcs+tCLumvrmF3lonu4
         ZzX/dP31A3lcrB6EPmrraxb6j/FGt+9NCzKpHErcU7Cfkx4uCWExtuDZl0pfjXL/SWqE
         ikUgIospApd+S7NQUwYZvQt7CRoACQSDeDP5GUt9q5fm7BSXFgOCfQtPuypFuS1alTmN
         9CutjSxmZUw5at+xpzfSDCA3GjHChrzClyEEQpYKY23VGqC9YEfRWj0BfVaUg+fTa7nU
         ZhSIpRP1zroF31LY2ykg+uZY+lUSSvGYEGDZFioicsbknbVQHexrWHCn8Sdpm5ONbZJ/
         9VYw==
X-Forwarded-Encrypted: i=1; AKwUvBxp4kz8hGrlozJwWuxukO/Dx1cDmLNccXqxDdRV2GRAno+unCzcQwnQLiycS86bu2U/SMzUUeCK@vger.kernel.org
X-Gm-Message-State: AFuF++lpV5bfAmH25ksqYoqK8fT8ymB4l9/PYb/fNofkvlE/Cj3h/tw/
	9mOEsLKyKQA4BHi0PtLhKHP+LwVpWEqLSOtjqBoF/egOvqyf8+YwbWmJ
X-Gm-Gg: AYBFou3/MnTlcKoTf6PlLtA/Gv5/JpvyL+U73ZexPktHTXDksoFcFKt7yQvvifRDq0x
	caDkueh9pCMLMnyH8lDanOHwjMzkkqOKFJ2zpadAubGo+o4p1+IRXbl7xXAUh0SGaiw4KV0BFl/
	I7NHk00l8X5m1ag94QSe3267RXz2Cnnsqh4mcFgMc9vt/6qZqrc2Pcgiw2fK1xX8xmaaRcn4Rce
	rwwmhEdwDBxmVB1+noApbKNnq/MGE4CJGrbiQCByYvBpx8qD3jLlFMJsXc4C652A+hjJiTiRCze
	ZwjPkm45fhzF85JxptkusslkpqBGflHBOgrXo8q7XTcIiVVsTWE9lerclByuKF7b7KpQ1sjGxr3
	dEOUUDZl7f8/e263De741or/6BLLmOTzJvmnTDrg7DDu88lIz+Z3oLCDsnS2C7jcP2mUbYbfJMu
	+e+VgmV0QjGiHsWtLV+J2jdGMFaE/lAvmglY5UVjqICWPYRgrF2G7BDIr0GXZIXbMQmyd5LtRhw
	t0/BvBILh87xRQyE9rOQId04giJvsE4gurtO2BihWVJE+TJOjc=
X-Received: by 2002:a05:6820:4cc7:b0:6b3:506e:b484 with SMTP id 006d021491bc7-6df32da21e3mr3485781eaf.16.1790986737447;
        Fri, 02 Oct 2026 17:18:57 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-49e1b2e3664sm2883059fac.7.2026.10.02.17.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:18:56 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	willy@infradead.org,
	jack@suse.cz
Cc: mhocko@suse.com,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	riel@surriel.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 0/3] mm/readahead: avoid per-folio memcg reclaim
Date: Fri,  2 Oct 2026 17:15:52 -0700
Message-ID: <20261003001555.3498357-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Readahead adds the folios in its window to the page cache one at a time. Each
folio is charged separately. When the memcg is at its limit, each one of those
charges triggers reclaim. With many tasks faulting in the same cgroup, the
margin one reclaim pass frees gets consumed by the others, so the faulting
tasks keep reclaiming, all to make room for speculative folios, and in the
worst case, reclaim livelocks.

On Meta's fleet, this per-folio reclaim is a large cost. From fleet-wide CPU
profiles at Meta:

 - Page cache insertion (filemap_add_folio()) triggers about half of all
   memcg limit reclaim CPU, more than anonymous faults, swap-in and
   memory.high combined.

 - 93% of that comes from mmap fault readahead: filemap_fault() ->
   do_sync_mmap_readahead() -> page_cache_ra_unbounded() ->
   filemap_add_folio() -> mem_cgroup_charge() -> try_charge_memcg() ->
   try_to_free_mem_cgroup_pages().

 - In filemap_add_folio(), 83% of the CPU is memcg reclaim while the page
   cache insertion itself is 6%.

Most of it comes from services whose worker cgroups run at their limit while
many threads fault in mmapped files, mostly on btrfs, which our hosts mount
with compress-force=zstd:3.

This series adds readahead folios to the page cache without direct
reclaim. When the memcg is at its limit, readahead reclaims for the rest of
its window all at once instead of once per folio, and tries a second time if
the window runs out of room again. Please note that this only applies to
speculative readahead folios. For the folio a fault or read actually needs to
read in, it is still charged with the mapping's normal gfp mask (with the
reclaim flag set), like before.

On a 26-core/52-thread machine with btrfs, running 26, 52 or 104 processes
(one per core, one per thread, and 2x oversubscribed) that each mmap their own
file in one memcg with a 1G memory.max (before and after measured in the same
boot), reclaim passes per major fault drop by 94-96% for both random and
sequential reads. With data compressing ~3:1 under compress-force=zstd:3, the
runs that livelocked in reclaim without this series (4 of 18) no longer do.
Throughput with incompressible data, where the disk is the bottleneck, is
within 5% of before in either direction and the drops are within run-to-run
variation. With the compressed data, it is 9% higher at 104 processes, where
reclaim contention is.

More details on the results seen (medians of 3 runs of 10 secs, 5 for seq, rand)
are as follows:

Reclaim passes per major fault:
                       26 procs      52 procs         104 procs
cold, rand          23.2 -> 0.88    23.2 -> 0.88    23.1 -> 0.89
cold, z3            21.7 -> 0.95    20.0 -> 0.91    17.9 -> 0.85
seq,  rand          78.3 -> 3.66    45.8 -> 2.37    26.8 -> 1.24
seq,  z3            42.0 -> 2.59    37.2 -> 2.01    22.9 -> 1.24

Throughput (pages/s), after vs before:
                       26 procs      52 procs         104 procs
cold, rand            -5%             +5%             -5%  (disk-bound)
cold, z3              -3%             -1%             +9%
seq,  rand            -1%              0%             +4%

(read_ahead_kb=128, "cold" = read 64 pages from random offsets, "seq" = read
4096 sequential pages, "rand" data doesn't compress , "z3" data compresses
~3:1, which moves the bottleneck from the disk to the CPU).

Cold readers get the same readahead as before (pages per major fault within
2%). Sequential readers get up to 18% fewer pages per major fault, but their 
throughput and read bandwidth are unchanged or slightly higher, so readahead
pretty much does the same IO but in more and smaller pieces.

There were a few alternative approaches considered and tested in experiments:
 - don't reclaim in readahead at all:
   This cut reclaim to 0.02 passes per fault, but effectively disabled readahead
   in cgroups that live at their limit, and led to ~100x as many major faults.
   Each read request sent to storage was around 5KB instead of ~120KB.

 - charging the whole window up front:
   This leads to overcharging, as it charges for folios that may turn out to
   already be cached. With every other 16 page jjchunk of the file cached it
   triggered ~15x more reclaim passes per fault than this series.

 - One reclaim attempt per request:
   This led to the fewest reclaim passes (0.75 per cold fault), but at 52 procs
   10x as many requests end early and sequential readers lose 29-35% of their
   pages per fault. This is because with many tasks in one memcg, the room one
   reclaim attempt makes is often used up by other tasks before the window has
   completed, and with no second attempt, readahead stops early.

 - Two attempts per request without the immediate drain-and-retry:
   3x as many requests end early as this series and sequential pages per fault
   drop 16-22%.

 - Up to four attempts per request:
   At 52 procs on z3 data it gave 14% more pages per fault for 8% more reclaim
   than two attempts, but this is within the noise of the two attempts'
   run-to-run variation (13%)

Swap readahead charges the folios in its window one at a time in the same way,
so it can hit the same per-folio reclaim at the memcg limit. This will be
further investigated and followed-up on in a separate independent series.

This series was run through an LLM for sanity-checking / reviewing,
structuring the cover letter and improving the wording of commit messages,
helping generate some test scripts, and for bouncing ideas for different
alternative designs that could work better.

Joanne Koong (3):
  mm: memcontrol: factor reclaim logic out of try_charge_memcg()
  mm: memcontrol: add mem_cgroup_reclaim_for_batch()
  mm/readahead: avoid per-folio memcg reclaim

 include/linux/pagemap.h |   1 +
 mm/internal.h           |  10 +++
 mm/memcontrol.c         | 131 ++++++++++++++++++++++++++++++++--------
 mm/readahead.c          |  51 ++++++++++++++--
 4 files changed, 163 insertions(+), 30 deletions(-)

-- 
2.52.0

