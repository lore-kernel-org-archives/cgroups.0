From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] sched/core: check format and overflows in cgroup2 cpu.max
Date: Wed, 27 Feb 2019 11:13:21 +0300
Message-ID: <155125520155.293746.7017401430432481979.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1551255202; bh=8kFu2wWh3Op+B8NZK/FPFrEnAAthfynrTJBN0YQ9dko=;
        h=Message-ID:Date:To:From:Subject;
        b=QChFQyWQRPml22HfRer0LqfEssiFGUcpS1KWe5R0TIdlZuGFWNRKKj56z9MhhdZXt
         Zd+DrubbdYyyqGmvyngmLnkwfAP4CcG/3cAK5wAtuyqVojB77JYtHHqk4pYxpRMr0x
         cHn31V4Ku8OwHCDGPQQjuQSDXj2R6508Qb/v2HBk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>

Cgroup2 interface for cpu bandwidth limit has some flaws:

- on stack buffer overflow
- no checks for valid format or trailing garbage
- no checks for integer overflows

This patch fixes all these flaws.

Fixes: 0d5936344f30 ("sched: Implement interface for cgroup unified hierarchy")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 kernel/sched/core.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5f46aa335b28..123b1910bc2e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6947,19 +6947,34 @@ static int __maybe_unused cpu_period_quota_parse(char *buf,
 						 u64 *periodp, u64 *quotap)
 {
 	char tok[21];	/* U64_MAX */
+	int ret, len;
 
-	if (!sscanf(buf, "%s %llu", tok, periodp))
+	if (sscanf(buf, "%20s %n", tok, &len) != 1)
 		return -EINVAL;
 
-	*periodp *= NSEC_PER_USEC;
-
-	if (sscanf(tok, "%llu", quotap))
-		*quotap *= NSEC_PER_USEC;
-	else if (!strcmp(tok, "max"))
+	ret = kstrtou64(tok, 10, quotap);
+	if (ret) {
+		if (strcmp(tok, "max"))
+			return ret;
 		*quotap = RUNTIME_INF;
-	else
+	} else if (*quotap <= U64_MAX / NSEC_PER_USEC) {
+		*quotap *= NSEC_PER_USEC;
+	} else
 		return -EINVAL;
 
+	buf += len;
+	if (*buf) {
+		if (sscanf(buf, "%20s %n", tok, &len) != 1 || buf[len])
+			return -EINVAL;
+		ret = kstrtou64(tok, 10, periodp);
+		if (ret)
+			return ret;
+		if (*periodp > U64_MAX / NSEC_PER_USEC)
+			return -EINVAL;
+	}
+
+	*periodp *= NSEC_PER_USEC;
+
 	return 0;
 }
 

