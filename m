Received: from tbjjbihbhdcb.turbo-smtp.net (tbjjbihbhdcb.turbo-smtp.net [199.187.173.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68E03D7D61
	for <cgroups@vger.kernel.org>; Sat, 18 Jul 2026 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.187.173.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784393798; cv=none; b=LYScsDpz9aZsZVjj3Kx4C5KHYX13n6psxSh364L8HGwS9tTksiFBWUj49AF18gpxU7F21T1XbokYQgQglQ431vwEDQOsGAq7lYa+ByIMce7OK251Gz6ZDXYwKN9y2KlOxKrNF1vtuUdRiOR/a1yl7ZE2bpuuGUqpQjY5OuquRPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784393798; c=relaxed/simple;
	bh=MolHESwn2IeR/FBN25HA/j1UYaLYlgKqZzc16tI9Lqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJxtNYuFcAUQbiJiuHPhjU7JXDs91asDl+0yw0P/Qa3FE5lieCO8qesgYXUvjVRZthVdQkg6Pj9AOvV+54LSbpufs3EXG8AD9nJGoSRXNb5wixS3oFxChhdnljcgqMSOYG/qxgFCXdd2c8aZ/JBF6IIVjAY7a1bdEsSNraA436w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahyatoubali.me; spf=pass smtp.mailfrom=yahyatoubali.me; dkim=pass (1024-bit key) header.d=yahyatoubali.me header.i=@yahyatoubali.me header.b=euZD8R7T; arc=none smtp.client-ip=199.187.173.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahyatoubali.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahyatoubali.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yahyatoubali.me header.i=@yahyatoubali.me header.b="euZD8R7T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=yahyatoubali.me; s=turbo-smtp; x=1784998597; h=Received:
	Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	References:MIME-Version:Content-Transfer-Encoding:Feedback-Id;
	bh=+VO4Q4LecmD2tihX70KIBFMSfRojfHXpihLnDpoElzM=; b=euZD8R7Tn/5b3
	d7a6X23/Bnox9n0Y01mgwq83K0s0M/5GN6vqFypEdcaQmiIOnSNM8dXgfCr7DUea
	czEMpDoWZladye+ZziluWekMXIg4FRa9YrLFsM0NCXfGVHTin4JMBII8gZZQbDgh
	vP69SoHjr2K8+sk8NCgI6SJBNrYBTU=
Received: (qmail 2894009 invoked from network); 18 Jul 2026 16:56:35 -0000
Received: from 197.145.178.94  by turbo-smtp.com with SMTP; 18 Jul 2026 16:56:34 -0000
X-TurboSMTP-Tracking: 64-018cfb16-00001e63be832602e005-005-4288be15
From: Yahya Toubali <yahya@yahyatoubali.me>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org (open list:CONTROL GROUP (CGROUP)), linux-doc@vger.kernel.org (open list:DOCUMENTATION), linux-kernel@vger.kernel.org (open list)
Cc: Weijie Yuan <wy@wyuan.org>, Randy Dunlap <rdunlap@infradead.org>, Yahya Toubali <yahya@yahyatoubali.me>
Subject: [PATCH v3] Documentation: admin-guide: fix trailing whitespace in cgroup-v2.rst
Date: Sat, 18 Jul 2026 17:56:14 +0100
Message-ID: <20260718165614.1923568-1-yahya@yahyatoubali.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <alumXzlDApA_iMbY@wyuan.org>
References: <alumXzlDApA_iMbY@wyuan.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-Id: 26016534

Remove trailing whitespace flagged by checkpatch.pl in the cgroup
memory and writeback sections.

Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 14b8c571c0d1..481658cfef40 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1332,7 +1332,7 @@ PAGE_SIZE multiple when read back.
 	cgroup is within its effective low boundary, the cgroup's
 	memory won't be reclaimed unless there is no reclaimable
 	memory available in unprotected cgroups.
-	Above the effective low	boundary (or 
+	Above the effective low	boundary (or
 	effective min boundary if it is higher), pages are reclaimed
 	proportionally to the overage, reducing reclaim pressure for
 	smaller overages.
@@ -2194,7 +2194,7 @@ of the two is enforced.
 
 cgroup writeback requires explicit support from the underlying
 filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
-btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are 
+btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
 attributed to the root cgroup.
 
 There are inherent differences in memory and writeback management

base-commit: 1229e2e57a5c2980ccd457b9b53ea0eed5a22ab3
prerequisite-patch-id: c8aee5eb39e3cd6f2b2f28c82163565665288d2a
-- 
2.55.0


