Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793484490;
	b=spTEJHWs7q+XWg+UtKYi3NwCNcS+qTPnnKSekSU567nbonVdm3Z3rXHSdj+MsPZG3ob0
	 edTa72hFSnk2aupxVfyu+nLP4sYhhuU9/MGteJ//IzgLMX4wV9k6v+btglgY1Hocgz9de
	 SqS6hfD+UayK0KUBA/vzw5+ad8RtEJbMYIJwa/YUx8Oy8EZmITTQ+rj/0skSfR1c3Y3sv
	 bvcafOOr0i+iAZW2bAvxXITudwWJclWw3sb1bNh9JYoaIN4b9AaHdDrIHXWKvKDAnMwXF
	 PyeB/gZPCS/4Bm8rbfeiIzdMEMSpxoat/8sl8/NHnXUh9MB4oizQ9EswSLfzNDWBzEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793484490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:To:Cc:From:Subject:Autocrypt:
	 Content-Type:Content-Transfer-Encoding;
	bh=u7hkZBdDMOeRJCx/V6agkDJoUh1Bg0n+5YdOFbLpFXQ=;
	b=dbzdOs9vZYGUVAfpadjPmghEg8RPSeZCh2cZP7YG1BSYf0iH0HQHis0WIQWXYJ0a9DgE
	 24Oxx5R/4BPoOl3ywxA9HoesEqV/2Zp9vZBYf3fEFPtvEqC1j4w6hyxUgqWYt3scAtzcp
	 ez2Hkcb/SIemnkka/z/A4aEJxNEDwlKxsZ+xdgeSDabJPKFYVE0VKpMDIh8X+XkElxtXv
	 M4D210ijTEt0waYN6FriInvJEb6gqkce9Sd5Q487rxMoeNvDMXYyfvlMnQsK0+M0TRO15
	 BZ2S8ZqI2eNCgGZJjFcp7s3iAiA53Rq9WKfqli223PQZpzzQoPdy5HhsD0WSDJkR71Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S60zogLR;
	arc=none smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452C8606A31D
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 22:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 452C8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S60zogLR
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b06c0794cfso16318567b3.0
        for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 15:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793484489; x=1794089289; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:autocrypt:subject:from:cc:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u7hkZBdDMOeRJCx/V6agkDJoUh1Bg0n+5YdOFbLpFXQ=;
        b=S60zogLR4R/USb4y+Plf+PXg7KNiF0R2MWmrsu416v8Fr3noC1aPez7DdMUp4gxnqR
         MmwOmnExBa6Ii55T8AcFGwgiSBL9Ad8D+KFFjuUSpmMi93+wrq9Qdc2Rr4dyUmmnqxzC
         X0W2CdFlP1sbytEeoYghQUM792nlkpRa6B83PEdD8muJvORo9HrFAspMIVBrhoKh54Jf
         gN71ygj0cfyxTvUQiJOVyWYL+09SIBcTtYvopn6uZizDkptxbf8JeudvDDfCs3yqm/P8
         z1Ak4VOwWFydgg1RnS/Hbk9CLzc91/Es82yACYYVXtPiqZfXJuH+gTGejdVM6+Bz2ZH+
         saBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793484489; x=1794089289;
        h=content-transfer-encoding:content-type:autocrypt:subject:from:cc:to
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u7hkZBdDMOeRJCx/V6agkDJoUh1Bg0n+5YdOFbLpFXQ=;
        b=rgRVZob5CZpdJCJgnGM6W3JQH7xYqhYFPj1zp/IKq58n936XqRDNFqZQn2BuxFxxew
         nNn9v/wx7umJk3sBROEFNVrT0xqdZ1kPvURam6OPmwvwvzCDQ6ZykueWxwTg77YUqk4s
         xQmGfvejlB7uTEHCCqdjC2ATBejfid8i4njB9qtVnUvq8UQ37QB7lmZjzqPppKi6CakM
         NzCXHIk7n8mtbcbG8xfOv4wQ0Dpt9XNhIf9tcEOI4gN3nUqaAq8XuyY1fxhWYdC6okqz
         nrXcIi4q+d18W0I1DSyghcmI8ITDmt0Mcw/GPZXB2ClCdmgOLgaiBFNPEM/w9iGOk9Fg
         Z19g==
X-Forwarded-Encrypted: i=1; AKwUvBxnz8sQ9RrgHe+mBlaaoPQLTAWkpH17+QTOmfWmUYmJsROxZw9Dxf2Zas9oXLTtoh2+KaGwocMi@vger.kernel.org
X-Gm-Message-State: APuU4Z9nTiL6womJAGLI6IpnLL0H5cjtv+SORXEV9TZsn/CT2+zz/EbI
	D44Lo3IMm5bRVjX40mUxKoReZvKGTut8E+wVLSvS8jRfpiESRSL164au
X-Gm-Gg: AYBFou2kQdyKukG52FUppcpp7DOPA/p+fHAa6YOOIAOecJfP5RE/UKoht9JceUq9d5h
	+6Su+m6hm/sZ7giCqeq/A/NSsUVRhTWT505JiRZxfs/CMcYKtSCTOrmHgRO7pcCy38KwyWLDsrW
	8WgGpMCBLlAYjF03UjZcNa4d0mtzthNo/lPH2Yw0x+lafonuJ7acdTvSs5oMEB31iCY+0FqShzx
	0WvCGkSStowlASVPLdtygRbBDpzKHCzA3n7QzkoO25xY7SMYw+9F/JVIBmzAt7dBe4DPb9js9J/
	38I4qoZpXlGpqCAGZWvffz529fp4Tcjt9GdWtcI6AAJjl201J/zQPKksEVJ2hwGE6Zrrv1snHJB
	OVV22+CgEcB4iXEVgj8AJSDrrKnd4NHKrhk0j1jLN8kmDNsYgAHphPr0lYUX/Yxx/xIGJJ4oL/l
	0rIMUBOFnXL3tgCHgd58lswz0YnWNPJRR34oXtvYaputn1eU4UYK0hVaYkacxPiNpGUlFetG9yF
	/qywsInZOPblDqSk+fMG/BLc6+EEAEaxr7r9MCSveVQAWyhG0bi5ZlwtVvX+RZk1ElcnbGltFKy
	xezew6bS/PM1CoYZ3yMcVdG+hKkz8nG8meMMkrSqEl293KroUVx2BwSDb+HuTRxidNKmbEfH1wS
	IPndNK9iaSD1ArsxE9aPB+WaC4oMRSA9kdamhOlhTz66L6rZ/7JZVhFmug5SSdA8=
X-Received: by 2002:a05:690c:3481:b0:8b1:bf85:3624 with SMTP id 00721157ae682-8b2b66c50c4mr45236217b3.11.1793484488972;
        Sat, 31 Oct 2026 15:08:08 -0700 (PDT)
Received: from [100.70.73.136] (host-219-69.tnnaknt.nashville.tn.us.clients.pavlovmedia.net. [96.63.219.69])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b71240a4sm26293567b3.7.2026.10.31.15.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 15:08:08 -0700 (PDT)
Message-ID: <14508cb2-805f-41ac-9f6b-bfd7c3d7cb1c@gmail.com>
Date: Sat, 31 Oct 2026 17:08:07 -0500
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>, Ridong Chen <ridong.chen@linux.dev>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Guopeng Zhang <guopeng.zhang@linux.dev>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 regressions@lists.linux.dev, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Weiheng Qiu <weihengqiuu@gmail.com>
Subject: sched/deadline, cpuset: total_bw corrupted by a sleeping DL task's
 cpuset move
Autocrypt: addr=weihengqiuu@gmail.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Moving a sleeping SCHED_DEADLINE task from the root cpuset into an
exclusive partition and back, before it runs again, leaves the root
domain short by the task's bandwidth. The root then over-admits, and
when the task exits its total_bw underflows: small DL requests fail
with -EBUSY while large ones wrap in __dl_overflow() and are admitted.
The partition also keeps a stale reservation.

cpuset_can_attach() and set_cpus_allowed_dl() both decide through
dl_task_needs_bw_move(), which tests task_rq(p)->rd. A sleeping task
is not migrated when its affinity changes, so task_rq(p) still points
at the CPU it last ran on, and on the move back the root domain is
neither re-credited nor the partition debited.

Reproducer below; needs root, cgroup v2 and debugfs, and turns the
last CPU into a partition, so use a test VM. On mainline c339f4010dea
with 4 CPUs:

  cpu3 is a partition; sleeping DL task 76 (0.5 CPU) in the root cgroup
  total_bw in CPUs (change since start):
  start:                     root  0.650 (+0.000)   partition  0.050 (+0.000)
  moved into the partition:  root  0.150 (-0.500)   partition  0.550 (+0.500)
  moved back to the root:    root  0.150 (-0.500)   partition  0.550 (+0.500)
  (expected: +0.000 and +0.000; the task is in state S and has not run)
  root domain admits 28 more 0.1-CPU tasks: 0.650 + 28 x 0.1 = 3.450 CPU
  reserved, limit 3.000 CPU (3 CPUs x 1000000/1000000)
  those tasks exited:        root  0.150 (-0.500)   partition  0.550 (+0.500)
  the DL task exited:        root -0.350 (-1.000)   partition  0.550 (+0.500)
  DL tasks left: 0; new 0.010-CPU request: Device or resource busy
  DL tasks left: 0; new 0.500-CPU request: accepted
  after a root-domain rebuild (recomputed): root 0.150, partition 0.050
  moved in while asleep, then SCHED_DEADLINE: Operation not permitted

Thanks,
Weiheng Qiu
Vanderbilt University

/* A sleeping SCHED_DEADLINE task moved into an exclusive cpuset partition and
 * back, without running in between: the move out debits the root domain and
 * credits the partition, the move back does neither, because
 * dl_task_needs_bw_move() looks at task_rq(p)->rd, which for a task that has
 * not run since the first move is still the root domain.
 * Needs cgroup v2 with the cpuset controller and at least 2 CPUs.
 * It temporarily turns the last CPU into a partition; use a test VM.
 *
 * Build: gcc -O2 -Wall -o cpuset_blocked_move cpuset_blocked_move.c
 * Run as root. Needs CONFIG_DEBUG_FS; total_bw is read from
 * /sys/kernel/debug/sched/debug.
 */
#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/wait.h>

#define SCHED_OTHER_		0
#define SCHED_DEADLINE_		6
#define BW_UNIT			(1LL << 20)	/* BW_SHIFT: 1 CPU == 1 << 20 */

struct sched_attr_ {
	uint32_t size;
	uint32_t sched_policy;
	uint64_t sched_flags;
	int32_t  sched_nice;
	uint32_t sched_priority;
	uint64_t sched_runtime;
	uint64_t sched_deadline;
	uint64_t sched_period;
};

static inline int setattr(pid_t pid, uint32_t policy, uint64_t flags,
		   uint64_t runtime_ns, uint64_t deadline_ns, uint64_t period_ns)
{
	struct sched_attr_ a = {
		.size = sizeof(a), .sched_policy = policy, .sched_flags = flags,
		.sched_runtime = runtime_ns, .sched_deadline = deadline_ns,
		.sched_period = period_ns,
	};
	return syscall(SYS_sched_setattr, pid, &a, 0) ? -errno : 0;
}

static inline int getattr(pid_t pid, struct sched_attr_ *a)
{
	memset(a, 0, sizeof(*a));
	return syscall(SYS_sched_getattr, pid, a, sizeof(*a), 0) ? -errno : 0;
}

static inline void need_debugfs(void)
{
	if (access("/sys/kernel/debug/sched/debug", R_OK))
		mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL);
	if (access("/sys/kernel/debug/sched/debug", R_OK)) {
		perror("/sys/kernel/debug/sched/debug");
		exit(2);
	}
}

/* dl_bw->total_bw of the root domain @cpu belongs to. */
static inline long long total_bw(int cpu)
{
	FILE *f = fopen("/sys/kernel/debug/sched/debug", "r");
	char line[256], *p;
	long long v = 0;
	int cur = -1, c;

	if (!f) {
		perror("open sched/debug");
		exit(2);
	}
	while (fgets(line, sizeof(line), f)) {
		if (sscanf(line, "dl_rq[%d]:", &c) == 1)
			cur = c;
		else if (cur == cpu && (p = strstr(line, "dl_bw->total_bw")) &&
			 (p = strchr(p, ':'))) {
			v = atoll(p + 1);
			break;
		}
	}
	fclose(f);
	return v;
}

static inline char task_state(pid_t pid)
{
	char path[64], buf[512], *p;
	FILE *f;

	snprintf(path, sizeof(path), "/proc/%d/stat", pid);
	f = fopen(path, "r");
	if (!f)
		return '?';
	if (!fgets(buf, sizeof(buf), f))
		buf[0] = 0;
	fclose(f);
	p = strrchr(buf, ')');
	return p && p[1] && p[2] ? p[2] : '?';
}

/* Wait until @pid is asleep (S) in the kernel. */
static inline void wait_sleeping(pid_t pid)
{
	for (int i = 0; i < 1000 && task_state(pid) != 'S'; i++)
		usleep(1000);
}

/* A child that blocks in read() and never wakes up by itself. */
static inline pid_t spawn_sleeper(void)
{
	int fd[2];
	pid_t pid;
	char ch;

	if (pipe(fd))
		exit(2);
	pid = fork();
	if (pid == 0) {
		close(fd[1]);
		if (read(fd[0], &ch, 1) < 0)
			_exit(1);
		_exit(0);
	}
	close(fd[0]);
	wait_sleeping(pid);
	return pid;
}

static inline void reap(pid_t pid)
{
	kill(pid, SIGKILL);
	waitpid(pid, NULL, 0);
	usleep(200 * 1000);	/* well past any 0-lag time */
}

static inline const char *bw_str(long long bw)
{
	static char buf[4][48];
	static int i;
	char *b = buf[i++ & 3];

	snprintf(b, 48, "%.3f CPU (%lld)", (double)bw / BW_UNIT, bw);
	return b;
}

/* Number of threads whose policy is SCHED_DEADLINE (field 41 of stat). */
static inline int count_dl_tasks(void)
{
	char path[600], buf[1024], *s;
	struct dirent *p, *t;
	DIR *pd, *td;
	FILE *f;
	int n = 0, i;

	pd = opendir("/proc");
	while (pd && (p = readdir(pd))) {
		if (p->d_name[0] < '0' || p->d_name[0] > '9')
			continue;
		snprintf(path, sizeof(path), "/proc/%s/task", p->d_name);
		td = opendir(path);
		while (td && (t = readdir(td))) {
			if (t->d_name[0] == '.')
				continue;
			snprintf(path, sizeof(path), "/proc/%s/task/%s/stat",
				 p->d_name, t->d_name);
			f = fopen(path, "r");
			if (!f)
				continue;
			s = fgets(buf, sizeof(buf), f) ? strrchr(buf, ')') : NULL;
			fclose(f);
			for (i = 0; s && i < 39; i++)
				s = strchr(s + 1, ' ');
			if (s && atoi(s + 1) == SCHED_DEADLINE_)
				n++;
		}
		if (td)
			closedir(td);
	}
	if (pd)
		closedir(pd);
	return n;
}

/* After a leak, ask for a reservation of the same size for a new task. */
static inline void try_fresh_admission(uint64_t runtime_ns,
				       uint64_t period_ns)
{
	int dl = count_dl_tasks();
	pid_t pid = spawn_sleeper();
	int rc = setattr(pid, SCHED_DEADLINE_, 0, runtime_ns, period_ns,
			 period_ns);

	printf("DL tasks left: %d; new %.3f-CPU request: %s\n", dl,
	       (double)runtime_ns / period_ns,
	       rc ? strerror(-rc) : "accepted");
	reap(pid);
}

/* Reading this sysctl makes sched_rt_handler() call rebuild_sched_domains(),
 * whose dl_rebuild_rd_accounting() recomputes total_bw from the servers and
 * the SCHED_DEADLINE tasks that actually exist. */
static inline long long recomputed_total_bw(int cpu)
{
	char buf[32];
	int fd = open("/proc/sys/kernel/sched_rt_runtime_us", O_RDONLY);

	if (fd >= 0) {
		if (read(fd, buf, sizeof(buf)) < 0)
			perror("sched_rt_runtime_us");
		close(fd);
	}
	return total_bw(cpu);
}

#define RUNTIME	(25 * 1000 * 1000ULL)	/* 25ms / 50ms = 0.5 CPU */
#define PERIOD	(50 * 1000 * 1000ULL)
#define CG	"/sys/fs/cgroup"
#define PART	CG "/dl-repro"
#define MAXF	1000

static int put(const char *path, const char *val)
{
	int fd = open(path, O_WRONLY), rc = 0;

	if (fd < 0 || write(fd, val, strlen(val)) < 0)
		rc = -errno;
	if (fd >= 0)
		close(fd);
	return rc;
}

static void get(const char *path, char *buf, int len)
{
	int fd = open(path, O_RDONLY), n = fd < 0 ? 0 : read(fd, buf, len - 1);

	buf[n > 0 ? n : 0] = 0;
	if (fd >= 0)
		close(fd);
}

static int move(pid_t pid, const char *cg)
{
	char path[128], v[32];

	snprintf(path, sizeof(path), "%s/cgroup.procs", cg);
	snprintf(v, sizeof(v), "%d\n", pid);
	return put(path, v);
}

static int iso;

static void show(const char *what, long long r0, long long p0)
{
	long long r = total_bw(0), p = total_bw(iso);

	printf("%-26s root %6.3f (%+.3f)   partition %6.3f (%+.3f)\n",
	       what, (double)r / BW_UNIT, (double)(r - r0) / BW_UNIT,
	       (double)p / BW_UNIT, (double)(p - p0) / BW_UNIT);
}

int main(void)
{
	pid_t pid, filler[MAXF];
	long long r0, p0;
	char buf[64], cpu[16];
	int rc, n, i, rt_runtime, rt_period;

	need_debugfs();
	/* Read now: reading these rebuilds the root domains (see
	 * recomputed_total_bw()). */
	get("/proc/sys/kernel/sched_rt_runtime_us", buf, sizeof(buf));
	rt_runtime = atoi(buf);
	get("/proc/sys/kernel/sched_rt_period_us", buf, sizeof(buf));
	rt_period = atoi(buf);
	iso = sysconf(_SC_NPROCESSORS_ONLN) - 1;
	if (iso < 1) {
		fprintf(stderr, "needs at least 2 CPUs\n");
		return 2;
	}
	if (access(CG "/cgroup.controllers", F_OK))
		mount("none", CG, "cgroup2", 0, NULL);
	put(CG "/cgroup.subtree_control", "+cpuset");
	mkdir(PART, 0755);
	snprintf(cpu, sizeof(cpu), "%d", iso);
	put(PART "/cpuset.cpus", cpu);
	put(PART "/cpuset.cpus.exclusive", cpu);
	put(PART "/cpuset.cpus.partition", "root");
	get(PART "/cpuset.cpus.partition", buf, sizeof(buf));
	if (strncmp(buf, "root", 4)) {
		fprintf(stderr, "could not make cpu%d a partition: %s", iso, buf);
		return 2;
	}

	pid = spawn_sleeper();
	rc = setattr(pid, SCHED_DEADLINE_, 0, RUNTIME, PERIOD, PERIOD);
	if (rc) {
		fprintf(stderr, "sched_setattr: %s\n", strerror(-rc));
		return 2;
	}
	r0 = total_bw(0);
	p0 = total_bw(iso);
	printf("cpu%d is a partition; sleeping DL task %d (0.5 CPU) in the root "
	       "cgroup\ntotal_bw in CPUs (change since start):\n", iso, pid);
	show("start:", r0, p0);
	rc = move(pid, PART);
	show(rc ? "move out FAILED:" : "moved into the partition:", r0, p0);
	rc = move(pid, CG);
	show(rc ? "move back FAILED:" : "moved back to the root:", r0, p0);
	printf("(expected: +0.000 and +0.000; the task is in state %c and has "
	       "not run)\n", task_state(pid));

	/* The root domain now has 0.5 CPU more "free" than it really has. */
	for (n = 0; n < MAXF; n++) {
		filler[n] = spawn_sleeper();
		if (setattr(filler[n], SCHED_DEADLINE_, 0, 10000000, 100000000,
			    100000000)) {
			reap(filler[n]);
			break;
		}
	}
	printf("root domain admits %d more 0.1-CPU tasks: %.3f + %d x 0.1 = "
	       "%.3f CPU\nreserved, limit %.3f CPU (%d CPUs x %d/%d)\n", n,
	       (double)r0 / BW_UNIT, n, (double)r0 / BW_UNIT + n * 0.1,
	       iso * (double)rt_runtime / rt_period, iso, rt_runtime,
	       rt_period);
	for (i = 0; i < n; i++)
		reap(filler[i]);
	show("those tasks exited:", r0, p0);

	reap(pid);
	show("the DL task exited:", r0, p0);
	try_fresh_admission(1000000, 100000000);
	try_fresh_admission(50000000, 100000000);
	r0 = recomputed_total_bw(0);	/* rebuild first, then read both */
	printf("after a root-domain rebuild (recomputed): root %.3f, "
	       "partition %.3f\n", (double)r0 / BW_UNIT,
	       (double)total_bw(iso) / BW_UNIT);

	/* Same stale rq: a SCHED_OTHER task moved into the partition while
	 * asleep cannot be made SCHED_DEADLINE before it has run. */
	pid = spawn_sleeper();
	rc = move(pid, PART);
	if (!rc)
		rc = setattr(pid, SCHED_DEADLINE_, 0, 1000000, 100000000,
			     100000000);
	printf("moved in while asleep, then SCHED_DEADLINE: %s\n",
	       rc ? strerror(-rc) : "accepted");
	reap(pid);

	put(PART "/cpuset.cpus.partition", "member");
	rmdir(PART);
	return 0;
}
