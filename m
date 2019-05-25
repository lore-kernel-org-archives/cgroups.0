From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v5 bpf-next 4/4] selftests/bpf: add auto-detach test
Date: Sat, 25 May 2019 09:37:42 -0700
Message-ID: <20190525163742.2616471-5-guro@fb.com>
References: <20190525163742.2616471-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lnPKXVooJUbpNWC+TYw9Uba3sAqshRTgWZf+RLcJsCI=;
 b=Rle19znJg/aLiVMugEYDnp8OAPnyKDVLqwHVQITc51uNuaEglgY9pnM1xYkmSGUVlCgO
 6D5qhnIa3mXxkGbL21OkjEA1ulxpSEzL8cFNmTGzKGmHArZpDxnzQ8suN9QeSZxwJeq4
 rq6Q8cGkYT8J+Y8gXCh1CBW7vy8yq/w69Go= 
In-Reply-To: <20190525163742.2616471-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

Add a kselftest to cover bpf auto-detachment functionality.
The test creates a cgroup, associates some resources with it,
attaches a couple of bpf programs and deletes the cgroup.

Then it checks that bpf programs are going away in 5 seconds.

Expected output:
  $ ./test_cgroup_attach
  #override:PASS
  #multi:PASS
  #autodetach:PASS
  test_cgroup_attach:PASS

On a kernel without auto-detaching:
  $ ./test_cgroup_attach
  #override:PASS
  #multi:PASS
  #autodetach:FAIL
  test_cgroup_attach:FAIL

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/test_cgroup_attach.c        | 98 ++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_cgroup_attach.c b/tools/testing/selftests/bpf/test_cgroup_attach.c
index 2d6d57f50e10..7671909ee1cb 100644
--- a/tools/testing/selftests/bpf/test_cgroup_attach.c
+++ b/tools/testing/selftests/bpf/test_cgroup_attach.c
@@ -456,9 +456,105 @@ static int test_multiprog(void)
 	return rc;
 }
 
+static int test_autodetach(void)
+{
+	__u32 prog_cnt = 4, attach_flags;
+	int allow_prog[2] = {0};
+	__u32 prog_ids[2] = {0};
+	int cg = 0, i, rc = -1;
+	void *ptr = NULL;
+	int attempts;
+
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++) {
+		allow_prog[i] = prog_load_cnt(1, 1 << i);
+		if (!allow_prog[i])
+			goto err;
+	}
+
+	if (setup_cgroup_environment())
+		goto err;
+
+	/* create a cgroup, attach two programs and remember their ids */
+	cg = create_and_get_cgroup("/cg_autodetach");
+	if (cg < 0)
+		goto err;
+
+	if (join_cgroup("/cg_autodetach"))
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++) {
+		if (bpf_prog_attach(allow_prog[i], cg, BPF_CGROUP_INET_EGRESS,
+				    BPF_F_ALLOW_MULTI)) {
+			log_err("Attaching prog[%d] to cg:egress", i);
+			goto err;
+		}
+	}
+
+	/* make sure that programs are attached and run some traffic */
+	assert(bpf_prog_query(cg, BPF_CGROUP_INET_EGRESS, 0, &attach_flags,
+			      prog_ids, &prog_cnt) == 0);
+	assert(system(PING_CMD) == 0);
+
+	/* allocate some memory (4Mb) to pin the original cgroup */
+	ptr = malloc(4 * (1 << 20));
+	if (!ptr)
+		goto err;
+
+	/* close programs and cgroup fd */
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++) {
+		close(allow_prog[i]);
+		allow_prog[i] = 0;
+	}
+
+	close(cg);
+	cg = 0;
+
+	/* leave the cgroup and remove it. don't detach programs */
+	cleanup_cgroup_environment();
+
+	/* wait for the asynchronous auto-detachment.
+	 * wait for no more than 5 sec and give up.
+	 */
+	for (i = 0; i < ARRAY_SIZE(prog_ids); i++) {
+		for (attempts = 5; attempts >= 0; attempts--) {
+			int fd = bpf_prog_get_fd_by_id(prog_ids[i]);
+
+			if (fd < 0)
+				break;
+
+			/* don't leave the fd open */
+			close(fd);
+
+			if (!attempts)
+				goto err;
+
+			sleep(1);
+		}
+	}
+
+	rc = 0;
+err:
+	for (i = 0; i < ARRAY_SIZE(allow_prog); i++)
+		if (allow_prog[i] > 0)
+			close(allow_prog[i]);
+	if (cg)
+		close(cg);
+	free(ptr);
+	cleanup_cgroup_environment();
+	if (!rc)
+		printf("#autodetach:PASS\n");
+	else
+		printf("#autodetach:FAIL\n");
+	return rc;
+}
+
 int main(void)
 {
-	int (*tests[])(void) = {test_foo_bar, test_multiprog};
+	int (*tests[])(void) = {
+		test_foo_bar,
+		test_multiprog,
+		test_autodetach,
+	};
 	int errors = 0;
 	int i;
 
-- 
2.21.0

