Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5D6433E84;
	Sat,  4 Jul 2026 05:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783143542; cv=none; b=od0O4bMFQaN2Y1clinHsYq/OB2oJ6056i4Py4TQiSp5BUhzrx1SwY8TNiY6OiIABPzzsPw89nCSk3BY4cSVWcyu4fX/aoYKvaeDYjmoVi/BaYYMdaOrXwoZmPCNqmCMAPosZvR3BvFZUCCGcl0iE7iaCN8RD8eeEZkKyJ7X9dHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783143542; c=relaxed/simple;
	bh=A+KjvuIipBnT7135EzuQXTsoASaUxKfMzokXbeK1pG0=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=VtQua7a/A0Sp11KZ+y4cPnw0pJCK6/QXcCuJKZJrqwOtivxPYkxGbqUaD3/kMl6jGph+/n5zrAqPD0IXrVyD0d6OXXEWVukrtOwjbnmCHgTOuQLE3WHOa81kSaaKE+5Esly5tcarpQFkcYaDILmRcxUwwnw1sBYaYd+ED3BzgX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5zChWYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5zChWYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673E01F000E9;
	Sat,  4 Jul 2026 05:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783143540;
	bh=Omav1PnVWAaMZoG6fUApE0dlp68yQBo+33N50QCsh9c=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Z5zChWYGLr0SHmTjjiqBGh0M7SlqKkNtKKOqVR/nPEaLT9OlNTAKFffZ1Ozyos581
	 ckbpJTAddK521RhDoYRpoHgCkrGEcpRK1P+h84zhGcDz/5sV2gRgFiI/hDzt5K1E7Z
	 2WyjJTpZKXoETEh/Y2NGhFK+vCDR7SECYQg0B7oLuLTVI8Pvt2AeO1Btf/l5A9hDBC
	 d6myTRAu7x1tu02MUEgvkfz8Gg91pFau2lx6smMw/8FtVw43BRDYHfzBt7Z4UER0SU
	 ldl0mwaGWX+SDxH924GS3hlG6e0Aqzqv8h3gHwfhVb6H2S03qDg0HgTIP4kipKjEel
	 qtlAcbvCR494w==
Content-Type: multipart/mixed; boundary="===============0892255960102653600=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <020c0e385f57d0b2dcdad92ae1ba2f411ec854dd9fb0f0eb4b4a618538b1c983@mail.kernel.org>
In-Reply-To: <20260704045617.487664-3-ziyang.meme@gmail.com>
References: <20260704045617.487664-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH 2/3] selftests/bpf: add memcg_stat_churn BPF-vs-memory.stat benchmark under churn
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,roman.gushchin@linux.dev,kernel-team@meta.com,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ziyang.meme@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sat,  4 Jul 2026 05:39:00 +0000 (UTC)

--===============0892255960102653600==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c b/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c
> new file mode 100644
> index 000000000000..3e386d0b4c03
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c

[ ... ]

> +static long long now_ns(void)
> +{
> +	struct timespec t;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &t);
> +	return (long long)t.tv_sec * 1000000000LL + t.tv_nsec;
> +}
> +
> +/* ---- tree construction (same shape as memcg_stat_reader) --------------- */
> +
> +static struct cg_node *nodes;
> +static int n_nodes;
> +static int n_leaves;
> +
> +static int add_node(const char *rel, bool is_leaf, int *keep_fd)
> +{
> +	int fd;
> +
> +	fd = create_and_get_cgroup(rel);
> +	if (fd < 0)
> +		return -1;
> +	if (keep_fd)
> +		*keep_fd = fd;
> +	else
> +		close(fd);
> +
> +	strncpy(nodes[n_nodes].rel, rel, sizeof(nodes[n_nodes].rel) - 1);
> +	nodes[n_nodes].rel[sizeof(nodes[n_nodes].rel) - 1] = '\0';
> +	nodes[n_nodes].id = get_cgroup_id(rel);
> +	nodes[n_nodes].is_leaf = is_leaf;
> +	if (is_leaf)
> +		n_leaves++;
> +	n_nodes++;
> +	return 0;
> +}
> +
> +/* Recursively create children of @rel. @rel must already exist and be recorded. */
> +static int build_children(const char *rel, int fanout, int depth)
> +{
> +	char child[128];
> +	int i;
> +
> +	if (depth == 0)
> +		return 0;
> +
> +	/* Enable memory on this interior node so its children get a memcg. */
> +	if (enable_controllers(rel, "memory"))
> +		return -1;
> +
> +	for (i = 0; i < fanout; i++) {
> +		snprintf(child, sizeof(child), "%s/c%d", rel, i);
> +		if (add_node(child, depth == 1, NULL))
> +			return -1;
> +		if (build_children(child, fanout, depth - 1))
> +			return -1;
> +	}
> +	return 0;
> +}
> +
> +static size_t tree_capacity(int fanout, int depth)
> +{
> +	size_t total = 1, level = 1;
> +	int d;
> +
> +	for (d = 0; d < depth; d++) {
> +		level *= fanout;
> +		total += level;
> +	}
> +	return total;
> +}
> +
> +static int build_tree(int fanout, int depth, int *root_fd)
> +{
> +	n_nodes = 0;
> +	n_leaves = 0;
> +	nodes = calloc(tree_capacity(fanout, depth), sizeof(*nodes));
> +	if (!nodes)
> +		return -1;
> +
> +	if (add_node(SUBTREE_ROOT, depth == 0, root_fd))
> +		return -1;
> +	return build_children(SUBTREE_ROOT, fanout, depth);
> +}

[ ... ]

> +static void parse_stat(char *buf, struct file_snap *o)
> +{
> +	char *save, *line;
> +
> +	for (line = strtok_r(buf, "\n", &save); line;
> +	     line = strtok_r(NULL, "\n", &save)) {
> +		unsigned long long val;
> +		char name[64];
> +
> +		if (sscanf(line, "%63s %llu", name, &val) != 2)
> +			continue;
> +		o->full_sum += val;
> +		o->full_fields++;
> +		if (!strcmp(name, "anon"))
> +			o->anon = val;
> +		else if (!strcmp(name, "file"))
> +			o->file = val;
> +		else if (!strcmp(name, "shmem"))
> +			o->shmem = val;
> +		else if (!strcmp(name, "file_mapped"))
> +			o->file_mapped = val;
> +		else if (!strcmp(name, "pgfault"))
> +			o->pgfault = val;
> +	}
> +}
> +
> +static int file_read_node(const char *rel, struct file_snap *o)
> +{
> +	char buf[8192];
> +
> +	memset(o, 0, sizeof(*o));
> +
> +	if (read_cgroup_file(rel, "memory.stat", buf, sizeof(buf)))
> +		return -1;
> +	parse_stat(buf, o);
> +
> +	if (!read_cgroup_file(rel, "memory.current", buf, sizeof(buf)))
> +		o->current = strtoull(buf, NULL, 10);
> +	if (!read_cgroup_file(rel, "memory.max", buf, sizeof(buf))) {
> +		if (!strncmp(buf, "max", 3))
> +			o->max_is_max = true;
> +		else
> +			o->max = strtoull(buf, NULL, 10);
> +	}
> +	return 0;
> +}

[ ... ]

> +static int drain_map(int mfd, struct memcg_stat_snapshot *out, int max)
> +{
> +	__u64 key = 0, next;
> +	int n = 0, err;
> +
> +	err = bpf_map_get_next_key(mfd, NULL, &next);
> +	while (err == 0) {
> +		if (n < max && !bpf_map_lookup_elem(mfd, &next, &out[n])) {
> +			sink += out[n].anon + out[n].full_sum;
> +			n++;
> +		}
> +		key = next;
> +		err = bpf_map_get_next_key(mfd, &key, &next);
> +	}
> +	return n;
> +}

[ ... ]

> +static bool memcg_kfuncs_available(void)
> +{
> +	struct btf *btf;
> +	bool ok;
> +
> +	btf = btf__load_vmlinux_btf();
> +	if (!btf)
> +		return false;
> +	ok = btf__find_by_name_kind(btf, "bpf_get_mem_cgroup", BTF_KIND_FUNC) > 0;
> +	btf__free(btf);
> +	return ok;
> +}

This isn't a bug, but several of these helpers appear nearly identical
to the ones in prog_tests/memcg_stat_reader.c -- tree_capacity(),
build_tree(), add_node(), build_children(), drain_map(), bpf_walk_once(),
file_read_node(), parse_stat(), now_ns(), and memcg_kfuncs_available().

The commit message notes the BPF program, map, and snapshot struct are
reused, but the userspace tree-construction and file-reader helpers are
duplicated rather than shared. Could the common pieces move into a small
shared header so the two tests don't drift apart over time?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/28695985027
--===============0892255960102653600==--
