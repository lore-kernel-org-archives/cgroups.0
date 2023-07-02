From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 6.1 2/3] selftests: cgroup: Add 'malloc' failures checks in test_memcontrol
Date: Sun,  2 Jul 2023 15:39:03 -0400
Message-ID: <20230702193904.1775957-2-sashal@kernel.org>
References: <20230702193904.1775957-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688326749;
        bh=qbSmFjkxX3HUcFYifbkogWWlpPQjlc1XuGkAs7z+xus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8GVO2PWCoelwP6GOJDM6eAGJPmAOtwe5fP7TwGURIHyjMAU5N2CuEFuHdMJwZJbZ
         R4iKCnURDXQznGvpNGI7ZLv9s/ZilZYTE4nNodI4I4Mt2ZA/ov04OVEXsnYJ1syB7h
         IJmKwB5lGxCE/xdtXbAcDaOAM1AZor0ASqG68GT7AaFDn8M+jBfY0pNDwYJKblIzmO
         7kai64nnYittYJCFRHmVNDxzOpepE9uXt7VS2eaYWudRLSlTZGWyd5QYYx5cANWSax
         mfRNWXSIXrAKXZowyOhQ6O+LZR1jD/fNlLDkmQwLosqhqx6YytoHiRBfr11iZwYw98
         NVhLevtUWchew==
In-Reply-To: <20230702193904.1775957-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

[ Upstream commit c83f320e55a49abd90629f42a72897afd579e0de ]

There are several 'malloc' calls in test_memcontrol, which can be
unsuccessful. This patch will add 'malloc' failures checking to
give more details about test's fail reasons and avoid possible
undefined behavior during the future null dereference (like the
one in alloc_anon_50M_check_swap function).

Signed-off-by: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Signed-off-by: Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 8833359556f38..fe4f9f4302822 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -98,6 +98,11 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -211,6 +216,11 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -759,6 +769,11 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
-- 
2.39.2

