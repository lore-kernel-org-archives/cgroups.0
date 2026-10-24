Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792850976;
	b=beya6KBer4jClyjj8I+JFJniQgo01phr1FneKQcASWHS5XuK6UV1vfskLzzoiMr0CoqV
	 fp2ZjLV21HAaHi+RMOBYZCvIeD4ac/oMqQ+cLzZclOuMIzJeoqpQUzsfPOIG12GnUacU/
	 5ifS7tC1svoPZIgB4wfOmJAXS7VPndus4A18DvWIKUyV8cGXEMuD+QoslhVMxTaCDYVNJ
	 PTc99/X1qw8ysafNcSJ6V90JaCbxIwYEWA761epqK026mtSsSpeosUtrjD8KAZ0y97Aod
	 HyPvrT/HESzIWLxxkNSJ2hGE79rSEZ7OYlEHBfCIurf+6hi71X+DNo/6/wUV0BjWmWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792850976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NbevVEv2qKfvdR+VHCdrsNToVr6babHAyFlUpwtlbls=;
	b=eNdqADlK+qilb+GwS0yV/JaOBQhL2VG9YJD1ROAGJmScjtSMEzV5WJdgXZRWSgZ0dcLN
	 heLJ7BLN0CX/+eVAXlQU5PwygUDHUKQlzZJ9+7+Qi4WDNTq4PW7yuilpjbuvsijTX8LY4
	 fJGNQbJMI7fh050mGhRGytqPnIx486HfLlxeZQprPmaCMvLz7TMsVgyY4ehWGE74LfpNV
	 qNccsBx9erAeG8lonCpKqxAGK1Bw4jnTMFKpM/GdLGgND4moa40BZQFodhan4dQ4YWYYL
	 633dS+5ger2t/65rc8NRu5Hw9LxlpJc1Sf0SjcW3D9E3prEZv4i75zAU7KkO5OWxAjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2BhZcIB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD10606A31A;
	Sat, 24 Oct 2026 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2BhZcIB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2241F01825;
	Sat, 24 Oct 2026 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792850975;
	bh=NbevVEv2qKfvdR+VHCdrsNToVr6babHAyFlUpwtlbls=;
	h=From:To:Cc:Subject:Date;
	b=T2BhZcIBvhrLZ+P5+Mw67X9xy7gAx/zXwoWKujoo2DvocMTA3srsBbK7VW9brahf5
	 fnjM4HGTQenrsWjaRjKW/Uw+Ig/KWqmyKN+Hr/ETyFHzRtcyPwyNOLrFolBgZ4fPv/
	 XM0iGPmm1m7aHiwrwDHoNG4iLQ8p3nhBW4ApCR5os4J0rBeIirUqBQYADbJT1Wkav7
	 0hpecnCc1w4GzV+MkrOtpkMEjijx/6YsQCUzwFrCtK4wmDxbKf6O9IRGvjkDpYU7Pt
	 NnbQcUd4Ia4Dhw4U+cAJ9WV2+zmHL/M2eV6VQpJUc622CYZvul6ieyni32Cs4mg4mt
	 SHJwAd6FHA4UQ==
From: Sasha Levin <sashal@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/cgroup: Don't count cgroup.threads in test_cgcore_proc_migration
Date: Sat, 24 Oct 2026 10:09:33 -0400
Message-ID: <20261024140933.315221-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

test_cgcore_proc_migration() moves a process with 13 extra threads to
cg_dst and checks that they all moved by counting the lines of
cg_dst/cgroup.threads.

test_stress.sh runs test_core while enabling and disabling cpuset in the
root cgroup.subtree_control in a loop. Each change moves every task in
the hierarchy to a new css_set. Reading cgroup.threads walks the
cgroup's css_sets without holding cgroup_mutex, so when such a change
lands in the middle of the read, threads that were already listed from
the old css_set are listed again from the new one. The test then fails
with "not ok 8 test_cgcore_proc_migration" although the migration
worked.

Running the test's steps 40000 times in a 2 CPU KVM guest with the
cpuset changes going on, 5 reads listed the 14 threads two or three
times over (up to 36 lines), and a second read right after gave 14.
Without the cpuset changes it did not happen in 40000 runs. With
test_stress.sh, the test failed in 2 of 150 runs.

Check the cgroup of each thread of the process in /proc instead, which
other migrations can't affect.

Fixes: 1a99fcc035fb ("selftests: cgroup: Run test_core under interfering stress")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_core.c | 36 +++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 20d2b63774c37..53592bf309fac 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -9,6 +9,7 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <unistd.h>
+#include <dirent.h>
 #include <fcntl.h>
 #include <sched.h>
 #include <stdio.h>
@@ -567,6 +568,39 @@ static void *dummy_thread_fn(void *arg)
 	return (void *)(size_t)pause();
 }
 
+/*
+ * Count the threads of the current process, or return -1 if any of them
+ * is not in @cgroup. Unlike reading cgroup.threads, this is not affected
+ * by other migrations happening at the same time.
+ */
+static int count_threads_in_cgroup(const char *root, const char *cgroup)
+{
+	char line[PATH_MAX];
+	struct dirent *de;
+	int cnt = 0;
+	DIR *dir;
+
+	snprintf(line, sizeof(line), CG_PATH_FORMAT, cgroup + strlen(root));
+
+	dir = opendir("/proc/self/task");
+	if (!dir)
+		return -1;
+
+	while ((de = readdir(dir))) {
+		if (de->d_name[0] == '.')
+			continue;
+
+		if (proc_read_strstr(atoi(de->d_name), false, "cgroup", line)) {
+			cnt = -1;
+			break;
+		}
+		cnt++;
+	}
+
+	closedir(dir);
+	return cnt;
+}
+
 /*
  * Test threadgroup migration.
  * All threads of a process are migrated together.
@@ -597,7 +631,7 @@ static int test_cgcore_proc_migration(const char *root)
 	}
 
 	cg_enter_current(dst);
-	if (cg_read_lc(dst, CG_THREADS_FILE) != n_threads + 1)
+	if (count_threads_in_cgroup(root, dst) != n_threads + 1)
 		goto cleanup;
 
 	ret = KSFT_PASS;
-- 
2.53.0

