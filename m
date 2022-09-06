From: Roberto Sassu <roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH 6/7] selftests/bpf: Ensure fd modes are checked for map iters and destroy links
Date: Tue,  6 Sep 2022 19:03:00 +0200
Message-ID: <20220906170301.256206-7-roberto.sassu@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220906170301.256206-1-roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mykolal-b10kYP2dOMg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jakub-lDpJ742SOEtZroRs9YW3xA@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Add an additional check in do_read_map_iter_fd(), to ensure that map
iterators requiring read-write access to a map cannot be created when they
receive as input a read-only fd. Do it for array maps, sk storage maps and
sock maps.

Allowing that operation could result in a map update operation not
authorized by LSMs (since they were asked for read-only access).

Finally, destroy the link when it is not supposed to be created.

Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index e89685bd587c..b2d067d38f47 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -72,10 +72,38 @@ static void do_read_map_iter_fd(struct bpf_object_skeleton **skel, struct bpf_pr
 				struct bpf_map *map)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct bpf_map_info info_m = { 0 };
+	__u32 info_m_len = sizeof(info_m);
 	union bpf_iter_link_info linfo;
 	struct bpf_link *link;
 	char buf[16] = {};
 	int iter_fd, len;
+	int ret, fd;
+
+	DECLARE_LIBBPF_OPTS(bpf_get_fd_opts, fd_opts_rdonly,
+		.open_flags = BPF_F_RDONLY,
+	);
+
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info_m, &info_m_len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		return;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, &fd_opts_rdonly);
+	if (!ASSERT_GE(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		return;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.map.map_fd = fd;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(prog, &opts);
+
+	close(fd);
+
+	if (!ASSERT_ERR_PTR(link, "attach_map_iter")) {
+		bpf_link__destroy(link);
+		return;
+	}
 
 	memset(&linfo, 0, sizeof(linfo));
 	linfo.map.map_fd = bpf_map__fd(map);
@@ -656,12 +684,12 @@ static void test_bpf_hash_map(void)
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
 	if (!ASSERT_ERR_PTR(link, "attach_iter"))
-		goto out;
+		goto free_link;
 
 	linfo.map.map_fd = bpf_map__fd(skel->maps.hashmap3);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
 	if (!ASSERT_ERR_PTR(link, "attach_iter"))
-		goto out;
+		goto free_link;
 
 	/* hashmap1 should be good, update map values here */
 	map_fd = bpf_map__fd(skel->maps.hashmap1);
@@ -683,7 +711,7 @@ static void test_bpf_hash_map(void)
 	linfo.map.map_fd = map_fd;
 	link = bpf_program__attach_iter(skel->progs.sleepable_dummy_dump, &opts);
 	if (!ASSERT_ERR_PTR(link, "attach_sleepable_prog_to_iter"))
-		goto out;
+		goto free_link;
 
 	linfo.map.map_fd = map_fd;
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
-- 
2.25.1

