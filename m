From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH] doc: cgroup: update note about conditions when oom killer is
 invoked
Date: Fri, 08 May 2020 17:16:29 +0300
Message-ID: <158894738928.208854.5244393925922074518.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588947391; bh=Kz8084Qd+ukMFtBduY70Wrn/hOXrye0GrRmcB96gXCQ=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=Dj8/u6gZYmMA/f3gA/Gqiy6C2yfCTKO//L+zyCsxYhibDXK2RnLGgmSAlaRXqqzlw
         Tq4x4ndeaEZyJGVAZxWLr/JJnElxICKB49ARgoON0n79PGht6cp9Htyk3J3iszXQle
         cbNDkAqPk/3XuNtXYZDXX5+C1gTBipR7wPmNTtdg=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Starting from v4.19 commit 29ef680ae7c2 ("memcg, oom: move out_of_memory
back to the charge path") cgroup oom killer is no longer invoked only from
page faults. Now it implements the same semantics as global OOM killer:
allocation context invokes OOM killer and keeps retrying until success.

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index bcc80269bb6a..1bb9a8f6ebe1 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1172,6 +1172,13 @@ PAGE_SIZE multiple when read back.
 	Under certain circumstances, the usage may go over the limit
 	temporarily.
 
+	In default configuration regular 0-order allocation always
+	succeed unless OOM killer choose current task as a victim.
+
+	Some kinds of allocations don't invoke the OOM killer.
+	Caller could retry them differently, return into userspace
+	as -ENOMEM or silently ignore in cases like disk readahead.
+
 	This is the ultimate protection mechanism.  As long as the
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
@@ -1228,17 +1235,9 @@ PAGE_SIZE multiple when read back.
 		The number of time the cgroup's memory usage was
 		reached the limit and allocation was about to fail.
 
-		Depending on context result could be invocation of OOM
-		killer and retrying allocation or failing allocation.
-
-		Failed allocation in its turn could be returned into
-		userspace as -ENOMEM or silently ignored in cases like
-		disk readahead.  For now OOM in memory cgroup kills
-		tasks iff shortage has happened inside page fault.
-
 		This event is not raised if the OOM killer is not
 		considered as an option, e.g. for failed high-order
-		allocations.
+		allocations or if caller asked to not retry attempts.
 
 	  oom_kill
 		The number of processes belonging to this cgroup

