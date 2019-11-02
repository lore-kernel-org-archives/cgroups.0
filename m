From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] mm/memcontrol: update documentation about invoking oom
 killer
Date: Sat, 02 Nov 2019 18:16:33 +0300
Message-ID: <157270779336.1961.6528158720593572480.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1572707794; bh=AR0posdeGGjRMOUjYp9dgJq5OCpwQBAAcmepPzGDKWg=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=X9dFktO77Na/G0mtC2+xSzpD1cMLgWOkM1P9fpb+ypv5Obc9xW91WTB8Mc1xm15fI
         f+vjegUUhK0i7hnoRfJ+Na/UVVXYuRet+Jx2AzVkMEQdB23FUCLveNYbe34Rajfqob
         WnSYBjjQfRvF4wy/a3HK7oM0Cf0Nz8wpJRNk4zps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.com>

Since commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
charge path") memcg invokes oom killer not only for user page-faults.
This means 0-order allocation will either succeed or task get killed.

Fixes: 8e675f7af507 ("mm/oom_kill: count global and memory cgroup oom kills")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 Documentation/admin-guide/cgroup-v2.rst |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 5361ebec3361..eb47815e137b 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1219,8 +1219,13 @@ PAGE_SIZE multiple when read back.
 
 		Failed allocation in its turn could be returned into
 		userspace as -ENOMEM or silently ignored in cases like
-		disk readahead.  For now OOM in memory cgroup kills
-		tasks iff shortage has happened inside page fault.
+		disk readahead.
+
+		Before 4.19 OOM in memory cgroup killed tasks iff
+		shortage has happened inside page fault, random
+		syscall may fail with ENOMEM or EFAULT. Since 4.19
+		failed memory cgroup allocation invokes oom killer and
+		keeps retrying until it succeeds.
 
 		This event is not raised if the OOM killer is not
 		considered as an option, e.g. for failed high-order

