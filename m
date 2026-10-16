Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C56E3932DB
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 05:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792128500; cv=none; b=sru11fxjqx4niu2HzwhPFJjYpdvVJGCWphgI0aYmdl+QNeQCC0nMW6zvjmrFU1CaZqiDj31McqV7hiweqiHUAIiA0VMDB0xUEy2lz3WxsH19WKKOQOn0qFhFjJLd6eRj8h8X11ARrJ5RvCcWAAmEMf5dTOUKi+fWkPKBqskqR58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792128500; c=relaxed/simple;
	bh=pnAG3LcqIwHtJgq+L1j9eG8rpeHgatIhQuWY53ECfKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ImYp/khkqO/zW3nF6m9KlLcWWvB7FABBCQMlUgmlUzcddJsyPeyIKy1AgAVABeFG0ZxJeeJiI8hZVHtw8pIQxPJm7KW094PSJn9FG1odYmKgKP3tb7NtJ5uw/w2APoKAVDZtr8Ui+QV8dhFjhjOa2l7e3WZrtHnmOoNj0tRNMns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pgGT5xVV; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pgGT5xVV"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-88bbc27f85cso8124995b3a.0
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 22:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128499; x=1792733299; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TOfi1okJuHw6W2fuigoKRfdJ0OT44tx1YKA+g69VlhU=;
        b=pgGT5xVVJ3QS+3597eQ62rRIMraejs+rKTPUdzNxLW+KtwvpH7V8QE8xjIMmjiKII3
         /53BKtsJ/oObzcUctTs3Oh6OXzA0/V7ZV1x61OExvnX9jQAjSoTM+dHzd/W0vUKRrOQ0
         nRIb878ew0LLO2RvF4Qdc/t8O+KzctrmB8Vwv6tIhCqWwHa1WSfHqACDevS2wIq4Uzmx
         3Jz6lZ2zCxWSDphn3P5oGChtYI/2ne2lSSsnh2CDKx3At02mTcF6Hbe4/HGYpL4eaxxM
         g0oHDXvk3YmX787sTyc5YNr1D8OEyT/utvDivUXVWcm05A1AZZ4Uwj5Vv7UlKjxCLLJ6
         fAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128499; x=1792733299;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TOfi1okJuHw6W2fuigoKRfdJ0OT44tx1YKA+g69VlhU=;
        b=mNcM08Yu7nKcYp030/2CVdYyCOuuWS5P3rbTRFSPYhLDzko8pKTaEWcrNIxkG9wqW9
         aTbT7G9L8IfhnlbjAjT7KS7kKBcUWJE5jVpCiBihLhwBzbSKsscozB5Qe29m6tbUBk6d
         oKT/h6H0F8orFC6sA5VL5S8kRxQiY8TbGs4EgypYQTeEc708qr8xPzEaongBLp389WE0
         3tBEJoJJD+WSXrpP5kvOcpZaf3ekrhmAKn4083j2xXGU+d6qmDKn5P40mYSiaxAyQXNu
         0Q3wzHfyR6fq9vJaRPM6Dv8/KbWyYqvmcgjcQv8PiufM5F2JQ2HqrBlhBC6VJfUIh6G+
         NALA==
X-Forwarded-Encrypted: i=1; AKwUvBxViQouuY1ElUAbOMvGsY5xwqDB27Z6vC2dDaRU+0cZtoqbu9+70Y3AKEYxCG27dk3Qdp6xBeks@vger.kernel.org
X-Gm-Message-State: AFq9FYIIdbGGBDMGSk9DHwq4aNS8gWtfDp3aSE8YRq6AeT5xCHSWNzq6
	f9ybAhlqwxdD8WZ7+6slAAD+f4lSbS6kssIgyWbo+BF5vIeeW35yX+3uKedmwJrEmETisLCrJg5
	yviJ3jA==
X-Received: from pfblu4.prod.google.com ([2002:a05:6a00:7484:b0:886:3bc7:1fbf])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c2cb:20b0:899:9267:3abc
 with SMTP id d2e1a72fcca58-8999267426bmr10023508b3a.41.1792128498428; Thu, 15
 Oct 2026 22:28:18 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:49 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-6-kuniyu@google.com>
Subject: [PATCH 5/5] selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

With MEMCG_SOCK batched in per-CPU memcg_stock, test_memcg_sock()
can fail in two places:

1. In tcp_client(), reading memory.stat only flushes rstat
   synchronously when vmstats->stats_updates exceeds
   MEMCG_CHARGE_BATCH * num_online_cpus().  Because mod_memcg_state()
   is now called less frequently, 16 read() iterations (0x10) on a
   64-CPU system can finish in a few milliseconds before
   stats_updates reaches the 4096-page threshold or the 2-second
   periodic flusher (FLUSH_TIME) runs, leaving "sock " at 0.

2. After the TCP connection is closed, up to MEMCG_CHARGE_BATCH - 1
   pages of MEMCG_SOCK delta can remain cached in per-CPU
   stock->nr_sock[] (e.g. when the initial charge published +n via
   try_charge_memcg() and mod_memcg_state(), while the uncharge was
   absorbed into stock->nr_sock[] as -n without overflowing
   stock->nr_pages[]).  Since the periodic rstat flusher does not
   drain memcg_stock, "sock " in memory.stat can stay non-zero across
   cg_read_key_long_poll().

Let's increase retries in tcp_client() from 0x10 to 0x40 and write
"0" to memory.high before polling memory.stat at the end of
test_memcg_sock() to trigger drain_all_stock() and flush
stock->nr_sock[].

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..1311aa5bc522 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1333,7 +1333,7 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	const char server[] = "localhost";
 	struct addrinfo *ai;
 	char servport[6];
-	int retries = 0x10; /* nice round number */
+	int retries = 0x40; /* nice round number */
 	int sk, ret;
 	long allocated;
 
@@ -1447,6 +1447,13 @@ static int test_memcg_sock(const char *root)
 	if (cg_read_long(memcg, "memory.current") < 0)
 		goto cleanup;
 
+	/*
+	 * Drain per-CPU memcg_stock so cached MEMCG_SOCK deltas in
+	 * stock->nr_sock[] are flushed to vmstats.
+	 */
+	if (cg_write(memcg, "memory.high", "0"))
+		goto cleanup;
+
 	/*
 	 * memory.stat is updated asynchronously via the memcg rstat
 	 * flushing worker, which runs periodically (every 2 seconds,
-- 
2.56.0.212.g129ede20d9-goog

