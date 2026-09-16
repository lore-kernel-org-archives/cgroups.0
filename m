Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711254D9F7B
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 21:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789592772; cv=none; b=YvnH8aY8n+QvDuw3xMlnbyTwHyLP3UFphL38YCScJ7Bh50VvXGM40ohIf8zG1s39vaHnxoce+d6aOvq+CcPjghLgxqMeSHGy/98TgteauwfAOZTY9LsaRAWA2rv4tQZv2ir8G29wIO75tYLOFJIYgx1qmR/qXJaejoX2xW+5QmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789592772; c=relaxed/simple;
	bh=xGttaEBOYXq/iqaNTGWFvcGx3O5je5+0K7ORO3gzBII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SqgeNi8j8Bo5fIAudbdW8HCg6uX7UXJlGt/BLHfT3D7b7Y4bKKoOppXJK1OMBeEbOwfkQZ27mXpKUhZBdyrpwvkUP551mxOIDrQzTP+run1JWKD9LS5hLkuy0wRkhv35QrZKbnnAcUKq7FwTE8+7Y5B2VM8pRNCEpe5/V9QIEEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BzOE7xKy; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BzOE7xKy"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-80638c24bedso67048a34.0
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 14:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592755; x=1790197555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CrpLOTKNk/9YQapYhhYSJLfsas1NK9k/H2Cz4g1H2bU=;
        b=BzOE7xKy6CRBfAfLqiW5XlG4pu/517itqVIPBgz5hEVMzedN85aJn7vJZK7LJ1QGNM
         O2LslFVuvrRL8oaBxKnQJDSmBGQQXGT/1ewhcJPMLmaB5oNHZpKve0YGKnyNqFCMvDw1
         HQg0Ec1+X5EH2SQSfMuOjeN5rY8xrs+ht30GIdx7IR8t+nSzncDT4Jek1mW6thzDah+L
         7WzvRYEOBFNCiBHtg1ipYGKwOCPcecGmNp9jRBEsniz/vDFkoRFq9qvkXOAq+DDvcRFl
         GwcgGVJtqKDTwQj+432fzw+qg2F41EhpDmIv/lK5BejSaQ5A5Shy81D8Q+nBj9uJNVY5
         UUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592755; x=1790197555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CrpLOTKNk/9YQapYhhYSJLfsas1NK9k/H2Cz4g1H2bU=;
        b=jMQohcqkRQJ9P1GmweEqgNJK/n9Nl2m5DGw1gtImKAGksXH7rgHdzG/CwkthkYYCdn
         cxxBNtlVyWh1aDPPgkIGqj535zifHQX2YQ3/cAGXJUtkrZhDwHR4ZV9YH5K67OQ21n0U
         fbVz71pXV3Z1FJYa1hidi++ZYtOyAVQvbzZXr/3ZsSBxO7IAb4DPtoV7RkBqG8Z6CCVW
         /0ZEHrWa+R0BdGHcDkTh5K1GEl5zhyoB2q+z3NNInImICK7AZeoUtI6bgcZuST7KfsKN
         G9AprCRAKAM1BCNVz54DQklklbCaTvOc177+yTxI2n8jYQoe6aUo9Q40QERMhl/DFzaH
         Ja2A==
X-Forwarded-Encrypted: i=1; AKwUvBwfaM9/EwwxztA6c1/pJO1qzrb2wfJMkoxxUMuTA/nCQiPx/xLQVyGGNxcoxX3OvsD6EUKz3xrn@vger.kernel.org
X-Gm-Message-State: AFuF++nRZNP5roFZ4NFf5abmgUdTJLzigdX8s0ICZbJiKDgvfGJnmQRb
	UcL0+Qw7ryCb6NcJiHSn5DmkLMseXcYX22YweHB75viOGoW79/TMLsM2
X-Gm-Gg: AYBFou1K1L+HgQpxIF4NIV0XN7kkJSOI7vjEJZML1SDjNdTukF1g7LxUYcK4qXakoy5
	aZLGYjvRh9GQEJTbFSEQgYeO+DBCR/Kr2eDJ6FffesA8qZUgXK50/e7o5RoLwmLegUR/CzaPZC5
	y+S7raKFHXld6sKnyWURaFe91mZ79HwjgbpQjdLa6qo0xvNm2adrrZIvzAxDOYkCrPydl9RiZ0I
	zB9/Z5I+ACvNfNcGGYIbTMgyOYZu6Ju1ru8Fn98JEcJzSSReGveUxlajpfQFvjFbm9BR89FfeUw
	fXg8BYVQp2UYUUuShlW/8/EPqjpJI/b2B+rt5iuCkqqU8kIc5ujWtYfg27hMYjwkLYp9afmhhgE
	jFUU9qumNAw8iFIUd/nTesZ1c2E2ru8qRkrDqm/oh4BxhJZOTZ5Mz2xLcO4hU0xhOrmjT9rCB3p
	HTzEucjNxxqckZgE1mwSaSpnFzBEy2sLuWcn2HwTxBk51JxPPY3Gy4tkKjv7Z5kvgQDor/NUav8
	h1tobPpd/LDpemGPTPbHsVFVJtT
X-Received: by 2002:a9d:64d4:0:b0:803:68df:7827 with SMTP id 46e09a7af769-80c4ef2087amr659287a34.36.1789592755475;
        Wed, 16 Sep 2026 14:05:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a74d2sm930485a34.12.2026.09.16.14.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:05:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Wed, 16 Sep 2026 14:05:46 -0700
Message-ID: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5 --> v6
=========
Following feedback that v5 combined the (1) stock abstraction move from
memcg to page_counter and (2) changing the allocation / draining
behavior, v6 limits itself to only the first goal. It retains the
existing seven-slot per-CPU design and drain policy.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small, frequent
allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation is within memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast
path behavior.

This matters for future work like my tiered memcg limits series [1]
which introduces multiple new page_counters to memcg. Without making
stock a page_counter-level property, it means that every memcg charge
now goes through multiple page_counter hierarchy walks, instead of
being able to cache these charges.

To make future page_counters scalable and performant, move stock from
mem_cgroup to page_counter so that each page_counter can opt into its
own per-CPU cache of pre-charged pages.

We get an added benefit of simplifying try_charge_memcg code, which now
has all the stock management handled transparently within the
page_counter layer.

EFFECT ON MEMCG V2 USERS
========================
This series has no functional changes intended for memcg v2 users. We
preserve all draining, refilling, and (un)charging behavior, including
the uncharge path's refills / direct uncharges.

EFFECT ON MEMCG V1 USERS
========================
For memcg v1 users, the decoupling of the memsw and memory stock means
that each of them now manage their own independent stocks and can lead
to a different size of precharged cache for each.

Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
than or equal to memory.usage_in_bytes, because memsw is a superset of
memory. With separate stocking, this could have been broken in scenarios
where the memory stock is bigger than the memsw stock, leading to
memory usage appearing to be inflated and greater than memsw usage,
even though the real usage preserves the invariant.

To prevent this, report the larger value of memory and memsw
usage_in_bytes for memsw reporting, so that the invariant isn't broken.
This is a bounded stock-related overestimate and does not affect
limit enforcement.

Based on latest mm-new as of 9/16/26:
892f5b3b07e5b "mm/swap, PM: hibernate: atomically replace hibernation pin"

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

Joshua Hahn (5):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter

 include/linux/page_counter.h |  35 +++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  12 +-
 mm/memcontrol.c              | 328 ++++++++++-------------------------
 mm/page_counter.c            | 209 ++++++++++++++++++++--
 6 files changed, 334 insertions(+), 254 deletions(-)

-- 
2.53.0-Meta

