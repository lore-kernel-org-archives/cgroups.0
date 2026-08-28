Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1155135975
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787953994; cv=none; b=Lq1xXp/zvGwquPobr/RPlsC0gfsnYzX7CnNz6/Kf2rUpRfIEk7x7j0+B6EHvqBlsvHMSMhEt4XPlEEzOjKRzGXrwXEyi+f1D03nhNW9AzL2TLyvy3Pf1DrZYNhO3hZAhQPhWwrTpbq9O5Fb09z/8gGv+gPVjpL5incZGe6+CH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787953994; c=relaxed/simple;
	bh=ZbSKxgcvJNKCZb5NN2exAqDxafTIHVtkUQsS+TGA2ig=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GClhuyGg5cuAgi7GkRExa4k1rypU9vNCpegcVCby44nvg+Frik5T42sWH9GLOavr9yvWlmIBKyUJoMHeE+GCAGI/v8I3nviWeEi/CAmdeCx4SQs2xvR3kGAg6VqyoR3AxGzqnZlOFEJgLkCp8J/Wa6cb2Ev48Ifim5oVjqwKu2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--eperot.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pv7usd1g; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--eperot.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pv7usd1g"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3950b1371a7so2335371a91.2
        for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 14:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787953992; x=1788558792; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LONXRy8p8ypM84GZsyXqlc4REgdbXBjlmnbaUHr3UhQ=;
        b=pv7usd1gPlIzPLWjwN4LAVEB3U+8twYCEj5fH0+Cua96z0aFzyL6PGZBX9XDM2U75w
         uraXrWw9odHFyHK2xbgAoCc2/zLu0v+rniaEDro6ZMYjR+krU1QCpxAI/UNlIWGh5Rqx
         Y9RwC3J6j3TJaZ4c3KFUSMdPHXDmqp7cWdGZPzuPVCKr7Lcpj6IvAdIITntJHO8EY9Xu
         siBiKALVnnXTlQ5xu/7zJrwGsrEx9mxG6doXOLYJBJ0/vf6kxiOOR1Fi1HQpBV3Fsp6i
         8NaIPGRhr+wB1ltwiY7luQK0XSa64+zAZukv/3W+5/4YWinbLvwzO3A4IqJul13XuvUA
         FpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787953992; x=1788558792;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LONXRy8p8ypM84GZsyXqlc4REgdbXBjlmnbaUHr3UhQ=;
        b=T5EX2El1AaFD48sqVlNArtfabaXbpSl03a/bSOSqPFNxgM+6TLNeSediKxLgu5FWC7
         L9Gre3/xG7yGYkjCHX1yFVdBvBlooO7xQWni0QYVISNXVqQZ07CpAqPwlWt3k8/TlQmh
         S8F4/fzzmrPKYJSl9C8DdFFzfiIGqbJasQSk9QUOHoVD0+JbbC/kGI1libIiC8hMNWsq
         rIBco0u9cQKlWKUHF4gJK3/cQIAAfwD5gdl7xoZixIV+E8C64TAl1yNRPJplGiJ0F/eg
         Cno5u16CcYKTPHCSw1Cn0hE2mqlVSMBGgxmTI342dFZNjh9igoIwv8BL5E73tYAO45Rf
         Ot1g==
X-Forwarded-Encrypted: i=1; AKwUvBwNE+ze72BjbsKmIGnrp02tFxmLjaZNulzuk5vAaUGyKo0vdhk+CzURkzK6LHdjFB6do+Ko66kg@vger.kernel.org
X-Gm-Message-State: AFuF++nKbbVqTjilycEZHfij5uKNLXHk+KxUf9OnVBQ1pntCl7cAIGjt
	Rn+0gpPkQpnsrll50UOBvBFmFS/FjoKR1bF5vD0V7i0kcZr3mCR3+k3cEispwYiaQuzb3fJZmbJ
	cvWJIYw==
X-Received: from dykg9.prod.google.com ([2002:a05:7300:5789:b0:327:c2c1:f06f])
 (user=eperot job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56c7:b0:398:9bd4:d18
 with SMTP id 98e67ed59e1d1-3989bd41466mr3966381a91.23.1787953992182; Fri, 28
 Aug 2026 14:53:12 -0700 (PDT)
Date: Fri, 28 Aug 2026 21:52:52 +0000
In-Reply-To: <20260828215252.4126811-1-eperot@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260828215252.4126811-1-eperot@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260828215252.4126811-2-eperot@google.com>
Subject: [PATCH 2/2] selftests/cgroup: test clone3() into a previously killed cgroup
From: Etienne Perot <eperot@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Etienne Perot <eperot@google.com>
Content-Type: text/plain; charset="UTF-8"

Once cgroup.kill had been written to a cgroup, a stale kill_seq
snapshot (taken in cgroup_css_set_fork() before the target cgroup was
resolved) caused every child subsequently cloned into that cgroup with
clone3(CLONE_INTO_CGROUP) to be SIGKILLed on the spot.

Add a regression test: create a cgroup, kill it while it is empty,
then clone a child into it and check that the child runs and exits
cleanly. On a kernel without the fix, the test fails:

  not ok 4 test_cgkill_clone_into_killed

The test is skipped on kernels without clone3() or without
CLONE_INTO_CGROUP.

Cc: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: LLM
Signed-off-by: Etienne Perot <eperot@google.com>
---
 tools/testing/selftests/cgroup/test_kill.c | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index f6cd23a8ecc7..5ba8e285b2f3 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
 #include "kselftest.h"
@@ -261,6 +262,59 @@ static int test_cgkill_forkbomb(const char *root)
 	return ret;
 }
 
+/*
+ * Test that a cgroup that was killed in the past can still be the target
+ * of clone3(CLONE_INTO_CGROUP): writing cgroup.kill must only kill the
+ * tasks in the cgroup at the time of the write, not tasks cloned into
+ * it afterwards.
+ */
+static int test_cgkill_clone_into_killed(const char *root)
+{
+	pid_t pid;
+	int cgroup_fd = -EBADF;
+	int ret = KSFT_FAIL;
+	char *cgroup = NULL;
+
+	cgroup = cg_name(root, "cg_test_clone_into_killed");
+	if (!cgroup)
+		goto cleanup;
+
+	if (cg_create(cgroup))
+		goto cleanup;
+
+	/* Kill the cgroup while it is still empty. */
+	if (cg_write(cgroup, "cgroup.kill", "1"))
+		goto cleanup;
+
+	cgroup_fd = dirfd_open_opath(cgroup);
+	if (cgroup_fd < 0)
+		goto cleanup;
+
+	pid = clone_into_cgroup(cgroup_fd);
+	if (pid < 0) {
+		if (errno == ENOSYS)
+			ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	if (pid == 0)
+		exit(EXIT_SUCCESS);
+
+	/* The child must not be SIGKILLed; it has to exit cleanly. */
+	if (clone_reap(pid, WEXITED) != EXIT_SUCCESS)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (cgroup_fd >= 0)
+		close(cgroup_fd);
+	if (cgroup)
+		cg_destroy(cgroup);
+	free(cgroup);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct cgkill_test {
 	int (*fn)(const char *root);
@@ -269,6 +323,7 @@ struct cgkill_test {
 	T(test_cgkill_simple),
 	T(test_cgkill_tree),
 	T(test_cgkill_forkbomb),
+	T(test_cgkill_clone_into_killed),
 };
 #undef T
 
-- 
2.55.0.897.gb25b4bd76c-goog

