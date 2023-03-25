From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] selftests: cgroup: Fix exception handling in
 test_memcg_oom_group_score_events()
Date: Sat, 25 Mar 2023 19:30:21 +0100
Message-ID: <c383bdca-6f0d-4a75-e788-e1920faa0a62@web.de>
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
Reply-To: Markus Elfring <Markus.Elfring@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cocci-owner@inria.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:from:to:references:cc:
   in-reply-to:content-transfer-encoding:subject:reply-to:
   sender:list-id:list-help:list-subscribe:list-unsubscribe:
   list-post:list-owner:list-archive;
  bh=gpd002g83eYHAwa8nXb4Tip7JW96SuuMFbMMvMgqptU=;
  b=GjPruCc1TL1H7zL5P05R44SNPbU+lNa+6wdDUmZLxqdq1dUM5UBZT/7S
   EaLprCyxY0oj8ub+drUaQf+YPd2bQaQKotxwCFBKsMDJvImhCK/1eQ64w
   xhyBPQwGISWr4O2PKJaGPRxib9T0r5DZ7jepbEV6lnCXAEHT4TeYxhCfn
   Y=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1679769024; i=markus.elfring@web.de;
	bh=v+rMXJgncvNeSS/c9GxyeVsaVJFxHUrosoDsvsBMKrA=;
	h=X-UI-Sender-Class:Date:Subject:From:To:References:Cc:In-Reply-To;
	b=E2ZRLGzBeWgDUjxxuDBQNzCqbzkObNJ2PQYpfhURJww+hylN8N/+Ouqj1TTy+BTOT
	 KbbxOqGmhbMKUzW0DrODYY0DpSNyvjAlZo5JB5snAXMrqmjwUvC5O/X7HhGIVkJ7hx
	 QfY8Tk4xJFvpdqiZY5oi+x6dAvscXBmijG2O7Qt4fFK4GByO5igabdQCDOLkDhsOhz
	 iWbYW3fZ9qDZD4KyS6I4pNxcfbrHVMG7qc6dPYdFlyUwKOU8F2VdV4dTE73RPtWyRM
	 8nAXhcDQKG/uA4ki9G6xPVxRcr/1646dFRU/l3HulUc7c8Hfeodny9CFUkdGi6AD7M
	 2CIyWbOgXof2A==
Content-Language: en-GB
In-Reply-To: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
Errors-To: cocci-owner@inria.fr
Sender: cocci-request@inria.fr
List-Id: <cgroups.vger.kernel.org>
List-Help: <mailto:sympa_inria@inria.fr?subject=help>
List-Subscribe: <mailto:sympa_inria@inria.fr?subject=subscribe%20cocci>
List-Unsubscribe: <mailto:sympa_inria@inria.fr?subject=unsubscribe%20cocci>
List-Post: <mailto:cocci@inria.fr>
List-Owner: <mailto:cocci-request@inria.fr>
List-Archive: <https://sympa.inria.fr/sympa/arc/cocci>
Content-Type: text/plain; charset="utf-8"
To: kernel-janitors@vger.kernel.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Jay Kamat <jgkamat@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc: cocci@inria.fr, LKML <linux-kernel@vger.kernel.org>

Date: Sat, 25 Mar 2023 19:11:13 +0100

The label =E2=80=9Ccleanup=E2=80=9D was used to jump to another pointer ch=
eck despite of
the detail in the implementation of the function
=E2=80=9Ctest_memcg_oom_group_score_events=E2=80=9D that it was determined=
 already
that a corresponding variable contained a null pointer.

1. Thus return directly after a call of the function =E2=80=9Ccg_name=E2=
=80=9D failed.

2. Use an additional label.

3. Delete a questionable check.


This issue was detected by using the Coccinelle software.

Fixes: a987785dcd6c8ae2915460582aebd6481c81eb67 ("Add tests for memory.oom=
.group")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 tools/testing/selftests/cgroup/test_memcontrol.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/test=
ing/selftests/cgroup/test_memcontrol.c
index f4f7c0aef702..afcd1752413e 100644
=2D-- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1242,12 +1242,11 @@ static int test_memcg_oom_group_score_events(const=
 char *root)
 	int safe_pid;

 	memcg =3D cg_name(root, "memcg_test_0");
-
 	if (!memcg)
-		goto cleanup;
+		return ret;

 	if (cg_create(memcg))
-		goto cleanup;
+		goto free_cg;

 	if (cg_write(memcg, "memory.max", "50M"))
 		goto cleanup;
@@ -1275,8 +1274,8 @@ static int test_memcg_oom_group_score_events(const c=
har *root)
 	ret =3D KSFT_PASS;

 cleanup:
-	if (memcg)
-		cg_destroy(memcg);
+	cg_destroy(memcg);
+free_cg:
 	free(memcg);

 	return ret;
=2D-
2.40.0

