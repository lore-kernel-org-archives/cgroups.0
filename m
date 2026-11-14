Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616194;
	b=jecI+PiAsFOyVXcW9HX3U/SYKZnmf+it82WBckEhqhjkI2QL57eM+USn4SYXp9uHck1I
	 fs23iZIL5v//+oXOE9eBHwSVxSQzymyCY1iyZH6fUuePe/oRO9PU8Z4ZNXdw5XPGr7OI5
	 d9KnpSRvMlAaQmr6Ix036CD9KRtUi96r3M7OHeoCv7Ym2iT72YKmaiCizxXy88R39ENf2
	 rAvEMMUIETMzjPWe5l4xIuYTK0AavIwzDxoWuG3OAn6Z3Ygi6xuHGJhl3gFBZdggkUvZj
	 e+o1GjyljXk/n9SW/36omtBJISyvIh5+zoXoq9X6D5nf3hpQdjTKwk124oTFHFOoucw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Iq2xOf7brzRimqeh3kCSIQaM8aaawwKdufuiU04kk44=;
	b=PcfaZLcIzGfqd0/Bb6uPEYko6boWtBDaULDU76YcQ+y+2enNrbxPsykxJnoDFREQjRhp
	 AxevNBlIT11RZ50Qjibat7HHWy8q/AN5DmszxwsZ0+1H6jSVjHG6N+BonGcXW3Z44AL86
	 /jLbkauKfiMjHG6j5KF7El1pXjWQjDGLMymbnHN1LgNBhSX8gCt15qMFbTsNE632gRjEZ
	 Wf/hOGt7uFH0Si77ELGFnan7YlKr2TlQWZMzUjL/AYPcb3tojAnHSfLkChwELp8tON5QB
	 nSYBU3Z8rTLQvryus/22U1SHKkz2oReQv7i9DbRlWEfkp0QqKTJO1CWWBbc296TJUyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XEz+9EvY;
	arc=none smtp.remote-ip=74.125.224.53
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F2606A330
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 00:29:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA6F2606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XEz+9EvY
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-67c58f18765so1293389d50.1
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 16:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616192; x=1795220992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Iq2xOf7brzRimqeh3kCSIQaM8aaawwKdufuiU04kk44=;
        b=XEz+9EvYjWENHP1gt0Iu3vfv0jOEaMjs6Qj/HLCbgFzcXSt3/g+iJSgKKmYw3xSyjr
         24eZWBWSxKUS5WqorJKGiPGiGjLAhqD7A7BbEzAwN4wEQzzkUuJeIiPDKSP2p2vu7jIM
         jaK8yaiTA0Zd9wGxYf2K87DaneOT2+W6ZTEpVq1xctX/g3+hSV8O9k35OM+CCUy2BMcW
         70ecJtQZ45IIs8t/DVwo9FQrpnfDCitU5la8MsBtoZN2MqgA3DDnbg8QKy85qxoomwzE
         IFCRxqrB9yWMT17W1nQV6PeGL7gdTOgvqMFkFgpLUeMZqd5u4ArP0vTUOVS7xfkh9jqk
         6rMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616192; x=1795220992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iq2xOf7brzRimqeh3kCSIQaM8aaawwKdufuiU04kk44=;
        b=AC1JX1G7/v8IW5skUMWEA5mig/zfeU4HpzlZMJPnBfM2vGkKXMO2BkvIjALv0mYuI0
         eymW4N8Fm88MjQJISRWUfJotXxrqIj5JDwGcpqj1LUymb5HNUGFhEA2iXGzX4Vtv9e1J
         jt7k7fSpF/rIkjGhzcfguLDAoIoe4ZOa2q4UDtqOp+PB+EtVUeJB7rVlE+gma8h290lD
         giofDfb5CJMbjhX5cnqbEelb2a49f+siA3s0wOwtLQ1bvfoEJ3cFc4HXO43GSDED0Gn+
         4nLNa+Itfe7FcCzaGKYjN2vRKBiyZoNRmU5dfYCDwat0prgtLegDVTAlxuoJp+pAlli7
         o/Aw==
X-Forwarded-Encrypted: i=1; AL+hErG8WogPkoFoqJMyEM+7pC8wWXA4hSjaNU+mdh0fP4IklfR4I/UxiVQkWcZ8hnoYxdi7FwlkRqX2@vger.kernel.org
X-Gm-Message-State: APuU4Z+hqnFGtvfpNRru3h6vuvbvherZObaKIjLpU6JAcOdjANLkoNIe
	sMNeMojk5VcpOrB+TQsSDeGwe1v9hz9n+RRpMwTdatKRXBi5+dCb4T34
X-Gm-Gg: AYBFou3qDxf6qaDFNb+bNOnaXAbZ5PMtNNLlivU+rVMFvTvn1/I78mC4Ng+R4uDlewb
	8taRDgRWRatZrMHMVuBtEM09OzDmm0VV1NtwuDTFtqs77lRmKLDkLgsE0ppqji9c0nIJ0mlwl96
	ijgWTE8J4Ozf7NytyQmbNhKi+gFgCUbWh46NzFChDJGu2CoE9TXa7+qarOptwE0PicJkPtfFmDs
	cj/PSy4rzph37ILeW40MSR+ee6X1S46w7ZBQkf+MImHFxLGLdoYqAFTaAjq3iq/Je3ZRpq3zoko
	6bZO+c8s63sOoxNl/vftiKjuDfs20Wy/p5qM5UCnYVT1XerrvqJKfy9wBbZeKbX7xuBXNfZLqlT
	/1q0GIJbHOjOyMce08Cub2bPwSzPyO0L3sYchTSRzbfAObK+PC7Cyv0uESj8Zhpf5y21GGOzEei
	M5h98ebiRMcAc2uAQXGOqSjmDqLGDw+XrRcb/sv3fet6u/UfvAbYL4V7/yifmWBLiYjTd+xmBG7
	6ySRrONDy5VnW90tsSdxDVyYTPbiXKy2DUAR/q3RWc42bUJoR17+q6WrJvxns0HuWDhgUrhvsul
	DK8ca8ue4HmfdKjeJaUSx4sOT8/5FuvbFY2dI06M/xaZGRxORpfVFWBnmrIO8pOydJmRKKNti0f
	m2+h0nxRvoLcdJFTQbT4wU21I4Yw=
X-Received: by 2002:a05:690e:b83:b0:67d:9d2b:91b7 with SMTP id 956f58d0204a3-67d9d2beba2mr161001d50.93.1794616192402;
        Fri, 13 Nov 2026 16:29:52 -0800 (PST)
Received: from localhost ([2a03:2880:ff:59::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a59f1afsm3447586d50.9.2026.11.13.16.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:29:51 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 0/4] mm: read root memcg stats from global counters instead of flushing
Date: Fri, 13 Nov 2026 16:28:18 -0800
Message-ID: <20261114002822.1043378-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
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
root memcg (eg global reclaim), that flushes every cgroup in the system,
which is expensive. Most of these flushes are ratelimited today, but the
stats they read can be stale for seconds.

For the root memcg, the call sites can read global counters directly
instead of going through rstat. Global counters are always up to date
and don't need flushing. For stats that only track memory charged to a
memcg (eg LRU sizes, workingset, rotation, and reclaim writeback
counts), the root memcg's hierarchical value equals the node counter.

Of the excluded stats, kernel stack, secondary page tables and
WORKINGSET_NODERECLAIM only differ from the node counters because
accounted kernel memory allocated by tasks in the root cgroup isn't
charged to the root memcg. If the root memcg's stats should include that
memory, then those could read the node counters as well. This is left
for a separate subsequent patchset though since that changes what the
root memcg reports and needs more upstream consensus.

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
add any cost: it took the same amount of time as reading the rstat
counter (~150ns, which includes bpftrace probe overhead).

For more context on the background of this series, please see the
discussion about memcg stats flushing in [1].

Changelog
---------
Changes since v2 [3]:
- Change from denylist (patch 2) to allowlist (Sashiko, me, Michal)
- Add SJ's reviewed-by from v1 for the damon patch, which I forgot to add to
  v2

Changes since v1 [2]:
- Read the node counters for the root memcg by default in
  lruvec_page_state()/lruvec_page_state_monotonic(), with explicit
  exclusions, instead of adding lruvec_lru_page_state() helpers that
  callers opt in to (Yosry). As a result, the root memcg's memory.numa_stat
  now also reports the node counters for the non-excluded stats
- Split the workingset_test_recent() flush skip out into its own patch
  (patch 3)
- The DAMON patch (now patch 4) only skips the flush, as
  lruvec_page_state() reads the node counters for the root memcg
- Rebased onto current mm-new

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20261102225030.2743129-1-joannelkoong@gmail.com/
[3] https://lore.kernel.org/linux-mm/20261110015321.611093-1-joannelkoong@gmail.com/

Joanne Koong (4):
  mm: zswap: fix shrinker count for the root memcg
  mm: memcg: read root lruvec stats from the node counters
  mm: workingset: skip the root memcg flush in workingset_test_recent()
  mm/damon/core: use node counters instead of flushing the root memcg

 mm/damon/core.c |  7 +++++-
 mm/memcontrol.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++--
 mm/workingset.c |  5 ++++-
 mm/zswap.c      |  7 ++++--
 4 files changed, 71 insertions(+), 6 deletions(-)


base-commit: 31a696f9c37defab0f28f774e00ac7f135889ec3
-- 
2.52.1

