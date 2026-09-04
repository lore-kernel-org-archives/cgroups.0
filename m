Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA933D6CB0
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518583; cv=none; b=Izjk7XOPVqUj5W6RmHoo5Ku2jwtV8/SgdxTEFPM4v0L4qg6KcQQ09sQc0oTlC2kuG/h75cmbu/csfJ/LwyIGfTyyYOClDpXRxmc+yyyzvv0uOAsAbiAj97/CL2Zwp/bl3Z/rVHmULkDUHF2X1LF8UleXodQA7OOfcJudt96PcJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518583; c=relaxed/simple;
	bh=8w3ux5dxQF/VaWUODYk/SATXtztTxPbRqIt+6Pe5jMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UJTMwupTM0eCljdT4ay0ZJQyUi/ku3buPxzezvSVydXSE9jF09qWjG2AJP/558kI3WMLHxaQqHP6VMIzTEvH9lIc/SENmZX4JTg5rujAAZlzR/9kbwEwAPwaoN5lIXUS867g/E3eUtuZjX8d7qdfACSCchuHv1WAHzlwO9nyti0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=es8aQSD7; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="es8aQSD7"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so709801a91.0
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 03:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518580; x=1789123380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4a4L7BNv+LxG4ZtAuwYin4s42kbMGqQiy86Ml9znP8k=;
        b=es8aQSD73GRS22fS7DLOIzOMF3yUToukkn+NTVn5v9cnJYoYlDlKST4njnzhhWwhYz
         jyh5MxHqQtaMK2lqnIGEnihPQP30b1eWqLnd5J+U9r4l6j5bO5mLMDWu9hTbf3ZUU1eh
         kP2nHT77YYtxzt+OvGp8e5DiyFxtBBeAiHe+cCxNsd9ZG5UxySThDkRXQ9Oh1HWl5Dar
         4q/QCLs0o2BuAn21qTfyQ8FpQE2ZiUS3rWN+N56ocbVmXNYlipm0hOWo+mdWi1xqXoHr
         QFhOVbHMfJWpg2Q9oj15wCicqy4c8Hd1wY/tcH3aK9nHWfm1509LwftVxVIYmYARPj2T
         yM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518580; x=1789123380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4a4L7BNv+LxG4ZtAuwYin4s42kbMGqQiy86Ml9znP8k=;
        b=hHl2FMtP9JMVCbCrE9ZQ3yS67G10ATSlpFTV5wM7LSacZuW2kjbPxKTLEPaSXz+Xn7
         1ULpEIug1ejSZuXQUBVZExxzArnBwrNYKABOKF8QZgm/ifp7Ed7nNdidB0KUxllDknaT
         IEZqK5DEwe7cYOr4YRiG7bDFkVVnUY6csdTVfBQ4O2GzQqDOGnJuYZisIJ/1Em8cA79C
         sT+BnKl/LrmUbbjFiMD5KS0UOi1cADLaYQIwk933rknCHddgg4QSY4/j50tdR2zvp9MA
         TyBaFQso5l7Y42doWoIa8D3qRWy284pCJNVqpfNpCqriU1MB2BA8yRZR0xF4JX02gbU7
         UbZA==
X-Forwarded-Encrypted: i=1; AKwUvBy08xZaRTabcfPkYRGipBspykM9xH4/MhBgN2sU31M+Omgoz56NxeCMijWAjGTzbmWcBGLox28R@vger.kernel.org
X-Gm-Message-State: AFuF++l8YOu99qx/afsxxzLHKXHiweIIUNLNM25Iw9+2ToT7TiOLCAoj
	SwRQpzeUKMC/uZh+cVM8AuuZCJXSAEHkiMFPO1JOnJvIDTocZka4Igic
X-Gm-Gg: AYBFou0lwXe6sTAp+ERgtLYYl4Eatqi4uuHYHNnkxkc8uiLb/OVeXX7NVE4UILlM3Wl
	MmOpc5kiNr4AqtT0VAm8z+JEBHfXnj9TnSDSWG7NDNL2opOZkkmPpQwKR3NrXufmNr+VWLFbF8L
	Rto9HP6ZnTYtRB4KgHoIEt8PEKQHKLUf+46de90EDVd18O35avpof1wXeoE6HGbC2LvthhCC9Ab
	PK8AY5Y3ygibLTcHiokrNLURyR08QXlKqCHk5ucz8RWlKU7xhYqMKtvPWMzZzkas5FU+VMrTSN9
	fsCgV3AMnO2jwT4uEjPuK4Uu/XekT4DscGHgufy6xRvTgsM3Mbgf2nqNW+zNYbnZkKkNmWhOS5p
	T1pRUBdNnwH4vje1rRF5o5xdukVlUf7oKjOmvYXQbUQegV8JBdjReRHyAnVnRl/18Ol3MXbF46O
	4swakAbIAhAX4wvHn2JrGB89+1P7rSPm8aDKZrktW5aCeSX+5jby632+eTtXTkhKHhzhC1AXjmA
	4nS0nbeM5MB3Z4Ejvgne85TbWo=
X-Received: by 2002:a17:90b:4cce:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39b260dd4e9mr8682700a91.2.1788518580475;
        Fri, 04 Sep 2026 03:43:00 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b314cfcsm5981759eec.19.2026.09.04.03.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:43:00 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] memcg: fix typo "memroy" in comment
Date: Fri,  4 Sep 2026 16:12:53 +0530
Message-ID: <20260904104254.16103-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "memroy" to "memory", reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 include/linux/memcontrol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..488dafe54d77 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -258,7 +258,7 @@ struct mem_cgroup {
 	atomic_t		kmem_stat;
 #endif
 	/*
-	 * Hint of reclaim pressure for socket memroy management. Note
+	 * Hint of reclaim pressure for socket memory management. Note
 	 * that this indicator should NOT be used in legacy cgroup mode
 	 * where socket memory is accounted/charged separately.
 	 */
-- 
2.48.1

