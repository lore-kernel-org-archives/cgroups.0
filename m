Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275638;
	b=x4SoWLm18yB8nGk6QqXAAT61DaUZr5oZzReGezy/28pzJH2cycMWTCuWIdK6FYWMf7AM
	 uxl+Dw2sn8vvZFRNfGtxaM92WRC8yFZECEho24RttXRsGJ7ZHjTiMd50wvkN4ANB2TZjU
	 A5TxkqEZkNGb6e2/71ZpXNf8TB4bY+GufRc1anWW8MzdO0oupj+g51wZ8SxZm9KOP8dVf
	 P6BB6QwOvsXB+e/OAaX7T7jypXjjZCIkyy7McL9GbVme0HPaXF3Bfdr+NPJxWVP9Gjuj7
	 CuigrXLWOxMGedmOvClSvfVtqHO1v47ND0PREYYj7vKMI6TEz14t9GdwlopfQrDatEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8I8d+hDMqZ6xVmUygiM+c57kytjFuIQN7v7mSubiZXE=;
	b=ps71suK9hoCKPd8dFvvoR4QhUD+EMIz5vBFR2oKNSi4AVvv8uJWn83Z+XOJpvORjMpxB
	 nZv3NvAcghAF01ZSUMW6UDIexjwi30f5W4yrJkB/1uzMLYXlaq3dTqyf9FJHY9SGGJndj
	 y5UkEIixKdgkPj2tSsCQAi84C6ILZeYF/w4xRpM8zh7mGOZ2LeZ2MgYxxnLG3ZgHRFSi/
	 nhrv5YE56PW2exLf8n42MnfA5ksDgz4YQA/z0OfEQZWI1ntERpa8Y8hQDlar1P8IUyEuu
	 cE/puRv/g8SdxUcmd9oHPp0ddLF9njlc0B0cOczT5Di1IhCyXXGNi4GofVhwUaSHTpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UvfMt4oi;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5086606A321
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 01:53:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5086606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UvfMt4oi
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3b0d0b80fb9so949937a91.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 17:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275637; x=1794880437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8I8d+hDMqZ6xVmUygiM+c57kytjFuIQN7v7mSubiZXE=;
        b=UvfMt4oiADcSHc64YiHqNaZvosUzcxw+0SxYNI8Oxbd2lyGdapRlMn3HwEmJUcbVkh
         0j+/crtsU3UtpejgXzT+aBSlPskpny/QpkROcVUmO79hYTh9BuWwipAUB64O8MLNRdM2
         eJ2t53QdcXUNxmzSJ3r58/EuFu/6vnNT1z1+EoJRUyew3t8g6Nnc4gsQCC5nZZCxc8pc
         aIvJ3loCuCKZuvyUOeW6eGbvXVrLLqk9BuQSSE/3+lDVcPLaR27iG+NoU7ihMHgNi5jU
         MRkYSvuCnr8yrnmGcbb3kYKzPcxCpOPUmzl8ludlGRRFHZp/DA9yCR/NAi10X1st+DSc
         3glg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275637; x=1794880437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8I8d+hDMqZ6xVmUygiM+c57kytjFuIQN7v7mSubiZXE=;
        b=BIX7mS0N8Oow+5JTCNlGT55gbowI7Iv46k2DJ/TLngz8PVSDXl+5LuttiRwl7UPCT8
         JDVYmuHZk4CgfsubMnq3zrKMgVL/9s/1E4OuLmvwzTcApPxus5TQrij8aVnVHBmIyYAF
         RTL0XB66c5OFelP6OgM1QDt0Ur49fc3UqWYraF7p762OXbqLKtUFrhFEErdnLYnNyJoN
         otDbn2Iow5EUDkLUqvB+XcI8koRk8Loaj4eTcFRpHMY6akuyzNcDqStiUyNRtDTe/74d
         vN6+RCiEpg8rIIeuK5F4NDTHyrpTE60QAhaHfXCogFXhoiOta+P9BUXovL6rE4Z2w2za
         nhAw==
X-Forwarded-Encrypted: i=1; AL+hErEDb83b+LEwtTRNU/VH3NbHt4JWaSgmWmviNDs1AP38mN3vU0LM9s/r4x+gBwQ7j8JeNbBVU3b4@vger.kernel.org
X-Gm-Message-State: APuU4Z8cF9kDW9jEV1QrHwS/SslEwtLNLUgio6XNjO03GBytgES9dyv8
	0NjtzeX9OcVCmXFay4+MgAO8veLMcJANA4GChF1D1XmOIcrkp1VSYP9/
X-Gm-Gg: AYBFou0A0kz/fkKTHn0LSDbcUdtuAJEMrlo6pKuWCfp9aU6PqKA0WmZh9LCbiyIDXX/
	uxCB1dDRZkAMlx+4ML0LL3ld2rPWJwV6p7DCV7c/MG+7nOqOIgYEaGkAh81W8+2sKE7LH6J4fBD
	zKTSgswQpwMIDLEZD+7kI3EY3+vTxmPYV5ob5ZI1e4xOUy6SOtM4Wo3P3Y89fYIpRXIbC/0QUFd
	c14d0O44aBSgO7nI6fm1BFI+Z4Poehn4YrWWznYSJU07mG+nWL1g0B2LJIx/oJ8k9ggBbsv2wnM
	6TqyzUzrmQ+0uv5TDvcmxapXqTRpse1zbKX/JuBd1/iaYhipUF/BwxBUhGr0hD1Ri4Se1Se5GJm
	C2DPU3XYgcOGMgwe9D78diK0N4RR403igTyf1FvCsINGQ+dDRjAlhoCMDyk2fMU0wAGqP+b+miH
	6gPjB5DluRVnpDBpGVd2YETGh4giVy32bzFOup5+eRwv/5xmSbiMUYADUgynkyogBKc1vdK01xj
	Nja1QuBN58phCRp8EB5hJicVqmrp2IP3AnkQl2rFXqbvC1NTDIxOXYgIDj9x0TGP/3MiEAtC4Co
	gDXYglxtUxPQ1Lg+oTr69yzgxcyuj2vNmD2yxCgMg4Y/1HQv/9pxcWubXDMEl+tF9W3KdzUPRPb
	w5M82Cw==
X-Received: by 2002:a17:90b:5848:b0:3b0:9976:c1c6 with SMTP id 98e67ed59e1d1-3b166e38ceemr1381590a91.66.1794275636884;
        Mon, 09 Nov 2026 17:53:56 -0800 (PST)
Received: from localhost ([2a03:2880:ff:52::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b168acaf41sm564784a91.0.2026.11.09.17.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:56 -0800 (PST)
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
Subject: [PATCH v2 3/4] mm: workingset: skip the root memcg flush in workingset_test_recent()
Date: Mon,  9 Nov 2026 17:53:20 -0800
Message-ID: <20261110015321.611093-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
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

We can skip the rstat flush in workingset_test_recent() when the
eviction memcg is the root memcg. lruvec_page_state() now reads the LRU
sizes of the root memcg from the node counters, which are always up to
date, and workingset_test_recent() only reads the eviction memcg's own
lruvec. This avoids an expensive flush on the refault path, as flushing
the root memcg flushes every memcg in the system.

For reclaim however, we still need to keep the flush (for now) since
global and root reclaim also read the rstat stats of the child memcgs
they scan, which the flush is needed for in order to keep up to date.

On an 80-CPU machine, a root flush took 69us on average with little
cgroup activity and ~0.9ms with 128 memcgs actively allocating (wall
time, including waiting for the rstat lock). Reading a node counter
doesn't add any cost. It took the same amount of time as reading the
rstat counter (~150ns, which includes bpftrace probe overhead).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..383f951eaad4 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -483,10 +483,13 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * section (for e.g, in cachestat) - these callers need to skip flushing
 	 * stats (via the flush argument).
 	 *
+	 * For the root memcg, the LRU sizes are read directly from the node
+	 * counters (see lruvec_page_state()).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	if (flush)
+	if (flush && !mem_cgroup_is_root(eviction_memcg))
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
-- 
2.52.0

