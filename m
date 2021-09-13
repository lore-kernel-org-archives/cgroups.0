From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] docs/cgroup: remove some duplicate words
Date: Mon, 13 Sep 2021 13:09:14 +0800
Message-ID: <1631509754-21485-1-git-send-email-brookxu.cn@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=HNyXcYZACqdPsANRJk2PRQjj527jHromuW2y01xPu04=;
        b=TYcC/3cpnYl4dRBe8dBz15FbZuelXpYwy22omwmbevheMUwjU+VhGpGYKn19xLTl2k
         /MIDBMueGpPVyDBjzxCRafVXMZlloTUMXlZhT12HM/gSZkmafQPql5hREsO4orJLgnNH
         ArgHHRYjZ7lgXJzenIRduqXgs3tkoQCtj4r2yBAEbqlO7dabyyg3m4vSWTHc0UPRRmHl
         7Us+VcdkgFXy7/f5126iBYaEWV/d/jlZUleY0SEVklrmXM0rPnOVolKGd3Es89UqzWKO
         zwvoGx/DptZ+rbJ2R6A0Un9FF8kOYWgZzzfLL5uvJpgiFhWpZuTFPTjyez+oUQYTZbW5
         ALow==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

When I tried to add some new entries to cgroup-v2.rst, I found that
the description of memory.events had some repetitive words, so I
tried to delete them.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 90a36ae..a6201a99 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1226,7 +1226,7 @@ PAGE_SIZE multiple when read back.
 
 	Note that all fields in this file are hierarchical and the
 	file modified event can be generated due to an event down the
-	hierarchy. For for the local events at the cgroup level see
+	hierarchy. For the local events at the cgroup level see
 	memory.events.local.
 
 	  low
-- 
1.8.3.1

