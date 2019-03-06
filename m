From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] sched/core: fix buffer overflow in cgroup2 property cpu.max
Date: Wed, 06 Mar 2019 20:11:42 +0300
Message-ID: <155189230232.2620.13120481613524200065.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1551892304; bh=N4pJuOAOM/HjAH7jthQtu7ug1NWBtPIhc7uNuJlsls8=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=L64b7S4Idl4iBSHfy4E3Cej6Fn8IsgExIzcoXbnkKR17KlxmuGRkSo7+3iAwj1ypo
         25rpzukurur/tlRWHD5CiGOXiOKaz8tIBgPpFxL8BuTnGHtZhIjOzIBGz06AfUAcoI
         88ARSg0KDwOOeeE7xy8uunc4RIJ3giniuyE+rL9A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>

Add limit into sscanf format string for on-stack buffer.

Fixes: 0d5936344f30 ("sched: Implement interface for cgroup unified hierarchy")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 43f44539b88f..3971bc62521d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6968,7 +6968,7 @@ static int __maybe_unused cpu_period_quota_parse(char *buf,
 {
 	char tok[21];	/* U64_MAX */
 
-	if (!sscanf(buf, "%s %llu", tok, periodp))
+	if (sscanf(buf, "%20s %llu", tok, periodp) < 1)
 		return -EINVAL;
 
 	*periodp *= NSEC_PER_USEC;

