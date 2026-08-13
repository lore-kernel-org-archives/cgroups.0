Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEAF39FCB1
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786617776; cv=none; b=F8LP5zhU89x4vjUmFC6ExGwrav50SImUv0NO9kjJnqET7TGasv9qKdRcVAVhAbkr3Jp394UcmQl5w7Ox3RviTga+q15pA7/qWtaOgE0Clx57kFjOC3NH+L6tnvGFe3XOi9nMcz4MSirh5iQko8214F0tyiASq9VpBHcpAijMxGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786617776; c=relaxed/simple;
	bh=0VqUwJS8ZvDBa7dlasus0ZlYTd950ehhOLBJWowlHSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=asaSEYgEJ7tlWSC4yEFagjCkpe4q2yzsuC5MOdb0/Lc11SHzgJFP6SPR93gzFLZcdYI9iG1S4dp63D8QeUHw2tHaKpY8zOwzlWNwBgL9yKWYx1nArV2MScVHi7Xc4rphugHddfybMGk+egMtfx1m76qFqyS7XvAfm1RcinyqztM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j0hVNSV8; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0hVNSV8"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cbee846deecso1829586a12.1
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 03:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786617775; x=1787222575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ao+G57HqxwG/64HYnW+6X3T+URkSZtqOIft3ps0hfco=;
        b=j0hVNSV8TTOdeUWRYqXYoafgpa2QITHp4a0lJESSVuVnpYU41KIY7eFEiR/U1YR8yd
         W4F1bJs8eLkl0iBEsYcc/UCgYXXbCqDRSrwf1pivrhOikJnuPHzQnSZkux5dw2r/JAGk
         zqL+FUjq3vBSe+FtIN/FFTT4nXHSei7AdvQ+KCoDtwPTWkRY7iRzCKDy/Bx1in8vn6NX
         EGqhB9Y96yZTetDLK6fvWFEwMUMSCfveVViexFIWbk5zNaNOWMzDvxg7HFfGUa60k/ze
         DtkPjnXkb1dCDIATh54il8mhH6h/XtmNwqU3G7DqUNgybFPlF7XgFRzqpUphFP7Mh08g
         yXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786617775; x=1787222575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ao+G57HqxwG/64HYnW+6X3T+URkSZtqOIft3ps0hfco=;
        b=E+njy9oTC9KTFAXvXLXGGzR9G4vLgPT+D783TgdWOpMtTOh91WTuhWyz1HY7JVah4J
         Dm0BYl7/CyY32GnATmH+SsDzGHk1BOHMpoGjmfQqoYehVfm9xqBjJl9NKDu9gXzvnkiB
         DuX6G1wi0nHfFcIu5HkTA/1Skq5g6Ttl0DTZh8NFl9ZWKVJU8X23G3Rl+A10yVllfGNq
         z/AzyQd8B879Q1773wFQSvOXNzRHftDPgBZhGLBO7ITZP6J81ZH+nPexvVxwug9xvt5j
         SFiA5Ko8HBlYgZxkpGzh6t0cY5f5QMIWm3BDK4tIL/D4RXNpyzrrVvZsYByq41df1ubr
         bcOA==
X-Gm-Message-State: AOJu0Yy3SR6s7XpjS2BNLL5iNCyZrCiiyzE0w1LNEiyJIzr+396lc+ke
	P2uYKBDf5WKSMf++IzxeDaUadihS025ayWPWbwhGex8KgeBt+x+taXZW/MNZRbDV6QI=
X-Gm-Gg: AR+sD11sXlgKS3SluwYygL3miKzWkNC3aHXStyFZ1VMsl5Pgr+hGqRpXA3Fpa6/sStR
	OEcVRFS1QUoMKiE21EL7whC2khNSHsU6jVJwdFoo5wpdH2qWVa8Ms0HKBvYuKWjO7Rj9t6CWtkh
	XSlGPe+LB2KezksCuCiT9lJ+LCn4idD0txLA6LkNdTF8lwUsdTrL0gkIHdyAQ6Sb3DhLx5w1327
	XLPNeSU5mXErLY2hJolh31qRoZCzSyy2buImg4UqfhyO3U5/96hNvmbB/el8tecWgi/qzd88a8n
	j/gfZvFlBxo/CLc/XHDB65mWeHnHqEm7GkLE3Ei+AA1WXanlTh2XCeuvqGBv9fb1CJOEEUswXcN
	K1Qyi7yfWtUP+hpreiXqar48Gm98YHvUHIyuv6kswms0tVImLK8BiP+Y4fe3koeR23De4XFoWRn
	MpqClzWo5xKyrrCESSh+p++uS8wwUvJLLbE0zxfw+LGTeR9hcigG5xV6vRU0LUGLr0lUcorPMe4
	bTFXtuQmJu4/9rLVe9k9vHsbVRs/CXUcVDjcdQjqFVrKkgR2CSzs/GtJMt7I1gdlBumQF5Ky+sY
	YA==
X-Received: by 2002:a05:6a21:6b01:b0:3c3:64cb:9b99 with SMTP id adf61e73a8af0-3cc54f4a8c2mr6631396637.6.1786617774704;
        Thu, 13 Aug 2026 03:42:54 -0700 (PDT)
Received: from localhost.localdomain ([2406:7400:94:ab62:887d:e555:df21:3318])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412da7d3cfsm10087279c88.15.2026.08.13.03.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 03:42:54 -0700 (PDT)
From: Manush Prajwal <manushprajwal555@gmail.com>
To: Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>
Cc: cgroups@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Manush Prajwal <manushprajwal555@gmail.com>
Subject: [PATCH] cgroup/dmem: fix comment typos in dmem.c
Date: Thu, 13 Aug 2026 16:12:36 +0530
Message-ID: <20260813104236.1532-1-manushprajwal555@gmail.com>
X-Mailer: git-send-email 2.46.2.windows.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix "succesful" -> "successful" (x2) in the kernel-doc for
dmem_cgroup_region::ref and dmem_cgroup_try_charge(). No functional
change.

Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>
---
 kernel/cgroup/dmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4753a67d0f..342ea5324e 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -21,7 +21,7 @@
 struct dmem_cgroup_region {
 	/**
 	 * @ref: References keeping the region alive.
-	 * Keeps the region reference alive after a succesful RCU lookup.
+	 * Keeps the region reference alive after a successful RCU lookup.
 	 */
 	struct kref ref;
 
@@ -634,7 +634,7 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
  * dmem_cgroup_try_charge() - Try charging a new allocation to a region.
  * @region: dmem region to charge
  * @size: Size (in bytes) to charge.
- * @ret_pool: On succesfull allocation, the pool that is charged.
+ * @ret_pool: On successful allocation, the pool that is charged.
  * @ret_limit_pool: On a failed allocation, the limiting pool.
  *
  * This function charges the @region region for a size of @size bytes.
-- 
2.46.2.windows.1

