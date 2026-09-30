Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68AD2E888A
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 06:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790748216; cv=none; b=dxC8JlZlqqoZbMqfpyTY8x4HsOVOBJNmMQn+74H8kqZb6RgQSPX8Ro6EuSuTDGujH6h4yR8onVUhF0X9hogaaLIMuFjwCrl53pLM92lDyPoIMCncnRYa1X4N1+L22ypHeuCpguOW4+AGXI0qTbDD5nNDk1HE77oToY6legtLI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790748216; c=relaxed/simple;
	bh=axdDbCUJzEf1U4BkmExcoQBin+GjinUVGoYj1DB4yNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XiTnvArsezTW7DSd/T4TUsFoduVJ2PEeCXdLgSqgLxWWBhPVpK7JEjMUlC+pBBF/G2/6tPzsvfCxz3YtbNRQP1Wy5tJBH2sgoKEYT7Vjp9MYF47oW1wJlJIFmtQa2162ZPopZcGyGvVyOE/UVHEwo/htjI7apkuNT9coEyi/KRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sKQIjK45; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sKQIjK45"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f066d8so13225385ad.1
        for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 23:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790748214; x=1791353014; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x3ttmE9X6/fAonyMgTPG4YUEsTGdFYYGeA/sfbV45M8=;
        b=sKQIjK45wPoS1dNuHPFH3ByFc5m6coPbzzQAuc8gEFd7k6yOoXmNJKc9FsXk6PMS88
         Mzqqgqx4i/UuNZr2Lc4dpqOJg8Ht18WmpkHl+1jwZ7j2601gMNWeSyP0ZRlOC7b7ZGVV
         E4P+yLuNZLVBwj5+o1RLqzOCVZFT8usKP7Sac2j2GaPjgZc2JApop1JrTKLRgK7B+HLX
         WE/Z8xke+gtBJBUEm8LEOxbHjnldneWHVvqKStMkdE2if+kQUbPzaV8rZJ/YUUXBDHUN
         V2XWJkxrL3ZOngYhNS18GJPZGazNobY/mlITvBgD8ge+0cIJ1FdEYGVv/I4aub/eakDc
         TZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790748214; x=1791353014;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x3ttmE9X6/fAonyMgTPG4YUEsTGdFYYGeA/sfbV45M8=;
        b=w8KDs5DAOdkY6y7wS8pWeIt6qWymoBo7WIsSnc5y3zs2LNjwcXViD1Ln2wX8f50FS1
         0IpeQ2aRxxuRIwrJuobLdWjK+DrKKEI8Rmbft0nQ4r46xOCDv19glNwfBBmLu/oeN8jB
         oB6vHfl7vhlUfzMsJX/JIiCTzs0deUTnNovJ+AndBDAKBp3oyAt9Up64sDKVhBbolXvP
         yWIpFrlzU0GPOaWE+mrWPV+AMqO+5ZcG4xwEOXl9dhw8Kd4NHM1tcUtkRK6inhT/ply7
         NKQvB0CfofCZbwM2nlFqryAwBkYPa8FJ0llro3bUKuapFAgZSVXjNZbI7Fd4mGHqnCiP
         w05A==
X-Forwarded-Encrypted: i=1; AKwUvBw9OluQ0YPeY5PP8S4ypbSEnEbh2hk18eEtUTeGeoTjIM9j0uDCbPqBNbI1jSa60b8u1gtTt6Z3@vger.kernel.org
X-Gm-Message-State: AFq9FYKQ5onjey2xhqlk8WAebtu9XJ379Elzx0wsBsjITuwOSz/JWm1z
	krilSMl6DhADmhZY731BMJX2z0eTexuVE6sUDTPpPeqxtIt+xLQITZGq
X-Gm-Gg: AYBFou2iHdCNnojKu47NIv5aQtoUP4L+6lPLvQxsVFBYVpELBpv0H9/DnkKFaSLuP6P
	g/cHfvsH4wA98wvk8iyF8KAGX/dnvvUJzyxWiAvZyVJ3WD1d6Dl77nUmjeRBRa0w51lUlxu8uDo
	YDw3aBI/Xk1hvhcRTDcCy9vYt5xJ7GBZG5nPizlzb5PvGNfKLX2NmUMdaBJx5w0UFJUEzgrwUAZ
	HLXqcoQcNcwjoIVQBvAQZ3TbSjnTYsxrwa4Q9QwI2gbB4ZTH84kktgdFceTfSkZHXTgecoXE5yr
	QXeIAifRRysQw69dVVywIe/gFTxVZgTHZ88DYRo1ehY17Ta9/vKR0sOWtAX2Nz+HSWEbLdjwldQ
	m7YQysQwtllK0ZhCWIpWYd9UNhxEQrW1pr8z9lbL98EkW3/GvhwskIaOfyAlPuLCZqkaOUiQ4Vy
	X2UYbj5CtiEkaM/3EPNsihn4nQ04mjqrfnJdp5oMtQWzgu0/qnS4YTpYIsRpHziBEjU4XF0e+IF
	es=
X-Received: by 2002:a17:903:2947:b0:2e2:d3ef:125 with SMTP id d9443c01a7336-2e2e4edf4a8mr1557185ad.5.1790748213905;
        Tue, 29 Sep 2026 23:03:33 -0700 (PDT)
Received: from omarchy ([2404:7a81:bb40:2400:e077:4928:9847:63b3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e2e5c39578sm1465025ad.76.2026.09.29.23.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 23:03:33 -0700 (PDT)
From: Ren Tamura <ren.tamura.oss@gmail.com>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	void@manifault.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: cgroup: enable the cpu controller in test_cpu
Date: Wed, 30 Sep 2026 15:03:24 +0900
Message-ID: <179074810117.139422.8287518907118199923@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

test_cpu uses cg_read_strstr() to check for "cpu" in the root cgroup's
cgroup.subtree_control. The substring also matches "cpuset", so a
hierarchy with only cpuset enabled skips writing "+cpu" during setup.

The tests then run without the required controller enabled and report
failures. When cpu is unavailable in that hierarchy, the suite also
reports failures instead of skipping.

Always write "+cpu" during setup and skip if the write fails. Enabling a
controller that is already enabled is a no-op, so a separate presence
check is unnecessary. This requires write access to
cgroup.subtree_control even when cpu is already enabled.

Fixes: 820a4f88ee46 ("cgroup: Add new test_cpu.c test suite in cgroup selftests")
Assisted-by: LLM
Signed-off-by: Ren Tamura <ren.tamura.oss@gmail.com>
---
Validation (2026-09-24, mainline 62f4c998b297): ran the full, unfiltered
test_cpu binary as root on a freshly built mainline kernel in a
four-vCPU KVM guest. With only cpuset enabled, the original reports two
passes and seven failures; the modified binary passes all nine tests.
With cpu already enabled, both pass all nine tests in the comparison
with vCPUs pinned to separate physical cores. With cpu disabled at boot
and only cpuset enabled, the original reports test failures while the
modified binary skips with exit status 4.

The guest validation used a writable root cgroup.

LLM assistance: finding small cgroup fixes, drafting code and commit
messages, and preparing validation.

 tools/testing/selftests/cgroup/test_cpu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 735a53bb222ba98812d5c6ace221c3154362d859..3456e3e988c68aa6105a0d862fdc51fa0cb10d6a 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -835,9 +835,8 @@ int main(int argc, char *argv[])
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-	if (cg_read_strstr(root, "cgroup.subtree_control", "cpu"))
-		if (cg_write(root, "cgroup.subtree_control", "+cpu"))
-			ksft_exit_skip("Failed to set cpu controller\n");
+	if (cg_write(root, "cgroup.subtree_control", "+cpu"))
+		ksft_exit_skip("Failed to set cpu controller\n");
 
 	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {

base-commit: 551c722f40809618230001baccf219193e22fc5a
