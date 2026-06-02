Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3C21BC2A
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 09:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780391472; cv=none; b=JnAgNT+ZEW2Mx1NtfWWEpTyKPkopw2yRUcbX6GedDtbMUKULNFywpmcSfZpHtUlfOVpTOIAQoRhul3PGF+3Jzw1Y/kenNKmUT6SuG4o0sx8o1apocHFAhODjSKhTmAmJNUSx6KLQyLA5JPn8DKCU5jyMQESfzmBjSehlGfg8UhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780391472; c=relaxed/simple;
	bh=R5nF5fhLnhrV2GlYTBTPDzqMqYcMhqKJ/HrzeSyHhCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gbnC7fenvtGVQBGup0lmvNy+vC8ZJ/k1o++Z01AJir1I1PgH+KlmlYOtx7PC3oddfB6KAuTVrVJXr9tOXK/UcbT51nXu7y1f8xXYEX3I1wkkCrYN+//U0NraFT/0Vhed7j4bWPX+oWHOVt6Mv++AN9opiDXjTZJ5LzCgInPpZKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KdasGFZA; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KdasGFZA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780391469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=360XwP/yPRhCWKhxS8hhQoZw5l/EoTdk5kd9baoql/o=;
	b=KdasGFZAj/cyjCYRC7bMGkVNyB344TePInDLAabZBJmA1NsDRUJrO2RDAlnmhU28nanMM1
	jF68aCIUSut3GYEAFM0lZZO9HyWeW5DX9t8XrmNEQ5+/BiIs444nP2kFOL8kY6WrTbIEE6
	kLfKEGbopnmnA6pOMj5b4kmE3IMZe7w=
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hanes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev
Subject: [PATCH] cgroup/cpuset: change ridong's email
Date: Tue,  2 Jun 2026 17:10:38 +0800
Message-ID: <20260602091038.26901-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The chenridong@huaweicloud.com is no longer a valid email,
replace it with the personal email ridong.chen@linux.dev

Signed-off-by: Ridong Chen <ridong.chen@linux.dev>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ec290e38b44..e035a3be797c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6535,7 +6535,7 @@ F:	include/linux/blk-cgroup.h
 
 CONTROL GROUP - CPUSET
 M:	Waiman Long <longman@redhat.com>
-R:	Chen Ridong <chenridong@huaweicloud.com>
+R:	Ridong Chen <ridong.chen@linux.dev>
 L:	cgroups@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
-- 
2.43.0

