Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090371;
	b=E+MNXJUvcUNAJi8sgrH1oluq9lMPwSBdfMmpGwj4qpJbKdFn6eAIsqCRSPKi/0zqOgM8
	 kEw7aKU0LQIOH6VbNy9g9w6a3s9jw1AuOQCWZZLsuJZG9//wtPFPIISvRw0pYsio3UH0U
	 rfDGaAEgCMFO5fGjyulcp/KYIyIPuQty4KLi+vABaoR9uzEq6/psLCMHc1vibrY+T14wb
	 omFhuRFZ33PVnx2FBpW1R/VGAbg4YonaSPs8tK613xTCw5xTUgWHUZMsV2UkJWMZwU+VP
	 nmV7ROAQAMjCelB1HiWRk6jMq/uAlHyrdoNTZUdirz5fIn/DKDSdSPsFHaxv9bsRXlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090371;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1z6u6B82Pr3/hzW5YMWmMP5A7ww17vCOqXR2hKgLl9c=;
	b=NpOEk/eqMihyaRp6j4UeGVDPYljHxjF05eZ/Jd4hkrZJLz8WXV8vs4DymtraI5Zc/r1b
	 ZA9xjswA4MtOldvHA81eGS4vfvRMoWe9mDLXsLY8ndC0jHZ4B1Ky4x4hewTukvs44MBAW
	 w8CVO9jNVWnjAIpsF+yyBuvmtx+HIi8Dv0OUAHWvEcQeVw1dja+ZJpmUtT9ToNEz4BOB1
	 FTBRHkoPaZTcBfthd0u4Qv9WGVEYB1F0iVniIZ4F5dxcv6zXyIe1knzzUCMO+GhQE6g5r
	 5XXqKWfPWr43wupT5jNq/DV9OAkPTpX7kYMEyXWq0Kg5B5AncojI4jjhcpD+QRtjQrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oSdjbadH;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A596606A31F
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 08:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A596606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oSdjbadH
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdab6ae1ee9so772724a12.1
        for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 01:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793090371; x=1793695171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1z6u6B82Pr3/hzW5YMWmMP5A7ww17vCOqXR2hKgLl9c=;
        b=oSdjbadHGHjMx6m92nhrDQflhJGALNSv+UxevBBC5BaLg3+8GAsVik0aVme73SHE8e
         d7VUZ+GR2k3kyC9HFXLEIqrpRpT8zg/RxMPQv0r/jJTaYUrlE3uXhnmCnj+AQsDG451/
         EUquDDFPcdq6qZqoFf7XAZiE2S1fSQq94sAWA+YjIvjlvG4R8rUP1gl4GewWR+eTcg+L
         OtGcAodpql3gqVlUKiIZUEAUKBz0CjDDK3yDoW+LGSVmMlx/VNmlBpfb7w4bKu8+IiPC
         4WtlJxWpc2ZZ4v3TedSwMmtl0HIw83vBuq5/8Ns7+meabVHRc2PLmvpZ2V8O2tPhkRPW
         1fng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090371; x=1793695171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1z6u6B82Pr3/hzW5YMWmMP5A7ww17vCOqXR2hKgLl9c=;
        b=1bshftwLOCH8WJom6cWvD4xp173b27k3Fy87AjadhAOdZ/zEKZtQWm1uEI3fgv2Dbf
         JJx17Zlkk8esrmF2lt/a9lBWXpHbkuu3iQwyYSlgNPGnOF08Ue+pW1cQDXCznUKGJknf
         vA89xjnqMqFXEAhcqv1dM3ucBNznmswLxjqs3P0E8fVQ+3ho1uHj9Ivq19E/6PCbUU49
         q6XgGKUzAddN8uHn9okEz9pkXVFhLWIuDISAmp3bx5q3NqavKilNzDXWQhDzcLfP+NIM
         u2wlrX+glQ68oTSkUVUNaYsuybb4HwkLen6t0VNfuM079HnFRvLM7uxDpLtrHaJvEj2W
         7+yQ==
X-Forwarded-Encrypted: i=1; AKwUvBxu7tLy/TKFZ68qtsACZ4Ec6BdfNX9AEU3M9Yj2d0Sa/wIlWDYqa1CHVK5DAgUWbL/Iq4iANZyV@vger.kernel.org
X-Gm-Message-State: AFq9FYLFpMD6ZSCwDfrcTtMeaU7Cwy8XGqK4v+c86pv5/LNPiy4vJ32+
	sRuCfyCmX8LG91N6/jLC+FNHihiX3JY3+p59Q07iRFkzrhZz8ZbKfK7a
X-Gm-Gg: AYBFou02oh4KYP1a5f3+50OExP0YPLS7KN6tZ/HlLWH049hVJP/R0PhFDQWqEKcEHew
	D3pN/zJtROomFFoi/Jdn6AUVbUhE3rjmz2BJ992Kb4pHYP9EDpVAuoX2LfuSOWxvSW88/3CKOXF
	QfwQkZHuJMSc+o0MDj7eIJEIssXoXFicwZS98iaRZbJ1RIHrsxdgjDkd5x9Un0Hij+nNqONDg3I
	wvyVKFdYmfwul1FHOYsWYNM+iSmjFeGLBTASq8K5JbgWRNQBj7ePojGMcS3NvuBEh3cc5RBn7T3
	iz7FB7MSNTts29stXOfMviym4yMnfymlgdUr1sQBf1/orG4NRuyyzqwGFigAUSKGeVTIf8u+NeT
	y6CbsDNO8aNc0gnQDK7A/9PwwFya6sL63hZqmdDbCX9XOgnaHKkoZJ45MB/Xo0rH9TplRPSklbD
	61dS90py1F+dd8reX7IhtDF+brYDiN39vdYJ8D37EWD18w7+ZaSh5+8IVSk0yPvj9KsdIH7rb6h
	ceOK9MrwD6/aSu0siytAzk62ZJTukCKzstvON538MCaPGqFx43/ClY3U43Ivgjp7vP8Ornc
X-Received: by 2002:a17:90a:e18c:b0:3ad:3e8:12 with SMTP id 98e67ed59e1d1-3adeb126491mr6478782a91.48.1793090370681;
        Tue, 27 Oct 2026 01:39:30 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4041fafcsm3618951a91.0.2026.10.27.01.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 01:39:30 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@I-love.SAKURA.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH] selftests: cgroup: test memcg OOM on a process whose leader has exited
Date: Tue, 27 Oct 2026 16:39:23 +0800
Message-ID: <20261027083923.2412015-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
References: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

Moving a process whose thread group leader has exited leaves the leader
behind, so its live threads sit in the destination memcg with nothing
listed in cgroup.procs.  Check that an OOM there still kills the process.

Without "mm: memcontrol: don't miss processes whose leader has exited in
OOM scans" no task is selected and the test fails after five seconds.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 123 ++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..bddbe923fa42 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -4,6 +4,8 @@
 #include <linux/limits.h>
 #include <linux/oom.h>
 #include <fcntl.h>
+#include <sched.h>
+#include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -18,6 +20,7 @@
 #include <netdb.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <sys/sysinfo.h>
 
 #include "kselftest.h"
@@ -1417,6 +1420,125 @@ static bool memcg_sockets_disabled(void)
  * The TCP client interleaves reads from the socket with check whether
  * memory.current and memory.stat.sock are similar.
  */
+static int exited_leader_pipe[2];
+
+static int exited_leader_thread(void *arg)
+{
+	char c;
+
+	/* Wait until the process has been moved, then fill memory. */
+	if (read(exited_leader_pipe[0], &c, 1) == 1)
+		alloc_anon(NULL, (void *)MB(100));
+	for (;;)
+		pause();
+	return 0;
+}
+
+/* Start a thread and exit only the thread group leader. */
+static int exited_leader_fn(const char *cgroup, void *arg)
+{
+	const size_t stack_size = 64 * 1024;
+	char *stack = malloc(stack_size);
+
+	if (!stack)
+		return EXIT_FAILURE;
+
+	if (clone(exited_leader_thread, stack + stack_size,
+		  CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND |
+		  CLONE_THREAD | CLONE_SYSVSEM, NULL) < 0)
+		return EXIT_FAILURE;
+
+	syscall(SYS_exit, 0);
+	return EXIT_FAILURE;
+}
+
+/*
+ * Moving a process whose leader has exited leaves the leader behind, so
+ * the destination's cgroup.procs is empty.  Check that the destination's
+ * OOM killer still finds the process using its memory.
+ */
+static int test_memcg_oom_exited_leader(const char *root)
+{
+	char *parent = NULL, *src = NULL, *dst = NULL;
+	int ret = KSFT_FAIL;
+	pid_t pid = -ESRCH;
+	int i;
+
+	if (pipe(exited_leader_pipe))
+		return KSFT_FAIL;
+
+	parent = cg_name(root, "memcg_test_exited_leader");
+	if (!parent)
+		goto cleanup;
+	src = cg_name(parent, "src");
+	if (!src)
+		goto cleanup;
+	dst = cg_name(parent, "dst");
+	if (!dst)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+	if (cg_create(src) || cg_create(dst))
+		goto cleanup;
+	if (cg_write(dst, "memory.max", "30M"))
+		goto cleanup;
+	if (cg_write(dst, "memory.swap.max", "0"))
+		goto cleanup;
+
+	pid = cg_run_nowait(src, exited_leader_fn, NULL);
+	if (pid < 0)
+		goto cleanup;
+
+	for (i = 0; i < 100; i++) {
+		if (!proc_read_strstr(pid, false, "stat", ") Z "))
+			break;
+		usleep(10000);
+	}
+	if (i == 100)
+		goto cleanup;
+
+	/* The exited leader stays in src, the live thread moves. */
+	if (cg_enter(dst, pid))
+		goto cleanup;
+	if (cg_read_strcmp(dst, "cgroup.procs", ""))
+		goto cleanup;
+
+	if (write(exited_leader_pipe[1], "x", 1) != 1)
+		goto cleanup;
+
+	if (cg_read_key_long_poll(dst, "memory.events", "oom_kill ", 1,
+				  50, 100000) != 1)
+		goto cleanup;
+
+	if (cg_read_strcmp_wait(dst, "cgroup.events", "populated 0\n"))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (dst)
+		cg_write(dst, "cgroup.kill", "1");
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+	}
+	close(exited_leader_pipe[0]);
+	close(exited_leader_pipe[1]);
+	if (dst)
+		cg_destroy(dst);
+	if (src)
+		cg_destroy(src);
+	if (parent)
+		cg_destroy(parent);
+	free(dst);
+	free(src);
+	free(parent);
+	return ret;
+}
+
 static int test_memcg_sock(const char *root)
 {
 	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
@@ -1816,6 +1938,7 @@ struct memcg_test {
 	T(test_memcg_oom_group_leaf_events),
 	T(test_memcg_oom_group_parent_events),
 	T(test_memcg_oom_group_score_events),
+	T(test_memcg_oom_exited_leader),
 	T(test_memcg_inotify_delete_file),
 	T(test_memcg_inotify_delete_dir),
 };

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.43.0

