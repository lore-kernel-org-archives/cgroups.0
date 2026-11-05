Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793841508;
	b=p2bJXTFokOgCfzDW6xyT3cbGtvjqFkzSnxNUdy5wLxOFUtdlJoW9ydVIkjVgAfXpJYgD
	 4ZspYA3fbjK9wmrUqaowWKufLB+7sGwOkfiI+vNFvXt2FRHK8sfWvNEYVOfj4KPMwG8jX
	 vBtgSDZfl0IZv9e0qCI8cr9iaRrqJSUbsFzBG5p/FEnR0DZQV05RPEAoE1K+0zvGGa/NA
	 6IQ4g3i5F2RHE6gef9OMC3U1ZLRv6d8nUXbx1G2M2RAdrg49EyF4IZcKQgHyJqzrcPYHQ
	 +5B0kNoq1Q1ldPPOyCCxDYNz1WvAjWAkEaowEjnyPInqkRqyT/cjyf0xEOZVYytGTEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793841508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQmK1VyNyRInh3bcu1F6pkwNvgg2G6ZMbyKt5yTapqk=;
	b=tWUgVdAUtHLAudXp9TbJ5Ahz4quDDY8gs2rdtvnIX4zIhqKTl9Tnhg0bwvxqbGVolFAE
	 qUx5Bblp4tq7nsixfZfRgxLNPxTg3GN9it0xSy11oBeD0Ku+m1IRLcEuVauUSmeGp/gt6
	 R0TB8UoYIU+nv4BHjhcofM7d79ta35XexywJKSnjcJwjkYlsYJ+kvNpqypFe8M7QZGzdj
	 e+WffjsVwNIRTyzR0nyGGjvIJYbzCC77QHcoL+4UQI/Ep6vmmCGhyaYXIaxZQgVdX39OH
	 1QMBvmTESj50Zr8WFcUR/LD/hv3faEVup1fsBYLFJOv5m3y123t3zTy7jP9CZ5dU5wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UUUFD0/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DFF606D82B;
	Thu,  5 Nov 2026 01:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUUFD0/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1531E1F00A20;
	Thu,  5 Nov 2026 01:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793841507;
	bh=mQmK1VyNyRInh3bcu1F6pkwNvgg2G6ZMbyKt5yTapqk=;
	h=From:To:Cc:Subject:Date;
	b=UUUFD0/RgyXitm6KMRBEe87kCtHttmgDX46T/atU2r8acWM3dB/s5NllRUEMpNEiK
	 MU6WSNC2Acb8ZjI7ca8uVCP7sKxODSHEukTJoVUU5H5HhkiNUEmceiK9xQf9i/lG3+
	 L3G4RTgZjbY2tRV3wXkdQdkjyzXMhJXESbPL3hTac1K7cWvu6hbHwuTUS0R2gygPLE
	 2wQ/PdHfOtCkuOgpm82s9gSuhZzkEqUkA62y3uHLmGIP9JfpEvCRUPcY8Lpghhv22/
	 htt2GoRebJ9LMjxCGPTc1Ti9LJRFq1ZMviUFBrLHIEEGUPpgH5CR81IGoNiOtRkNAY
	 Hz9QsmJIYNVsg==
From: Sasha Levin <sashal@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: cgroup: fall back to an unlinked file without O_TMPFILE
Date: Wed,  4 Nov 2026 20:18:24 -0500
Message-ID: <20261105011824.1143947-1-sashal@kernel.org>
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

get_temp_fd() creates its page cache file with O_TMPFILE in the current
directory. On filesystems without O_TMPFILE support, such as NFS, the
open fails with EOPNOTSUPP, and with it every test that needs page cache:
test_memcg_current_peak, test_memcg_min, test_memcg_low, test_memcg_high,
test_memcg_max and test_memcg_reclaim. Boards that boot with an NFS root
fail all six.

Create a regular file with mkstemp() and unlink it in that case.

Fixes: 84092dbcf901 ("selftests: cgroup: add memory controller self-tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with KernelCI's NVIDIA lab, whose boards boot from NFS. Tested on a
144-CPU Grace with KernelCI's arm64 build of 05441d697f7f9: run from an
NFSv3 mount, all six tests fail without this patch. With it, they behave
as they do from ext4 on that machine: the other four pass, while
test_memcg_min fails and test_memcg_low sometimes fails there too.

 tools/testing/selftests/cgroup/test_memcontrol.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf08..7dc9c26628675 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -33,7 +33,17 @@ static int page_size;
 
 int get_temp_fd(void)
 {
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
+	char name[] = "./cgroup_test_XXXXXX";
+	int fd;
+
+	fd = open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
+	if (fd >= 0 || errno != EOPNOTSUPP)
+		return fd;
+
+	fd = mkstemp(name);
+	if (fd >= 0)
+		unlink(name);
+	return fd;
 }
 
 int alloc_pagecache(int fd, size_t size)
-- 
2.53.0

