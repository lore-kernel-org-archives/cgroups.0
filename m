Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794603748;
	b=x7Vp9VMWujv/F4zGtS8OUisFdFF2I36SF8gSBUB7qTWEV0mHLVBqy/6mlMaPbb33aRov
	 HAlRVyKr5LVU94+xvmSCRvlz1uJYlfXzyRggt1+uEsfOpjSck76N+/F6JTF1HgOHwCidn
	 SKFxrY8DZFdTGRGmBYa1m8G3tPPwI1Tyu5eojnlY7Wg94pQ5cSUZ3dAmqLEvaR+crDL/n
	 IgHNJNmN7rbTRqcuYqof7ucYYk4dRbL12r04aoXqcYGVv2JgxcdeMLmY+3odp745Uu3uH
	 y258EplqiL1NZhvkxORxwWzkOkmMf2a33BmhoV+QP7Zcnfo/vVc2NqyOruR5DWaw6FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794603748;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=EKHRyYgdapxeK/rUhbpHJUiKnPLzVOKH5p9Uv++JqjQ=;
	b=Xy+SGq6G12HU7H8DCKMryCFnpGDrfKWFP2HAAOCrER5z3DANcpQqNTEHQ/t3oooOfwHe
	 kvezZnZp+iqNKHgiE1Hr9T1T/y9Y4NFl8MAD3HoLMN0x25R9JYvDYUtyQy9waVx554Ke5
	 v6DBKrGpWV/RagfdgP2w/EpSsDiA/6rxd9MS5B1A3tYor+DN57B2xjG+lGaEne3ZRDA2u
	 YTaEIUznJeTFEI/ixSpwPqUsKY0DxZJzsuAZznkxy9qCMvWZFYQlsY49W6MXBD6yo8PEG
	 MDnUKWlOA+5qe9qb68Q0Z6kbSmKovKMEW1racEXqktHYU9zFtiyDRtzF/Yk43R0e6Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vtjrl+HT;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F035606A323
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 21:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F035606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vtjrl+HT
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b10ca4e3f9so737102a91.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 13:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794603747; x=1795208547; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EKHRyYgdapxeK/rUhbpHJUiKnPLzVOKH5p9Uv++JqjQ=;
        b=Vtjrl+HTFtDYpH1k/xMvPa0U4XA7zxm74cDcWT3ciAcY2b1dUVFT8UDyypvZDOlwvk
         PubWoKh0opscbhzYtFpP8bjgwIo/FiRDoMbxBffjiCEizZa/ETFBfV5KMIpRKyoMUDaH
         cATgyYwBBTMZFh3SNmGW35kS/AV5UQunb98gbWf5Jx231mArTxSLLJsd6vUpEtSf1Ycm
         67kU1qjSBhG3bboeNS0D4AZdAbfayPx6KqioD6sv5Vl73Sd6uEkb1iNrmFj6Yb8/crn+
         3Wwf9etxDL8UInQejYsV8yBYE/c1CSwtcETjIxmk8ovzsl+82PdmDRfP21mh5q3uWwbP
         Rh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794603747; x=1795208547;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EKHRyYgdapxeK/rUhbpHJUiKnPLzVOKH5p9Uv++JqjQ=;
        b=MLFHXcGPL+RSqQNVbmTYbjv3qvejqIIN/RDfUvdx8+kDSTOqTKJv/iOU8dGlzWzS6U
         iJk9P2LEychkrD2VcuT9ACQ54Qf3bf+Huygs+fQndoLb2RGvChvZfkN02BPfyBG7KJRP
         O54C2cghcU+2losT8eC4zRtDfv5/vmLZHiRpdKhEYDgNNHD9Iy6jp3VS7tV6CTtnqhd/
         yTXMm2wWY0aslCFqJm+mC36K5eIz69Vomvj0KljZXjz8nuVztRcy+zf3RLRvOC3gb57f
         4iuz8jMwU23QciGptZ0caSaudZhNhwIkMqXncDvZKenpFAKUzI74vwU4cAsJDXDVrIMm
         4TAA==
X-Forwarded-Encrypted: i=1; AL+hErFlrhDHA1XPE4xiyzU+BP8Ilgt/HFRnCNYFItw1rdNM4/LNKBXBiiC23hHknACNuR8lyYCe+VV6@vger.kernel.org
X-Gm-Message-State: APuU4Z8L69UM8VZyXoOGkrlMHz9zT2KmYCn6qO7wBiKA0h7Il1Er4uNS
	dTRVCxGG94dcVXOD1tegWjvM8EVVxuDr/YrNA4dxDltc1T97kG92Zoy/
X-Gm-Gg: AYBFou0zdWTRNuHfzH9SFd52UOxYSNXDV1DvcKTm6zuP8XEV2eAatT84XyUWJS+j+0n
	+vqU1z2ak38csZ9m7lH6GHlQ1hNzDd8gOqrtLlD33zp4Wi2HfCFNuPACgFRmbQtbvXFfBX2mJx/
	ZPM2EUbKjtNdjvC8VmQVvfk6YvyuyJliZL5kyrabci5DnGnk2lxsCkVoYWflMR1BORuw4yOWFC6
	/kAsKX6POdjHkecQpi+lwFL11MDXSqHdfUp427DruTRVyCH2yhzGKRJD23l8ADAB6UAffacZpwW
	oFmZS9Kd7Hf++hkkl+7JFYP84W8lznWlV9uBW4r1lwT7JO2NaHwTQZPerINF5f6hINskHeomfsW
	nCjPiqgRJwrA23JNL1+mPn5G1QE/m0gJH+vpm6C0ek9wg1ZyQhHnGNzeCONW8XiAm+xGtzvt6Mr
	tkPZmURe9QdowQ9h2NRX54LS6GxMxMQEy0n+GEqGm+Wsz96aq7rPWE2v/WOVaeTiSsifdt/H7Xk
	NhA4cJT4NpSW43K+Pv8DYqdq/1W6fk5l14H7i5nNllMdHQjuDGqRDHKuNfAC5o55pZ99/IbZnQD
	svXqOPz2NDYpyDMD9fEjw3U7sKStyiQaIW8C2vsJ4Mw6b+syvD2dOYNYVnNRVlIOGSiQjQ==
X-Received: by 2002:a17:90b:3f46:b0:3b1:8301:95c0 with SMTP id 98e67ed59e1d1-3b1b0b95db4mr2905351a91.61.1794603746615;
        Fri, 13 Nov 2026 13:02:26 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec66f4csm6066122a91.14.2026.11.13.13.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 13:02:24 -0800 (PST)
Date: Sat, 14 Nov 2026 05:02:11 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org, kasong@tencent.com
Cc: "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v4 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
Message-ID: <avd5bI-b9y1nKWw5@KASONG-MC4>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>

On Fri, Oct 16, 2026 at 02:15:49AM +0800, Kairui Song via B4 Relay wrote:
> Hi all, this cover letter is going to be very long, as it includes a
> systematic test and analysis. And moving this series out of RFC phase
> as almost all readings are positive, tested on at least five different
> platforms (desktop, large server, Android, x86_64 and arm64 boxes)
> covering typical benchmarks, database, real applications, and has
> good test reports from other individual testers. It's also pretty clear
> about the next steps, and this blocks or breaks nothing AFAIK, which
> should be a pure gain, improving the performance or reducing IO of many
> workloads by ~10-40%.

A little update on the testing result: I've been running a week-long,
four-arm test matrix on this, and the tests took 2 weeks to finish
because it's a very large matrix based on this V4, on top of the
partial reversion of 6cbdd9726fb5:

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b3d85fe91385..d39061238fab 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -337,7 +337,7 @@ static inline unsigned long
lru_gen_folio_seq(const struct lruvec *lruvec,
                  (folio_test_dirty(folio) || folio_test_writeback(folio))))
                gen = MIN_NR_GENS;
        else
-               gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+               gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_lru_refs(folio) > 1);

        return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }

diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..a2600d1b6d6c 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -317,15 +317,14 @@ static void lru_gen_refault(struct folio *folio,
void *shadow)
        refs = (token & (BIT(LRU_REFS_WIDTH) - 1)) + 1;
        tier = lru_tier_from_refs(refs, workingset);

+       if (lru_gen_in_fault()) {
+               mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+               folio_set_active(folio);
+       }
+
        atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);

        if (workingset) {
-               /*
-                * see folio_add_lru(), where folio_set_active() is
-                * called for workingset folios
-                */
-               if (lru_gen_in_fault())
-                       mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);


The four arms are:
- ORIG:  mm-unstable 2 weeks ago 
- FIXED: mm-unstable 2 weeks ago with the fix above 
- FG: MGLRU-FG on top of FIXED
- RD: Refault distance on top of FG 
  - The refault distance algorithm is from:
  - https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/
  - The refault distance part is still being tweaked frequently, so RD
    results are just for reference.

I didn't include CLRU this time or it will be too long, all tests are done
for 12 interleave boots, could be noise but given the size of the matrix I
think it's quite reliable.

Test spec:
Zipf is widely used here, as it is commonly recognized as a good way
to represent different kinds of workloads covering server, desktop
interacrtive workloads, CDN, router, etc, depending on the theta
factor and memory limit size:

None of the test involves MADV_FREE / MADV_COLD, MADV_RANDOM is also bypassed.

### fio
# Test is done with a NVME drive, memory limitation using memcg, THP off,
# swap off. 40 GiB working set (16 × 2560 MiB files) Common cmdline part:

numactl --membind=0 --cpunodebind=0 \
fio --name=fg --numjobs=16 --nrfiles=1 \
    --filename_format=/var/lib/kmultibench/realdk.$jobnum.img \
    --size=2560M --rw=randread --bs=4k --time_based \
    --random_distribution=zipf:${θ} \
    --ramp_time=120s --runtime=600s --group_reporting

# fio fd reading:
--buffered=1 --ioengine=sync

# fio mmap reading (bypassing MADV_RANDOM at the moment):
--ioengine=mmap --fadvise_hint=0

### YCSB
# MongoDB 7 container, --network host, --memory 12G --memory-swap 12G (no swap),
# workload {a,b,c}, mem 12G, threads 16, iops limited to 5000.
# Also wiredTigerCacheSizeGB 0.25  (forces the hot set into the OS page cache)

# LOAD (untimed): 18,000,000 records x 10 fields x 100 B ~= 18 GB
ycsb load mongodb -s -p mongodb.url=mongodb://localhost:27017/ycsb \
   -p recordcount=18000000 -p fieldcount=10 -p fieldlength=100 \
   -threads 16 -P workloads/workloada

# RUN (timed): 100% zipfian read, 27,000,000 ops (1.5 x recordcount), 16 threads
ycsb run mongodb -s -p mongodb.url=mongodb://localhost:27017/ycsb \
   -p recordcount=18000000 -p fieldcount=10 -p fieldlength=100 -threads 16 \
   -p requestdistribution=zipfian -p readproportion=1 -p updateproportion=0 \
   -P workloads/workloada -p operationcount=27000000 -t

And the results are:

fio FD READ: Avg IOPS (higher is better)
  memcg/θ         ORIG |       FIXED (vs ORIG) |          FG (vs ORIG) |          RD (vs ORIG) |
-----------------------------------------------------------------------------------------
  16G/1.4    13,993,868|  14,153,014 (  +1.1%) |  14,619,834 (  +4.5%) |  14,492,871 (  +3.6%) |
  16G/1.2     4,557,469|   4,564,882 (  +0.2%) |   5,188,226 ( +13.8%) |   5,066,064 ( +11.2%) |
  16G/1.1     2,167,267|   2,158,549 (  -0.4%) |   2,453,911 ( +13.2%) |   2,417,420 ( +11.5%) |
  16G/0.9       610,129|     617,994 (  +1.3%) |     718,869 ( +17.8%) |     708,871 ( +16.2%) |
  16G/0.8       401,362|     406,178 (  +1.2%) |     465,164 ( +15.9%) |     454,454 ( +13.2%) |

fio FD READ: refault per read (lower is better)
  memcg/θ         ORIG |       FIXED (vs ORIG) |          FG (vs ORIG) |          RD (vs ORIG) |
-----------------------------------------------------------------------------------------
  16G/1.4       0.00182|     0.00169 (  -7.0%) |     0.00131 ( -28.1%) |     0.00135 ( -25.7%) |
  16G/1.2       0.01557|     0.01551 (  -0.4%) |     0.01323 ( -15.0%) |     0.01342 ( -13.8%) |
  16G/1.1       0.03785|     0.03782 (  -0.1%) |     0.03261 ( -13.8%) |     0.03313 ( -12.5%) |
  16G/0.9       0.13992|     0.13978 (  -0.1%) |     0.12301 ( -12.1%) |     0.12495 ( -10.7%) |
  16G/0.8       0.21259|     0.21256 (  -0.0%) |     0.18853 ( -11.3%) |     0.19146 (  -9.9%) |

fio MMAP: Avg IOPS (higher is better)
  memcg/θ         ORIG |       FIXED (vs ORIG) |          FG (vs ORIG) |          RD (vs ORIG) |
-----------------------------------------------------------------------------------------
  16G/1.4    20,670,288|  18,601,708 ( -10.0%) |  21,428,715 (  +3.7%) |  21,604,461 (  +4.5%) |
  16G/1.2     4,739,384|   4,959,906 (  +4.7%) |   5,126,105 (  +8.2%) |   5,270,792 ( +11.2%) |
  16G/1.1     2,145,716|   2,422,244 ( +12.9%) |   2,560,802 ( +19.3%)*|   3,554,448 ( +65.7%)*|
  16G/0.9     3,887,814|   4,259,544 (  +9.6%) |   4,372,044 ( +12.5%) |   4,431,153 ( +14.0%) |
  16G/0.8     3,566,541|   3,907,269 (  +9.6%) |   4,085,982 ( +14.6%) |   4,040,826 ( +13.3%) |
   8G/1.4    13,471,704|  14,102,398 (  +4.7%) |  14,524,256 (  +7.8%) |  15,528,982 ( +15.3%) |
   4G/1.4     9,222,754|   9,540,640 (  +3.4%) |   9,973,791 (  +8.1%) |  11,066,377 ( +20.0%) |
  12G/1.2     3,565,213|   3,593,112 (  +0.8%) |   3,826,527 (  +7.3%) |   4,019,067 ( +12.7%) |
   8G/1.2     2,504,381|   2,649,853 (  +5.8%) |   2,776,443 ( +10.9%) |   2,990,251 ( +19.4%) |
   4G/1.2     1,676,208|   1,728,339 (  +3.1%) |   1,825,272 (  +8.9%) |   2,064,706 ( +23.2%) |
  12G/1.1     1,592,245|   1,579,824 (  -0.8%) |   1,726,557 (  +8.4%) |   1,775,451 ( +11.5%) |
   8G/1.1     1,117,784|   1,169,936 (  +4.7%) |   1,229,181 ( +10.0%) |   1,325,119 ( +18.5%) |
   6G/1.1       939,984|     980,984 (  +4.4%) |     996,724 (  +6.0%) |   1,134,737 ( +20.7%) |

fio MMAP: refault per read (lower is better)
  memcg/θ         ORIG |       FIXED (vs ORIG) |          FG (vs ORIG) |          RD (vs ORIG) |
-----------------------------------------------------------------------------------------
  16G/1.4       0.00202|     0.00317 ( +57.0%) |     0.00187 (  -7.7%) |     0.00179 ( -11.3%) |
  16G/1.2       0.01671|     0.01550 (  -7.2%) |     0.01529 (  -8.5%) |     0.01462 ( -12.5%) |
  16G/1.1       0.03965|     0.03394 ( -14.4%) |     0.03318 ( -16.3%)*|     0.02312 ( -41.7%)*|
  16G/0.9       0.01982|     0.01791 (  -9.6%) |     0.01771 ( -10.6%) |     0.01735 ( -12.4%) |
  16G/0.8       0.02149|     0.01957 (  -8.9%) |     0.01889 ( -12.1%) |     0.01923 ( -10.5%) |
   8G/1.4       0.00446|     0.00408 (  -8.5%) |     0.00394 ( -11.7%) |     0.00359 ( -19.4%) |
   4G/1.4       0.00745|     0.00700 (  -6.1%) |     0.00668 ( -10.3%) |     0.00583 ( -21.7%) |
  12G/1.2       0.02338|     0.02252 (  -3.7%) |     0.02131 (  -8.8%) |     0.02016 ( -13.8%) |
   8G/1.2       0.03311|     0.03076 (  -7.1%) |     0.02984 (  -9.9%) |     0.02766 ( -16.5%) |
   4G/1.2       0.05043|     0.04746 (  -5.9%) |     0.04574 (  -9.3%) |     0.04071 ( -19.3%) |
  12G/1.1       0.05536|     0.05371 (  -3.0%) |     0.05099 (  -7.9%) |     0.04847 ( -12.4%) |
   8G/1.1       0.07682|     0.07110 (  -7.4%) |     0.06966 (  -9.3%) |     0.06507 ( -15.3%) |
   6G/1.1       0.09150|     0.08489 (  -7.2%) |     0.08313 (  -9.1%) |     0.07650 ( -16.4%) |

YCSB: throughput ops/sec (higher is better), n=3
  workload         ORIG |       FIXED (vs ORIG) |          FG (vs ORIG) |          RD (vs ORIG) |
----------------------------------------------------------------------------------------
 workloada        14,657|      14,284 (  -2.5%) |      16,788 ( +14.5%) |      17,836 ( +21.7%) |
 workloadb        14,309|      14,304 (  -0.0%) |      16,504 ( +15.3%) |      17,957 ( +25.5%) |
 workloadc        14,458|      13,777 (  -4.7%) |      16,806 ( +16.2%) |      17,868 ( +23.6%) |

YCSB READ p99 latency (lower is better):
  workload         ORIG |       FIXED (vs ORIG) |          FG (vs ORIG) |          RD (vs ORIG) |
----------------------------------------------------------------------------------------
    10-wla       61535.0|     65375.0 (  +6.2%) |      3474.3 ( -94.4%) |      2888.3 ( -95.3%) |
    20-wlb       65641.7|     64265.7 (  -2.1%) |      3901.0 ( -94.1%) |      2757.0 ( -95.8%) |
    30-wlc       63348.3|     71188.3 ( +12.4%) |      3251.0 ( -94.9%) |      2724.3 ( -95.7%) |

So in conclusion:

1. The FIXED is helpful for the MMAP read by ~5-10%, harmless in most
cases and with certain regressions in one or two cases, it may
correspond to the LevelDB regression I described a while ago:
https://lore.kernel.org/linux-mm/CAMgjq7AtuK22FsuqvGRLVZ2eWrp-N4qQ_MHoXsXDkVBprekdDA@mail.gmail.com/
Which I think it's fine to have as the previous change that FIXED is
trying to patch is causing other DB regression too.

2. MGLRU-FG is suitable across all cases covered above and
outperformance everything we have in upstream so far by ~9-20% in
these generic tests, and a huge improvement for lower latency (-90%).

3. Refault Distance will greatly help with cases where working set
sits at the cgroup boundary on top of FG, offering up ~65% vs ORIG
(~38% over FG) performance gain for certain cases. I think Refault
distance will also cover the workingset shift case, with a slight
regression for buffered read which could be the counter update
overhead, I will explore that further after FG.

Posting these here so I can reference them later and try make the test
result less bloated for later versions, and will be rebasing for V5
soon, maybe with a shorter test process.
