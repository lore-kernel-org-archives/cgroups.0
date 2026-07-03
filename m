Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F0D3806C4;
	Fri,  3 Jul 2026 06:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783060732; cv=none; b=iVpcU8sFjyjKDFeQs8oHxsRVw4FOlAN5naFDpXjhfkBSzsclTraYWIavULIYr4i7LrMEnGdwLkP5hQOOHpPvsa2GQW0qSwrWYBO2uQzCuJzGJ5c858/E5PzxSYN+ZlfsqAwqga3dre+eilEH6kVHFrp/pSLDjESno5aXiH3u9wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783060732; c=relaxed/simple;
	bh=MCFRL8G3IiFC1y+iJSbAx/VqT1lrgXRbyOmslUOD4QI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lrMBPezqFOwUYMmQTYBPgcl2ajYtzkbWTGaUNUKa4exOI4zZNn2M9HMzaCQF48dLwVSCIbUsL7mZrtZGrWReUczArrKHZhWVlLd65mVhMGTS/MwpkncaB/gzQ8wL749NnR3mSgJG0E6YCyQfytqcvMg0u4fTcOA9qP9QfW4HtUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=BIkuZWYJ; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=oh0MX1Fb; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="BIkuZWYJ";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="oh0MX1Fb"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4gs3xG633kz9tvC;
	Fri,  3 Jul 2026 08:38:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783060722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fOrgozTJMjn4rnfORWTzUhBrhJUbQ04jzVOms79twA8=;
	b=BIkuZWYJYWBx7iUYhfpzSFXjQD+U/od29GDxLdr7oky2VZSDQ/ZMuLEEsgAzj7SbK11MH/
	EXGZ3PE7Woh4EXlHOz6UoitcLunH81JmsZPUJAyDNyWbzpc00LGs1JRfGRNdzwyOPvJYCG
	WFq4Tfn2tzMRFVHYKG84n0zktwaKb247rOFZXqtJIiXQJjvZ+UgS2Lk9bHlCF6rR+grJ+x
	6C9F6zwZ/tmuqe2LyFAUbiJIS1D2TPRDsvOBk2NMMW1xSpaV8oqplAIneyc8dgrQCe71D9
	MdPzxTSovkLArAlFLN3wMvtJXJ69aZukLletVVNuzLvAlNXyJvtXttDMnC1SAA==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=oh0MX1Fb;
	spf=pass (outgoing_mbo_mout: domain of manuelebner@mailbox.org designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783060721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fOrgozTJMjn4rnfORWTzUhBrhJUbQ04jzVOms79twA8=;
	b=oh0MX1Fbpd6Ik9QucBv8+3vbQyn15Ib1nryU5b1BJpofP58HQ63X5Qp/JX1DSuyFEJKQKo
	pVyGO1Uj9Xh1g8s8uTHZYN0DjkLbjiREKsIfxrp8MpLBnQXWbCgGGJCKn83AJYk7S4cBHo
	CQct+o/wk1etoS4S8X51rG6B9jWt2f+wyVYj7tBgjTvOejIc+huCX95l26GNardMjpkmJY
	fJgFMKg3JIqJOal7m/DOEYir7UEd1JfkG2Ab7FK5uSiADweiMb12Bzi0SJhQshnxdlPk/W
	IetlBapndJoyTme+aZTtwfk969NPASZKGDhOlj7e+txGmuQgV09wz6Aa4r26pQ==
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org (open list:CONTROL GROUP (CGROUP)),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-kernel@vger.kernel.org (open list),
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH] docs: cgroup: Fix bracket
Date: Fri,  3 Jul 2026 08:38:05 +0200
Message-ID: <20260703063805.219517-2-manuelebner@mailbox.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: z3jpxezsq364x6an79ecobauiz7dpphq
X-MBO-RS-ID: 52e40322ae47065f32b
X-Rspamd-Queue-Id: 4gs3xG633kz9tvC

Remove single ')'.

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
 Documentation/admin-guide/cgroup-v1/memcg_test.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
index ebedbc3c3f9c..d9951c319ef5 100644
--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
+++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -10,7 +10,7 @@ Because VM is getting complex (one of reasons is memcg...), memcg's behavior
 is complex. This is a document for memcg's internal behavior.
 Please note that implementation details can be changed.
 
-(*) Topics on API should be in Documentation/admin-guide/cgroup-v1/memory.rst)
+(*) Topics on API should be in Documentation/admin-guide/cgroup-v1/memory.rst
 
 0. How to record usage ?
 ========================
-- 
2.54.0

