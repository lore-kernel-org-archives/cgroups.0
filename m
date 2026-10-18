Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4D04DE736
	for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 22:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792361103; cv=none; b=EMy3motZBKmAcjoI4dhokyjB5Y6UMrE0Z/JVQw4tm5nUpq1VcqPcg9hluJv/08uWGsg749AMHefdUgmFIFMamJyMZ7XMg7WBcmTpW6Q6bDLdkY9HR2p6Bm2xCFNKI/5l9agWmCWVgw++lhUfpx/Baafmz77met95p6dsaJQyCnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792361103; c=relaxed/simple;
	bh=zauIoj7DYdW8cMWaD329FhY6axNzTzIKJHEYCxLohYM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Wb/6A3rdd9LSYjRvMPikksATrXa/+w60q8nzbimVvURsvAgxij8ck/9YJ4Gs89yjOR2FH8muMh8vRg0w8Xc+3aYy93OoS+bIJ5qlC/XyYvVA5S5Ue6s9LntXr0KehrwKB0cyOAPUYJD5bmIM4dvm7bJ86lLKzwdBRv6SChay4nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Erl9pUtG; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Erl9pUtG"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e5378b281aso6167075ad.2
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 15:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792361102; x=1792965902; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=opmL3UHh7n4QvgHM+DCxITPrZJqwJ9zUZp8DhzIayMY=;
        b=Erl9pUtG+JFjchQdrPI3imxixQezaW07VnxUEFtvWFAuzkxX9boSS2oJFsNUiJhdcr
         xmVAdBPhU4cxSEB0X3meh2aOE0XeqpYUyizHLDo299WC0IlMgNPU5WTt/ihK5V2+FUjl
         X8DfgkyBvXbGdIFQRnilTcrIuo2wMEZhj7BzkVktC1XOtNP/bMdi/GwI0m0f90Uy2DP0
         1RcOxztzPVcTBfF60E/Otdd5VkXrhL8HajLt9pt7iSpWaNAwIpyPRdnsWXKvDEA/8KpW
         abTopu9BMOAiAJ5eJ0Q69Hzowh7Yj06hc4r+fuTYxh62s6Dt7ZIteAeM3MY18wuFxI9k
         ms9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792361102; x=1792965902;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=opmL3UHh7n4QvgHM+DCxITPrZJqwJ9zUZp8DhzIayMY=;
        b=rsePBAzlaEemCOUfq55+u/fasXygfFJwk1/puVyxhY1NbMXbhiptEbfMOhfr6W+DaX
         LELpSYtFza0dMxgkatQuW4Qo4nsGgCPt81cbiSKjoP4qJ55XzFstSLQ70tMxenM1EWNm
         mZHy04FK1SioPmUMM8FBnwDfN+Ixk9uPGNR2IX9dDdR9pS6viXUFTn1Q0OvbMVe01GrW
         uKc9Lo3XaNwFyrsujzbYsnEI4QAK3GnJualCkK8+sjuhhXWGOSSTbFWp6gapVcYdfpuk
         BkQ4kp+FLYfZ41sPeptVVlDKXd7VnYfL910KuJihXHpMdJYF+isihzfvqQ1Bbe4caR22
         Z2Xw==
X-Forwarded-Encrypted: i=1; AKwUvByQ3cThjIJO3NCYBDtPfV1nrSgvS5e7XNYY89hX0FWwm4Q09tPQ/gXdf6rg3ZzMmGBVH/jrIjvw@vger.kernel.org
X-Gm-Message-State: AFq9FYL7hvSClSVsqCFNRi664dezniK4wFweMy+VakbyfycF9kCnn9dU
	Y0mAWg3dfg4JbzF9ACHUnWGOyZ4vS81rtdt0k9aaAkI6oDoYgN87beYN
X-Gm-Gg: AYBFou1BXywNyzb2AYs7oAw/+c04T5Eba/rkjsjRtIkR7Qg0hMjwOjOu088/Ck/teeD
	zagiS+QdhpY7M9jKTKI4xc0WvgZ40OtFkrHCgbANzEXvLz+B6k6q1yIhv5lQiVEU3roFpVpFz1y
	qIqDO0Y4RFErkazlQP+0yx6aev75e2TsnpY5XV71f+CbsKAzLOdF/5btb9544/tSU64ffB5peQQ
	6n/LyX45fdaEKJkDv3Rr/TE2iGfgg9kuhQhnyMFoaynsuESo1ubRPw8NQ8L/CWl7E0BTtg8LmqW
	cpzzls7q2lD4neAAa0MISxaTUzAIayPIXg1jeJNb0YZqsYlO0cwzDpNwh20GHCnU21w9HPq3M+v
	XHKp8OfGvt16ah/cJ1gCF1GlfTBLvRF+9RKxgbecrgTYz9lBQJhxaETQx9KAxj/Zq+3PP4X7lPl
	o3uqurN5WIMUeT8oU9JkEh0ykGN0H7aTXdDfhBIWg6fFs7Fd/a0V3lb/YJOckOOFLEIVXTLw==
X-Received: by 2002:a17:90b:4ac6:b0:39d:efa9:cd1a with SMTP id 98e67ed59e1d1-3acee280e87mr5328078a91.4.1792361101759;
        Sun, 18 Oct 2026 15:05:01 -0700 (PDT)
Received: from [10.1.2.130] ([67.185.120.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac945e72c6sm17718271a91.5.2026.10.18.15.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 15:05:00 -0700 (PDT)
From: Kir Kolyshkin <kolyshkin@gmail.com>
Date: Sun, 18 Oct 2026 15:04:40 -0700
Subject: [PATCH 2/2] selftests/cgroup: test cgroup.kill with an exited
 thread group leader
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261018-cgroup-kill-exited-leader-v1-2-c71ad94c20cc@gmail.com>
References: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
In-Reply-To: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Serge Hallyn <serge@hallyn.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, 
 Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Kir Kolyshkin <kolyshkin@gmail.com>
X-Mailer: b4 0.14.3

Add two tests for cgroup.kill and a process whose thread group leader
has exited while another thread is still running:

 - test_cgkill_exited_leader kills the cgroup the process is in;
 - test_cgkill_exited_leader_migrated moves the remaining thread to
   another cgroup, where the process is not listed in cgroup.procs, and
   kills that cgroup.

Both check that the cgroup is no longer populated afterwards.

Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 tools/testing/selftests/cgroup/test_kill.c | 158 +++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index bac1ddd8cb94..756bc7193d4b 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -2,10 +2,13 @@
 
 #include <errno.h>
 #include <linux/limits.h>
+#include <sched.h>
+#include <signal.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/syscall.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <unistd.h>
@@ -315,6 +318,159 @@ static int test_cgkill_clone_into_killed(const char *root)
 	return ret;
 }
 
+static int sleep_forever(void *arg)
+{
+	for (;;)
+		pause();
+	return 0;
+}
+
+/*
+ * Start a thread and exit the main thread only, leaving behind a zombie
+ * thread group leader with a live thread.
+ */
+static int exit_leader_fn(const char *cgroup, void *arg)
+{
+	const size_t stack_size = 64 * 1024;
+	char *stack = malloc(stack_size);
+
+	if (!stack)
+		return EXIT_FAILURE;
+
+	if (clone(sleep_forever, stack + stack_size,
+		  CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND |
+		  CLONE_THREAD | CLONE_SYSVSEM, NULL) < 0)
+		return EXIT_FAILURE;
+
+	syscall(SYS_exit, 0);
+	return EXIT_FAILURE;
+}
+
+static int wait_for_zombie_leader(pid_t pid)
+{
+	int i;
+
+	for (i = 0; i < 100; i++) {
+		if (!proc_read_strstr(pid, false, "stat", ") Z "))
+			return 0;
+		usleep(10000);
+	}
+
+	return -1;
+}
+
+/*
+ * Test that cgroup.kill kills a process whose thread group leader has
+ * already exited while its other threads are still running.
+ */
+static int test_cgkill_exited_leader(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cgroup = NULL;
+	pid_t pid = -ESRCH;
+
+	cgroup = cg_name(root, "cg_test_exited_leader");
+	if (!cgroup)
+		goto cleanup;
+
+	if (cg_create(cgroup))
+		goto cleanup;
+
+	pid = cg_run_nowait(cgroup, exit_leader_fn, NULL);
+	if (pid < 0)
+		goto cleanup;
+
+	if (wait_for_zombie_leader(pid))
+		goto cleanup;
+
+	if (cg_read_strcmp(cgroup, "cgroup.events", "populated 1\n"))
+		goto cleanup;
+
+	if (cg_write(cgroup, "cgroup.kill", "1"))
+		goto cleanup;
+
+	if (cg_read_strcmp_wait(cgroup, "cgroup.events", "populated 0\n"))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		wait_for_pid(pid);
+	}
+	if (cgroup)
+		cg_destroy(cgroup);
+	free(cgroup);
+	return ret;
+}
+
+/*
+ * Test that cgroup.kill kills the threads of a process that were migrated
+ * to the cgroup after their thread group leader had exited, and so are
+ * not listed in its cgroup.procs.
+ */
+static int test_cgkill_exited_leader_migrated(const char *root)
+{
+	char *parent = NULL, *src = NULL, *dst = NULL;
+	int ret = KSFT_FAIL;
+	pid_t pid = -ESRCH;
+
+	parent = cg_name(root, "cg_test_exited_leader_migrated");
+	if (!parent)
+		goto cleanup;
+
+	src = cg_name(parent, "src");
+	if (!src)
+		goto cleanup;
+
+	dst = cg_name(parent, "dst");
+	if (!dst)
+		goto cleanup;
+
+	if (cg_create(parent) || cg_create(src) || cg_create(dst))
+		goto cleanup;
+
+	pid = cg_run_nowait(src, exit_leader_fn, NULL);
+	if (pid < 0)
+		goto cleanup;
+
+	if (wait_for_zombie_leader(pid))
+		goto cleanup;
+
+	/* The exiting leader stays behind, only the live thread is moved. */
+	if (cg_enter(dst, pid))
+		goto cleanup;
+
+	if (cg_read_strcmp(dst, "cgroup.events", "populated 1\n") ||
+	    cg_read_strcmp(dst, "cgroup.procs", ""))
+		goto cleanup;
+
+	if (cg_write(dst, "cgroup.kill", "1"))
+		goto cleanup;
+
+	if (cg_read_strcmp_wait(dst, "cgroup.events", "populated 0\n"))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		wait_for_pid(pid);
+	}
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
 #define T(x) { x, #x }
 struct cgkill_test {
 	int (*fn)(const char *root);
@@ -324,6 +480,8 @@ struct cgkill_test {
 	T(test_cgkill_tree),
 	T(test_cgkill_forkbomb),
 	T(test_cgkill_clone_into_killed),
+	T(test_cgkill_exited_leader),
+	T(test_cgkill_exited_leader_migrated),
 };
 #undef T
 

-- 
2.55.0

