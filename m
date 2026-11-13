Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.243.244.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794537904;
	b=ZN9wZGZFhbwpyOrFIfsLEXiau5+IqXTjjDx9+9jMVKtrqyIE3rmDkv8+6xvK/yW2BUBY
	 MzMbzfD76VQuuqul28GPllp3o4TgEZwhN5z/r1j2XbW+wAGqrwlmQYcy310b9JNQjJsIh
	 FBVc4EEmApSsRtLUN7Cd4YaABW67+4BBFplmJCFQJp5cu4EJiuqI2fcguMHpQY2D/289F
	 W+43ZBkCpElf/7ur8EmCQ17H2eELK8d6VlFg307viwomsi+2iI+V64HidIcWUDkXW9Mxi
	 qKlf+82Tjf/uEUozWoHMymGWBBKHRJ876IJGZdNI19+EbaZ5B5gE5fJNRhDZJJRwRkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794537904;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=gTK+CJUKCB9TjETxtk3SgMQ3mAsKhlysPlmQdHrNIo4=;
	b=YGvB0PlpOir6Zn3rlL10X7+QkSdxCxyle6cvDePC9vd82KgRiLM9s5qw4j5PfP4jmaOR
	 0PKVutFaUo9hHSAu4K6fOHnTIKIYQ/zHZ2DcGQTHDhUuilVxYMVP8igGJs1dlmQnDQfvw
	 b9pjuii2J8HBcnJ/RbCOece2hXsbiTGnQJ+fC5uCA0vgJjGJkoLCw4R/FciaIsKXCt8YV
	 21Kf1S//EaMg4DhJpfRWkE3qm8JlJX54k6RFPiVz3nFQHhYTzMGV0UBR1nVJGIz1VEgc7
	 8u1vXHo9XMA/nozVGngi5MC83EuDBKRargv3XmldEvjFNtLi7R9pV03kATEgWAkNQ9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smail.nju.edu.cn;
	spf=pass smtp.mailfrom=smail.nju.edu.cn;
	dkim=pass header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.a=rsa-sha256 header.s=iohv2404 header.b=fRH2R25X;
	arc=none smtp.remote-ip=54.243.244.52
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740AD606A31C;
	Fri, 13 Nov 2026 02:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 740AD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.a=rsa-sha256 header.s=iohv2404 header.b=fRH2R25X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1794537899;
	bh=gTK+CJUKCB9TjETxtk3SgMQ3mAsKhlysPlmQdHrNIo4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=fRH2R25XnOU61gYKZ2SSI4aEPnByV2koBClHxNyD6y1rmugZYX7NHXB5exDRdwmFH
	 oByU7k8ET/Jj/4BMc8YdbbKJFlns6en0O4z7vaGp8xIyrw/6KqHuHZl4ZliRzIE33P
	 2CN+V4A3fKE1vFEiR22j1amSIxYIFPlcsy5YbG/Y=
X-QQ-mid: zesmtpip4t1794537898t5eebd4cc
X-QQ-Originating-IP: dD1y0njpFnaJcOMo/TXNzNhF8HdteDHggezH089V2S0=
Received: from workstation-Precision-7920-Towe ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 10:44:57 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9753415056096768044
From: Kang Chen <k.chen@smail.nju.edu.cn>
To: Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org
Subject: [PATCH bpf v2 2/2] selftests/bpf: Test that a drained css iterator keeps returning NULL
Date: Fri, 13 Nov 2026 10:44:53 +0800
Message-Id: <20261113024453.922726-2-k.chen@smail.nju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261113024453.922726-1-k.chen@smail.nju.edu.cn>
References: <20261110125110.2935707-1-k.chen@smail.nju.edu.cn>
 <20261113024453.922726-1-k.chen@smail.nju.edu.cn>
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
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: M0gHv0LuXe/ScOc92M9cY7Q34GSnqjYDm2vrsu+HQJVsG0ytKmpNt3MH
	OABzM9UPNWeJoPZx/G3s1NdP3vhkhNYMiDXsvgnVsi9ItQKN4KqtPAqKVy7d0P0bxHtfXX5
	DGpabKvWJBHxYgU52nz5wHXSvWuyjuv/ELzq1sAEWrZedXppbF9htiV80RI/1MRCCvCT/7Y
	H2CHnyeowtGPYvmuBjM0Bfr6QHZvTrqxfM7e4XPrtK53mDylUmE9jTvZQphpePYZqWvwV3O
	jOXg/D+lfYRcLFWcev6OmdaJpj4GlL9D4TwoUDRKyIoHfFgEVjjkCCioq05szRsRZQ+9wLM
	owZ3jELIAyXGy0ohiKdwXGmxayY0jQ5PxY6EPLuQoiXdXhyJE9S78W0f9I2ClONksgMoQSN
	sRNW79vv3XnT/sTw3Np7oTrx2P+A40rW3bRSAYT2m7thevqfhS4J/sWsJY9k22rFEnmoys1
	yZ894XAKZ4eRj3nHYe7iM7rZ8MKtzhrTiw77ExUGmZcxDLsmAB3pn6S5HzVJ4RLpD+vjaRD
	fBEH/a4yvcrBQlCTOtum93jq/i9sM3GB0SSu6zFswl7mB7g1B6omGiUp2G1aJ6k6fD48u9u
	CXOzdYwSyw3eeh6QmF0wSoUJSzXf1oRFN1Xh76U6AHSJ6KimWwLrMHzXca+ZsbxgE7pM3yg
	IjDLWTyQoULVc1U1wWEdegAa26BDrsQZkFYh/vVJeaCS8+x5GYwD+nzC+WICuG7b1Bdn5EU
	8+7ckp6rT6n9adUeha4baEeV0HS+q7sKeew+tg4jox4mFZEYdiKxVO/DtGcsAy5Hsc/x2+R
	LPDORn5jovVK5t2CMvcKMxh7s28TlU4rLpYpJfXLaywHf9D3JWVwVmFVTt8dFNQcIDP2/yy
	74ZqbkfijKlRlHq6I442VCiEdl1XAoipBSuoz2l0vJqPeZDWxq8hDbxTc7IP9sCkXwd3geN
	z5ERp1J8QbPgwx/4A37SlBKNZ9E+ilnhSqePp7wgChpjh7En4Us56e20LeTNoHEgaMWsWZs
	3QkFMUwQmNpxBZQ1xp7frfCU/gS60=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Add a syscall program that walks the current cgroup's css descendants,
drains the iterator and calls bpf_iter_css_next() once more.  Store the
raw result in a global so the verifier cannot fold the call to zero.

The test holds an RCU read lock and releases the cgroup reference taken by
bpf_cgroup_from_id().  The user-space test checks that the constructor
succeeded, that at least one css was drained, and that the extra next()
returned NULL.

Signed-off-by: Kang Chen <k.chen@smail.nju.edu.cn>
---
v2:
- New selftest in v2.

 .../selftests/bpf/prog_tests/css_iter.c       | 35 +++++++++++++
 tools/testing/selftests/bpf/progs/css_iter.c  | 49 +++++++++++++++++++
 2 files changed, 84 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/css_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/css_iter.c

diff --git a/tools/testing/selftests/bpf/prog_tests/css_iter.c b/tools/testing/selftests/bpf/prog_tests/css_iter.c
new file mode 100644
index 000000000000..9bf8f056d3cd
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/css_iter.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include "css_iter.skel.h"
+
+static void test_css_iter_next_after_drain(void)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	struct css_iter *skel;
+	int err, fd;
+
+	skel = css_iter__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "css_iter__open_and_load"))
+		return;
+
+	fd = bpf_program__fd(skel->progs.iter_css_next_after_drain);
+	err = bpf_prog_test_run_opts(fd, &topts);
+	if (!ASSERT_OK(err, "test_run_opts err"))
+		goto out;
+	if (!ASSERT_OK(topts.retval, "test_run_opts retval"))
+		goto out;
+
+	ASSERT_OK(skel->bss->new_ret, "new_ret");
+	ASSERT_GT(skel->bss->css_count, 0, "css_count");
+	ASSERT_EQ(skel->data->next_after_drain, 0, "next_after_drain");
+
+out:
+	css_iter__destroy(skel);
+}
+
+void test_css_iter(void)
+{
+	if (test__start_subtest("next_after_drain"))
+		test_css_iter_next_after_drain();
+}
diff --git a/tools/testing/selftests/bpf/progs/css_iter.c b/tools/testing/selftests/bpf/progs/css_iter.c
new file mode 100644
index 000000000000..2ebac638bf78
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/css_iter.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "vmlinux.h"
+#include "bpf_experimental.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* Result of a bpf_iter_css_next() call after the iterator was drained */
+__u64 next_after_drain = -1;
+int new_ret;
+__u64 css_count;
+
+struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
+void bpf_cgroup_release(struct cgroup *p) __ksym;
+void bpf_rcu_read_lock(void) __ksym;
+void bpf_rcu_read_unlock(void) __ksym;
+
+SEC("syscall")
+int iter_css_next_after_drain(const void *ctx)
+{
+	u64 cg_id = bpf_get_current_cgroup_id();
+	struct cgroup *cgrp = bpf_cgroup_from_id(cg_id);
+	struct cgroup_subsys_state *pos;
+	struct bpf_iter_css it;
+
+	if (!cgrp) {
+		new_ret = -1;
+		return 0;
+	}
+
+	bpf_rcu_read_lock();
+	new_ret = bpf_iter_css_new(&it, &cgrp->self,
+				   BPF_CGROUP_ITER_DESCENDANTS_PRE);
+	if (new_ret)
+		goto out_destroy;
+
+	while ((pos = bpf_iter_css_next(&it)))
+		css_count++;
+
+	/* Store the raw value; the verifier would remove a branch on it */
+	next_after_drain = (__u64)bpf_iter_css_next(&it);
+
+out_destroy:
+	/* The destructor is called even when the constructor failed. */
+	bpf_iter_css_destroy(&it);
+	bpf_rcu_read_unlock();
+	bpf_cgroup_release(cgrp);
+	return 0;
+}
-- 
2.34.1

