From: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] selftests: cgroup: add zswap-memcg unwanted writeback test
Date: Wed, 21 Jun 2023 17:35:48 +0200
Message-ID: <20230621153548.428093-4-cerasuolodomenico@gmail.com>
References: <20230621153548.428093-1-cerasuolodomenico@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687361758; x=1689953758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WEOIwynIIsT/3TCYBn4hnrnBW3FX88KHSnE+980PXNU=;
        b=LeFLd/T5OM7aszQ1BHpFd0lDMx5q3DtKYmanSZjPYSO9vh9puF3ky8Fx90y7g5rbL/
         ZQesZAiEn4lr2smBWWC3dAzUstEMURZ+QSShkPF6FjFpZf/FHZ6X5GDVlslXIdQUxLfl
         KgT1BGP5eERxBDUn+DMzi4Tlv13Y8MqVVVbZC09Ve8oTJI9eLkqyqNPNCyWrHxApZj8y
         kgAL6n5oXWw5LVHF0E2lo2tQn6ylvgXV1O/8dxzLIbQXAwYVD8MQIDmxcYIi3A8Ys9nb
         PyPHQzQAr0tJmcixMtaFbr5pJDcFTYhJpajQz2ErIoQ/MpRwnd5ayZQRzSobig5ls2OW
         usAw==
In-Reply-To: <20230621153548.428093-1-cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ddstreet-EkmVulN54Sk@public.gmane.org, vitaly.wool-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, nphamcs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add a test to verify that when a memcg hits its limit in zswap, it
doesn't trigger an unwanted writeback that would result in pages not
owned by that memcg to be sent to disk, even if zswap isn't full.
This was fixed by commit 0bdf0efa180a("zswap: do not shrink if cgroup
may not zswap").

Signed-off-by: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 61 +++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index e859fecd310b..49def87a909b 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -50,6 +50,66 @@ static int get_zswap_stored_pages(size_t *value)
 	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
 }
 
+static int get_zswap_written_back_pages(size_t *value)
+{
+	return read_int("/sys/kernel/debug/zswap/written_back_pages", value);
+}
+
+static int allocate_bytes(const char *cgroup, void *arg)
+{
+	size_t size = (size_t)arg;
+	char *mem = (char *)malloc(size);
+
+	if (!mem)
+		return -1;
+	for (int i = 0; i < size; i += 4095)
+		mem[i] = 'a';
+	free(mem);
+	return 0;
+}
+
+/*
+ * When trying to store a memcg page in zswap, if the memcg hits its memory
+ * limit in zswap, writeback should not be triggered.
+ *
+ * This was fixed with commit 0bdf0efa180a("zswap: do not shrink if cgroup may
+ * not zswap"). Needs to be revised when a per memcg writeback mechanism is
+ * implemented.
+ */
+static int test_no_invasive_cgroup_shrink(const char *root)
+{
+	size_t written_back_before, written_back_after;
+	int ret = KSFT_FAIL;
+	char *test_group;
+
+	/* Set up */
+	test_group = cg_name(root, "no_shrink_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "1M"))
+		goto out;
+	if (cg_write(test_group, "memory.zswap.max", "10K"))
+		goto out;
+	if (get_zswap_written_back_pages(&written_back_before))
+		goto out;
+
+	/* Allocate 10x memory.max to push memory into zswap */
+	if (cg_run(test_group, allocate_bytes, (void *)MB(10)))
+		goto out;
+
+	/* Verify that no writeback happened because of the memcg allocation */
+	if (get_zswap_written_back_pages(&written_back_after))
+		goto out;
+	if (written_back_after == written_back_before)
+		ret = KSFT_PASS;
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
 struct no_kmem_bypass_child_args {
 	size_t target_alloc_bytes;
 	size_t child_allocated;
@@ -176,6 +236,7 @@ struct zswap_test {
 	const char *name;
 } tests[] = {
 	T(test_no_kmem_bypass),
+	T(test_no_invasive_cgroup_shrink),
 };
 #undef T
 
-- 
2.34.1

