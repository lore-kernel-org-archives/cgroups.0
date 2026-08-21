Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627B63DDB15
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338694; cv=none; b=Mykmg3+uoReREHtf6Rl6YXA1mhV76W8/0LBkeCz2KOdRa6nc/eWej7yQCYOaLfq9OnZbxsZOtjTvl5Oha9Q5LpODTizrsw4yth1D4ecDV7G8XHrDbDdzz+aEBs2OeulDwZRgE6gVZR17V0ngmJ9xz9GabszB5s6NYdLqC5X2Nbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338694; c=relaxed/simple;
	bh=TCbGsETC5zbx2qOdJrl9p/Ic1W1ZL40CCT82Qzdw3mc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iKLCvRU8ca5cSJCOUkqD/tyLYcHupR15xDCHZnLl2TYyvGTqacZSI+WDvTt8EBHrZRK8hKpknUanCYnDbI+e4qYlT2U7hwRg++84kWCLp6gbm9PjVEjHyqixk2HQt5WEu/k8VCEdPghJ0d0Pfa9AffcQJivIUI6Zp1sHOnSsSjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gWOhLED0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hxj2v5xy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gWOhLED0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hxj2v5xy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kx9TWcXB6g4zQsYJ1k0m/LLY9asJkpc0FRvOq2JFBz8=;
	b=gWOhLED0UTiTgfFNH/tGin9atmfL93ENnG6Uic6Pd3wDl6GC5js35aGazYKcxhaBTvORd7
	Y93dfsg0WYqgn+J9ZOEzj75cYdT9lSbAnvvyEvDXUe9jOBTsYNh1suvbIBdDTatUmzw2n5
	M0eYvr1/rl7oxk70AvP5+sre7ibaLpY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-qqRH5lMEMlGjN56kOhUd_Q-1; Fri, 21 Aug 2026 14:58:10 -0400
X-MC-Unique: qqRH5lMEMlGjN56kOhUd_Q-1
X-Mimecast-MFC-AGG-ID: qqRH5lMEMlGjN56kOhUd_Q_1787338689
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c19493ac2so14896751cf.1
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 11:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787338689; x=1787943489; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kx9TWcXB6g4zQsYJ1k0m/LLY9asJkpc0FRvOq2JFBz8=;
        b=Hxj2v5xyOzyUxF/PLaxHl18N/3jBLr28za1o0M/u2QzEDK4lYGGLpW3g2gUx7itJm5
         X97y8A8Vw5obo9N123Y28Pe9ZTzDR7BCsOMvNnMWc7uDS35GieSZLiXhCaHte2RRLPxX
         mWyJXGNRaiZGxxeZ0YME2GRnWCO+NMf5ycOMvjOepGJKENOPVTEaa1LRNszOB5jZ+i4/
         IfsoIbSUJ9ps1ErQ0o+G9enwRvGgX9lQr7WO0SId1rpivLFc9J7J6bqxE/7LiKR/etr8
         k0pup+fZLeBLszy7RQl7HWV1Uh9R2u2Cy/WaPkOOdfND0g7OYlBy8W0T4Leg8Ku/6W65
         4N2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338689; x=1787943489;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kx9TWcXB6g4zQsYJ1k0m/LLY9asJkpc0FRvOq2JFBz8=;
        b=IMwbQgmzgPeOjpGOjc4mEELgp+vUHqLbZa8Gpc2TljA9EfYrjKbRx1n7PvJwg0QITN
         1/xGlviH5OMX5qldiTYbAbfyajnWNEpKAQXoTBeEACfsBjPyyoQatxe7AVRkEaz15LFY
         dj71BTciJC4dYGHIR7mk8Ay/qb206Zkb2dGb8RVitV45xMFzkdbPyESbk3vDzI0TuC7p
         JkCABxw5a8a+xCFI4uXru8xmYxh1DkEB9KbWw9mQDeEM4F0FmRGdnBS4vk5KXv44KOxS
         qufoqDaHoiwnwh04InUK1VBDjTB2EGZKjq4kD2rRMnH5fLQt4oc9MThfoJfJM6rLNmVg
         1IZw==
X-Forwarded-Encrypted: i=1; AHgh+Ro4SmQfbMiztXnx1BIDo3YY/hoAjNIeL+5I9FolUb5q+WxRlFFbhYjF98iTzULh+tytLvEEZyiv@vger.kernel.org
X-Gm-Message-State: AFuF++lx17Nab/KYB7X2f6GYP1nfiYMq+xo88SDMIdFGwNFLKK5CIgc0
	9IzP0+XLgShGGiGkrTg8t977Se0OJnlOcG6bAGW+8ZrmjdvDKL8MwOceLHjROlSr28wgX91uq/y
	MpXBKPRT638Br+OJS/5cau5kF1D+CITBbkSWPi6g4hWLEj76VkpokYUmsd64=
X-Gm-Gg: AR+sD13WFqzfEV2T5NbUIfocb9OhXiRRb6BHvgoLAJqQrMJk/xwSMhPcP+Poxh7ef+V
	Db4rdNQtNHafzuFQscwNUQ72lE0FY/5YdR6ICZneQObpOjvHZgVZvhxs1x9rIIrJOPlWwRHVEz9
	bWF3XslsekFrVJcsmbayvqEol3QpXLQwq0UYNIR/otLL3m+rJb2cprEgHDCvJbSQCrJO5AUc893
	Rb8vT5KAdTnQf0ahZ9fxqB6U7mtgcvcLwTzQTCygcE/EYkgi+pJbVFatIna7NmGM1GaUzUkGEVy
	rgenhOIs6lcCXRN57/lzwcrzKuDRSX0fL4l8lsOTK8Ns2GMEO9fh/XnXjZb7CF3mSMrWb+d/n+h
	NhZMnIzI57EKF7hrNteNJ5SxmQMpZ3KHjKhx/n2hWF1Nw
X-Received: by 2002:a05:622a:1496:b0:52d:a4e5:6b3c with SMTP id d75a77b69052e-52df5748a04mr82975921cf.15.1787338689308;
        Fri, 21 Aug 2026 11:58:09 -0700 (PDT)
X-Received: by 2002:a05:622a:1496:b0:52d:a4e5:6b3c with SMTP id d75a77b69052e-52df5748a04mr82975391cf.15.1787338688779;
        Fri, 21 Aug 2026 11:58:08 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e09974c7asm1255941cf.6.2026.08.21.11.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:07 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:57:00 -0400
Subject: [PATCH 08/11] selftests: cgroup: add memcg cma tests
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cma-memcg-regions-v1-8-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3

Add test_cma_memcg with two simple tests to exercise CMA memcg
accounting using the dma-buf CMA heap
(/dev/dma_heap/default_cma_region).

test_cma_charge allocates a 4MB buffer in the default CMA area, verifies
memory.cma.reserved.current increased by that amount, then frees the
buffer and verifies that the counter returns to its original value.

test_cma_limit sets memory.cma.reserved.max to 2MB, attempts a 4MB
allocation in the default CMA area and verifies it fails as expected.

Skip the test if memory_cma_accounting is not enabled on the cgroupfs.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/.gitignore       |   1 +
 tools/testing/selftests/cgroup/Makefile         |   2 +
 tools/testing/selftests/cgroup/test_cma_memcg.c | 193 ++++++++++++++++++++++++
 3 files changed, 196 insertions(+)

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..b9a4298d4944 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 test_core
+test_cma_memcg
 test_cpu
 test_cpuset
 test_freezer
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..601d930160a4 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -8,6 +8,7 @@ TEST_PROGS     := test_stress.sh test_cpuset_prs.sh test_cpuset_v1_hp.sh
 TEST_GEN_FILES := wait_inotify
 # Keep the lists lexicographically sorted
 TEST_GEN_PROGS  = test_core
+TEST_GEN_PROGS += test_cma_memcg
 TEST_GEN_PROGS += test_cpu
 TEST_GEN_PROGS += test_cpuset
 TEST_GEN_PROGS += test_freezer
@@ -24,6 +25,7 @@ include ../lib.mk
 include lib/libcgroup.mk
 
 $(OUTPUT)/test_core: $(LIBCGROUP_O)
+$(OUTPUT)/test_cma_memcg: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
 $(OUTPUT)/test_freezer: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/test_cma_memcg.c b/tools/testing/selftests/cgroup/test_cma_memcg.c
new file mode 100644
index 000000000000..b5b5ea140518
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_cma_memcg.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <sys/mman.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <linux/dma-heap.h>
+#include <sys/ioctl.h>
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+#define CMA_HEAP_DEFAULT_PATH	"/dev/dma_heap/default_cma_region"
+#define CMA_RESERVED_CURRENT	"memory.cma.reserved.current"
+#define CMA_RESERVED_MAX	"memory.cma.reserved.max"
+
+static int cma_heap_alloc(int heap_fd, size_t size)
+{
+	struct dma_heap_allocation_data data = {
+		.len = size,
+		.fd_flags = O_RDWR | O_CLOEXEC,
+	};
+
+	if (ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &data) < 0)
+		return -1;
+
+	return data.fd;
+}
+
+static int test_cma_charge(const char *root)
+{
+	int heap_fd = -1, buf_fd = -1;
+	int rc = KSFT_FAIL, in_cg = 0;
+	size_t size = 4UL << 20;
+	long before, after;
+	char *cg;
+
+	cg = cg_name(root, "memcg_cma_charge");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_enter_current(cg))
+		goto cleanup;
+	in_cg = 1;
+
+	heap_fd = open(CMA_HEAP_DEFAULT_PATH, O_RDONLY | O_CLOEXEC);
+	if (heap_fd < 0) {
+		ksft_print_msg("cannot open CMA heap (%m)\n");
+		goto cleanup;
+	}
+
+	before = cg_read_long(cg, CMA_RESERVED_CURRENT);
+
+	buf_fd = cma_heap_alloc(heap_fd, size);
+	if (buf_fd < 0) {
+		ksft_print_msg("cannot allocate in CMA heap (%m)\n");
+		goto cleanup;
+	}
+
+	after = cg_read_long(cg, CMA_RESERVED_CURRENT);
+
+	if (after - before < (long)size) {
+		ksft_print_msg(
+			"invalid CMA counter after charge: before=%ld after=%ld\n",
+			before, after);
+		goto cleanup;
+	}
+
+	close(buf_fd);
+	buf_fd = -1;
+
+	after = cg_read_long(cg, CMA_RESERVED_CURRENT);
+	if (!values_close(before, after, 3)) {
+		ksft_print_msg(
+			"invalid CMA counter after uncharge: before=%ld after=%ld\n",
+			before, after);
+		goto cleanup;
+	}
+
+	rc = KSFT_PASS;
+
+cleanup:
+	if (buf_fd >= 0)
+		close(buf_fd);
+	if (heap_fd >= 0)
+		close(heap_fd);
+
+	if (in_cg)
+		cg_enter_current(root);
+	cg_destroy(cg);
+	free(cg);
+
+	return rc;
+}
+
+static int test_cma_limit(const char *root)
+{
+	int heap_fd = -1, buf_fd = -1;
+	int rc = KSFT_FAIL, in_cg = 0;
+	size_t size = 4UL << 20;
+	char *cg;
+
+	cg = cg_name(root, "memcg_cma_limit");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_enter_current(cg))
+		goto cleanup;
+	in_cg = 1;
+
+	if (cg_write(cg, CMA_RESERVED_MAX, "2M")) {
+		ksft_print_msg("cannot set CMA limit (%m)\n");
+		goto cleanup;
+	}
+
+	heap_fd = open(CMA_HEAP_DEFAULT_PATH, O_RDONLY | O_CLOEXEC);
+	if (heap_fd < 0) {
+		ksft_print_msg("cannot open CMA heap (%m)\n");
+		goto cleanup;
+	}
+
+	buf_fd = cma_heap_alloc(heap_fd, size);
+	if (buf_fd >= 0) {
+		ksft_print_msg("CMA limit not enforced.\n");
+		close(buf_fd);
+	} else
+		rc = KSFT_PASS;
+
+cleanup:
+	if (heap_fd >= 0)
+		close(heap_fd);
+
+	if (in_cg)
+		cg_enter_current(root);
+	cg_destroy(cg);
+	free(cg);
+
+	return rc;
+}
+
+#define T(x) { x, #x }
+struct cma_memcg_tests {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_cma_charge),
+	T(test_cma_limit),
+};
+#undef T
+
+int main(int argc, char *argv[])
+{
+	char root[PATH_MAX];
+	int has_memory_cma_acc, i;
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
+
+	has_memory_cma_acc = proc_mount_contains("memory_cma_accounting");
+	if (has_memory_cma_acc < 0)
+		ksft_exit_skip("cannot query cgroup mount option.\n");
+	else if (!has_memory_cma_acc)
+		ksft_exit_skip("CMA accounting is disabled.\n");
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroupfs is not available.\n");
+
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller is not available (CONFIG_CGROUP_MEMCG?)\n");
+
+	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
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
2.53.0

