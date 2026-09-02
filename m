Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A9639B48F
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378348; cv=none; b=MpdLGawxoNav3rH7FpajucW2Wnzm9ZkCiyTqyp4T1F0+06ewlzaOJsD1ScK2CF3FulDS9Ude7TEPbTI1DtIwr/qn6/WoYJUVEHmoMPHSFnUx+CBIiqBL0/AY2H9Xw17JMwrl+tdd+x1kHE4BxScNUm9bZDa9jyOgUFMA57yyjZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378348; c=relaxed/simple;
	bh=PjcBpfhFVcXBPs8lEnyLBI90MdqrLbOVRiz3lk594Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PFS2GYL2WkHxFsUdByc4VLxQnxn5vfW6J+Kz7j0QbmFTuBvoAPD/d4fuhMNDmVOmu80x0KIJfHdOKvQe04Hu/CchtKndbW7yCKG6ffhbDX1I1LoBcPpgdbjMBQyuBGC2wwrBKG2bxini9hu+z0UNr5axxJvI699HEFuBLuhCtd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ed8K/5eu; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ed8K/5eu"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7f4f3683fbcso300626a34.0
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788378327; x=1788983127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tGCfm32JlUmtMotIy6qoQBTUO4f6h2sqplyq+pgz4JI=;
        b=ed8K/5eu5N54pYlW86kpHWEmXBdqRL4I/g661BP+ZffYSTegORUEMu/hQLg1D9pXcX
         AszyDnE+CaJQ0DGY+yq6ANQypkLPvyPLT+wCHsz/d/aLrEouZ2lko6LNpPwMIVIcslL6
         8avPwqLTscz0unvjbgY1O+63fMY92TA/CihkdDaDaz8zdZZOzdHSgcPAnn+YVf6qJ3oL
         ND0OEmZQjqPFqRn4xBxTyNtLt27bc/EF9qy17dbDST3lZQb4EahDQejlZ2uXVunqSTiD
         3iaBC2P6jsQEgNJzyRa+buTy2tVZCczyONTTZHeosqV/gd+Twx0Sh+/B+CpirRSd6lYb
         4kag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378327; x=1788983127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tGCfm32JlUmtMotIy6qoQBTUO4f6h2sqplyq+pgz4JI=;
        b=ASKPlGUUWTFHeFJakt/Ro4APL+le2YGUUVw3p4xpZVAzG8YtgPk9afEyWMKtOJ8ppu
         CBDgAgDkWa2i/4XuJVZo9B9ZSSmvopkcHClkePTsCG2p9NFWJO9kH4lMDVzq9OmYUKYJ
         s52WiZVg4ZW/rVigKeJgy4u0orSKoTX43ZHRj32+2L+sqaow5M/cei7Iz1d4Lsqm0Uh7
         v8ft2UAewkQCXR6oKr541nOSkXKZJ8Pl36i/sBMxWeUFsGCBDrki11Xn+2Jxsir8BmGP
         Tak2eovudPLNIapbNkCbVhIvCOSRZkRxIwG7N7ioZaTfff5k9D8UWKy41j5naA4SF6Np
         8OyA==
X-Forwarded-Encrypted: i=1; AHgh+Rpc4ac7K+mFS3s85ejBUbqtrEEqX1Q9UUERAnLg0G/fjQV+UuzY9Q+RzlDA5wyiSz+Bss6G4tzA@vger.kernel.org
X-Gm-Message-State: AFuF++kjCuQoDyRCVqmnxdRCIaOFmay0eRfQdFr7WbRkAdFikvG5RyyO
	2oNolj1sc8gkzoJOE4TLDBC4UDnFF/75jhzDL4/L60X0hnWraos+lHuF
X-Gm-Gg: AR+sD11gh7ZDyeRnpsUCEHOgYLrfpiLuH0Ak+isX7BFNpN98v7HXkGHI+S8dCW9BBIR
	ScQV34aOil4gTne5x4OSaSmIdejjO36Bq2LVunJYILA+beDMjSwAxudCKXA8qqrtW/LV6wgyaKm
	xxcff7SbwS5XUOVEYZiZtVg3lDbK+wKP6oVIw9LpUr2ar7ok4BGGsd20jhhGvjUGF7sCs+Ku6PX
	6xsiwM2TNec/sOgB9gMQVm+GUUvmXIIP17pPELPIlZk0WUIwmYTqT/ukwVjhD6xsv0IyvDIj5gJ
	svOzoSCrTodbEbrmlJKp3WC0OUjOtE1rqVV1Isn4HXaKF2t2wskG4TsUHJrWQmoFSW4eL/ERzSZ
	FgiE+tTuJpg7qkAJ8gPoPBKOe7O+2Tj/jnRWdI5jVHINPr68utZ3/r7B7KRJ+SE1m94zCAWaJGo
	91Q+SXuoIZtLGsQGFl0EcAX7eT45dgTiPbPqxVksjJhk+FQG82msfR1ibNslUgHKas8kpgvlVuL
	st9JWo89oDDtPXvcsU=
X-Received: by 2002:a05:6830:488f:b0:7f4:3902:3a26 with SMTP id 46e09a7af769-7f899b8d376mr1482293a34.1.1788378322092;
        Wed, 02 Sep 2026 12:45:22 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:17::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f74f9ec644sm2999492a34.24.2026.09.02.12.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:45:21 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Krush Chavan <krushchavan@outlook.com>,
	"Chengming Zhou" <chengming.zhou@linux.dev>,
	"Tejun Heo" <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Shuah Khan" <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] selftests/cgroup: account for zswap shrinker writeback
Date: Wed,  2 Sep 2026 12:45:20 -0700
Message-ID: <20260902194521.3652178-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
has zswapped out more memory than memory.zswap.max, it does not
trigger writeback for other cgroups. To do this, it compares the
writeback count in a control cgroup and makes sure that it is 0,
and then checks the writeback count in an aggressor cgroup who does
expect to see writeback.

However, when the zswap shrinker is enabled, the victim cgroup can see
legitimate writebacks not triggered by the aggressor. In some Meta CI
tests, we have seen this failure mode happen.

Instead of checking that the victim cgroup has 0 writeback, compare the
writeback values before and after the aggressor runs and check that
the victim cgroup did not perform any additional writeback. Note that
this can still lead to probabilistic failures if writebacks take longer
than 5 seconds, but this should fix the systematic failure case.

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Reported-by: Krush Chavan <krushchavan@outlook.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Instead of skipping the test when the zswap shrinker is enabled,
  compare the victim's writeback counts before and after the aggressor
  runs, as Nhat suggested.

 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 9c5bd503c3f73..1ac7790727757 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -20,6 +20,7 @@ static int page_size;
 
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+#define PATH_ZSWAP_SHRINKER_ENABLED "/sys/module/zswap/parameters/shrinker_enabled"
 #define PATH_ZSWAP_STORED_PAGES "/sys/kernel/debug/zswap/stored_pages"
 
 static int read_int(const char *path, size_t *value)
@@ -446,6 +447,16 @@ static int test_zswap_writeback_disabled(const char *root)
 	return test_zswap_writeback(root, false);
 }
 
+static bool zswap_shrinker_enabled(void)
+{
+	char value[2];
+
+	if (read_text(PATH_ZSWAP_SHRINKER_ENABLED, value, sizeof(value)) <= 0)
+		return 0;
+
+	return value[0] == 'Y';
+}
+
 /*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
  * limit in zswap, writeback should affect only the zswapped pages of that
@@ -455,6 +466,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
 	unsigned int off;
+	long zswpwb_before, zswpwb_after, zswpwb_target;
 	size_t allocation_size = page_size * 1024;
 	unsigned int nr_pages = allocation_size / page_size;
 	char zswap_max_buf[32], mem_max_buf[32];
@@ -490,6 +502,14 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
+	/* If the shrinker is enabled, try to let the writebacks finish first */
+	if (zswap_shrinker_enabled())
+		sleep(5);
+
+	zswpwb_before = get_cg_wb_count(zw_group);
+	if (zswpwb_before < 0)
+		goto out;
+
 	/* Push wb_group memory into zswap with hard-to-compress data to trigger wb */
 	if (cg_enter_current(wb_group))
 		goto out;
@@ -502,9 +522,13 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 		getrandom(&wb_allocation[off], page_size/4, 0);
 	}
 
-	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
+	/* Verify that only zswapped memory from wb_group has been written back */
+	zswpwb_target = wait_for_writeback(wb_group, 5000);
+	zswpwb_after = get_cg_wb_count(zw_group);
+
+	if (zswpwb_target > 0 && zswpwb_before == zswpwb_after)
 		ret = KSFT_PASS;
+
 out:
 	cg_enter_current(root);
 	if (zw_group) {
-- 
2.53.0-Meta

