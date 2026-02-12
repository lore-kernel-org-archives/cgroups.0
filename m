Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F5A35DD1B
	for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 21:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933521; cv=none; b=sJIFJiCTZrvzJ35jw1CTewjMoon8s8ctI5UwCsTho6dLi4GI8/IovVrj6B9fNPvmey+++wYpvrt4Uf8vN1GWQE0FBNLZ5muRi5yRkSGQO5m6ZrRPsy/GzGPU0s7Tf1hst4ukWx2K4bCe8gY+0XUdn5LEj1UbnYc/0CpsOF6alUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933521; c=relaxed/simple;
	bh=ezbBm/Tq1NbOZNYchfM5BrbiYJXHM46rp75jJpESgIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YoHnVMy+i2g1ujpH2MXu+KqRDwOFyUMWxf2KUK3+Y8jed2yn2uLvpZqXg7lPWtT6C1PU4h3HLGB+7M0MVxCuuqQNRH6UgjqVVDN6AQB0w7W8pFSkbAb4AYpctkhW15315Gp2CH+LdnDph95yixPL7GjGSkE8h9B3Y5ZXaQOXy8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cwnua99f; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cwnua99f"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso260514a91.2
        for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 13:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770933518; x=1771538318; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/49beE9xrDbjk2PTkq3bWwQqpKtfvuvBtaf8t9tZ8yg=;
        b=cwnua99fB0+vvZARrjQFt2miVg+prGDbN9oZs8jB2HxK+GLIItGcsZ8RhBu0tPl5Ks
         FwIjMBKXn6hfVVGCPeSN4XD4fBLobGDf+RXFLP9RyiD6hH+eQWCAZXWWPJYge0aCUHN0
         mVwaUY/03pV5wEs7VH7a4him0RbU2HiSifwQOszre/RrgNqXXsI0Hvu0b8wLkQRvON9a
         jE1v3Ar8l2WQdbFahdVVRJwuiSR3quYjEz/GgfxXoB0vcpz6tA1M/3B6Oq4bp1BMK4I9
         4yjZZxZc1tsLwWEZLNtv4o553Wa6kjv3pXWWXb8uzmKPKoGQpN+MBaT5/9vdrofO4EpN
         yrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770933518; x=1771538318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/49beE9xrDbjk2PTkq3bWwQqpKtfvuvBtaf8t9tZ8yg=;
        b=ucIzgEId7Nndesu7dqTfZ/q+6TKFUra0zytQdySxJ53sh0SngAMkIltEJ/SBgmE0fi
         xeATEaeeb+HxxAw2G7Uy1/dwGW4rf4kyDsBOw5+1Ac0E1k8QlBqucoECRqtjiR6bFEbN
         Z9ipG0xN7l9axUiaUhdxMZBkUckaaXjCNke4Yj6N//SFnaH/sVif6Sh9MEiApPq0w59D
         kMwZP+XKdwmQyScA0B2zfEysFGCw+d4xPMO/gSxX8twx8jLnPp9AhTKKVYKB6lo0NwqN
         ZhvwnNYY8Fo89W4Kpsz+E0djWSgY300cbPMjxenjfuQR2xM5kuk5wj4IWRMTvUge2gLi
         bfTA==
X-Forwarded-Encrypted: i=1; AJvYcCV60icKPNcqJ+MEwE2GCCBi+MZ4DRNt6t66I0AG5uigadPIucdsALsgX7x8vOITIV+xm0dbAA1C@vger.kernel.org
X-Gm-Message-State: AOJu0YwWjN7ds3TJHuuiwtMmDg/pq9yzhIgnQp/2EMhtVxzwTUP5Xm+T
	5hf0JgX4z+I83iNWCAWSxQn1/zhVkZVexEdD4xdIj518gBdsKdc3SmDvtu9awtZQBjLO/gFJxGn
	+6WniYYp+M2yK6n8Ujw==
X-Received: from pjbqx6.prod.google.com ([2002:a17:90b:3e46:b0:354:c41d:dd42])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:544e:b0:356:268e:ff97 with SMTP id 98e67ed59e1d1-356a792ab7fmr512870a91.20.1770933517978;
 Thu, 12 Feb 2026 13:58:37 -0800 (PST)
Date: Thu, 12 Feb 2026 13:58:14 -0800
In-Reply-To: <20260212215814.629709-1-tjmercier@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212215814.629709-1-tjmercier@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260212215814.629709-4-tjmercier@google.com>
Subject: [PATCH v2 3/3] selftests: memcg: Add tests IN_DELETE_SELF and
 IN_IGNORED on memory.events
From: "T.J. Mercier" <tjmercier@google.com>
To: gregkh@linuxfoundation.org, tj@kernel.org, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: "T.J. Mercier" <tjmercier@google.com>
Content-Type: text/plain; charset="UTF-8"

Add two new tests that verify inotify events are sent when memcg files
are removed.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 122 ++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 4e1647568c5b..be0e78809494 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -10,6 +10,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
+#include <sys/inotify.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <arpa/inet.h>
@@ -1625,6 +1626,125 @@ static int test_memcg_oom_group_score_events(const char *root)
 	return ret;
 }
 
+static int read_event(int inotify_fd, int expected_event, int expected_wd)
+{
+	struct inotify_event event;
+	ssize_t len = 0;
+
+	len = read(inotify_fd, &event, sizeof(event));
+	if (len < (ssize_t)sizeof(event))
+		return -1;
+
+	if (event.mask != expected_event || event.wd != expected_wd) {
+		fprintf(stderr,
+			"event does not match expected values: mask %d (expected %d) wd %d (expected %d)\n",
+			event.mask, expected_event, event.wd, expected_wd);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int test_memcg_inotify_delete_file(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *memcg, *child_memcg;
+	int fd, wd;
+
+	memcg = cg_name(root, "memcg_test_0");
+
+	if (!memcg)
+		goto cleanup;
+
+	if (cg_create(memcg))
+		goto cleanup;
+
+	if (cg_write(memcg, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+
+	child_memcg = cg_name(memcg, "child");
+	if (!child_memcg)
+		goto cleanup;
+
+	if (cg_create(child_memcg))
+		goto cleanup;
+
+	fd = inotify_init1(0);
+	if (fd == -1)
+		goto cleanup;
+
+	wd = inotify_add_watch(fd, cg_control(child_memcg, "memory.events"), IN_DELETE_SELF);
+	if (wd == -1)
+		goto cleanup;
+
+	cg_write(memcg, "cgroup.subtree_control", "-memory");
+
+	if (read_event(fd, IN_DELETE_SELF, wd))
+		goto cleanup;
+
+	if (read_event(fd, IN_IGNORED, wd))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	if (child_memcg)
+		cg_destroy(child_memcg);
+	free(child_memcg);
+	if (memcg)
+		cg_destroy(memcg);
+	free(memcg);
+
+	return ret;
+}
+
+static int test_memcg_inotify_delete_rmdir(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *memcg;
+	int fd, wd;
+
+	memcg = cg_name(root, "memcg_test_0");
+
+	if (!memcg)
+		goto cleanup;
+
+	if (cg_create(memcg))
+		goto cleanup;
+
+	fd = inotify_init1(0);
+	if (fd == -1)
+		goto cleanup;
+
+	wd = inotify_add_watch(fd, cg_control(memcg, "memory.events"), IN_DELETE_SELF);
+	if (wd == -1)
+		goto cleanup;
+
+	if (cg_destroy(memcg))
+		goto cleanup;
+	free(memcg);
+	memcg = NULL;
+
+	if (read_event(fd, IN_DELETE_SELF, wd))
+		goto cleanup;
+
+	if (read_event(fd, IN_IGNORED, wd))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	if (memcg)
+		cg_destroy(memcg);
+	free(memcg);
+
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct memcg_test {
 	int (*fn)(const char *root);
@@ -1644,6 +1764,8 @@ struct memcg_test {
 	T(test_memcg_oom_group_leaf_events),
 	T(test_memcg_oom_group_parent_events),
 	T(test_memcg_oom_group_score_events),
+	T(test_memcg_inotify_delete_file),
+	T(test_memcg_inotify_delete_rmdir),
 };
 #undef T
 
-- 
2.53.0.273.g2a3d683680-goog

