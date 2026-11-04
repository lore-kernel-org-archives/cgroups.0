Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793786002;
	b=nKT4QxyJkBwpBSzTPpAirJWlk/B3VyEOh/pxwCFl4+sCJzi92+5izxneFCGS1aDNUZOI
	 VOHBKly3QUf+8i4f0TC8bG+TxP29B/LSvmS5HPPSGutfa2/gkQ0hsG8gf8CMmfQnKt+mi
	 6FkM8QFAO/fDojBaCBPUo7pC8NuTuv+jOemd0HN6TGFKU4IBhUQH0RFKZcIHw1DhYhqwC
	 LIYOpBvFHhEg50k7S9Y9bx1JCegCIS118vZCG6vMfryUpvsMWJTs6RA7DeGCIunxh7vdI
	 D7phgk8guVhLpY98aADRJX0lgHK27MjE+yGJ02lYJ3wfNIHRNrp7HO5+pWdfCbTdd+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786002;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UBcVaAbLaeyK7MRE5ZU4PqnqGrSg6XSemL3qeOhiHzs=;
	b=gKIkAoDaq5po3KAay9CzFyJ5qo3qZ9TGM/1HsVBIxja+V5BtEfSKool4NFmmKaJjY6Ui
	 g4tfKJUAoz85PxNi7gYCFBHe8zFQ/C8V3wL0C4UrhLn7dk2i3w8EdUFFQ/U7aADZYzkGy
	 qd4HSjiUW72Bo9K1Zg/mLJPkxdvefWXeTyh8sAw6SqsemhIN0JghafWWISQUQuvIVSjr7
	 8JuZ4O30ARiBW6FMFk6jBNU6LsdPAs/xeARupWkhpiNkrdJtC6YSn9jr+M5vFcIxu2YbP
	 RgCVfwJqQEfifHybWX5kMQrZayVHqydtptgu3edQUl/84tgLMwm3ePgW4tPplS7s6jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=MwetI8vy;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0648606A326;
	Wed,  4 Nov 2026 09:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0648606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=MwetI8vy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=MwetI8vy9oPzQgv3cP54vIJQxWkTWz87x9obfeha0JO9FxMxt90SjcnoPXU6SvpqMblM/xyT3coof
	 7C6Ne1lYAzxtYDUciVJ+MfKG3LpiELgg1qFQMeZ/uj/IqqigdvbDPkPwTycHfIkt7DFSqd1u7fhMwP
	 QoA9o3BwsxdRZors=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66aeb008f096-698a1;
	Wed, 04 Nov 2026 17:53:19 +0800 (CST)
X-RM-TRANSID:2ee66aeb008f096-698a1
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36aeb008df34-1a091;
	Wed, 04 Nov 2026 17:53:19 +0800 (CST)
X-RM-TRANSID:2ee36aeb008df34-1a091
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] selftests/cgroup: test_zswap: check malloc() return value
Date: Wed,  4 Nov 2026 17:53:15 +0800
Message-ID: <20261104095315.2326-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_no_invasive_cgroup_shrink() uses zw_allocation immediately
after malloc() without checking for allocation failure.

Check for NULL before accessing the buffer and use the existing
cleanup path to report test failure, matching the handling of
wb_allocation later in the function.

Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index d50acc1b83ac..abe2e4954c71 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -503,6 +503,8 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_enter_current(zw_group))
 		goto out;
 	zw_allocation = malloc(allocation_size);
+	if (!zw_allocation)
+		goto out;
 	for (int i = 0; i < nr_pages; i++) {
 		off = (unsigned long)i * page_size;
 		memset(&zw_allocation[off], 0, page_size);
-- 
2.50.1.windows.1



