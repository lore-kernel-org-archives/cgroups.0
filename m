Received: from tbjjbihbhdcb.turbo-smtp.net (tbjjbihbhdcb.turbo-smtp.net [199.187.173.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA853D47D4
	for <cgroups@vger.kernel.org>; Sat, 18 Jul 2026 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.187.173.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784387980; cv=none; b=jMyxHH3tfZiKoSJH44lT6AUgQ7oT6PSHp0sq/QDv90qh7t+5n41BI8+XQlgc4UUyTeycOuWkc5OIJdyQZwaHVhUA5lEOr42q+zahQbTuX6p2cB2UK+dAoo0vnusC2d7epBDEDynYYXpP5HmG4kGJM2JuE3NC1+M4iHP3JCMqtGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784387980; c=relaxed/simple;
	bh=u4TmYmgg3ogWaairOru6yrWLetG7MAyZNJeqZxm0jo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m03I0knf4UPDyfylJ60VdAhqsdSt8YSZSNl897w6TF5U724eOQW/NlM6+DWWiBahmUe32yrxUxe1dOLhSIC4y1+KSW+q87g6bx4ayLpHB8qEZFV0uYpTbCt97QrSivp2DbssGoiM/pXDv+9pVMomQoNSS8dak4JeJOdcbXy66/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yahyatoubali.me; spf=pass smtp.mailfrom=yahyatoubali.me; dkim=pass (1024-bit key) header.d=yahyatoubali.me header.i=@yahyatoubali.me header.b=DFyhDwab; arc=none smtp.client-ip=199.187.173.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yahyatoubali.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahyatoubali.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yahyatoubali.me header.i=@yahyatoubali.me header.b="DFyhDwab"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=yahyatoubali.me; s=turbo-smtp; x=1784992779; h=Received:
	Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	References:MIME-Version:Content-Transfer-Encoding:Feedback-Id;
	bh=wq7IpL/hJ1ZgAwVvjpnIjJbMFf986942JKTBhleZonM=; b=DFyhDwabQhpGF
	3anthIIlGxvwNCA50KVNocMXQAakZXWNyb2gdaAQt60DXAdTzuSUz2nbUoOnQbkC
	ezAg+mHHB4dASCn/CxwJ8pj6chsggb5/GM5QFebP2wKVeWq79f/qzqNEqN3J91wX
	QsC/6DBr4A5Uckur5Ayi26hUolAc+0=
Received: (qmail 2203694 invoked from network); 18 Jul 2026 15:19:37 -0000
Received: from 105.76.9.106  by turbo-smtp.com with SMTP; 18 Jul 2026 15:19:36 -0000
X-TurboSMTP-Tracking: 64-018cfb16-00001e63a851e042c005-005-4288be15
From: Yahya Toubali <yahya@yahyatoubali.me>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org (open list:CONTROL GROUP (CGROUP)), linux-doc@vger.kernel.org (open list:DOCUMENTATION), linux-kernel@vger.kernel.org (open list)
Cc: Yahya Toubali <yahya@yahyatoubali.me>
Subject: [PATCH 2/5] Documentation: admin-guide: fix trailing whitespace in cgroup-v2.rst
Date: Sat, 18 Jul 2026 16:19:08 +0100
Message-ID: <20260718151913.1892547-2-yahya@yahyatoubali.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718151913.1892547-1-yahya@yahyatoubali.me>
References: <20260718151913.1892547-1-yahya@yahyatoubali.me>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-Id: 26016534

Remove trailing spaces on lines 1335 and 2197.

Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
---
 Documentation/admin-guide/cgroup-v2.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 14b8c571c0d1..f15a613fed6a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1,4 +1,5 @@
 .. _cgroup-v2:
+.. SPDX-License-Identifier: GPL-2.0
 
 ================
 Control Group v2
@@ -1332,7 +1333,7 @@ PAGE_SIZE multiple when read back.
 	cgroup is within its effective low boundary, the cgroup's
 	memory won't be reclaimed unless there is no reclaimable
 	memory available in unprotected cgroups.
-	Above the effective low	boundary (or 
+	Above the effective low	boundary (or
 	effective min boundary if it is higher), pages are reclaimed
 	proportionally to the overage, reducing reclaim pressure for
 	smaller overages.
@@ -2194,7 +2195,7 @@ of the two is enforced.
 
 cgroup writeback requires explicit support from the underlying
 filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
-btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are 
+btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
 attributed to the root cgroup.
 
 There are inherent differences in memory and writeback management
-- 
2.55.0


