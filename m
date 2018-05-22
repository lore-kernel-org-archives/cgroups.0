From: Roman Gushchin <guro@fb.com>
Subject: [PATCH] cgroup, docs: add a note about returning EBUSY in some cases
Date: Tue, 22 May 2018 15:36:48 +0100
Message-ID: <20180522143648.29508-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=pyGyst6CwqeV5Q/PD0dBswtRw65+/xB3wFZAo8T8W68=;
 b=Thpcd6pVWuyT5i5NFYbWW+77Wywh2cK00X5Hvj+0ziS3gy+DkwHZR4MhshntQYwI2Tqk
 wBLIvG91MFIaEfWQFMFB3hzAWefl6+a8qc0yH11cr/UNAQjzBxQi9Y4189jHMJWHkKOg
 W0sQEY36Gw3sIEX9nzaPELiWrsyNOStZtS0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyGyst6CwqeV5Q/PD0dBswtRw65+/xB3wFZAo8T8W68=;
 b=DM5iM5qdlOnoBQvHK1BfsfyiLWBfg0Ae8iW1i1wOLFS17JHHjgl6ETADF5j67osxy1LLPfyT23rRPiwX4D8e3vr5eGhpsYyXM1xFo57DuvYhBg2cZeAVQP7hF86wP4h5Goz1FueubY8DyxqKqaWRDxeXrF/vgEhsPTVNML8Nq+8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Explicitly document EBUSY returned by writing into cgroup.procs
if controllers are enabled; and writing into cgroup.subtree_control
if there are attached processes.

The return code might be slightly surprising, and because there is
nothing obviously better, let's document it at least.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/cgroup-v2.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 74cdeaed9f7a..57302f88a4ad 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -799,6 +799,9 @@ All cgroup core files are prefixed with "cgroup."
 	When delegating a sub-hierarchy, write access to this file
 	should be granted along with the containing directory.
 
+	If the target cgroup has enabled controllers, writing to this
+	file will fail with EBUSY.
+
 	In a threaded cgroup, reading this file fails with EOPNOTSUPP
 	as all the processes belong to the thread root.  Writing is
 	supported and moves every thread of the process to the cgroup.
@@ -850,6 +853,9 @@ All cgroup core files are prefixed with "cgroup."
 	the last one is effective.  When multiple enable and disable
 	operations are specified, either all succeed or all fail.
 
+	If the cgroup has attached tasks, writing to this file will
+	fail with EBUSY.
+
   cgroup.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
-- 
2.14.3

