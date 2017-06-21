From: Roman Gushchin <guro@fb.com>
Subject: [v3 6/6] mm,oom,docs: describe the cgroup-aware OOM killer
Date: Wed, 21 Jun 2017 22:19:16 +0100
Message-ID: <1498079956-24467-7-git-send-email-guro@fb.com>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=S7XRIbEZCwZHkHEXbbJLXkFQwIn0b6WrS3BG6uzMqZo=;
 b=QoOopS2SqqvwZKp53wEKJrgN319z2m9dNT7RCaQZghsd9gDLngyzL/xXHRoMW5htCtKi
 t1mfEJnXnOZ3lpuaoZF6XF0/LFUlnaPlEzZoUXrQhi2J1f7iyB388VSSPbbWnx0Lwst1
 T0QprD3z55JnU+4+INaO4q67TywMRJk/0CI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=S7XRIbEZCwZHkHEXbbJLXkFQwIn0b6WrS3BG6uzMqZo=;
 b=TcZncen66wleq5pN2NpEkBjHAIsxz3J/dv+o2+7knD7ivIN2VwwN0peBybFV0unZ/60yJs3dmv+6r+55gV7Qw+9iHtnHRtNQIyRFM4zJYTK0V8E8JwRxbejmwBOAeYZ0DnI+w3ztwD8mfFxyiCrrAjljCGXQaIlcBIIUc03RKOI=
In-Reply-To: <1498079956-24467-1-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Update cgroups v2 docs.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 Documentation/cgroup-v2.txt | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index a86f3cb..7a1a1ac 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -44,6 +44,7 @@ CONTENTS
     5-2-1. Memory Interface Files
     5-2-2. Usage Guidelines
     5-2-3. Memory Ownership
+    5-2-4. Cgroup-aware OOM Killer
   5-3. IO
     5-3-1. IO Interface Files
     5-3-2. Writeback
@@ -799,6 +800,26 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
 
+  memory.oom_kill_all_tasks
+
+	A read-write single value file which exits on non-root
+	cgroups.  The default is "0".
+
+	Defines whether the OOM killer should treat the cgroup
+	as a single entity during the victim selection.
+
+	If set, it will cause the OOM killer to kill all belonging
+	tasks, both in case of a system-wide or cgroup-wide OOM.
+
+  memory.oom_score_adj
+
+	A read-write single value file which exits on non-root
+	cgroups.  The default is "0".
+
+	OOM killer score adjustment, which has as similar meaning
+	to a per-process value, available via /proc/<pid>/oom_score_adj.
+	Should be in a range [-1000, 1000].
+
   memory.events
 
 	A read-only flat-keyed file which exists on non-root cgroups.
@@ -1028,6 +1049,29 @@ POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
 belonging to the affected files to ensure correct memory ownership.
 
 
+5-2-4. Cgroup-aware OOM Killer
+
+Cgroup v2 memory controller implements a cgroup-aware OOM killer.
+It means that it treats memory cgroups as first class OOM entities.
+
+Under OOM conditions the memory controller tries to make the best
+choise of a victim, hierarchically looking for the largest memory
+consumer. By default, it will look for the biggest task in the
+biggest leaf cgroup.
+
+But a user can change this behavior by enabling the per-cgroup
+oom_kill_all_tasks option. If set, it causes the OOM killer treat
+the whole cgroup as an indivisible memory consumer. In case if it's
+selected as on OOM victim, all belonging tasks will be killed.
+
+Tasks in the root cgroup are treated as independent memory consumers,
+and are compared with other memory consumers (e.g. leaf cgroups).
+The root cgroup doesn't support the oom_kill_all_tasks feature.
+
+This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
+the memory controller considers only cgroups belonging to the sub-tree
+of the OOM'ing cgroup.
+
 5-3. IO
 
 The "io" controller regulates the distribution of IO resources.  This
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
