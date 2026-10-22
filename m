Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792708793;
	b=g986e7lZuRx4/stTBJw4vFZTVNNvm/v2Lg/PIAPH20igJo0N+KDD8ZIFtt6TPez7HwHC
	 I5LXKEaZQYZbOlY9fOQLmSE+AP79JEIKHwcjiKubp6At6sJ/KKLcetsUTcLOJbVMObVNq
	 kaBQp+d1XMOT//fLehJQU/uoXF2wQ+1U652DzCTtgbKQVm4uiM2LaCpYaQ2SLTsF5Oo8l
	 bP2inrX6wATOZbdG2lSyhX1asw+oMd1h5GTpUjLTjtNoLqsdh/nNhZp7UVtmJbTDobIZJ
	 bJdsmFWAir5Fi7embaKJq5vzc2srBEB/24flffX279m59MbW/tPuuHLFKTmmyYEAYJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792708793;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JtKxQk17mKJ5H+rcmhYc0xGV7tRV/52vlvUl23dtKyE=;
	b=W+VJrycr1cRV5Photkhp3fRz2ljXSxKhwbspt7f4c1YM6tARwjGq/S+sjZHBF2K5WMEq
	 haL5DWFw1PaPP9Ake1qVHC+FMNTcC4Ohq946S605zsSDuS4pMwccXOPcgTx6tvIklnelr
	 8HycVlQ1q3JNQhsslgq7hy6OXW9mvkLDkK2nE++yFPd9inNRhYLLNX8wyFFCK64A+g/x1
	 ZyP/LBt+B976MJYou40Me6khDWO1CIbEguzseb9tjQZOnAxFbBz+ZcdJx1V3TAZrepqFL
	 MxPWxdiRGungstyxZcOldzCQXaCMSL2ePE6Uc3tHk/NAmUaV1QPJwuhP0FnIo/mvp3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bgMVp+0s;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0208606A319
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 22:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0208606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bgMVp+0s
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8ab395abf79so3781217b3.0
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 15:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792708792; x=1793313592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JtKxQk17mKJ5H+rcmhYc0xGV7tRV/52vlvUl23dtKyE=;
        b=bgMVp+0sudcJ8dXgkYK4tKQatlgpk5wPpV4vQGqjQKWuQtj7QHGPvIWPG57+LjO6iH
         0NR4nsOPOyp7vCmV3hluG3FjJfYHWZkyGRLqcHb6kwIH6vlJ2Uquovw7MTliBkMnVPxl
         MHORi95m5WkNQ40ivGxJ7Bpkr7cNYXgntcusWCHu1899VjnkFLnIDyhmEC9k2Er9xUka
         +6u4AZGabnqfLBwObJSJ9iKpwSDAbwzrI35xbn4eTO8YSV0imdFjiwtR9y/CYgVkKu+l
         0/adTPtPz7rzvuzHC1qeyUO94PwHmh1TUbslb6JUaZkGv9yiBYe6u5TUBl5yNb82rb0P
         XHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792708792; x=1793313592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtKxQk17mKJ5H+rcmhYc0xGV7tRV/52vlvUl23dtKyE=;
        b=VOQgJsx5DGpQPixhcENVleWIFI2tcBHplXgKjCv7+ZqviB7VXupG83vf/UZGNO9VuC
         +WfTYUxpsJhT/k7vQlLew0g4kPYIj4YMHdlKPm+rUsxHoU+/UqCXoiPrmkpGijijhRKt
         OAzuPlmjhopWwQ8YhZ529i44So1rSGgN/e8XGU+SGFbzq0P9kvr13X2nmrKWiVfHKZ3f
         lv/1x5u8G7dVICdd04vScXNz8/fuSeBBMtKkFtin+OGT4d6pm7wuVbVeSz9pHaCiDzBT
         xiRqVgkqMw6hnz1M35CXued/m3jJRL+Z/EfzLGq8DvkP5s0tdA5dI40f+CWOKkQvzUnr
         IJOA==
X-Forwarded-Encrypted: i=1; AKwUvBwh9gOh3i77tDqXYWf/7dCVChf6EsxEnfuBoMmFDhE7WsWh0vpQOvq0ftgvelS8bszI0rtAZO+x@vger.kernel.org
X-Gm-Message-State: AFq9FYKX32qnmZPnd4EWfA/+mj7ns3p8cmCZbGv/aPqPEHIEIKLRxBUe
	jo5IA84PMn+kyCjf+FLMldo1rk5e7SOOW2ABeVJPeVOwnnUi7bmBsGgA
X-Gm-Gg: AYBFou13vCSV/yWOUttxJrZpqt9j3Y0ooao7QiScDmWNHCVPNF84dY/qplJBG7CohWX
	hnePsVlLDnbKEUenBwuuPhc4VmkJn/pWBbkJiQ8MuOUX6IRL36T5TJKE6KgE8pn3UZmStcF0Pxs
	+J3X+MmJnN9pt8Pvu8KDF/mHdfNIWkPKDt5oQGnod4N20ZixAiDpLqpfFGL+0lDHbmWWMTPsSID
	KJY5f0+vnLX6URx9AUOdw4rPwIfi7QVVHe8oCKGRCHSusI5LJ4Zi4o4MV+iwg4Xr2NtfV7ow2kw
	qzAmiYL+TtuLsCwmI2pmPLYNwfgykkE6W/pk7KXOxmPjNlGGAGZ5yGJGRvzwqsg9OfgC6N6rQzv
	riqyiJcY6NOoDsNydD249/Dphn9CtZdBKxrLSYEUGoXuhB62SV6Q0hSRYd/ApNSu2gL0meHcLgb
	uAdFaqszwGKRC+aC/dXQ3botaQQh+srKifS68JTfcC6uQbgEqbpuA0+VrTY2t80am33m/q4Sg9U
	JOyZ/tjhI0W4hBZGlJ9zHyPU1up9Y/Tj+m1bMPZfuWx1pMAm4T96//fh6KQa+4DIRqefpHJmm4G
	u5AS8hVfJxr9vtJ5r+1Bmr6V/E3/kqa8
X-Received: by 2002:a05:690c:c4e9:b0:8b0:6d14:23fe with SMTP id 00721157ae682-8b157ef7c05mr3917477b3.52.1792708791905;
        Thu, 22 Oct 2026 15:39:51 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b155f8af63sm5238657b3.2.2026.10.22.15.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:39:51 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] memcg: reduce cacheline contention from lruvec stat
Date: Thu, 22 Oct 2026 15:39:28 -0700
Message-ID: <20261022223930.138779-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
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

Memcg lruvec stat updates read fields of struct mem_cgroup_per_node and struct
lruvec that can share a 128-byte cacheline pair with lines the lru_lock holder
writes constantly (the LRU list heads, lru_lock or lru_zone_size[]), depending
on where struct mem_cgroup_per_node lands in its slab. On CPUs that do spatial
prefetching (eg Intel CPUs), this makes the stat updates contend with the
lru_lock holder.

Patch 1 rearranges struct mem_cgroup_per_node so that its read-mostly line is
paired with a cold line, and patch 2 makes the folio and kmem stat updates use
the memcg and node they already know instead of going through the lruvec,
whose pgdat field shares a cacheline pair with lru_lock or lru_zone_size[].

Results on a 2-socket Skylake (80 CPUs), average pages per second for
threads faulting in and freeing memory in a single memcg:

		   base     patch 1   patch 1+2 
shmem, 20 threads  4.74M    5.59M     5.77M
shmem, 80 threads  7.94M    8.66M     8.82M
anon,  20 threads  3.04M    3.08M     3.10M

Changelog
---------
v1: https://lore.kernel.org/linux-mm/20261020200730.250189-1-joannelkoong@gmail.com/
Changes from v1 -> v2:
- Replace the lruvec_stats_percpu pointers in struct mem_cgroup with a
  rearranged struct mem_cgroup_per_node layout (Shakeel)
- Move lruvec_stat_mod_folio()/mod_lruvec_kmem_state() change into its own
  patch (Shakeel)

Joanne Koong (2):
  memcg: reduce cacheline contention between lruvec stat updates and LRU
    lists
  memcg: don't go through the lruvec for folio and kmem lruvec stat
    updates

 include/linux/memcontrol.h | 22 ++++++------
 mm/memcontrol.c            | 71 ++++++++++++++++----------------------
 2 files changed, 40 insertions(+), 53 deletions(-)


base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.52.0

