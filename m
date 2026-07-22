Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D210D45D5F1;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763680; cv=none; b=uEQuDGY8fOqeAp/pYGchKwhg6rlDojcpf111GiMvQYndQN3tyDf57mhLF4jEjtCn4G4iVO1oUqb+bzyKLs+bq3ZIZmWwgvkOoYTz+s02GOXX0UyYC15kbsERNBaHXoOpX+qyfmkaQzcZFJzJ3I0tIGxrSUOz4HhiosjIXL4MBcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763680; c=relaxed/simple;
	bh=tQO4lhRXKQ6uEvJGNjKAll868IKX9d/or000tzu8DAA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=merzugLiuRSSJEtRye4nfSkEY0jC3Xz9yU+lFCyxjh5Qjv/mWNmdEExY07JL7LVoKhJ9Z5rctA9KDzBn6JIIvWyWQz5rEEdULM15Uo28SHsv/sLEmnDrepSz10WImcLCD/WOz3lRE+IYrCKX3lYWr8AXqtOzbwdT8Vt2U2Z6EeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Da/RE/zo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Da/RE/zo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADAE6C19425;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=tQO4lhRXKQ6uEvJGNjKAll868IKX9d/or000tzu8DAA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Da/RE/zoJl4bsjzKC3/H6wBhxJjhv27xrkhGf2e6DeYX9aq6zIh+n6ytW5Gp6GUll
	 ec3Y3rU+Amik1YEt1lejx7UURMqrjTazilzUhYdGgWMKY9/ZJIUN0xPOctaL6JwcSe
	 KnAZyPXxm6Nb9oGSP0ap2pMOrlBKq6jvUtnEKc8YW/omG8kzGSvdj89nppnrvSATBA
	 jU5l+YcJFIA3ooIyyd4Fi4fQARsM5hg+hUek35mgd8ozVwjLqWesvg5WNaiwE2ItoU
	 qOjtW/Fl4hCjl3LsF1sG0Oivg+ODaW0T/kECmSYG+7Ln163AXtbZNgzJY4z44n0y0K
	 724cJdjfF3u3g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99666C4453A;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:21 -0700
Subject: [PATCH v4 13/16] WIP: Reproducer for allocation failure due to
 cgroup v2 memory limits
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-13-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=6966;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=JlTcWmu4YylYJqF+iA2BMg6mM33pft18C72PLT5bBdc=;
 b=CsPLTCLuBSVGQbXs8wDx4crR6XxCc1FrWqzQJTSbrryBKU8/Kqta9FxI5P4Zfib63Gi8X9Vyh
 BLsF9HAKYoDCxA69jvJVKW35iNPeQTIvHSYzk03E2p3reohwsAxU8Hk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

(This reproducer was hacked up and not meant to be merged.)

cgroup_v2_allocation_failure.c triggers HugeTLB allocation failure by exploiting
cgroup v2 memory limits. This allows testing the error paths in the kernel when
memory control charging fails, even when physical huge pages are available.

The program performs the following steps to trigger the failure:

1. Enable hugetlb accounting in cgroup v2.
     + The program checks if memory_hugetlb_accounting is enabled in the cgroup2
       mount options. If not, it remounts /sys/fs/cgroup with this option
       enabled. This ensures that HugeTLB allocations are charged against the
       cgroup memory limits.

2. Create a test cgroup and set limits.
     + The program creates a new cgroup subdirectory named test_reproducer under
       /sys/fs/cgroup.
     + It sets the memory.max limit of this cgroup to 1MB (which is less than
       the 2MB huge page size).

3. Fork a child process and move it to the test cgroup.
     + The program forks a child process.
     + The child process moves itself into the test_reproducer cgroup by writing
       its PID (using 0 for current process) to cgroup.procs in the test cgroup
       directory.

4. Attempt to allocate and touch a 2MB huge page.
     + The child process maps a 2MB anonymous huge page using mmap with
       MAP_PRIVATE, MAP_ANONYMOUS, and MAP_HUGETLB.
     + The child process writes to the mapped address, triggering a page fault.

5. Triggering the kernel bugs.
     + The page fault handler calls alloc_hugetlb_folio to allocate the huge
       page.
     + The allocation of the physical page from buddy allocator succeeds
       (assuming nr_hugepages is sufficient).
     + The kernel then attempts to charge this allocation to the child process's
       cgroup by calling mem_cgroup_charge_hugetlb.
     + Since the child's cgroup memory limit is 1MB and the page is 2MB, the
       charge fails and mem_cgroup_charge_hugetlb returns -ENOMEM.
     + This triggers the error path in alloc_hugetlb_folio where the bugs (folio
       refcount mismatch, infinite loop on ENOMEM, and reservation leaks) are
       handled.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 cgroup_v2_allocation_failure.c | 169 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/cgroup_v2_allocation_failure.c b/cgroup_v2_allocation_failure.c
new file mode 100644
index 0000000000000..1a813678d8cd2
--- /dev/null
+++ b/cgroup_v2_allocation_failure.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <string.h>
+#include <errno.h>
+
+#define CGROUP_PATH "/sys/fs/cgroup"
+#define TEST_CGROUP "test_reproducer"
+#define TEST_CGROUP_PATH CGROUP_PATH "/" TEST_CGROUP
+
+static void write_file_val(const char *path, const char *val)
+{
+	int fd = open(path, O_WRONLY);
+
+	if (fd < 0) {
+		fprintf(stderr, "Failed to open %s: %s\n", path, strerror(errno));
+		exit(1);
+	}
+	if (write(fd, val, strlen(val)) < 0) {
+		fprintf(stderr, "Failed to write %s to %s: %s\n", val, path, strerror(errno));
+		close(fd);
+		exit(1);
+	}
+	close(fd);
+}
+
+static int is_hugetlb_accounting_enabled(void)
+{
+	char spec[256], file[256], type[256], opts[512];
+	char line[1024];
+	int enabled = 0;
+	FILE *fp;
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp) {
+		perror("fopen /proc/mounts");
+		return -1;
+	}
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (sscanf(line, "%255s %255s %255s %511s", spec, file, type, opts) == 4) {
+			if (strcmp(file, CGROUP_PATH) == 0 && strcmp(type, "cgroup2") == 0) {
+				if (strstr(opts, "memory_hugetlb_accounting") != NULL)
+					enabled = 1;
+				break;
+			}
+		}
+	}
+	fclose(fp);
+	return enabled;
+}
+
+static int enable_hugetlb_accounting(void)
+{
+	int ret;
+
+	printf("Attempting to remount cgroup2 with memory_hugetlb_accounting...\n");
+	ret = system("mount -o remount,memory_hugetlb_accounting " CGROUP_PATH);
+	if (ret != 0) {
+		fprintf(stderr, "Failed to remount: system() returned %d\n", ret);
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct stat st;
+	size_t size;
+	void *addr;
+	pid_t pid;
+	int enabled;
+	int status;
+	int fd;
+
+	if (stat(CGROUP_PATH, &st) != 0 || !S_ISDIR(st.st_mode)) {
+		fprintf(stderr, "cgroup v2 not mounted at %s\n", CGROUP_PATH);
+		return 1;
+	}
+
+	enabled = is_hugetlb_accounting_enabled();
+	if (enabled < 0)
+		return 1;
+
+	if (!enabled) {
+		if (enable_hugetlb_accounting() != 0) {
+			fprintf(stderr, "Could not enable memory_hugetlb_accounting\n");
+			return 1;
+		}
+		/* Re-check */
+		enabled = is_hugetlb_accounting_enabled();
+		if (enabled <= 0) {
+			fprintf(stderr, "Failed to enable memory_hugetlb_accounting (re-check failed)\n");
+			return 1;
+		}
+		printf("Successfully enabled memory_hugetlb_accounting\n");
+	} else {
+		printf("memory_hugetlb_accounting is already enabled\n");
+	}
+
+	/* Enable memory controller in subtree */
+	fd = open(CGROUP_PATH "/cgroup.subtree_control", O_WRONLY);
+	if (fd >= 0) {
+		(void)write(fd, "+memory", 7);
+		close(fd);
+	}
+
+	if (mkdir(TEST_CGROUP_PATH, 0755) != 0) {
+		if (errno != EEXIST) {
+			perror("mkdir test_reproducer");
+			return 1;
+		}
+	}
+
+	/* Set memory limit to 1MB (less than 2MB hugepage) */
+	write_file_val(TEST_CGROUP_PATH "/memory.max", "1M");
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		/* Child: Move to cgroup */
+		write_file_val(TEST_CGROUP_PATH "/cgroup.procs", "0");
+
+		printf("Child: Attempting to allocate and touch 2MB hugepage...\n");
+		/* Allocate 2MB hugepage */
+		size = 2 * 1024 * 1024;
+		addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+		if (addr == MAP_FAILED) {
+			perror("Child: mmap MAP_HUGETLB");
+			exit(1);
+		}
+
+		printf("Child: mmap succeeded at %p, touching it now...\n", addr);
+		*(char *)addr = 1;
+
+		printf("Child: Successfully touched page (bug not triggered?).\n");
+		munmap(addr, size);
+		exit(0);
+	}
+
+	/* Parent */
+	waitpid(pid, &status, 0);
+
+	printf("Parent: Child exited. Cleaning up.\n");
+	rmdir(TEST_CGROUP_PATH);
+
+	if (WIFSIGNALED(status)) {
+		printf("Parent: Child killed by signal %d (%s)\n",
+		       WTERMSIG(status), strsignal(WTERMSIG(status)));
+		if (WTERMSIG(status) == SIGBUS)
+			printf("Parent: Child got SIGBUS as expected.\n");
+	} else if (WIFEXITED(status)) {
+		printf("Parent: Child exited with status %d\n", WEXITSTATUS(status));
+	}
+
+	return 0;
+}

-- 
2.55.0.229.g6434b31f56-goog


