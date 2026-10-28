Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213443;
	b=jR695gIktvVuXM+13N25clMVwXnaWjI1VDzQSF+Ttl2yq4fJvbBS0/w7bV1rHys01f/x
	 he/Bn0lB5WEI1n41nYF3Pii/vGtsH6qT+D12gYcLGp97naa9zxQTe58V20E4YGmAoK6S4
	 c0CluyION0S1xM9mau6w6n8+lpvKIVh4A5mSAj0MVOGgoPR0WQzF4iNvEcaKG9wXLmEiz
	 v0gEWZbo/cty45menSeC+B6XGaA630QmSEYF9fUmTvqg3qSS10yo+NPGFa5KdN/k6y+IX
	 Nm9chny8nLR+Dbp1V+RRTJ8vocAvZJ5H679VNMNhAeJfpK4OlsAtPcjk6/hd6gc41Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213443;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+UVeUN9zfkatX9aRBqcQooe9pOmTFVR27qwKTlMgs/Q=;
	b=ipIYAobJXw4pW+9HP2nfqpKLQ0pCxuS1prr04OD4shKgXrtAvsOgCtsN1nEm8uo51G74
	 EASeOCyqpCFrs6SSDhABrndimrkm0qeT1Pyrb8ls7vBO1TL9wXcE/zJS98roQkO8tC6Lv
	 VbI4XY/UyWxo3y7DpqFT96LIObSTnEmWf8kD0QmytIseccjyA79kmvoTazhrqHB5JvM5W
	 cE2qp+/TFd6xhoZ9dsA30oG0rWGaQznn1ZkhOWxE5uuhk0pNcQfGkYKYgJzUpWlmxaVRP
	 aaH03CAu+RZv63qNcjgDfjy3IXNElZBlITj14w5jIzLCjnaLmb3MsLBOB5/OqRFEPcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CSawB3NX;
	arc=none smtp.remote-ip=209.85.215.197
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43DD606A31E
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D43DD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CSawB3NX
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdac8b7169eso741213a12.2
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213442; x=1793818242; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+UVeUN9zfkatX9aRBqcQooe9pOmTFVR27qwKTlMgs/Q=;
        b=CSawB3NXRDO89mXKTuU8cQDholwFec6dAvB8VQGouxGpivIdsnHVestw+Gnx7BBxnf
         4bSmyUD4rUXH8cVMOaxrGsIpg63L2bPFWwyyNmF1gOEtbPu5u2arIU1p99xa3gDnQ859
         scgv39Dv4Nq9I/SHWeYmNDoxg47FxA2vP99fFyLGpzE/X0QtCuTfkvQ8ssTpoaSXhMnu
         xEv2T2AC3bg+CS/hcLpcCsL75JmKhFCX6JqAQd0OQnnMWporehE28beFYQYjN5C0Fj/d
         kQnK/xcogUuoKpwrVvNOkUUe2ZwGhKw+Nr5VLiAlmfjJ4gqojiyVBNkhvOIvF/kiOf49
         yRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213442; x=1793818242;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+UVeUN9zfkatX9aRBqcQooe9pOmTFVR27qwKTlMgs/Q=;
        b=VDOt7beAnoIqvLRfoE6WFBdIUFnLsE1GS1aaHBHCoN4Ri4ff957ZRnYkccnX9uLA4y
         9l905WFPufcttIb5NjaaqhxDX2dborobcJyJBEQYqrtqIX02vt4Tgm+q6bc67ePyKNuk
         oOm3di1z+5Q1trjfaoEp09ARI63JXpPKaovwJLAXR1xPxEB91N2La382fYLf0ZJDzd8M
         +H85yEzdsXln1hz72lMFEplEOIj+x4OT3NRBa9c70F9IuwiDVV4uPQOExQAxaOgmhKKb
         zNnVOH5UvbKsbEXhf4VbIlpE1i8MbrRGil51JogXtIGDhDFfciVEJJJ4tYnRDHvv416D
         sMjA==
X-Forwarded-Encrypted: i=1; AKwUvBxi03a1zjW+02mpHUCd7sKftPWomK6uAWmt8fe+8p3fKBuf08+8nYJ2F8Vtaybct4SGXgqNXH3i@vger.kernel.org
X-Gm-Message-State: AFq9FYIlxtjzWbKf4V3X8Bs/prjZ2TW+X/XzuaDsl+k7h7u73yRp2bCB
	IivuLkgHQzu1cwwRSoFV8pTl8jmksAQDCqFvwOusR8TeTpqYWoHrAKmJfdgUtISMOFGVk8YxAHM
	Ufkmbuw==
X-Received: from pfrg14.prod.google.com ([2002:aa7:9f0e:0:b0:89e:6029:204b])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918c:b0:3e2:117a:62ff
 with SMTP id adf61e73a8af0-3e9023d6b5fmr2794333637.61.1793213441975; Wed, 28
 Oct 2026 11:50:41 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:18 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-7-kuniyu@google.com>
Subject: [PATCH v2 6/6] selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now, MEMCG_SOCK stats updates are batched in per-CPU
memcg_stock->nr_sock[] up to MEMCG_CHARGE_BATCH (64) pages.

After closing the TCP connection, test_memcg_sock() runs
alloc_anon() to force an rstat flush and verifies that "sock"
in memory.stat drops to 0.

However, alloc_anon() only charges and uncharges anonymous pages
(nr_sock == 0), which trims stock->nr_pages[] without draining
stock->nr_sock[].

If a residual negative delta (-63 to -1 pages) remains cached
in stock->nr_sock[] when the socket closes, "sock" in memory.stat
stays positive even after rstat is flushed.

Let's write "0" and then "max" to memory.high in the flush_rounds
loop to trigger drain_all_stock() and flush stock->nr_sock[] into
per-CPU vmstats.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..62cb0278168d 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1483,6 +1483,14 @@ static int test_memcg_sock(const char *root)
 
 	/* the uncharge is done, but a flush still walking the CPUs can hide it from a read */
 	while (flush_rounds--) {
+		/*
+		 * Drain per-CPU memcg_stock so cached MEMCG_SOCK deltas in
+		 * stock->nr_sock[] are flushed to vmstats.
+		 */
+		if (cg_write(memcg, "memory.high", "0") ||
+		    cg_write(memcg, "memory.high", "max"))
+			goto cleanup;
+
 		if (cg_run(memcg, alloc_anon, (void *)MEMCG_FLUSH_BYTES))
 			goto cleanup;
 
-- 
2.56.0.313.g2479322e68-goog

