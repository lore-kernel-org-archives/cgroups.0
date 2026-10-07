Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C6D403AF8
	for <cgroups@vger.kernel.org>; Wed,  7 Oct 2026 06:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354882; cv=none; b=LxU687PQniGM2rkEDi7Yf3bpeJPHNGQsMNMd4jki4hGvOoYjUWYDqDAqLJsNcwvhSGc7IcpqIx7YGv2V+O3n4fp8xog7dUaFH8ERQ2tBcM2f3r7wK3gaL3rY+nZGfs+JLm8scJZg9Z5zA9kPWhcMnO/tLfL+htv7nXLbfhDOxHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354882; c=relaxed/simple;
	bh=5gdYiXsdIEdmd5/adEl+CJE03b+Owzw4GAQ5g07E9QI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cPCANXP6jPEENs5+cxWSgtzOkHWYQWW6KIi4d/Erasq5/5F4MncjrrpPACO5cP2MfFmiZ14BJDK746SD9JmPPYqgeQOF2eCl0l2fmbFcUmDcQYl7HVr5PWdUcF22uwSFGwbQkQ2EmFKwJ0K5TKUXb+BZmUJONTeCTsz4m/zZk44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7MTs0WR; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7MTs0WR"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3a886d6ad51so841389a91.1
        for <cgroups@vger.kernel.org>; Tue, 06 Oct 2026 23:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791354880; x=1791959680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x8h3RxZtf4MBoLCdyCQWKGMghw8BxjoE7AErxA1MxGw=;
        b=e7MTs0WRyw4Lc9L624rjGdbRmwwKFUtFEBqWvYjK6q4ExnvLteIJ188fotb7EO5NWx
         S6ELQEp18HeY6Mrwo2H7DE8k6zhsJhcOz4U8YYmxnrnYgAuaPnRvWo0PE9ST6HYe+VO8
         kgvYCf55rCUcAULxtop/q2f7jvsJfNeaRmMRAAnEU5SmRuKqYtvj//rHJv4W+o1WBW91
         On0jqx70cs96T1wNPhvkrn2OysOyuZTAcaRD+OAkjQQ37PJMRqPPJXUfe/s46S6Ml5F/
         k8PrMfaryCvklGQaHxxz6M7eAbAO1MZJpWRFBd70UqfxD7537NLPniIuICx2y+nI1Pjl
         +c8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791354880; x=1791959680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x8h3RxZtf4MBoLCdyCQWKGMghw8BxjoE7AErxA1MxGw=;
        b=OZJMxTrPN4ejHv6hgd/MXnkqhr30OBmerdxf4gsazjGHomEjVdzIZegfCY9CdoQfAx
         OmqpiqAyWF+d9WgInduXVeJwZb7kgbbDGKD2t9ULNBF+91JBlqu0qHCesmEpRaPkvlqg
         VvuauZgcVBQR8XU5YXri1ZBHl+v+LD2oyLZU/Au172DcEh0EmYTGRUAM18o8Dl217OjB
         BB22UjCSi5iGw0vThmU32WaSVVRg6Vcq+TgRFoeVeh1jCNRl+eEVOj2pKZ8MBqdTN5zx
         HyjLoKlznChCp7CwkoVSATNURciI0JguWLRtLdxmJP+PEpbD/AO3H33Szfbr8quCo7+M
         eYIw==
X-Gm-Message-State: AFq9FYLbODmLOLJExy9+CX/q8+vnGM1MLLkbNhzZBrClZcRDjjxuFvJy
	1Gg9HpWxEr59iWeHzgXKWzw+e5W6L9w5k7TkS70lwHEcQkpcyBi/hhFF
X-Gm-Gg: AYBFou21ITsb2PCr3GMCxMozkXMwMe0+FcifzoJXHgRX/O1ZqkVLkmkxfZ+XzL7UAeT
	8akXU8oNOJslUQAXxPZiITX5IwTIBHU72/CWoan7YmbI0N4DWOUo/aoYEfWUHmBDijTWWvZeXWD
	ymP9rsNi2AOSYgaK0cOn+osmWUTeZc1SPZN8+ord3lLuzHQUH3Q6nllv+5fpQJ3aQ+bogWrr3RJ
	chTOcZ+WT2eGf7yAgvib1Dk/GDE8fy8PyGioChesE3lQaHleNvqCQ8STsPbA8UC1KJvAF5p3AGs
	cVEf5szRfQobU0KGHHQsBNM2VxvA+UUoF/6Igy9oPoGMjMXBHGRLOKsxiB7YrOMCMWMypbS8Tnm
	Xm26ivBuZjYWKOIc69r7pxySaUlJaPSAtSQ6vGbwvc6BE7EhU4z0x9MxUaRCx2pYQ6fBUX2JfgA
	nJ0A/a2Upp2+uMc3EgObLsXulCdse/ox5DlrCp2Pb8YyVL4gFTwsBX3gwqZk52zvFOIgxrsqo4z
	+yFuI6G1E0AmKRI40IxmHENuvxmuwNfdkTeQic=
X-Received: by 2002:a17:90b:2ccc:b0:3a8:d71:5fda with SMTP id 98e67ed59e1d1-3a8a1c3834amr1054901a91.63.1791354879691;
        Tue, 06 Oct 2026 23:34:39 -0700 (PDT)
Received: from obadmin-Precision-3680.atlascopco.group ([136.226.232.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89ab81320sm3029992a91.3.2026.10.06.23.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 23:34:39 -0700 (PDT)
From: Sahaj Chaudhari <sahaj123.sc@gmail.com>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/cgroup: test pids.events notification
Date: Wed,  7 Oct 2026 12:05:16 +0530
Message-ID: <20261007063516.1192279-1-sahaj123.sc@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify that a fork rejected by pids.max increments
pids.events and emits an IN_MODIFY notification.

Run the test in a temporary cgroup v2 hierarchy with
pids_localevents enabled.

Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
---
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 .../selftests/cgroup/test_pids_local_events.c | 139 ++++++++++++++++++
 3 files changed, 142 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_pids_local_events.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf070..0a00eaab14cb1 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -8,5 +8,6 @@ test_kill
 test_kmem
 test_memcontrol
 test_pids
+test_pids_local_events
 test_zswap
 wait_inotify
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189ac..e494487307418 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -16,6 +16,7 @@ TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_memcontrol
 TEST_GEN_PROGS += test_pids
+TEST_GEN_PROGS += test_pids_local_events
 TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
@@ -32,4 +33,5 @@ $(OUTPUT)/test_kill: $(LIBCGROUP_O)
 $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
+$(OUTPUT)/test_pids_local_events: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/test_pids_local_events.c b/tools/testing/selftests/cgroup/test_pids_local_events.c
new file mode 100644
index 0000000000000..fa501e2091873
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_pids_local_events.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/limits.h>
+#include <poll.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/inotify.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "cgroup_util.h"
+#include "kselftest.h"
+
+static int test_pids_events_notify(const char *root)
+{
+	union {
+		struct inotify_event align;
+		char bytes[sizeof(struct inotify_event) + NAME_MAX + 1];
+	} event_buf;
+	struct pollfd pfd;
+	char *cgroup = NULL, *events_path = NULL;
+	const char *reason = "pids.events did not notify after a rejected fork";
+	bool moved = false;
+	int inotify_fd = -1, ret = KSFT_FAIL, watch;
+	ssize_t n;
+	pid_t child;
+
+	cgroup = cg_name(root, "pids_local_events_notify");
+	if (!cgroup) {
+		reason = "failed to allocate cgroup path";
+		goto cleanup;
+	}
+	if (cg_create(cgroup)) {
+		reason = "failed to create test cgroup";
+		goto cleanup;
+	}
+	if (cg_write(cgroup, "pids.max", "1")) {
+		reason = "failed to set pids.max";
+		goto cleanup;
+	}
+
+	if (asprintf(&events_path, "%s/pids.events", cgroup) < 0) {
+		reason = "failed to allocate pids.events path";
+		goto cleanup;
+	}
+	inotify_fd = inotify_init1(IN_CLOEXEC | IN_NONBLOCK);
+	if (inotify_fd < 0) {
+		reason = "inotify_init1 failed";
+		goto cleanup;
+	}
+	watch = inotify_add_watch(inotify_fd, events_path, IN_MODIFY);
+	if (watch < 0) {
+		reason = "inotify_add_watch on pids.events failed";
+		goto cleanup;
+	}
+
+	if (cg_enter_current(cgroup)) {
+		reason = "failed to move test into cgroup";
+		goto cleanup;
+	}
+	moved = true;
+
+	child = fork();
+	if (child == 0)
+		_exit(0);
+	if (child > 0) {
+		waitpid(child, NULL, 0);
+		reason = "fork succeeded despite pids.max";
+		goto cleanup;
+	}
+	if (errno != EAGAIN) {
+		reason = "fork failed for a reason other than pids.max";
+		goto cleanup;
+	}
+
+	if (cg_read_key_long(cgroup, "pids.events", "max ") != 1) {
+		reason = "pids.events did not count the rejected fork";
+		goto cleanup;
+	}
+
+	pfd.fd = inotify_fd;
+	pfd.events = POLLIN;
+	if (poll(&pfd, 1, 1000) <= 0) {
+		reason = "timed out waiting for pids.events notification";
+		goto cleanup;
+	}
+	n = read(inotify_fd, event_buf.bytes, sizeof(event_buf.bytes));
+	if (n < sizeof(struct inotify_event) ||
+	    !(event_buf.align.mask & IN_MODIFY)) {
+		reason = "received no pids.events modify notification";
+		goto cleanup;
+	}
+	if (cg_read_key_long(cgroup, "pids.events", "max ") != 1) {
+		reason = "pids.events did not count the rejected fork";
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (inotify_fd >= 0)
+		close(inotify_fd);
+	if (moved)
+		cg_enter_current(root);
+	if (cgroup)
+		cg_destroy(cgroup);
+	free(events_path);
+	free(cgroup);
+	if (ret != KSFT_PASS)
+		ksft_print_msg("%s\n", reason);
+	return ret;
+}
+
+int main(void)
+{
+	char root[PATH_MAX];
+	int ret;
+
+	ksft_print_header();
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	if (proc_mount_contains("pids_localevents") <= 0)
+		ksft_exit_skip("mount cgroup2 with pids_localevents to run this test\n");
+	if (cg_read_strstr(root, "cgroup.controllers", "pids"))
+		ksft_exit_skip("pids controller isn't available\n");
+	if (cg_read_strstr(root, "cgroup.subtree_control", "pids") &&
+	    cg_write(root, "cgroup.subtree_control", "+pids"))
+		ksft_exit_skip("failed to enable pids controller\n");
+
+	ksft_set_plan(1);
+	ret = test_pids_events_notify(root);
+	ksft_test_result_report(ret, "pids.events notifies on a rejected fork\n");
+	ksft_finished();
+}
-- 
2.43.0

