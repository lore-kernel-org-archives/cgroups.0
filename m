Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790641;
	b=ARsfhDx7NLJblWudtJ7bz5rMIBFuCDqYDu2/mUlW5tXy5HdtvqZZs5nAWnniUpaBWSqd
	 R/f5BKcjQj8jrCepsBxAcAHi0QD92LjZFGY61BeP2oF2K2F1IkA0xvK1J6efWgO6nw0LY
	 leaxmBT0JvL8SQUg19i9K24nWOSddCnr5gmT1EexBEWhd2Qk8HGOFBDqDwVV7QHmSCXor
	 i1adNsN1Y0f3+CaJ1fKPsu66B8wUFamfnrxL0UyTT9ARZcXC3BOC3rokVVPd3wG5KoKVj
	 QBPYHKCdBH0QVJXf6m6xCKnqqhLabBMCECwhQs4vBhSKhobm2193V/Tm5Nu3ECGmt8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790641;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=FoGBuBHViNR7dCPgFzpMMi1HyRV5gRfPHUJcGkhURP0=;
	b=llrnoIN/ecZ+VSkuTGlhtKVJqmD/2WR1QZtEOLb73AzJkM6lxNJv1AJ9QeBmsvIAIIYK
	 URTtrOotw2f+W76tRXWjTkD985A5ra8SZ285X6EI7fc0fqu9lUwbhQDaewzRTECpYP8+H
	 k+FI0vYksRJsTUEesyUMhK+B4bSAhsjhrwQ8RJZsRPs0cPn50rSJjhJjawFXA4CH0KP1X
	 7g/l+Emc2l394+6G/+ZzpBFh17tPHJ9ICOn51Yt4qj3BA64Sz0angyEvigliyGzV8nbCe
	 CRIFtD4GE71W/c71rqQPVykSLVphF2ZpNoQUvKntGwd4k2soBUfmo3bXHQna19BD6SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=P3OCzfB6;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416836082BD5
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 11:10:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 416836082BD5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=P3OCzfB6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FoGBuBHViNR7dCPgFzpMMi1HyRV5gRfPHUJcGkhURP0=;
	b=P3OCzfB6zPrIZjSGpIaJ/skqX+GWZdGFH3N6eUCd3tNmt+v9Z4cfo5oml4eW7fOk1AzvB9
	jVv3FY5LCg1W35rd2NC6yZUbi9hj0knl7xZpAFRJbsDCjRHDombM6G8cRiiTcVIrGFyCWU
	L77vy+XBPTryjK8a2mQb1x+aPgzvufU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-116-VQUIjkzqOi62L9Gt-VB5UA-1; Wed,
 04 Nov 2026 06:10:35 -0500
X-MC-Unique: VQUIjkzqOi62L9Gt-VB5UA-1
X-Mimecast-MFC-AGG-ID: VQUIjkzqOi62L9Gt-VB5UA_1793790631
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE35C1956071;
	Wed,  4 Nov 2026 11:10:30 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2352F1956088;
	Wed,  4 Nov 2026 11:10:22 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:17 +0100
Subject: [PATCH v4 8/8] selftests/dmabuf-heaps: Add dma-buf memcg
 accounting tests
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-8-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=24408;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=XtrfPl9LwXsIsdDJxExxyr8cN61qDJ+6OZ6oi1WmSFY=;
 b=59BiYm8GUrAOFMlhE89jRW7t2QhdageaeOUS6NnsoUq1cPrxeMD2gTpPX1D84pXRRiFWwZ906
 9E4VBx8ufdtCWDlemVcwVbZcnJQA4mUNSUI2PV2QnQ8G3rl+ZrVctGR
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add tests for the new charge_fd field in struct
dma_heap_allocation_data.

When the charge_fd feature is absent (unpatched kernel),
the probe in pidfd_alloc_supported() detects this and the
tests are skipped gracefully.

Add vmtest.sh similar to other subsystem suites, to orchestrate
building the selftests (optionally with a freshly compiled kernel)
inside a virtme-ng VM, so the tests can be run without modifying
the host system. Add a config fragment with required Kconfig symbols.

Also add test_memcg_dmabuf() to the existing test_memcontrol suite
to verify end-to-end cross-cgroup accounting: a parent process opens
a pidfd for a child in a separate cgroup, allocates a dma-buf via
DMA_HEAP_IOCTL_ALLOC with that pidfd, and asserts that memory.stat
dmabuf in the child's cgroup reflects the allocation. If the dmabuf
key is missing (unpatched kernel) or /dev/dma_heap/system is absent,
the test is skipped.

Assisted-by: LLM
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 tools/testing/selftests/cgroup/Makefile            |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 290 ++++++++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/config        |   1 +
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 227 +++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/vmtest.sh     | 226 ++++++++++++++++
 5 files changed, 742 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..9edfc9f1de5c 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wall -pthread
+CFLAGS += -Wall -pthread $(KHDR_INCLUDES)
 
 all: ${HELPER_PROGS}
 
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..3c95bcabee2b 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -19,10 +19,20 @@
 #include <errno.h>
 #include <sys/mman.h>
 
+#include <linux/dma-buf.h>
+#include <linux/dma-heap.h>
+#include <signal.h>
+#include <sys/ioctl.h>
+
+#include "../pidfd/pidfd.h"
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define DMA_HEAP_SYSTEM		"/dev/dma_heap/system"
+#define ONE_MEG			(1024 * 1024)
+
 #define MEMCG_SOCKSTAT_WAIT_RETRIES        30
+#define MEMCG_DMABUF_WAIT_RETRIES          30
 
 static bool has_localevents;
 static bool has_recursiveprot;
@@ -1764,6 +1774,267 @@ static int test_memcg_inotify_delete_dir(const char *root)
 	return ret;
 }
 
+static int memcg_dmabuf_child(const char *cgroup, void *arg)
+{
+	pause();
+	return 0;
+}
+
+/*
+ * This test allocates a dma-buf via DMA_HEAP_IOCTL_ALLOC with a pidfd
+ * pointing to a child process in a separate cgroup, then checks that
+ * memory.stat[dmabuf] in the child's cgroup rises by the allocation size
+ * and returns to zero after the buffer fd is closed.
+ */
+static int test_memcg_dmabuf(const char *root)
+{
+	char *parent = NULL, *child_cg = NULL;
+	int ret = KSFT_FAIL;
+	int heap_fd = -1, dmabuf_fd = -1, pidfd = -1;
+	pid_t child_pid;
+	int child_status;
+	long dmabuf_stat;
+	struct dma_heap_allocation_data alloc = {
+		.len      = ONE_MEG,
+		.fd_flags = O_RDWR | O_CLOEXEC,
+	};
+
+	if (access(DMA_HEAP_SYSTEM, R_OK | W_OK)) {
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	parent = cg_name(root, "dmabuf_memcg_test");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup_parent;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup_parent;
+
+	child_cg = cg_name(parent, "child");
+	if (!child_cg)
+		goto cleanup_parent;
+
+	if (cg_create(child_cg))
+		goto cleanup_parent;
+
+	child_pid = cg_run_nowait(child_cg, memcg_dmabuf_child, NULL);
+	if (child_pid < 0)
+		goto cleanup_child;
+
+	if (cg_wait_for_proc_count(child_cg, 1))
+		goto cleanup_kill;
+
+	pidfd = sys_pidfd_open(child_pid, 0);
+	if (pidfd < 0) {
+		ret = KSFT_SKIP;
+		goto cleanup_kill;
+	}
+
+	heap_fd = open(DMA_HEAP_SYSTEM, O_RDWR);
+	if (heap_fd < 0) {
+		ret = KSFT_SKIP;
+		goto cleanup_pidfd;
+	}
+
+	alloc.charge_fd = (__u32)pidfd;
+	if (ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc) < 0)
+		goto cleanup_heap;
+	dmabuf_fd = (int)alloc.fd;
+
+	dmabuf_stat = cg_read_key_long(child_cg, "memory.stat", "dmabuf ");
+	if (dmabuf_stat == -1) {
+		ret = KSFT_SKIP;
+		goto cleanup_dmabuf;
+	}
+	if (dmabuf_stat != ONE_MEG)
+		dmabuf_stat = cg_read_key_long_poll(child_cg, "memory.stat",
+						    "dmabuf ", ONE_MEG,
+						    MEMCG_DMABUF_WAIT_RETRIES,
+						    DEFAULT_WAIT_INTERVAL_US);
+	if (dmabuf_stat != ONE_MEG) {
+		fprintf(stderr, "Expected dmabuf stat %d, got %ld\n",
+			ONE_MEG, dmabuf_stat);
+		goto cleanup_dmabuf;
+	}
+
+	close(dmabuf_fd);
+	dmabuf_fd = -1;
+
+	dmabuf_stat = cg_read_key_long_poll(child_cg, "memory.stat",
+					    "dmabuf ", 0,
+					    MEMCG_DMABUF_WAIT_RETRIES,
+					    DEFAULT_WAIT_INTERVAL_US);
+	if (dmabuf_stat != 0) {
+		fprintf(stderr, "Expected dmabuf stat 0 after close, got %ld\n",
+			dmabuf_stat);
+		goto cleanup_heap;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup_dmabuf:
+	if (dmabuf_fd >= 0)
+		close(dmabuf_fd);
+cleanup_heap:
+	close(heap_fd);
+cleanup_pidfd:
+	close(pidfd);
+cleanup_kill:
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &child_status, 0);
+cleanup_child:
+	cg_destroy(child_cg);
+	free(child_cg);
+cleanup_parent:
+	cg_destroy(parent);
+	free(parent);
+cleanup:
+	return ret;
+}
+
+/*
+ * Allocate a dma-buf in cgroup A, set memory.max on cgroup B below the
+ * buffer size, then attempt DMA_BUF_IOCTL_XFER_CHARGE to B. The transfer
+ * must fail with ENOMEM and the charge must remain in A.
+ */
+static int test_memcg_dmabuf_xfer_at_limit(const char *root)
+{
+	char *parent = NULL, *cg_a = NULL, *cg_b = NULL;
+	int ret = KSFT_FAIL;
+	int heap_fd = -1, dmabuf_fd = -1, cg_b_fd = -1;
+	pid_t child_pid;
+	int child_status;
+	long stat_a;
+	struct dma_heap_allocation_data alloc = {
+		.len      = ONE_MEG,
+		.fd_flags = O_RDWR | O_CLOEXEC,
+	};
+	struct dma_buf_transfer_charge xfer = { 0 };
+
+	if (access(DMA_HEAP_SYSTEM, R_OK | W_OK)) {
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	parent = cg_name(root, "dmabuf_xfer_limit_test");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup_parent;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup_parent;
+
+	cg_a = cg_name(parent, "cg_a");
+	cg_b = cg_name(parent, "cg_b");
+	if (!cg_a || !cg_b)
+		goto cleanup_cgs;
+
+	if (cg_create(cg_a) || cg_create(cg_b))
+		goto cleanup_cgs;
+
+	if (cg_write(cg_b, "memory.max", "524288"))
+		goto cleanup_cgs;
+
+	child_pid = cg_run_nowait(cg_a, memcg_dmabuf_child, NULL);
+	if (child_pid < 0)
+		goto cleanup_cgs;
+
+	if (cg_wait_for_proc_count(cg_a, 1))
+		goto cleanup_kill;
+
+	heap_fd = open(DMA_HEAP_SYSTEM, O_RDWR);
+	if (heap_fd < 0) {
+		ret = KSFT_SKIP;
+		goto cleanup_kill;
+	}
+
+	alloc.charge_fd = (__u32)sys_pidfd_open(child_pid, 0);
+	if ((int)alloc.charge_fd < 0) {
+		ret = KSFT_SKIP;
+		goto cleanup_heap;
+	}
+
+	if (ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc) < 0) {
+		close(alloc.charge_fd);
+		goto cleanup_heap;
+	}
+	close(alloc.charge_fd);
+	dmabuf_fd = (int)alloc.fd;
+
+	stat_a = cg_read_key_long(cg_a, "memory.stat", "dmabuf ");
+	if (stat_a == -1) {
+		ret = KSFT_SKIP;
+		goto cleanup_dmabuf;
+	}
+	if (stat_a != ONE_MEG)
+		stat_a = cg_read_key_long_poll(cg_a, "memory.stat",
+					       "dmabuf ", ONE_MEG,
+					       MEMCG_DMABUF_WAIT_RETRIES,
+					       DEFAULT_WAIT_INTERVAL_US);
+	if (stat_a != ONE_MEG) {
+		fprintf(stderr, "Charge not in A after alloc: expected %d, got %ld\n",
+			ONE_MEG, stat_a);
+		goto cleanup_dmabuf;
+	}
+
+	cg_b_fd = open(cg_b, O_RDONLY | O_DIRECTORY);
+	if (cg_b_fd < 0)
+		goto cleanup_dmabuf;
+
+	xfer.charge_fd = (__u32)cg_b_fd;
+	if (ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer) == 0) {
+		fprintf(stderr, "xfer_charge should have failed at limit\n");
+		goto cleanup_cgfd;
+	}
+	if (errno != ENOMEM) {
+		fprintf(stderr, "Expected ENOMEM, got %s\n", strerror(errno));
+		goto cleanup_cgfd;
+	}
+
+	stat_a = cg_read_key_long_poll(cg_a, "memory.stat",
+				       "dmabuf ", ONE_MEG,
+				       MEMCG_DMABUF_WAIT_RETRIES,
+				       DEFAULT_WAIT_INTERVAL_US);
+	if (stat_a != ONE_MEG) {
+		fprintf(stderr, "Charge leaked from A: expected %d, got %ld\n",
+			ONE_MEG, stat_a);
+		goto cleanup_cgfd;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup_cgfd:
+	close(cg_b_fd);
+cleanup_dmabuf:
+	if (dmabuf_fd >= 0)
+		close(dmabuf_fd);
+cleanup_heap:
+	close(heap_fd);
+cleanup_kill:
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &child_status, 0);
+cleanup_cgs:
+	if (cg_a) {
+		cg_destroy(cg_a);
+		free(cg_a);
+	}
+	if (cg_b) {
+		cg_destroy(cg_b);
+		free(cg_b);
+	}
+cleanup_parent:
+	cg_destroy(parent);
+	free(parent);
+cleanup:
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct memcg_test {
 	int (*fn)(const char *root);
@@ -1785,13 +2056,19 @@ struct memcg_test {
 	T(test_memcg_oom_group_score_events),
 	T(test_memcg_inotify_delete_file),
 	T(test_memcg_inotify_delete_dir),
+	T(test_memcg_dmabuf),
+	T(test_memcg_dmabuf_xfer_at_limit),
 };
 #undef T
 
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, proc_status;
+	int i, proc_status, count = ARRAY_SIZE(tests);
+	const char *filter = NULL;
+
+	if (argc > 1)
+		filter = argv[1];
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	if (page_size <= 0)
@@ -1822,8 +2099,17 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Failed to query cgroup mount option\n");
 	has_localevents = proc_status;
 
-	ksft_set_plan(ARRAY_SIZE(tests));
+	if (filter) {
+		count = 0;
+		for (i = 0; i < ARRAY_SIZE(tests); i++) {
+			if (!strcmp(tests[i].name, filter))
+				count++;
+		}
+	}
+	ksft_set_plan(count);
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		if (filter && strcmp(tests[i].name, filter))
+			continue;
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
 			ksft_test_result_pass("%s\n", tests[i].name);
diff --git a/tools/testing/selftests/dmabuf-heaps/config b/tools/testing/selftests/dmabuf-heaps/config
index be091f1cdfa0..94c8f33b71a2 100644
--- a/tools/testing/selftests/dmabuf-heaps/config
+++ b/tools/testing/selftests/dmabuf-heaps/config
@@ -1,3 +1,4 @@
+CONFIG_MEMCG=y
 CONFIG_DMABUF_HEAPS=y
 CONFIG_DMABUF_HEAPS_SYSTEM=y
 CONFIG_DRM_VGEM=y
diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
index 1d49df671919..90ef14d2ecba 100644
--- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
+++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
@@ -3,6 +3,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
@@ -10,11 +11,15 @@
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
+#include <linux/limits.h>
 #include <drm/drm.h>
+#include "../pidfd/pidfd.h"
 #include "kselftest.h"
 
 #define DEVPATH "/dev/dma_heap"
@@ -320,6 +325,8 @@ static int dmabuf_heap_alloc_newer(int fd, size_t len, unsigned int flags,
 		__u32 fd;
 		__u32 fd_flags;
 		__u64 heap_flags;
+		__u32 charge_fd;
+		__u32 __padding;
 		__u64 garbage1;
 		__u64 garbage2;
 		__u64 garbage3;
@@ -328,6 +335,8 @@ static int dmabuf_heap_alloc_newer(int fd, size_t len, unsigned int flags,
 		.fd = 0,
 		.fd_flags = O_RDWR | O_CLOEXEC,
 		.heap_flags = flags,
+		.charge_fd = 0,
+		.__padding = 0,
 		.garbage1 = 0xffffffff,
 		.garbage2 = 0x88888888,
 		.garbage3 = 0x11111111,
@@ -496,6 +505,218 @@ static void test_alloc_no_fd_leak_on_efault(char *heap_name)
 	ksft_test_result(fd_before == fd_after,
 			 "fd leak on EFAULT: before=%d after=%d\n",
 			 fd_before, fd_after);
+
+out:
+	close(heap_fd);
+}
+
+static int dmabuf_heap_alloc_pidfd(int fd, size_t len, unsigned int heap_flags,
+				   unsigned int charge_fd, int *dmabuf_fd)
+{
+	struct dma_heap_allocation_data data = {
+		.len = len,
+		.fd = 0,
+		.fd_flags = O_RDWR | O_CLOEXEC,
+		.heap_flags = heap_flags,
+		.charge_fd = charge_fd,
+	};
+	int ret;
+
+	if (!dmabuf_fd)
+		return -EINVAL;
+
+	ret = ioctl(fd, DMA_HEAP_IOCTL_ALLOC, &data);
+	if (ret < 0)
+		return ret;
+	*dmabuf_fd = (int)data.fd;
+	return ret;
+}
+
+/*
+ * Probe whether the kernel honours charge_fd in DMA_HEAP_IOCTL_ALLOC.
+ */
+static bool pidfd_alloc_supported(int heap_fd)
+{
+	int devnull_fd, dmabuf_fd = -1, ret;
+
+	devnull_fd = open("/dev/null", O_RDONLY);
+	if (devnull_fd < 0)
+		return false;
+
+	ret = dmabuf_heap_alloc_pidfd(heap_fd, ONE_MEG, 0, devnull_fd, &dmabuf_fd);
+	if (dmabuf_fd >= 0) {
+		close(dmabuf_fd);
+		dmabuf_fd = -1;
+	}
+	close(devnull_fd);
+	return ret < 0;
+}
+
+/*
+ * Test: allocate charging the calling process's own cgroup via a self pidfd.
+ */
+static void test_alloc_pidfd_self(char *heap_name)
+{
+	int heap_fd = -1, pidfd = -1, dmabuf_fd = -1, ret;
+
+	heap_fd = dmabuf_heap_open(heap_name);
+
+	if (!pidfd_alloc_supported(heap_fd)) {
+		ksft_test_result_skip("charge_fd not supported by this kernel\n");
+		goto out;
+	}
+
+	pidfd = sys_pidfd_open(getpid(), 0);
+	if (pidfd < 0) {
+		ksft_test_result_skip("pidfd_open not available\n");
+		goto out;
+	}
+
+	ret = dmabuf_heap_alloc_pidfd(heap_fd, ONE_MEG, 0, pidfd, &dmabuf_fd);
+	ksft_test_result(!ret, "Allocation with self pidfd %d\n", ret);
+	if (dmabuf_fd >= 0)
+		close(dmabuf_fd);
+	close(pidfd);
+out:
+	close(heap_fd);
+}
+
+/*
+ * Test: allocate charging a child process's cgroup via a child pidfd.
+ */
+static void test_alloc_pidfd_child(char *heap_name)
+{
+	int heap_fd = -1, pidfd = -1, dmabuf_fd = -1;
+	pid_t child_pid;
+	int status, ret;
+
+	heap_fd = dmabuf_heap_open(heap_name);
+
+	if (!pidfd_alloc_supported(heap_fd)) {
+		ksft_test_result_skip("charge_fd not supported by this kernel\n");
+		goto out;
+	}
+
+	child_pid = fork();
+	if (child_pid == 0) {
+		pause();
+		_exit(0);
+	}
+	if (child_pid < 0)
+		ksft_exit_fail_msg("fork failed: %s\n", strerror(errno));
+
+	pidfd = sys_pidfd_open(child_pid, 0);
+	if (pidfd < 0) {
+		kill(child_pid, SIGTERM);
+		waitpid(child_pid, &status, 0);
+		ksft_test_result_skip("pidfd_open for child failed\n");
+		goto out;
+	}
+
+	ret = dmabuf_heap_alloc_pidfd(heap_fd, ONE_MEG, 0, pidfd, &dmabuf_fd);
+	ksft_test_result(!ret, "Allocation with child pidfd %d\n", ret);
+	if (dmabuf_fd >= 0)
+		close(dmabuf_fd);
+	close(pidfd);
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &status, 0);
+out:
+	close(heap_fd);
+}
+
+static int open_self_cgroupfd(void)
+{
+	char cgroup_path[PATH_MAX];
+	char buf[PATH_MAX];
+	FILE *f;
+
+	f = fopen("/proc/self/cgroup", "r");
+	if (!f)
+		return -1;
+
+	cgroup_path[0] = '\0';
+	while (fgets(buf, sizeof(buf), f)) {
+		char *p = buf;
+
+		if (strncmp(p, "0::", 3) == 0) {
+			p += 3;
+			p[strcspn(p, "\n")] = '\0';
+			snprintf(cgroup_path, sizeof(cgroup_path),
+				 "/sys/fs/cgroup%s", p);
+			break;
+		}
+	}
+	fclose(f);
+
+	if (!cgroup_path[0])
+		return -1;
+
+	return open(cgroup_path, O_RDONLY | O_DIRECTORY);
+}
+
+/*
+ * Test: allocate charging the calling process's own cgroup via a cgroupfd.
+ */
+static void test_alloc_cgroupfd_self(char *heap_name)
+{
+	int heap_fd = -1, cgroup_fd = -1, dmabuf_fd = -1, ret;
+
+	heap_fd = dmabuf_heap_open(heap_name);
+
+	if (!pidfd_alloc_supported(heap_fd)) {
+		ksft_test_result_skip("charge_fd not supported by this kernel\n");
+		goto out;
+	}
+
+	cgroup_fd = open_self_cgroupfd();
+	if (cgroup_fd < 0) {
+		ksft_test_result_skip("cannot open self cgroupfd\n");
+		goto out;
+	}
+
+	ret = dmabuf_heap_alloc_pidfd(heap_fd, ONE_MEG, 0, cgroup_fd, &dmabuf_fd);
+	ksft_test_result(!ret, "Allocation with cgroupfd %d\n", ret);
+	if (dmabuf_fd >= 0)
+		close(dmabuf_fd);
+	close(cgroup_fd);
+out:
+	close(heap_fd);
+}
+
+/*
+ * Test: transfer a dma-buf's charge to self cgroup via DMA_BUF_IOCTL_XFER_CHARGE.
+ */
+static void test_xfer_charge_cgroupfd_self(char *heap_name)
+{
+	int heap_fd = -1, cgroup_fd = -1, dmabuf_fd = -1, ret;
+	struct dma_buf_transfer_charge xfer = { 0 };
+
+	heap_fd = dmabuf_heap_open(heap_name);
+
+	if (!pidfd_alloc_supported(heap_fd)) {
+		ksft_test_result_skip("charge_fd not supported by this kernel\n");
+		goto out;
+	}
+
+	ret = dmabuf_heap_alloc(heap_fd, ONE_MEG, 0, &dmabuf_fd);
+	if (ret) {
+		ksft_test_result_fail("Allocation failed %d\n", ret);
+		goto out;
+	}
+
+	cgroup_fd = open_self_cgroupfd();
+	if (cgroup_fd < 0) {
+		ksft_test_result_skip("cannot open self cgroupfd\n");
+		close(dmabuf_fd);
+		goto out;
+	}
+
+	xfer.charge_fd = cgroup_fd;
+	ret = ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
+	ksft_test_result(!ret, "XFER_CHARGE to self cgroupfd %d\n", ret);
+
+	close(cgroup_fd);
+	close(dmabuf_fd);
 out:
 	close(heap_fd);
 }
@@ -530,7 +751,7 @@ int main(void)
 		return KSFT_SKIP;
 	}
 
-	ksft_set_plan(12 * numer_of_heaps());
+	ksft_set_plan(16 * numer_of_heaps());
 
 	while ((dir = readdir(d))) {
 		if (!strncmp(dir->d_name, ".", 2))
@@ -546,6 +767,10 @@ int main(void)
 		test_alloc_compat(dir->d_name);
 		test_alloc_errors(dir->d_name);
 		test_alloc_no_fd_leak_on_efault(dir->d_name);
+		test_alloc_pidfd_self(dir->d_name);
+		test_alloc_pidfd_child(dir->d_name);
+		test_alloc_cgroupfd_self(dir->d_name);
+		test_xfer_charge_cgroupfd_self(dir->d_name);
 	}
 	closedir(d);
 
diff --git a/tools/testing/selftests/dmabuf-heaps/vmtest.sh b/tools/testing/selftests/dmabuf-heaps/vmtest.sh
new file mode 100755
index 000000000000..3574b71ca83e
--- /dev/null
+++ b/tools/testing/selftests/dmabuf-heaps/vmtest.sh
@@ -0,0 +1,226 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2026 Red Hat
+#
+# Dependencies:
+#		* virtme-ng
+#		* qemu	(used by virtme-ng)
+
+readonly SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
+readonly KERNEL_CHECKOUT=$(realpath "${SCRIPT_DIR}"/../../../../)
+readonly CGROUP_DIR="${KERNEL_CHECKOUT}/tools/testing/selftests/cgroup"
+
+source "${SCRIPT_DIR}"/../kselftest/ktap_helpers.sh
+
+readonly DMABUF_HEAP_TEST="${SCRIPT_DIR}"/dmabuf-heap
+readonly MEMCONTROL_TEST="${CGROUP_DIR}"/test_memcontrol
+readonly TMP_DIR=$(mktemp -d /tmp/dmabuf-vmtest.XXXXXXXX)
+
+VERBOSE=false
+BUILD=false
+BUILD_HOST=""
+BUILD_HOST_PODMAN_CONTAINER_NAME=""
+SHELL_MODE=false
+
+usage() {
+	echo
+	echo "$0 [OPTIONS]"
+	echo
+	echo "Options"
+	echo "  -b: build the kernel from the current source tree and use it for the VM"
+	echo "  -H: hostname for remote build host (used with -b)"
+	echo "  -p: podman container name for remote build host (used with -b)"
+	echo "      Example: -H beefyserver -p vng"
+	echo "  -s: drop into an interactive shell in the VM instead of running tests"
+	echo "  -v: enable verbose vng/qemu output"
+	echo
+
+	exit 1
+}
+
+die() {
+	echo "$*" >&2
+	exit "${KSFT_FAIL}"
+}
+
+cleanup() {
+	rm -rf "${TMP_DIR}"
+}
+
+check_deps() {
+	for dep in vng make; do
+		if [[ ! -x $(command -v "${dep}") ]]; then
+			echo -e "skip:    dependency ${dep} not found!\n"
+			exit "${KSFT_SKIP}"
+		fi
+	done
+
+	if ${SHELL_MODE}; then
+		return
+	fi
+
+	if [[ ! -x "${DMABUF_HEAP_TEST}" ]]; then
+		printf "skip:    %s not found!" "${DMABUF_HEAP_TEST}"
+		printf " Please build the kselftest dmabuf-heaps target (or use -b).\n"
+		exit "${KSFT_SKIP}"
+	fi
+
+	if [[ ! -x "${MEMCONTROL_TEST}" ]]; then
+		printf "skip:    %s not found!" "${MEMCONTROL_TEST}"
+		printf " Please build the kselftest cgroup target (or use -b).\n"
+		exit "${KSFT_SKIP}"
+	fi
+}
+
+check_vng() {
+	local tested_versions=("1.36" "1.37")
+	local version
+	local ok=0
+
+	version="$(vng --version)"
+	for tv in "${tested_versions[@]}"; do
+		if [[ "${version}" == *"${tv}"* ]]; then
+			ok=1
+			break
+		fi
+	done
+
+	if [[ "${ok}" -eq 0 ]]; then
+		printf "warning: vng version '%s' has not been tested and may " "${version}" >&2
+		printf "not function properly.\n\tThe following versions have been tested: " >&2
+		echo "${tested_versions[@]}" >&2
+	fi
+}
+
+build_selftests() {
+	make -C "${KERNEL_CHECKOUT}" headers_install \
+		INSTALL_HDR_PATH="${TMP_DIR}/usr" -j"$(nproc)"
+
+	local khdr="-isystem ${TMP_DIR}/usr/include"
+
+	if ! make -C "${SCRIPT_DIR}" KHDR_INCLUDES="${khdr}" -j"$(nproc)"; then
+		die "failed to build dmabuf-heaps selftests"
+	fi
+
+	if ! make -C "${CGROUP_DIR}" KHDR_INCLUDES="${khdr}" \
+		"${MEMCONTROL_TEST}" -j"$(nproc)"; then
+		die "failed to build cgroup/test_memcontrol selftest"
+	fi
+}
+
+handle_build() {
+	if ! ${BUILD}; then
+		return
+	fi
+
+	if [[ ! -d "${KERNEL_CHECKOUT}" ]]; then
+		echo "-b requires vmtest.sh called from the kernel source tree" >&2
+		exit 1
+	fi
+
+	pushd "${KERNEL_CHECKOUT}" &>/dev/null
+
+	if ! vng --kconfig --config "${SCRIPT_DIR}/config"; then
+		die "failed to generate .config for kernel source tree (${KERNEL_CHECKOUT})"
+	fi
+
+	local vng_args=("-v" "--config" "${SCRIPT_DIR}/config" "--build")
+
+	if [[ -n "${BUILD_HOST}" ]]; then
+		vng_args+=("--build-host" "${BUILD_HOST}")
+	fi
+
+	if [[ -n "${BUILD_HOST_PODMAN_CONTAINER_NAME}" ]]; then
+		vng_args+=("--build-host-exec-prefix" \
+			   "podman exec -ti ${BUILD_HOST_PODMAN_CONTAINER_NAME}")
+	fi
+
+	if ! vng "${vng_args[@]}"; then
+		die "failed to build kernel from source tree (${KERNEL_CHECKOUT})"
+	fi
+
+	build_selftests
+
+	popd &>/dev/null
+}
+
+make_runner() {
+	# virtme-ng shares the host filesystem, so TMP_DIR is accessible
+	# inside the VM at the same absolute path.
+	cat > "${TMP_DIR}/run_tests.sh" <<-EOF
+	#!/bin/sh
+	set -u
+
+	# Enable memory controller for child cgroups
+	echo +memory > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null
+
+	PASS=0; FAIL=0; SKIP=0; N=0
+
+	run() {
+		name="\$1"; shift
+		N=\$((N+1))
+		"\$@"; rc=\$?
+		if   [ \$rc -eq 0 ]; then echo "ok \$N \$name";        PASS=\$((PASS+1))
+		elif [ \$rc -eq 4 ]; then echo "ok \$N \$name # SKIP"; SKIP=\$((SKIP+1))
+		else                      echo "not ok \$N \$name";    FAIL=\$((FAIL+1))
+		fi
+	}
+
+	run "dmabuf-heap charge_fd ioctl"	${DMABUF_HEAP_TEST}
+	run "memcontrol dma-buf memcg"	${MEMCONTROL_TEST} test_memcg_dmabuf
+	run "memcontrol dma-buf xfer limit" \
+		${MEMCONTROL_TEST} test_memcg_dmabuf_xfer_at_limit
+	echo "# PASS=\$PASS SKIP=\$SKIP FAIL=\$FAIL"
+	[ \$FAIL -eq 0 ]
+	EOF
+	chmod +x "${TMP_DIR}/run_tests.sh"
+}
+
+run_vm() {
+	local verbose_opt=""
+	local kernel_opt=""
+
+	${VERBOSE} && verbose_opt="--verbose"
+
+	# If we are running from within the kernel source tree, use the kernel
+	# source tree as the kernel to boot, otherwise use the running kernel.
+	if [[ "$(realpath "$(pwd)")" == "${KERNEL_CHECKOUT}"* ]]; then
+		kernel_opt="${KERNEL_CHECKOUT}"
+	fi
+
+	if ${SHELL_MODE}; then
+		echo "Starting interactive shell in VM. Exit to stop VM."
+		vng --run ${kernel_opt} ${verbose_opt} --user root --memory 512M \
+			--append "dma_heap.mem_accounting=1" \
+			-- bash --noprofile --norc
+		exit "${KSFT_PASS}"
+	fi
+
+	vng --run ${kernel_opt} ${verbose_opt} --user root --memory 512M \
+		--append "dma_heap.mem_accounting=1" \
+		--exec "${TMP_DIR}/run_tests.sh"
+}
+
+while getopts :hvsbH:p: o
+do
+	case $o in
+	v) VERBOSE=true;;
+	b) BUILD=true;;
+	s) SHELL_MODE=true;;
+	H) BUILD_HOST=$OPTARG;;
+	p) BUILD_HOST_PODMAN_CONTAINER_NAME=$OPTARG;;
+	h|*) usage;;
+	esac
+done
+shift $((OPTIND-1))
+
+trap cleanup EXIT
+
+check_deps
+check_vng
+handle_build
+make_runner
+
+echo "Booting VM and running tests..."
+run_vm

-- 
2.55.0

