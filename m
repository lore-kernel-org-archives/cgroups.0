Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C047146AA66;
	Sun, 11 Oct 2026 22:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758058; cv=none; b=RwcyUuhYlsknETuSu178ipbS5OkliOblZjYH7VvNQWCXcZgL9qTPd6D6GIJelt5o/+61FhiBtyrKEniCQKhxb92s7r4O6Y7UfPw8O3AEoq73srLsHj8G0/WHzz4UNiIBz1hPgCTMk4Nn4J7aYKOy5AlEnBOgPAbimp4BYAxqLWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758058; c=relaxed/simple;
	bh=cqh6tlFJZjhez+ao6RTIP2gIoYEZzEwhNiTrCHAQAnY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Npyr9hSL9Q3FfGEUfONMKI7rIksmSNstOl2E6I+Z2CdrYZ7jWATXL/ZwnLNVjb3l6x/Wt7C2TBukz7/wPXlG66UrvMVEEX9QMBc+PfN69AUXtUPFMolS7A/Inp7wtRVoP/giqvS/NN0VE9DjDdQVSaOg7k7iVsgr4NFIiJCNBfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KoMFCYlY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KoMFCYlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80A21F0089C;
	Sun, 11 Oct 2026 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791758057;
	bh=9MrFerv6Jpm1jokOVRLuq0IMQxsqJAGOQf/Q+BYiBtc=;
	h=From:To:Cc:Subject:Date;
	b=KoMFCYlYq7yX0NexNVslRP2Q9jdRQkju78eMkJLUKn7l2uJ5FnFzwSwQ5Rxvj98A2
	 7CgYxhsprVNiSpMYq7XsFGHw5k1IJE4dh+EcGTtgjiNpj0l8UYSigqG+C697yBuKBz
	 SDmj19j8c04V8qee2RoSjF00Sv7rLm7TYD5AXf4ZU6bwxEN7Ek6MqTp3famAKyWkpZ
	 HmlqM9tqOH3IsMj1by1iPmWTqf+rDxa33ZYFWN74QIEgkziTfg8fSJF5L+QYL69moA
	 sQPyifw1RjeXmxkSO+L3sELLw32vPOWA1JD009MILJwn2Ne/8s4bk/wZ3rkKyeADeg
	 UWqRXTJdxRERg==
From: Sasha Levin <sashal@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"T.J. Mercier" <tjmercier@google.com>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: memcg: don't close an uninitialized fd
Date: Sun, 11 Oct 2026 18:33:37 -0400
Message-ID: <20261011223358.2327625-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
jump to cleanup before the inotify fd is created when cg_name() or
cg_create() fails, and cleanup then closes whatever fd holds:

  test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]

Initialize fd to -1.

Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044ed..047d487f6dd57 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1678,7 +1678,7 @@ static int test_memcg_inotify_delete_file(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd = -1, wd;
 
 	memcg = cg_name(root, "memcg_test_0");
 
@@ -1723,7 +1723,7 @@ static int test_memcg_inotify_delete_dir(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd = -1, wd;
 
 	memcg = cg_name(root, "memcg_test_0");
 
-- 
2.53.0

