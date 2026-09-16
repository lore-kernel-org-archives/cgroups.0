Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379BE42125F
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 21:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789592463; cv=none; b=k0TyUlgf3LRcLg6pD0yIjh+dN99XK/50/C1XfbKO4IZIndCG5YUXa04IfwUqxYEz3vSRy1PIAiNvV94rSCFAq6/dNG0mNTImohfO376fOd9MCZle6ZX32ntPtba2mihZEansDVbevo7bG/osmo1UyqTmQ1eNQl8aO2p0fK6Pz2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789592463; c=relaxed/simple;
	bh=bWJrz4s4s4Jv7sK9Wa6htRKbmqEKsCYgmvl9+dlKg+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pooj8YEjs3oK3Fztzr/m+uXYq/pV8iZ4hj0WUMRppjx4Vwysoki62XFiJqqPcBGeoK+KLf7rB7OTNss2HC+MwXNvQCYNZ0B9n8wPkHr8UgWrREjhO4cgi/o6GjKZS7dchcODwNQ0/VLGpzGF9lVrderoxNWqrt2A6Mh7fBB3cFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=jCHyUCJr; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="jCHyUCJr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=XPqpgfCd+NVaFwI3tbS5RTUSF1zYM8sxZ4o4/8h5BXg=; b=jCHyUCJr9WhX
	ih7kzgf/yHidk9RuChcbpZvi+tVtDRRxw08PY6vidW74MKuku5q0JfmzUvyO5ETx35QwCz5jUyh+K
	MeHdDYGWmtITH7NMHX9LC7Kr9WGpl2lE+dAGryNrZZEYwAbEe1l48wsj8UUtPkURapQR2I5hANXGi
	TJpWXTjeAQbDeC5xiBjxFHcb6BkcxGjckC9bw7yLLSHBN3GCK7vZD3w+3q4ywuAU4Z2vP4Bm6DzCB
	147Nz2GA0tT8gBh2lI9/DoEldBjb2i8IG1AfuVIz8M5PzTchHs1uNFrZqG9j53W1i4t/wTKsHYOp8
	hIojTPDlMTxpIHxgm8ZJAg==;
Received: from ch-vpn.virtuozzo.com ([130.117.225.6] helo=LekKit-T14)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <eva.kurchatova@virtuozzo.com>)
	id 1x6wRz-00CfhM-1M;
	Wed, 16 Sep 2026 22:44:41 +0200
From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH] selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode
Date: Wed, 16 Sep 2026 23:44:31 +0300
Message-ID: <20260916204436.821378-1-eva.kurchatova@virtuozzo.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

O_TMPFILE, like O_CREAT, needs the third argument. Without it glibc
refuses the call at compile time as soon as fortification is on:

  In function 'open',
      inlined from 'get_temp_fd' at test_memcontrol.c:33:9:
  /usr/include/bits/fcntl2.h:52:11: error: call to '__open_missing_mode'
    declared with attribute error: open with O_CREAT or O_TMPFILE in
    second argument needs 3 arguments

The fortify checks take effect only once the compiler optimises, and
cgroup/Makefile builds with "-Wall -pthread" alone, so this goes
unnoticed in a plain build. Building the tests with the flags
distributions commonly use, -O2 -D_FORTIFY_SOURCE=3, loses
test_memcontrol entirely.

Fixes: 84092dbcf901 ("selftests: cgroup: add memory controller self-tests")
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 3a84d068fbf3..0ed82347044e 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -30,7 +30,7 @@ static int page_size;
 
 int get_temp_fd(void)
 {
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
+	return open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
 }
 
 int alloc_pagecache(int fd, size_t size)
-- 
2.55.0

