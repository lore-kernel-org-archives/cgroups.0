Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09027314A73
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 04:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786940860; cv=none; b=fZsuLxknonAPubXeK2/gv35JKUKtEquSVOhPp25I5TVbUsPFxYZdf/vB2i6nN78e3SKPyNQBfA7CqewdJCZZl9EsK8vQrKDfxPgWY6f7vwOa6Lzu7zEW/UMYs3+eQbA6SB428weUD2AswJzI9vifsHSW5dyBoZNR+liRLQ+MqLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786940860; c=relaxed/simple;
	bh=jb1gQEt9X3ic1kv0Ym8M4A7fGjG8QJ0gQBiay9KXRsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ouJJrs+JnN7S/WBOqL4F+ypza1a3inDzBl0Gp/D8dHhN4bgvVyIWkaO4p6ZhS8KF6xEpPikekdOBKgClufWDWE19kB+L8i1NTv6X1SHu8vR8GMpVaTMgnOMPv4e96S9igUSjAiNbTTyil/drrbX6uBAdXRdFHcwMlz8D2JEd38s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H26i4V5o; arc=none smtp.client-ip=95.215.58.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H26i4V5o"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jb1gQEt9X3ic1kv0Ym8M4A7fGjG8QJ0gQBiay9KXRsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786940855; v=1; x=1787545655;
 b=H26i4V5oxquRXIE8cVjZEVd5yqamMFwFpMgLcdISuwHwQBX+pr8lvUzdovJH48Ux8WQC9xvQ
 rcUTdPdQSFPf0mflPlZg7ObfbA4iAT7w7SLNfWJmW2NRvN1LwxP5qo61pHPBTHq/mLsd/npWHJH
 PNM4b5yL3nwvfZOFTrfGi5w4=
X-Envelope-To: cgroups@vger.kernel.org
Received: from ctao-book.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 0453194cf996fbf3;
	Mon, 17 Aug 2026 04:27:25 +0000
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] mm: page_counter: reject empty string in page_counter_memparse()
Date: Mon, 17 Aug 2026 12:26:52 +0800
Message-ID: <20260817042652.74136-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

memparse() consumes no characters on an empty input and leaves the
end pointer at the terminating NUL.  The only validation in
page_counter_memparse() checks for trailing characters, so an empty
input slips through and the limit becomes 0.

All limit write callbacks of the memory controller strstrip() the
input before calling this helper, so a script that writes an unset
variable hits this path:

  LIMIT=
  echo "$LIMIT" > $CG/memory.max
  echo $?
  0
  cat $CG/memory.max
  0

Nothing reports the mistake: the limit is now 0 and the OOM killer
goes after every task in the cgroup.  The same happens for
memory.min, memory.low, memory.high, memory.swap.high,
memory.swap.max and memory.zswap.max, where 0 silently removes the
protection or disables swap and zswap.

Reject the input when no characters were consumed, which is the one
case the trailing-character check cannot catch.

Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 mm/page_counter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..d14db705b04f 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
 	}
 
 	bytes = memparse(buf, &end);
-	if (*end != '\0')
+	if (*end != '\0' || end == buf)
 		return -EINVAL;
 
 	*nr_pages = min(bytes / PAGE_SIZE, (u64)PAGE_COUNTER_MAX);
-- 
2.43.0

