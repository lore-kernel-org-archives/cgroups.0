From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Fri, 20 May 2022 09:09:30 -0700
Message-ID: <926b21ee-58e8-18b1-3d60-148d02f1c17a@fb.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dK/WPah+Njuj6KyTgpYn4HCZNrvh+sREx3/JSOWITTE=;
 b=KxteDxWim7Ps9k41SrVJxCLDS8pimzC9LQpOTW7fIL3HhxClUSn7/p0A8RPW00PyjhVP
 Gv2PpvrX5NBScg7bEF38u4QgSeEuk2ReCVtMIGdEPbk7gKuMrBi4vlmxESjuFr5LOw8F
 2dyb3785mbd4Spq+yjuQ8gIfMcpvFhZfgV4= 
Content-Language: en-US
In-Reply-To: <20220520012133.1217211-6-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org



On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> Add a selftest that tests the whole workflow for collecting,
> aggregating, and display cgroup hierarchical stats.
> 
> TL;DR:
> - Whenever reclaim happens, vmscan_start and vmscan_end update
>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>    have updates.
> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>    the stats.
> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>    updates, vmscan_flush aggregates cpu readings and propagates updates
>    to parents.
> 
> Detailed explanation:
> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>    measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>    rstat updated tree on that cpu.
> 
> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>    each cgroup. Reading this file invokes the program, which calls
>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>    the stats are exposed to the user.
> 
> - An ftrace program, vmscan_flush, is also loaded and attached to
>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
>    from the rstat tree in a bottom-up fashion, so calls will always be
>    made for cgroups that have updates before their parents. The program
>    aggregates percpu readings to a total per-cgroup reading, and also
>    propagates them to the parent cgroup. After rstat flushing is over, all
>    cgroups will have correct updated hierarchical readings (including all
>    cpus and all their descendants).
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   .../test_cgroup_hierarchical_stats.c          | 339 ++++++++++++++++++
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>   .../selftests/bpf/progs/cgroup_vmscan.c       | 221 ++++++++++++
>   3 files changed, 567 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
>   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> new file mode 100644
> index 000000000000..e560c1f6291f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> @@ -0,0 +1,339 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Functions to manage eBPF programs attached to cgroup subsystems
> + *
> + * Copyright 2022 Google LLC.
> + */
> +#include <errno.h>
> +#include <sys/types.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include <bpf/libbpf.h>
> +#include <bpf/bpf.h>
> +#include <test_progs.h>
> +
> +#include "cgroup_helpers.h"
> +#include "cgroup_vmscan.skel.h"
> +
> +#define PAGE_SIZE 4096
> +#define MB(x) (x << 20)
> +
> +#define BPFFS_ROOT "/sys/fs/bpf/"
> +#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
> +
> +#define CG_ROOT_NAME "root"
> +#define CG_ROOT_ID 1
> +
> +#define CGROUP_PATH(p, n) {.name = #n, .path = #p"/"#n}
> +
> +static struct {
> +	const char *name, *path;
> +	unsigned long long id;
> +	int fd;
> +} cgroups[] = {
> +	CGROUP_PATH(/, test),
> +	CGROUP_PATH(/test, child1),
> +	CGROUP_PATH(/test, child2),
> +	CGROUP_PATH(/test/child1, child1_1),
> +	CGROUP_PATH(/test/child1, child1_2),
> +	CGROUP_PATH(/test/child2, child2_1),
> +	CGROUP_PATH(/test/child2, child2_2),
> +};
> +
> +#define N_CGROUPS ARRAY_SIZE(cgroups)
> +#define N_NON_LEAF_CGROUPS 3
> +
> +bool mounted_bpffs;
> +static int duration;
> +
> +static int read_from_file(const char *path, char *buf, size_t size)
> +{
> +	int fd, len;
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0) {
> +		log_err("Open %s", path);
> +		return -errno;
> +	}
> +	len = read(fd, buf, size);
> +	if (len < 0)
> +		log_err("Read %s", path);
> +	else
> +		buf[len] = 0;
> +	close(fd);
> +	return len < 0 ? -errno : 0;
> +}
> +
> +static int setup_bpffs(void)
> +{
> +	int err;
> +
> +	/* Mount bpffs */
> +	err = mount("bpf", BPFFS_ROOT, "bpf", 0, NULL);
> +	mounted_bpffs = !err;
> +	if (CHECK(err && errno != EBUSY, "mount bpffs",

Please use ASSERT_* macros instead of CHECK.
There are similar instances below as well.

> +	      "failed to mount bpffs at %s (%s)\n", BPFFS_ROOT,
> +	      strerror(errno)))
> +		return err;
> +
> +	/* Create a directory to contain stat files in bpffs */
> +	err = mkdir(BPFFS_VMSCAN, 0755);
> +	CHECK(err, "mkdir bpffs", "failed to mkdir %s (%s)\n",
> +	      BPFFS_VMSCAN, strerror(errno));
> +	return err;
> +}
> +
> +static void cleanup_bpffs(void)
> +{
> +	/* Remove created directory in bpffs */
> +	CHECK(rmdir(BPFFS_VMSCAN), "rmdir", "failed to rmdir %s (%s)\n",
> +	      BPFFS_VMSCAN, strerror(errno));
> +
> +	/* Unmount bpffs, if it wasn't already mounted when we started */
> +	if (mounted_bpffs)
> +		return;
> +	CHECK(umount(BPFFS_ROOT), "umount", "failed to unmount bpffs (%s)\n",
> +	      strerror(errno));
> +}
> +
> +static int setup_cgroups(void)
> +{
> +	int i, err;
> +
> +	err = setup_cgroup_environment();
> +	if (CHECK(err, "setup_cgroup_environment", "failed: %d\n", err))
> +		return err;
> +
> +	for (i = 0; i < N_CGROUPS; i++) {
> +		int fd;

You can put this to the top declaration 'int i, err'.

> +
> +		fd = create_and_get_cgroup(cgroups[i].path);
> +		if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> +			return fd;
> +
> +		cgroups[i].fd = fd;
> +		cgroups[i].id = get_cgroup_id(cgroups[i].path);
> +		if (i < N_NON_LEAF_CGROUPS) {
> +			err = enable_controllers(cgroups[i].path, "memory");
> +			if (!ASSERT_OK(err, "enable_controllers"))
> +				return err;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void cleanup_cgroups(void)
> +{
> +	for (int i = 0; i < N_CGROUPS; i++)
> +		close(cgroups[i].fd);
> +	cleanup_cgroup_environment();
> +}
> +
> +
> +static int setup_hierarchy(void)
> +{
> +	return setup_bpffs() || setup_cgroups();
> +}
> +
> +static void destroy_hierarchy(void)
> +{
> +	cleanup_cgroups();
> +	cleanup_bpffs();
> +}
> +
[...]
> +
> +SEC("iter.s/cgroup")
> +int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp)
> +{
> +	struct seq_file *seq = meta->seq;
> +	struct vmscan *total_stat;
> +	__u64 cg_id = cgroup_id(cgrp);
> +
> +	/* Flush the stats to make sure we get the most updated numbers */
> +	cgroup_rstat_flush(cgrp);
> +
> +	total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
> +	if (!total_stat) {
> +		bpf_printk("error finding stats for cgroup %llu\n", cg_id);
> +		BPF_SEQ_PRINTF(seq, "cg_id: -1, total_vmscan_delay: -1\n");
> +		return 0;
> +	}
> +	BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: %llu\n",
> +		       cg_id, total_stat->state);
> +	return 0;
> +}
> +

Empty line here.

