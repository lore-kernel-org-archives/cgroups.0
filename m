Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659857;
	b=rrJDoBCeN2MlnMSNRgbHZ4Y3RwIIK/MCd8vsx2RC7exx+g92fZ5USBpo27f/bGFTnTfz
	 LG9phD4FGifaEcLEUQU7ShoK14EKH4BI2kXqS4+43AvlA5td9Ey6abZAf0ImUTwqAOFna
	 ISkLoTNDQPFMBnSYusn3d7SZPyJPXuT2aff36aQl/U7OPMM603+QmXJRzXuQgCOeHfk2/
	 9dGowRmJHV6UtDMFA/V+98BSWubVp1KKaoxcm3m1w2Y543YP/2srzrAIYOt6mzPurAGxb
	 qEvDbfGizg0ZLYLfzvOptOfbC6p+egOjs7I1J1q73QerS/3Ahvs5ijgWiG5r/xQFiFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659857;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JZOd5uUgyv72utWzP1shduuWDKjucDdTZdv55Qn50b8=;
	b=L8TrMqwVkK3wiVIhDK57HC48Ve7mY8PYWcYnmwMiCF86TyOAyRxeRtDaUvUlMsJlLYE7
	 7KrnFYtj3N87HaZttBu7psEyCDhvzYuDS4Flos1GhhRucn3ZlRenkp2wj3pFptzgnvsFZ
	 KIwabkROZjUbXGNQ0BfumFJiqxNH1e9xNtq1aMRVq82e2+8Na5ZMMmD7jvQNh/0iSB4K1
	 pOspWJgpaW6eL9paP7tMbMrbiQjbCIq1ioxGbBVy0qPuw9P92Mby7aOdg4fCWkNBHUJck
	 MndkV3ITmyJvMQLiEMSu01vDAtrBXdk/TTlSXxjybGcKsWr3nsEv/dMMQjOEtQozX3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ifZkED0w;
	arc=none smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25550606A324
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 22:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25550606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ifZkED0w
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8ad98c3fb15so30277167b3.2
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 14:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659856; x=1794264656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZOd5uUgyv72utWzP1shduuWDKjucDdTZdv55Qn50b8=;
        b=ifZkED0wdBxJMSWC6bkffyMZJEB1FS4T4rEYTPJey0r+0ZmRi/Qssx919bpr2m8eDu
         mY2qFdqP3b2pPvXRfY/LFAs02hs0jkmGeBydhijglqcLKg+9tFJVr9kCAX7Dod83xf6g
         16uugzggB4KGI5ccijwBHOj6fmSaGs7tNw2TTe5JHi7LzX+TS4rO5lnQREjASCujqkXd
         QRrwGODuC1R5j0tPSCWWRod+/lztUyUzSKkHe+DGgqrmJ1aII21ufAzUwwWxRtCVYgpc
         o9PbxReb1YcnlclHdS0IRxj47/mjjRxbF/eVItSnsR1Yw8mIypl78zsQf4pBaVoHTjZ/
         4QAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659856; x=1794264656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JZOd5uUgyv72utWzP1shduuWDKjucDdTZdv55Qn50b8=;
        b=wfymbxl/4M4ucz1umlfCJR3Jz15vfn8vY5/Zhu+b68qeP4cMb1OWC4EdCnUUWwxZGb
         BmHYcVZEG1lzwMI+AF7sw6fpXjQEK8sRzFKcwR47QeFcyAubXewsvXfs3xzUy3tMiFf/
         kI1OzNqzLo08oO0g+o9Mag6XZH1HKzvXmtjE6FBEi1vYTm9lopPDxONmyGGFcOQol0OP
         rHvTupFlzo9wPbSgxJwPurZeFryQr8Qm7/3z5ZFjfcxdm8tib693fGr8XQc6ne9JcfUz
         hLsdj2wvU7s6bYSqZ6MUhujtbQNXxU7yTUqdbWpXx0JXmEIwfc7epU+nzAba+cdyHPF9
         ksxA==
X-Forwarded-Encrypted: i=1; AKwUvBzyiROsEu+tltpE43qiJJhlwmcgRub24R8beCRz34cst8Iip17bgBv7xNDzdXguukj/dYM5/nTh@vger.kernel.org
X-Gm-Message-State: APuU4Z+Hd93gM6pD28CnjnlYIT/zyPqXXK9sa1BfI8OxbGV5loBUV1hR
	HfKGSg7VrjFeLdRTshkGWlBc1JyY3uim8BURDp3hl3LDnpV/21qFecdD
X-Gm-Gg: AYBFou1v6fFnvOGjrndZiv6e39266YrjN0ZwWBD4OsCY0gB9Ptflh4wSTVNiX8h1fq7
	lZC1AfWnXzkgDgzaVqxMolOCQWQPOoQw2TVLaqGKlieJP5WxJl9EyMmovaRlI/PVOBMHcJr7fRn
	ucnMxnM8TvFKfpTUL8nAqX5fS5JbRAWqyhyEGoeQeHIsb0W9TduG6/H3Npy9DP6iGR/SyLnkJMN
	xYuByn6xY34qszOzN6ppFvU5SL4N481hAckE5D5YwB0u2mlL9cxBOd+9KOTtXXkBkT63zRYEK+p
	z1BsKbHjSsxop0VM/TgjCDhAy7K+Ky3Pb1+KYXwfOXpsTyk88piNV8NBzje0ZRXrg7niEmZGVcr
	mpykf52MX8H7CoxPxKk8apPA/DFEqgzsG8JrGtPiTu/Qz8O/5hnRCrxh4Yd0KNwmcn1gZuadjJK
	RT1XknPJ0LX1slAbGk1oWPySGGuZa3XvjDPh7BH3QLo3gsPZ5lN2tQaA+b83iWV/V6tAYjQfrRE
	uHxHxIkgdRYZcBiFkvCCdYlqwm0VC+fnDcwJTBz0WxVrvnTCvukyFgN913bRy8l7VvejRe0EpjU
	sxwZRyDSj2+zcOxD9tJTKTVjUr21Y+xTkKxYZtaNFOafp2yaYHeBktzihS1vKk+RjWsCDPed+UX
	rpM0in5pdqRvGEBLx3PEVyU0ec0Lt
X-Received: by 2002:a05:690c:397:b0:8b0:9e81:8ba6 with SMTP id 00721157ae682-8b2b67967afmr88183357b3.44.1793659856054;
        Mon, 02 Nov 2026 14:50:56 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b704dab5sm61260967b3.1.2026.11.02.14.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:50:55 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v1 0/3] mm: read root memcg stats from global counters instead of flushing
Date: Mon,  2 Nov 2026 14:50:27 -0800
Message-ID: <20261102225030.2743129-1-joannelkoong@gmail.com>
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

Reclaim, refault detection, the zswap shrinker, and DAMON quota goals all
flush the memcg rstat stats before reading them. When the target is the
root memcg (eg global reclaim), that flushes every cgroup in the system.
Most of these flushes are ratelimited today, but the stats they read can
be stale for seconds.

For the root memcg, the call sites can just directly read global counters
instead of going through rstat. Global counters are always up to date and
don't need flushing. For stats that only track memory charged to a memcg
(LRU sizes, workingset, rotation, and reclaim writeback counts), the root
memcg's hierarchical value equals the node counter.

Patch 1 is a zswap fix for the shrinker's count for the root memcg and
can be applied independently of the rest. It doesn't have the stable
tag, since the zswap shrinker is opt-in and the fix can change writeback
behavior.

Patch 2 adds lruvec_lru_page_state(), which reads the node counters for
the root memcg, and uses it in reclaim and workingset_test_recent().
workingset_test_recent() can then skip its flush when the eviction memcg
is the root memcg. Reclaim keeps its flush for now, since global and
root reclaim also read the stats of the child memcgs they scan.

Patch 3 does the same for DAMON's node_memcg_used_bp and
node_memcg_free_bp quota goals, whose flush is not ratelimited.

Three root flushes remain. Reclaim also reads the stats of the child
memcgs it scans, and count_shadow_nodes() and filemap_cachestat() need
the root memcg's own (local) stats or the stats of arbitrary memcgs,
which means global counters can't be used as a substitute there. This
will be addressed in a subsequent patchset, as well as getting rid of
ratelimiting for most call sites.

On an 80-CPU machine running proactive reclaim on the root cgroup, a
root flush took 69us on average with little cgroup activity and ~0.9ms
with 128 memcgs repeatedly allocating and freeing memory (wall time,
including waiting for the rstat lock). Reading a node counter doesn't
add any cost. It took the same amount of time as reading the rstat
counter (~150ns, which includes bpftrace probe overhead).

For more context on the background of this series, please see the
discussion about memcg stats flushing in [1].

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com/

Joanne Koong (3):
  mm: zswap: fix shrinker count for the root memcg
  mm: memcg: read root lruvec LRU stats from the node counters
  mm/damon/core: use node counters instead of flushing the root memcg

 include/linux/memcontrol.h | 16 ++++++++++++++
 mm/damon/core.c            | 15 ++++++++-----
 mm/memcontrol.c            | 44 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                | 36 +++++++++++++++----------------
 mm/workingset.c            | 19 +++++++++-------
 mm/zswap.c                 |  7 ++++--
 6 files changed, 104 insertions(+), 33 deletions(-)


base-commit: 0e02eb17f263e4a3ae6bf1fe45122c23361f0cf7
-- 
2.52.0

