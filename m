Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29563515D2
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 05:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790401332; cv=none; b=IVsq2r2RP4sWfW5W8wWl4wtbwg+kz1TUh5AOC6TcZtc19B8w/EVoblWc9VYR79B4V0FmEhnPNmD+Bb/f8DKmqTufW1UqU48StruOCxyKH6GYceiDqq3yJxt82ZQKgdw/1hXEcXYyt9irFxDx5EjkCv7a96Lcudo1fOyIBU0TA7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790401332; c=relaxed/simple;
	bh=ihSErNzL28dopbbYtQk6sfe08O6dP4QtdIBtZVb4Srg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X/egzkj6cMoKqc6jsAPV+hGpmooti3pMsk3axh8QldIPVHFqryDVyzZ84vkfChNrshx8m+YxJZaVF+jab8VzJg94xH+v+nVf3qpy9YoS26Pht8gkoXpNR/e9JG3HUgyelzmaZLeMAUe9oD40e5+my3CXJi6NzSWLV2hNKUHWf3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p1tx3DnV; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p1tx3DnV"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912e2406so7439145e9.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 22:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790401329; x=1791006129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=poMR+QoD4H3NHZQTFS1CZaPTIlu9qbIcYvmcDeHr1ig=;
        b=p1tx3DnVVwWjOFwADRo6uLbq1ztMJJ4/vjhUmWOw5FWhkmnAnw8pKPuIaTROtM/6Fe
         2z+LnIvYoACIncm62wZ4rqxahJ4YHayGVfRgcdfD8pbY//jl4G2NoRtDR3dtmv16OBBc
         wqtr8F8w60WpxiIztu3q4nYUyWW47BOGTx8g0FVeZz6qQ4VHJKNktPaa6GBLaQ7cSuqX
         k9XRG5wwzugG67nBG7QnLCvEM8UmY7HrsuhuTr/HvhtRnoUcZ99qpEwca6J+L2DuKEdV
         LngO1WtQwZD1sqN/mECpXJXw8GL1q8Mj5waqBzuGturUJtxF0lgOXWZKK/BC+uTWEdjX
         ESKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790401329; x=1791006129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=poMR+QoD4H3NHZQTFS1CZaPTIlu9qbIcYvmcDeHr1ig=;
        b=nh9BL+gNkFNoVK3MCjGIeg+XScnPCQALcJXFKdJdmnxHJGDIdF3LibAY+vliGYzqpV
         KBeAdq+eLCpcUbIBqHga77z3aNQizrRXuTgPpXCiv0ZL2fz8PTm6VJ1jPUTd589Aql7t
         TwttlIo+GqT8bgeE7PILn8eOK0UCk9E6KCw+f2oaBmSsE60hx6qg5ykG1Vk8XoMCgWBQ
         RglIp7BijDDIkYd0zAYdLJseb+pLBfrNaLvhfPnCd/NFtT4RpdE8JnURI1DJAoUKvzFV
         vDSt+9/8Hta0Wp1XODUhCHS6pu39xSWMS0mADOSHqhbxBHPcvmHMlpcKlOQPRNFKjuo1
         7jew==
X-Forwarded-Encrypted: i=1; AKwUvBzlhQ0HFbu7EiBkrbVXmPsnOu8Hm2CuhS7l/hd3BKjTv5hXBtoG+xO7elseQx1eUbKiDGcGE2is@vger.kernel.org
X-Gm-Message-State: AFuF++kUUTlbRXbrmu96XdTNUbmyGMU+hn3DMBVgtck96iDkgMBJ4MFJ
	5fKLXZ2ZwVsJKYGgMfmeWs/JctZi+3OzHZVn9l7QgzDba/C6xf1M2awI
X-Gm-Gg: AYBFou0FmK02eNjc0U5g+n5tpqN4n+6BUcAUrv3ywb2dy89iXDjuu2A04ZK/H3UFRwe
	DuE07o6Wnj8JhSgaTTALMYVV8NVQRl9KOas5HLWthLpAgHjqAi/wzXaUD5uJZ3wUszdKu1U8+ec
	UyD24KJ+n53DxTFJzF/YgO4J4RASSQRQsso+8UpH+ae6rtoACtiS0fr+LPTL+vRPIzEist4xKVn
	NtRPaKPbOhPVKdFgHnWZtPeyI+zkbEpwvLZYtFau9FWmCQpggcbzTvu/rY2EPT1FZRbPrmN7B3O
	Y8XScCfeFQ64fCfqgk268RW8n37vrSzyIDj1MCt4tECc1gw8Ja0h58qqkYozf3GlSF2Xrb1rUwC
	jOy0Yvkh+VDvKp41h40kKI/v+4xJfVWBLati48f+dwDoWSrMvtl3QQwDzrrLefGRu+JAZoTfanv
	dOB8C4tQ31XuvGqdcIwwdVfTdeVpNdLQvA8IsR1Yjm16/pnwrFJ56/zQZ8CcHGpL7GSV+lZqVzB
	F+Um3+hJABBhCn0BDV4J+NcxwfdAlCIpI/qlAJpSvDg
X-Received: by 2002:a05:600c:6986:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-49fe66d05d7mr126116765e9.8.1790401328777;
        Fri, 25 Sep 2026 22:42:08 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff065873csm104782365e9.2.2026.09.25.22.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 22:42:08 -0700 (PDT)
From: Sebastian Chlad <sebastianchlad@gmail.com>
X-Google-Original-From: Sebastian Chlad <sebastian.chlad@suse.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Sebastian Chlad <sebastian.chlad@suse.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: memcg: Don't hang in the inotify tests without IN_DELETE_SELF
Date: Sat, 26 Sep 2026 07:42:03 +0200
Message-ID: <20260926054205.28933-1-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
wait for IN_DELETE_SELF with a blocking read() on the inotify fd. On a
kernel that does not send IN_DELETE_SELF for kernfs files and
directories, the read() never returns and test_memcontrol hangs until
it is killed by the kselftest timeout. The remaining tests do not run
and no result is reported for the inotify tests.

Wait for the first event with poll() and a timeout. If IN_DELETE_SELF
does not arrive in time, report it and fail the test instead of
blocking, so that test_memcontrol completes and the remaining results
are reported.

Assisted-by: claude-opus-5-5
Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 27 ++++++++++++++++---
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..c00420acc9a1 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -11,6 +11,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include <sys/inotify.h>
+#include <poll.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <arpa/inet.h>
@@ -1655,10 +1656,20 @@ static int test_memcg_oom_group_score_events(const char *root)
 	return ret;
 }
 
+#define INOTIFY_TIMEOUT_MS 5000
+
 static int read_event(int inotify_fd, int expected_event, int expected_wd)
 {
+	struct pollfd pfd = { .fd = inotify_fd, .events = POLLIN };
 	struct inotify_event event;
 	ssize_t len = 0;
+	int ret;
+
+	ret = poll(&pfd, 1, INOTIFY_TIMEOUT_MS);
+	if (ret == 0)
+		return -ETIMEDOUT;
+	if (ret < 0)
+		return -1;
 
 	len = read(inotify_fd, &event, sizeof(event));
 	if (len < (ssize_t)sizeof(event))
@@ -1678,7 +1689,7 @@ static int test_memcg_inotify_delete_file(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd, wd, err;
 
 	memcg = cg_name(root, "memcg_test_0");
 
@@ -1701,7 +1712,11 @@ static int test_memcg_inotify_delete_file(const char *root)
 	free(memcg);
 	memcg = NULL;
 
-	if (read_event(fd, IN_DELETE_SELF, wd))
+	err = read_event(fd, IN_DELETE_SELF, wd);
+	if (err == -ETIMEDOUT)
+		fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
+			INOTIFY_TIMEOUT_MS);
+	if (err)
 		goto cleanup;
 
 	if (read_event(fd, IN_IGNORED, wd))
@@ -1723,7 +1738,7 @@ static int test_memcg_inotify_delete_dir(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd, wd, err;
 
 	memcg = cg_name(root, "memcg_test_0");
 
@@ -1746,7 +1761,11 @@ static int test_memcg_inotify_delete_dir(const char *root)
 	free(memcg);
 	memcg = NULL;
 
-	if (read_event(fd, IN_DELETE_SELF, wd))
+	err = read_event(fd, IN_DELETE_SELF, wd);
+	if (err == -ETIMEDOUT)
+		fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
+			INOTIFY_TIMEOUT_MS);
+	if (err)
 		goto cleanup;
 
 	if (read_event(fd, IN_IGNORED, wd))
-- 
2.51.0

