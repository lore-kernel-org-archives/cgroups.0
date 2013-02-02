From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 4/4] cgroup: adapt to the new way of detecting cgroup removal
Date: Sat, 2 Feb 2013 14:51:51 +0800
Message-ID: <510CB787.80003@huawei.com>
References: <510CB733.2080904@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <510CB733.2080904@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Davide Libenzi <davidel@xmailserver.org>, Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>

If read() returns with errno == EIDRM, we know the cgroup has been
removed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 tools/cgroup/cgroup_event_listener.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup_event_listener.c
index 4eb5507..19e3d4a 100644
--- a/tools/cgroup/cgroup_event_listener.c
+++ b/tools/cgroup/cgroup_event_listener.c
@@ -62,18 +62,16 @@ int main(int argc, char **argv)
 		if (ret == -1) {
 			if (errno == EINTR)
 				continue;
-			err(1, "Cannot read from eventfd");
+			if (errno != EIDRM)
+				err(1, "Cannot read from eventfd");
 		}
-		assert(ret == sizeof(result));
 
-		ret = access(event_control_path, W_OK);
-		if ((ret == -1) && (errno == ENOENT)) {
-			puts("The cgroup seems to have removed.");
+		if (ret == -1 && errno == EIDRM) {
+			puts("The cgroup has been removed.");
 			break;
 		}
 
-		if (ret == -1)
-			err(1, "cgroup.event_control is not accessible any more");
+		assert(ret == sizeof(result));
 
 		printf("%s %s: crossed\n", argv[1], argv[2]);
 	}
-- 
1.8.0.2
