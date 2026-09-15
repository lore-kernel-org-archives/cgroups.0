Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92D23B19B4;
	Tue, 15 Sep 2026 12:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476058; cv=none; b=nANNVmmkKxjB+UjrjwwngWWjUiIoXmuIkmEizXsWK1iL1mcvi15mC5oOiEPgJi4yTiZSwmOMsICCW/7Ea+rNmnQXC/U4X+Z5C8CL7+XAtnvBff0o99bxxalfEv/QqI0Q0Qjp/fnHpajx8fjuxAa24xl+KoaKrqk5pyt6sxwJpkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476058; c=relaxed/simple;
	bh=lK8p3vq8Qdfa0WHwB9t+AItemftdfcNQ3jgLOiA+nBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsyBajhvhgtoRLAbgipvxc9+L1zKn5I9ecZY3d8ojVoxVFvaDXCYUfhDMKkEDvtPf7eyiddae7lvDGBdDvtRIJgrYQtwlCcQvyC2yNVNgq/08ncFKULLt+LQD+cUVMV8JIil7SRPh4ag8xJunyGUhlZFu2C+SPf52O7TcNAryoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=apUrA7o3; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="apUrA7o3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=z2
	U8h+zF57zfpgG0XDnBuYqu+d5iFOPNY28cQLpmvMM=; b=apUrA7o3NqVZtzl5sP
	IEmmLVyRuwdFIdgaV3OWIriyUYDHhOdUjomPkekGTeN2lF1ozD/hkmKQyqLoT4RD
	LC3MNX+4xNjTF6OT8Rz8ej34WQ7CkUla95uzPZWMdOp12qXVowkPoPVFRJyCLthx
	UR4WJpBIuk9LDA9mmw7QMQ6Ak=
Received: from sky.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3v02rPKlqNilvAw--.51711S2;
	Tue, 15 Sep 2026 20:40:11 +0800 (CST)
From: Junnan Zhang <zhangjn_dev@163.com>
To: zhangjn_dev@163.com
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	ridong.chen@linux.dev,
	sunshx@chinatelecom.cn,
	tj@kernel.org
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in cgroup1_pidlist_destroy_all
Date: Tue, 15 Sep 2026 20:40:10 +0800
Message-ID: <20260915124010.18927-1-zhangjn_dev@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910061610.91209-1-zhangjn_dev@163.com>
References: <20260910061610.91209-1-zhangjn_dev@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v02rPKlqNilvAw--.51711S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3uF1UKF1xXrWxKF1rZr1DWrg_yoW8Gr15Zo
	Z5J3W8Jr18Xr1DXr18Gw1DtrW5Wr1xCr97tr1UXr4DGF1UCr4jqw13Ga13Gw12qr4UCr17
	JrWYqr4UX3W8tF4Un29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUjApnDUUUU
X-CM-SenderInfo: x2kd0wxmqbvvry6rljoofrz/xtbC7Qs+02qpPKtiJwAA3a

Hi Tejun,

As promised, here are the numbers from a synthetic reproducer.

Common setup (deliberately excluding all the alternative contributors
you mentioned):

- test VM, with/without the patch, no other workload, no memory
  pressure, CPUs far from saturated
- a private v1 named hierarchy (no controllers), so nothing else on
  the system touches cgroup_pidlist_destroy_wq
- some long-lived cgroups holding tasks ("containers"), concurrent
  readers sweeping their cgroup.procs ("monitoring agents"), and churn
  threads doing mkdir/read tasks/rmdir ("container churn")
- latency of cgroup1_pidlist_destroy_all() measured with bpftrace
  kprobe/kretprobe, aggregated per 10s window

I ran two configurations at different scales (same 1000 churners):

  Run A: 8 CPUs, 1G RAM, 200 cgroups x 20 tasks, 100 readers, 300s
           ./cg_flush_repro -s 200 -t 20 -r 100 -c 1000 -d 300

  Run B: 64 CPUs, 16G RAM, 50 cgroups x 1000 tasks, 50 readers, 300s
           ./cg_flush_repro -s 50 -t 1000 -r 50 -c 1000 -d 300

Summary (per 10s window; count = number of calls, avg/max per call):

  Run A unpatched:  count ~400,     avg 71-103 us,   max ~9.8 ms
  Run A patched:    count 157-641,  avg 3-6 us,      max 32-78 us

  Run B unpatched:  count ~40k,     avg 1044-1306 us, max 218-253 ms
                    (tail: ~1000 samples above 2 ms,
                     dozens above 128 ms per window)
  Run B patched:    count ~43-45k,  avg 1 us,        max 131-188 us

Two observations:

1. The coupling scales as predicted: flush latency = backlog x
   per-work latency. Both factors grew from run A to run B -- the
   bigger machine keeps a deeper backlog in flight, and 1000 instead
   of 20 tasks per cgroup make each pidlist rebuild hold pidlist_mutex
   much longer. The unpatched latency grew accordingly: average from
   ~100us to >1ms, max from ~10ms to ~250ms, with a long tail of
   individual flush calls waiting behind the backlog (see the Run B
   histograms below: single flush calls waiting >100ms are not
   outliers but a steady population).

2. With the patch, latency stays flat and microscopic (max < 200us)
   at the same churn rate in both runs -- destroy latency no longer
   depends on the queue backlog at all.

To be upfront: I still have not reproduced the full 120s hang in the
lab; the backlog and per-work latency I can build here remain well
below the production node's. But the unpatched latency grows with
exactly the two factors that were larger in production, while the
patched latency is insensitive to them -- on an otherwise idle
machine, with no competing workqueue items, no worker-creation stalls
and no CPU contention.

The raw bpftrace output (two 10s windows per configuration), the
reproducer (cg_flush_repro.c) and the bpftrace script
(cg_flush_lat.bt) are included below.

Thanks,
Junnan

---
Raw bpftrace output:

Run A, unpatched:

  @count: 406
  @avg_us: 71
  @max_us: 9765
  @lat_us:
  [0]                   16 |@@@@@@                                              |
  [1]                    2 |                                                    |
  [2, 4)                80 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                     |
  [4, 8)               131 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [8, 16)              121 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    |
  [16, 32)              35 |@@@@@@@@@@@@@                                       |
  [32, 64)               7 |@@                                                  |
  [64, 128)              1 |                                                    |
  [128, 256)             5 |@                                                   |
  [256, 512)             3 |@                                                   |
  [512, 1K)              0 |                                                    |
  [1K, 2K)               2 |                                                    |
  [2K, 4K)               0 |                                                    |
  [4K, 8K)               2 |                                                    |
  [8K, 16K)              1 |                                                    |

  @count: 393
  @avg_us: 103
  @max_us: 9582
  @lat_us:
  [0]                   13 |@@@@                                                |
  [1]                    1 |                                                    |
  [2, 4)                61 |@@@@@@@@@@@@@@@@@@@@@                               |
  [4, 8)               150 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [8, 16)              106 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                |
  [16, 32)              33 |@@@@@@@@@@@                                         |
  [32, 64)              10 |@@@                                                 |
  [64, 128)              4 |@                                                   |
  [128, 256)             4 |@                                                   |
  [256, 512)             3 |@                                                   |
  [512, 1K)              0 |                                                    |
  [1K, 2K)               2 |                                                    |
  [2K, 4K)               3 |@                                                   |
  [4K, 8K)               2 |                                                    |
  [8K, 16K)              1 |                                                    |

Run A, patched:

  @count: 157
  @avg_us: 6
  @max_us: 32
  @lat_us:
  [0]                    2 |                                                    |
  [1]                    0 |                                                    |
  [2, 4)                 9 |@@@@                                                |
  [4, 8)               117 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [8, 16)               23 |@@@@@@@@@@                                          |
  [16, 32)               5 |@@                                                  |
  [32, 64)               1 |                                                    |

  @count: 641
  @avg_us: 3
  @max_us: 78
  @lat_us:
  [0]                   57 |@@@@@@@@@@                                          |
  [1]                   30 |@@@@@                                               |
  [2, 4)               281 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [4, 8)               254 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     |
  [8, 16)               13 |@@                                                  |
  [16, 32)               5 |                                                    |
  [32, 64)               0 |                                                    |
  [64, 128)              1 |                                                    |

Run B, unpatched:

  @count: 40124
  @avg_us: 1044
  @max_us: 218693
  @lat_us:
  [4, 8)              6822 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              |
  [8, 16)             3895 |@@@@@@@@@@@@@@@@@@@@@                               |
  [16, 32)            1467 |@@@@@@@@                                            |
  [32, 64)            2848 |@@@@@@@@@@@@@@@                                     |
  [64, 128)           5475 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      |
  [128, 256)          9321 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [256, 512)          7324 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            |
  [512, 1K)            948 |@@@@@                                               |
  [1K, 2K)             179 |                                                    |
  [2K, 4K)             515 |@@                                                  |
  [4K, 8K)             393 |@@                                                  |
  [8K, 16K)            179 |                                                    |
  [16K, 32K)           528 |@@                                                  |
  [32K, 64K)           123 |                                                    |
  [64K, 128K)           78 |                                                    |
  [128K, 256K)          35 |                                                    |

  @count: 39245
  @avg_us: 1306
  @max_us: 253031
  @lat_us:
  [4, 8)              5188 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@                        |
  [8, 16)             4072 |@@@@@@@@@@@@@@@@@@@@@@                              |
  [16, 32)            1366 |@@@@@@@                                             |
  [32, 64)            2340 |@@@@@@@@@@@@                                        |
  [64, 128)           4782 |@@@@@@@@@@@@@@@@@@@@@@@@@                           |
  [128, 256)          9566 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [256, 512)          8335 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       |
  [512, 1K)           1688 |@@@@@@@@@                                           |
  [1K, 2K)             134 |                                                    |
  [2K, 4K)             466 |@@                                                  |
  [4K, 8K)             387 |@@                                                  |
  [8K, 16K)            156 |                                                    |
  [16K, 32K)           457 |@@                                                  |
  [32K, 64K)           112 |                                                    |
  [64K, 128K)          138 |                                                    |
  [128K, 256K)          56 |                                                    |

Run B, patched:

  @count: 45368
  @avg_us: 1
  @max_us: 131
  @lat_us:
  [0]                  569 |                                                    |
  [1]                38421 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [2, 4)              5330 |@@@@@@@                                             |
  [4, 8)               957 |@                                                   |
  [8, 16)               71 |                                                    |
  [16, 32)              12 |                                                    |
  [32, 64)               1 |                                                    |
  [64, 128)              6 |                                                    |
  [128, 256)             1 |                                                    |

  @count: 42817
  @avg_us: 1
  @max_us: 188
  @lat_us:
  [0]                 1156 |@                                                   |
  [1]                34402 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
  [2, 4)              6165 |@@@@@@@@@                                           |
  [4, 8)               919 |@                                                   |
  [8, 16)              147 |                                                    |
  [16, 32)              23 |                                                    |
  [32, 64)               2 |                                                    |
  [64, 128)              1 |                                                    |
  [128, 256)             2 |                                                    |

---
==> cg_flush_repro.c <==

/*
 * cg_flush_repro.c - synthetic reproducer for the cgroup v1 pidlist
 * destroy workqueue backlog (the scenario behind the hung task splat in
 * cgroup1_pidlist_destroy_all() -> flush_workqueue()).
 *
 * It reproduces the three conditions of a busy container node:
 *
 *   1. many long-lived cgroups, each holding many tasks ("containers");
 *   2. concurrent readers sweeping cgroup.procs ("monitoring agents")
 *      with a sweep period >> CGROUP_PIDLIST_DESTROY_DELAY (1s), so the
 *      pidlist cache never hits: every read rebuilds the pidlist under
 *      pidlist_mutex and queues an expiry destroy work 1s later;
 *   3. constant cgroup create/read/destroy churn from several threads,
 *      where each destruction ends up in cgroup1_pidlist_destroy_all()
 *      and, on an unpatched kernel, flush_workqueue() on the shared
 *      cgroup_pidlist_destroy_wq.
 *
 * Compare `cgroup1_pidlist_destroy_all()` latency with and without the
 * fix using cg_flush_lat.bt (bpftrace).
 *
 * Build:  gcc -O2 -pthread -o cg_flush_repro cg_flush_repro.c
 * Usage:  sudo ./cg_flush_repro [-m mnt] [-s seed_cgroups] [-t tasks_per]
 *                               [-r readers] [-c churners] [-d seconds]
 *
 * Needs root. Works on cgroup v2-only systems as well: it mounts its
 * own v1 named hierarchy (no controllers needed, cgroup.procs/tasks
 * still go through the v1 pidlist code).
 *
 * WARNING: this deliberately stresses the kernel. Run it in a test VM,
 * never on a production host.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <pthread.h>
#include <signal.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define NAME_PREFIX	"cgflush"

static const char *mnt = "/tmp/cgflush_v1";
static int nr_seed = 500;	/* long-lived cgroups swept by readers */
static int tasks_per = 50;	/* tasks in each seed cgroup */
static int nr_readers = 16;	/* concurrent cgroup.procs readers */
static int nr_churners = 4;	/* concurrent cgroup create/destroy threads */
static int duration = 300;	/* seconds */

static volatile sig_atomic_t stop;

static atomic_ulong reads_done;
static atomic_ulong churn_done;
static atomic_ulong errors;

static pid_t *children;		/* nr_seed * tasks_per tasks */
static size_t nr_children;

static void on_signal(int sig)
{
	stop = 1;
}

static int write_pid(const char *path, pid_t pid)
{
	char buf[32];
	int len = snprintf(buf, sizeof(buf), "%d", pid);
	int fd = open(path, O_WRONLY);
	int ret = -1;

	if (fd < 0)
		return -1;
	if (write(fd, buf, len) == len)
		ret = 0;
	close(fd);
	return ret;
}

/* Read the whole file so the seq_file start/stop cycle completes. */
static int read_fully(const char *path)
{
	char buf[65536];
	ssize_t n;
	int fd = open(path, O_RDONLY);

	if (fd < 0)
		return -1;
	while ((n = read(fd, buf, sizeof(buf))) > 0)
		;
	close(fd);
	return n < 0 ? -1 : 0;
}

static void *reader_fn(void *arg)
{
	long id = (long)arg;
	unsigned int seed = getpid() ^ (id * 2654435761u);
	char path[256];

	while (!stop) {
		int idx = rand_r(&seed) % nr_seed;

		snprintf(path, sizeof(path), "%s/seed_%d/cgroup.procs", mnt, idx);
		if (read_fully(path) == 0)
			atomic_fetch_add(&reads_done, 1);
		else
			atomic_fetch_add(&errors, 1);
	}
	return NULL;
}

/*
 * Churn: repeatedly create a cgroup, read its tasks file (building a
 * pidlist, hence queueing a destroy work) and remove it.  The cgroup
 * destruction ends up in cgroup1_pidlist_destroy_all().  Each churner
 * thread uses its own dir name prefix so they never collide.
 */
static void *churn_fn(void *arg)
{
	long id = (long)arg;
	char dir[256], path[320];
	unsigned long i = 0;

	while (!stop) {
		snprintf(dir, sizeof(dir), "%s/churn_%ld_%lu", mnt, id, i);
		snprintf(path, sizeof(path), "%s/tasks", dir);

		if (mkdir(dir, 0755) < 0) {
			atomic_fetch_add(&errors, 1);
			usleep(1000);
			continue;
		}
		read_fully(path);
		if (rmdir(dir) == 0)
			atomic_fetch_add(&churn_done, 1);
		i++;
	}
	return NULL;
}

static void spawn_task(size_t cgroup_idx)
{
	pid_t pid = fork();
	char path[256];

	if (pid < 0) {
		perror("fork");
		return;
	}
	if (pid == 0) {
		/* child: just exist as a cgroup member */
		for (;;)
			pause();
	}
	children[nr_children++] = pid;
	snprintf(path, sizeof(path), "%s/seed_%zu/cgroup.procs", mnt, cgroup_idx);
	write_pid(path, pid);
}

static void cleanup(void)
{
	size_t i;
	char path[256];

	for (i = 0; i < nr_children; i++)
		kill(children[i], SIGKILL);
	while (waitpid(-1, NULL, 0) > 0)
		;
	for (i = 0; i < (size_t)nr_seed; i++) {
		snprintf(path, sizeof(path), "%s/seed_%zu", mnt, i);
		rmdir(path);
	}
	umount(mnt);
	rmdir(mnt);
}

int main(int argc, char **argv)
{
	pthread_t *readers, *churners;
	struct sigaction sa = { .sa_handler = on_signal };
	unsigned long reads, churns;
	int opt, i;

	while ((opt = getopt(argc, argv, "m:s:t:r:c:d:")) != -1) {
		switch (opt) {
		case 'm': mnt = optarg; break;
		case 's': nr_seed = atoi(optarg); break;
		case 't': tasks_per = atoi(optarg); break;
		case 'r': nr_readers = atoi(optarg); break;
		case 'c': nr_churners = atoi(optarg); break;
		case 'd': duration = atoi(optarg); break;
		default:
			fprintf(stderr,
				"usage: %s [-m mnt] [-s seed_cgroups] "
				"[-t tasks_per] [-r readers] [-c churners] "
				"[-d seconds]\n",
				argv[0]);
			return 1;
		}
	}

	sigaction(SIGINT, &sa, NULL);
	sigaction(SIGTERM, &sa, NULL);

	/* mount a v1 named hierarchy (no controllers needed) */
	if (mkdir(mnt, 0755) < 0 && errno != EEXIST) {
		perror("mkdir mountpoint");
		return 1;
	}
	if (mount("cgroup", mnt, "cgroup", 0, "none,name=" NAME_PREFIX) < 0 &&
	    errno != EBUSY) {
		perror("mount cgroup v1");
		return 1;
	}

	/* create seed cgroups */
	for (i = 0; i < nr_seed; i++) {
		char dir[256];

		snprintf(dir, sizeof(dir), "%s/seed_%d", mnt, i);
		if (mkdir(dir, 0755) < 0) {
			perror("mkdir seed cgroup");
			goto out_cleanup;
		}
	}

	/* fork tasks (before creating any threads!) and populate seeds */
	children = calloc((size_t)nr_seed * tasks_per, sizeof(pid_t));
	if (!children) {
		perror("calloc");
		goto out_cleanup;
	}
	printf("spawning %d tasks across %d cgroups...\n",
	       nr_seed * tasks_per, nr_seed);
	for (i = 0; i < nr_seed * tasks_per; i++)
		spawn_task(i / tasks_per);
	printf("running: %d readers + %d churners for %ds (Ctrl-C to stop)\n",
	       nr_readers, nr_churners, duration);

	/* start readers and churners */
	readers = calloc(nr_readers, sizeof(pthread_t));
	churners = calloc(nr_churners, sizeof(pthread_t));
	for (i = 0; i < nr_readers; i++)
		pthread_create(&readers[i], NULL, reader_fn, (void *)(long)i);
	for (i = 0; i < nr_churners; i++)
		pthread_create(&churners[i], NULL, churn_fn, (void *)(long)i);

	for (i = 0; i < duration && !stop; i++)
		sleep(1);
	stop = 1;

	for (i = 0; i < nr_churners; i++)
		pthread_join(churners[i], NULL);
	for (i = 0; i < nr_readers; i++)
		pthread_join(readers[i], NULL);

	reads = atomic_load(&reads_done);
	churns = atomic_load(&churn_done);
	printf("done: %lu procs reads (%lu/s), %lu churn cycles (%lu/s), "
	       "%lu errors\n",
	       reads, reads / (duration ?: 1),
	       churns, churns / (duration ?: 1),
	       atomic_load(&errors));

out_cleanup:
	cleanup();
	return 0;
}

==> cg_flush_lat.bt <==

kprobe:cgroup1_pidlist_destroy_all
{
	@start[tid] = nsecs;
}

kretprobe:cgroup1_pidlist_destroy_all
/@start[tid]/
{
	$us = (nsecs - @start[tid]) / 1000;
	@lat_us = hist($us);
	@max_us = max($us);
	@avg_us = avg($us);
	@count = count();
	delete(@start[tid]);
}

interval:s:10
{
	print(@count);
	print(@avg_us);
	print(@max_us);
	print(@lat_us);

	clear(@count);
	clear(@avg_us);
	clear(@max_us);
	clear(@lat_us);

}

END
{
	clear(@start);
}

