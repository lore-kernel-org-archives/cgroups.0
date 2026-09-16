Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3B4EA37A;
	Wed, 16 Sep 2026 11:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557364; cv=none; b=u6221xdoRbKMaWjvkV+5gYoFdClWCfFXzVr/12d0pDfWSw40cm9f8WKWq4dhlPj5hW6pU7zGltfwc5NNHcyGM5YvmzYNlh46unjNOg2TI4CFjl5FUx6Xq1+jeJ5lgTNLG1iNtA5S1dofD69c2aOa9oC8H8EJtzj/3BgRfLDMta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557364; c=relaxed/simple;
	bh=46veRo3f13r9EJbfzSR0yBrwbfSPZ+LfsURj0SMrUeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TLxHpHhoFxnJ+IYG9Bcdp/ihyW79NBZxvff2f3z0ts9mnV7jPRK9EVespLJMtAIPfNiLV99gfM/sHjlEOtomTMPzjps1c5fsKhLrqo6xnw+uK2QwZs6WQ9hEE9SdYxNRP345FKfolqgIVURCXdF1J3u9T4ATwnpttnZDIZRf03Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e90106f0b1bf11f19a56ed5b684f684d-20260916
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:97206f4a-25d4-4af2-b1c0-2ec4ad1d0486,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:97206f4a-25d4-4af2-b1c0-2ec4ad1d0486,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:23475718357aac7aa9d1062cacb463e6,BulkI
	D:260916191526FQT8CGIX,BulkQuantity:0,SF:10|38|66|78|102|127|865|898,TC:ni
	l,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e90106f0b1bf11f19a56ed5b684f684d-20260916
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 991811094; Wed, 16 Sep 2026 19:15:23 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [RFC PATCH] selftests/cgroup: Add a test for the /proc/self/cgroup namespace view
Date: Wed, 16 Sep 2026 19:14:45 +0800
Message-ID: <20260916111445.245788-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A cgroup namespace virtualizes /proc/$PID/cgroup: processes see cgroup
paths relative to the namespace root, and cgroups outside of that subtree
are reported with a "../" prefix.  This is documented in
Documentation/admin-guide/cgroup-v2.rst (section "Namespace"), but no
selftest checks the resulting view.

Add test_cgroupns, which checks the three documented cases on cgroup v2:

  - a process which unshares a cgroup namespace rooted at its own cgroup
    sees "0::/" even though its cgroup is below the real root,
  - after moving into a sub-cgroup of the namespace root it sees "0::/sub",
  - after moving into a sibling cgroup of the namespace root it sees
    "0::/../cg_ns_b".

The last case needs more than the one-way pipe the other two use: the
migration has to happen between the child's unshare(2) and its read of
/proc/self/cgroup, the parent cannot observe the unshare on its own, and
only the parent can do the migration - with the nsdelegate mount option,
which systemd uses by default, a process can only migrate tasks within
its own cgroup namespace, so the child cannot move itself out of its
namespace root.  The two sides therefore exchange three messages in both
directions, which is why this case uses a socketpair.

The test is skipped when cgroup v2 isn't mounted and when creating a cgroup
namespace is not permitted by the environment.

Sample output on a host with cgroup v2 mounted, with and without the
nsdelegate mount option:

  TAP version 13
  1..3
  ok 1 test_cgroupns_root_view
  ok 2 test_cgroupns_nested_view
  ok 3 test_cgroupns_sibling_cgroup_view
  # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
RFC.  This adds the missing selftest coverage for how /proc/$PID/cgroup is
rendered for cgroup namespaces: the behavior is documented in
Documentation/admin-guide/cgroup-v2.rst (section "Namespace"), but nothing
in tools/testing/selftests exercises it.

Two points I would like feedback on before asking for a merge:

  - The third case, a process moved into a sibling cgroup of its namespace
    root, needs the parent and the child to synchronize, which is about a
    third of the file.  Letting the child migrate itself after unsharing
    would remove most of that code, but with the nsdelegate mount option
    (which systemd sets by default) cgroup_procs_write_permission()
    rejects the migration with -ENOENT, so the test could only skip on
    exactly the setups where the behavior matters.  Keep the coverage and
    the synchronization, prefer the smaller test, or split the file into a
    basic-view patch and a boundary patch?

  - I kept the ksft_* style with a tests[] table which the other tests in
    this directory use.  If new tests should use kselftest_harness.h
    instead, I can switch.

This is an RFC, not a merge request yet.

 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   4 +-
 .../testing/selftests/cgroup/test_cgroupns.c  | 591 ++++++++++++++++++
 3 files changed, 595 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/cgroup/test_cgroupns.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf070..c04df79c41cd8 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+test_cgroupns
 test_core
 test_cpu
 test_cpuset
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189ac..4191f817f4f2f 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -7,7 +7,8 @@ TEST_FILES     := with_stress.sh
 TEST_PROGS     := test_stress.sh test_cpuset_prs.sh test_cpuset_v1_hp.sh
 TEST_GEN_FILES := wait_inotify
 # Keep the lists lexicographically sorted
-TEST_GEN_PROGS  = test_core
+TEST_GEN_PROGS  = test_cgroupns
+TEST_GEN_PROGS += test_core
 TEST_GEN_PROGS += test_cpu
 TEST_GEN_PROGS += test_cpuset
 TEST_GEN_PROGS += test_freezer
@@ -23,6 +24,7 @@ LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 include ../lib.mk
 include lib/libcgroup.mk
 
+$(OUTPUT)/test_cgroupns: $(LIBCGROUP_O)
 $(OUTPUT)/test_core: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/test_cgroupns.c b/tools/testing/selftests/cgroup/test_cgroupns.c
new file mode 100644
index 0000000000000..8711ccc5cda3f
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_cgroupns.c
@@ -0,0 +1,591 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <linux/limits.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <sched.h>
+#include <signal.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+#ifndef CLONE_NEWCGROUP
+#define CLONE_NEWCGROUP 0
+#endif
+
+/*
+ * Child exit codes used to report the outcome of the child's setup and
+ * the subsequent /proc/self/cgroup read back to the parent.
+ */
+enum cgns_child_exit {
+	CGNS_CHILD_OK		= 0,
+	CGNS_CHILD_SKIP		= 1,	/* unshare(CLONE_NEWCGROUP) not permitted */
+	CGNS_CHILD_FAIL_ENTER	= 2,
+	CGNS_CHILD_FAIL_UNSHARE	= 3,
+	CGNS_CHILD_FAIL_NESTED	= 4,	/* nested cg_enter_current() failed */
+	CGNS_CHILD_FAIL_READ	= 5,
+	CGNS_CHILD_FAIL_WRITE	= 6,
+	CGNS_CHILD_FAIL_SYNC	= 7,
+};
+
+/*
+ * Creating a cgroup namespace fails with EPERM if the caller lacks
+ * CAP_SYS_ADMIN in its user namespace and with ENOSPC once the cgroup
+ * namespace ucount limit is reached.  Neither indicates a bug in the code
+ * under test, so treat both as a test skip rather than a failure.
+ */
+static bool cgns_unshare_skip_errno(int err)
+{
+	return err == EPERM || err == ENOSPC;
+}
+
+/*
+ * cgns_report_child_exit - print why a child did not exit with
+ * CGNS_CHILD_OK.
+ *
+ * @code: exit code reported by the child
+ * @cgroup: cgroup the child was moving into
+ * @nested: nested cgroup the child was moving into; may be %NULL for
+ *	    callers which never move the child into a nested cgroup
+ */
+static void cgns_report_child_exit(int code, const char *cgroup,
+				   const char *nested)
+{
+	switch (code) {
+	case CGNS_CHILD_FAIL_ENTER:
+		ksft_print_msg("failed to move the child into %s\n", cgroup);
+		break;
+	case CGNS_CHILD_FAIL_UNSHARE:
+		ksft_print_msg("unshare(CLONE_NEWCGROUP) failed\n");
+		break;
+	case CGNS_CHILD_FAIL_NESTED:
+		ksft_print_msg("failed to move the child into %s\n", nested);
+		break;
+	case CGNS_CHILD_FAIL_READ:
+		ksft_print_msg("failed to read /proc/self/cgroup\n");
+		break;
+	case CGNS_CHILD_FAIL_WRITE:
+		ksft_print_msg("failed to report the result to the parent\n");
+		break;
+	case CGNS_CHILD_FAIL_SYNC:
+		ksft_print_msg("child failed to synchronize with the parent\n");
+		break;
+	default:
+		ksft_print_msg("child exited unexpectedly with code %d\n", code);
+		break;
+	}
+}
+
+/*
+ * cgns_check_v2_path - check the unified hierarchy line of a
+ * /proc/$PID/cgroup dump read into @buf.
+ *
+ * /proc/$PID/cgroup has one line per mounted hierarchy, so on systems
+ * which also mount legacy hierarchies the dump consists of several lines
+ * and cannot be compared as a whole.  Look the unified hierarchy line
+ * ("0::") up and compare the path following the second ':' with @path.
+ */
+static bool cgns_check_v2_path(const char *buf, const char *path)
+{
+	size_t path_len = strlen(path);
+	const char *line = buf;
+
+	while (*line) {
+		const char *eol = strchr(line, '\n');
+		size_t len = eol ? (size_t)(eol - line) : strlen(line);
+
+		if (len >= 3 && !strncmp(line, "0::", 3))
+			return len - 3 == path_len &&
+			       !strncmp(line + 3, path, path_len);
+
+		if (!eol)
+			break;
+		line = eol + 1;
+	}
+
+	return false;
+}
+
+/*
+ * cgns_read_result - read the message a child sent over @fd up to EOF into
+ * @buf and NUL terminate it.
+ *
+ * The child closes its end of the pipe or socket once the message is
+ * complete, so reading up to EOF also waits for the child to finish
+ * talking.  Reading up to EOF instead of issuing a single read(2) avoids
+ * having to rely on the message being delivered atomically.
+ *
+ * Returns the message length on success and -1 on failure, in which case a
+ * diagnostic is printed.
+ */
+static ssize_t cgns_read_result(int fd, char *buf, size_t buflen)
+{
+	size_t total = 0;
+
+	while (total < buflen - 1) {
+		ssize_t len = read(fd, buf + total, buflen - 1 - total);
+
+		if (len < 0 && errno == EINTR)
+			continue;
+
+		if (len < 0) {
+			ksft_print_msg("read() failed: %s\n", strerror(errno));
+			return -1;
+		}
+
+		if (len == 0)
+			break;
+
+		total += len;
+	}
+
+	buf[total] = '\0';
+	return (ssize_t)total;
+}
+
+/*
+ * cgns_read_self_cgroup - read /proc/self/cgroup from inside a fresh
+ * cgroup namespace rooted at @cgroup.
+ *
+ * Forks a child, moves it into @cgroup, unshares the child's cgroup
+ * namespace and stores what the child sees in /proc/self/cgroup into
+ * @buf.  If @nested is non-NULL, the child is additionally moved into
+ * @nested after unsharing.
+ *
+ * Returns 0 on success, 1 if unshare(CLONE_NEWCGROUP) is not permitted
+ * and the test should be skipped, and -1 on failure, in which case a
+ * diagnostic is printed.
+ */
+static int cgns_read_self_cgroup(const char *cgroup, const char *nested,
+				 char *buf, size_t buflen)
+{
+	int pipefd[2];
+	int status;
+	pid_t pid;
+	ssize_t len;
+
+	if (pipe(pipefd) < 0) {
+		ksft_print_msg("pipe() failed: %s\n", strerror(errno));
+		return -1;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		ksft_print_msg("fork() failed: %s\n", strerror(errno));
+		close(pipefd[0]);
+		close(pipefd[1]);
+		return -1;
+	}
+
+	if (pid == 0) {
+		/* Child */
+		char child_buf[BUF_SIZE];
+		ssize_t child_len;
+
+		close(pipefd[0]);
+
+		if (cg_enter_current(cgroup))
+			_exit(CGNS_CHILD_FAIL_ENTER);
+
+		if (unshare(CLONE_NEWCGROUP))
+			_exit(cgns_unshare_skip_errno(errno) ?
+			      CGNS_CHILD_SKIP : CGNS_CHILD_FAIL_UNSHARE);
+
+		if (nested && cg_enter_current(nested))
+			_exit(CGNS_CHILD_FAIL_NESTED);
+
+		child_len = read_text("/proc/self/cgroup", child_buf,
+				      sizeof(child_buf));
+
+		if (child_len < 0)
+			_exit(CGNS_CHILD_FAIL_READ);
+
+		child_buf[child_len] = '\0';
+
+		if (write(pipefd[1], child_buf, child_len + 1) != (child_len + 1))
+			_exit(CGNS_CHILD_FAIL_WRITE);
+
+		close(pipefd[1]);
+		_exit(CGNS_CHILD_OK);
+	}
+
+	/* Parent */
+	close(pipefd[1]);
+	len = cgns_read_result(pipefd[0], buf, buflen);
+	close(pipefd[0]);
+
+	if (waitpid(pid, &status, 0) < 0) {
+		ksft_print_msg("waitpid() failed: %s\n", strerror(errno));
+		return -1;
+	}
+
+	if (!WIFEXITED(status)) {
+		ksft_print_msg("child did not exit normally (status %#x)\n",
+			       status);
+		return -1;
+	}
+
+	switch (WEXITSTATUS(status)) {
+	case CGNS_CHILD_OK:
+		if (len < 0)
+			return -1;
+
+		if (len == 0) {
+			ksft_print_msg("child did not report a result\n");
+			return -1;
+		}
+
+		return 0;
+	case CGNS_CHILD_SKIP:
+		return 1;
+	default:
+		cgns_report_child_exit(WEXITSTATUS(status), cgroup, nested);
+		return -1;
+	}
+}
+
+/*
+ * After unshare(CLONE_NEWCGROUP), /proc/self/cgroup must show the
+ * process's cgroup relative to the new namespace root, i.e. "0::/"
+ * even though the process lives in a non-root cgroup.
+ */
+static int test_cgroupns_root_view(const char *root)
+{
+	char *cg = cg_name(root, "cg_test_ns");
+	char buf[BUF_SIZE];
+	int ret = KSFT_FAIL;
+	int rc;
+
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	rc = cgns_read_self_cgroup(cg, NULL, buf, sizeof(buf));
+	if (rc > 0) {
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+	if (rc < 0)
+		goto cleanup;
+
+	if (!cgns_check_v2_path(buf, "/")) {
+		ksft_print_msg("expected \"0::/\\n\", got \"%s\"\n", buf);
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	cg_destroy(cg);
+	free(cg);
+	return ret;
+}
+
+/*
+ * A process moved into a sub-cgroup below its cgroup namespace root
+ * must see the path relative to the namespace root, i.e. "0::/sub".
+ */
+static int test_cgroupns_nested_view(const char *root)
+{
+	char *cg = cg_name(root, "cg_test_ns");
+	char *sub = NULL;
+	char buf[BUF_SIZE];
+	int ret = KSFT_FAIL;
+	int rc;
+
+	if (!cg)
+		goto cleanup;
+
+	sub = cg_name(cg, "sub");
+	if (!sub)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_create(sub))
+		goto cleanup;
+
+	rc = cgns_read_self_cgroup(cg, sub, buf, sizeof(buf));
+	if (rc > 0) {
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+	if (rc < 0)
+		goto cleanup;
+
+	if (!cgns_check_v2_path(buf, "/sub")) {
+		ksft_print_msg("expected \"0::/sub\\n\", got \"%s\"\n", buf);
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	cg_destroy(sub);
+	free(sub);
+	cg_destroy(cg);
+	free(cg);
+	return ret;
+}
+
+/*
+ * A process which is moved from its cgroup namespace root (cg_ns_a) to
+ * the sibling cgroup cg_ns_b must see a path relative to the namespace
+ * root prefixed with "../", i.e. "0::/../cg_ns_b".
+ *
+ * The path is rendered relative to the cgroup namespace of the process
+ * which reads /proc/$PID/cgroup - proc_cgroup_show() uses the cgroup
+ * namespace of %current - so the child has to read its own
+ * /proc/self/cgroup: the parent, which lives in the initial namespace,
+ * would be shown the full path instead.
+ *
+ * The migration has to happen after the child has unshared its cgroup
+ * namespace but before it reads /proc/self/cgroup, and the parent cannot
+ * observe the unshare on its own.  The two sides therefore synchronize
+ * over a socketpair, which carries all three messages: the child reports
+ * the finished unshare on it, waits for the parent's go-ahead and finally
+ * sends back what it read.
+ *
+ * The two wake-up bytes hold no information and are not compared with
+ * anything: there is exactly one sender and one message per direction, so
+ * all a reader has to establish is that a byte arrived at all.  A
+ * zero-length read means that the writer is gone, and it is how the
+ * parent notices a child which bailed out, e.g. with CGNS_CHILD_SKIP,
+ * instead of reaching the migration point.
+ */
+static int test_cgroupns_sibling_cgroup_view(const char *root)
+{
+	char *cg_a = cg_name(root, "cg_ns_a");
+	char *cg_b = cg_name(root, "cg_ns_b");
+	char buf[BUF_SIZE];
+	int sv[2] = { -1, -1 };
+	pid_t pid;
+	ssize_t len;
+	bool parent_failed = false;
+	int status = 0;
+	int ret = KSFT_FAIL;
+
+	if (!cg_a || !cg_b)
+		goto cleanup;
+
+	if (cg_create(cg_a) || cg_create(cg_b))
+		goto cleanup;
+
+	if (socketpair(AF_UNIX, SOCK_STREAM, 0, sv))
+		goto cleanup;
+
+	pid = fork();
+	if (pid < 0)
+		goto cleanup;
+
+	if (pid == 0) {
+		/* Child */
+		char ch;
+
+		close(sv[1]);
+
+		if (cg_enter_current(cg_a))
+			_exit(CGNS_CHILD_FAIL_ENTER);
+
+		if (unshare(CLONE_NEWCGROUP))
+			_exit(cgns_unshare_skip_errno(errno) ?
+			      CGNS_CHILD_SKIP : CGNS_CHILD_FAIL_UNSHARE);
+
+		if (write(sv[0], "R", 1) != 1)
+			_exit(CGNS_CHILD_FAIL_SYNC);
+
+		/* Wait until the parent has migrated us into cg_ns_b. */
+		do {
+			len = read(sv[0], &ch, 1);
+		} while (len < 0 && errno == EINTR);
+
+		if (len != 1)
+			_exit(CGNS_CHILD_FAIL_SYNC);
+
+		len = read_text("/proc/self/cgroup", buf, sizeof(buf));
+		if (len < 0)
+			_exit(CGNS_CHILD_FAIL_READ);
+
+		buf[len] = '\0';
+
+		if (write(sv[0], buf, len + 1) != (len + 1))
+			_exit(CGNS_CHILD_FAIL_WRITE);
+
+		close(sv[0]);
+		_exit(CGNS_CHILD_OK);
+	}
+
+	/* Parent */
+	close(sv[0]);
+	sv[0] = -1;
+
+	/* Wait for the child to finish unsharing. */
+	do {
+		len = read(sv[1], buf, 1);
+	} while (len < 0 && errno == EINTR);
+
+	if (len < 0) {
+		ksft_print_msg("read() failed: %s\n", strerror(errno));
+		parent_failed = true;
+		goto out_child;
+	}
+
+	/* A zero length read means that the child bailed out. */
+	if (len != 1)
+		goto out_child;
+
+	/* Move the child into the sibling cgroup. */
+	if (cg_enter(cg_b, pid)) {
+		ksft_print_msg("failed to move the child into %s\n", cg_b);
+		parent_failed = true;
+		goto out_child;
+	}
+
+	if (write(sv[1], "G", 1) != 1) {
+		ksft_print_msg("failed to wake up the child: %s\n",
+			       strerror(errno));
+		parent_failed = true;
+		goto out_child;
+	}
+
+	len = cgns_read_result(sv[1], buf, sizeof(buf));
+	close(sv[1]);
+	sv[1] = -1;
+	if (len < 0) {
+		/* Already reported by cgns_read_result(). */
+		parent_failed = true;
+		goto out_child;
+	}
+
+	if (len == 0) {
+		ksft_print_msg("child did not report a result\n");
+		goto out_child;
+	}
+
+	/* All communication is done, reap the child. */
+	if (waitpid(pid, &status, 0) < 0) {
+		ksft_print_msg("waitpid() failed: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status) != CGNS_CHILD_OK) {
+		ksft_print_msg("child failed after reporting a result\n");
+		goto cleanup;
+	}
+
+	if (!cgns_check_v2_path(buf, "/../cg_ns_b")) {
+		ksft_print_msg("expected \"0::/../cg_ns_b\\n\", got \"%s\"\n",
+			       buf);
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+	goto cleanup;
+
+out_child:
+	/* Close our end so that a blocked child isn't left hanging. */
+	if (sv[1] >= 0) {
+		close(sv[1]);
+		sv[1] = -1;
+	}
+
+	/*
+	 * Only a child which exited with CGNS_CHILD_SKIP means that the
+	 * test should be skipped; anything else, including a failed
+	 * waitpid(2), is a test failure.
+	 *
+	 * A child which exited with CGNS_CHILD_OK has nothing to add, and
+	 * neither has one which failed to synchronize because we gave up
+	 * first: closing our end of the socket leaves it stuck in its
+	 * go-ahead read, so it exits with CGNS_CHILD_FAIL_SYNC even though
+	 * the failure was ours.  Ours was reported where it happened.
+	 */
+	if (waitpid(pid, &status, 0) < 0) {
+		ksft_print_msg("waitpid() failed: %s\n", strerror(errno));
+	} else if (!WIFEXITED(status)) {
+		ksft_print_msg("child did not exit normally (status %#x)\n",
+			       status);
+	} else if (WEXITSTATUS(status) == CGNS_CHILD_SKIP) {
+		ret = KSFT_SKIP;
+	} else if (!parent_failed && WEXITSTATUS(status) != CGNS_CHILD_OK) {
+		cgns_report_child_exit(WEXITSTATUS(status), cg_a, NULL);
+	}
+
+cleanup:
+	if (sv[0] >= 0)
+		close(sv[0]);
+
+	if (sv[1] >= 0)
+		close(sv[1]);
+
+	cg_destroy(cg_b);
+	free(cg_b);
+
+	cg_destroy(cg_a);
+	free(cg_a);
+
+	return ret;
+}
+
+#define T(x) { x, #x }
+struct cgroupns_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_cgroupns_root_view),
+	T(test_cgroupns_nested_view),
+	T(test_cgroupns_sibling_cgroup_view),
+};
+#undef T
+
+int main(int argc, char *argv[])
+{
+	char root[PATH_MAX];
+	size_t i;
+
+	/*
+	 * The tests write to pipes or sockets whose reader may already be
+	 * gone, e.g. a child which is killed while it waits for the parent.
+	 * Let such a write fail with EPIPE so that the test can report it,
+	 * instead of SIGPIPE killing the whole test process and truncating
+	 * the TAP output.
+	 */
+	signal(SIGPIPE, SIG_IGN);
+
+	ksft_print_header();
+
+	/*
+	 * If the C library headers the test was built against are too old to
+	 * define CLONE_NEWCGROUP, the fallback definition above makes it 0 and
+	 * unshare(2) would silently not create a namespace.
+	 */
+	if (!CLONE_NEWCGROUP)
+		ksft_exit_skip("CLONE_NEWCGROUP is not defined\n");
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	ksft_set_plan(ARRAY_SIZE(tests));
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", tests[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	ksft_finished();
+}
-- 
2.50.1

