From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] cgroup: Make Kconfig prompt of debug cgroup more accurate
Date: Wed, 14 Jun 2017 16:08:38 -0400
Message-ID: <20170614200842.15174-4-tj@kernel.org>
References: <20170614200842.15174-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IwbQePC3cKGMaWJdnK7rb8J5cg6fKUs8NAGlOdq+m7I=;
        b=a0hDI0mtW0aFDrjiTqte/yzkRIjiYFTNwqhSL6Dhrw0pCJ0XAya1yWCECsoTLcnoBo
         //UzLufXIGgPUWr3YbwqZSuDIEIpKEvLgD39gAg5M5j9QmeWysoVUS734Cp0ikh0lzIo
         AAAcXFSWD3e1VDU+I4+yD9I/U1Vq+iqivwDEy0+1XdKZA3hPyNW10zCwW1uDzHzwniKm
         5FAU8den4krpNqSN9Gci1usmgGdmt45gWM86vjeJqs5WcrQB/AT69Ls+ZA8y858Pz49d
         09vy3PMl6/YAYx5ErfM26SXeIEER3aG8rTx327qEHL1zGAjutFORxNEXhaUDMHmiCkAv
         ltpQ==
In-Reply-To: <20170614200842.15174-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

From: Waiman Long <longman@redhat.com>

The Kconfig prompt and description of the debug cgroup controller
more accurate by saying that it is for debug purpose only and its
interfaces are unstable.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 init/Kconfig          | 7 +++++--
 kernel/cgroup/debug.c | 6 ++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 1d3475fc9496..5f9d13929ae0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1205,11 +1205,14 @@ config CGROUP_BPF
 	  inet sockets.
 
 config CGROUP_DEBUG
-	bool "Example controller"
+	bool "Debug controller"
 	default n
+	depends on DEBUG_KERNEL
 	help
 	  This option enables a simple controller that exports
-	  debugging information about the cgroups framework.
+	  debugging information about the cgroups framework. This
+	  controller is for control cgroup debugging only. Its
+	  interfaces are not stable.
 
 	  Say N.
 
diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 1c209aa43733..cbe77a2087c5 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -1,3 +1,9 @@
+/*
+ * Debug controller
+ *
+ * WARNING: This controller is for cgroup core debugging only.
+ * Its interfaces are unstable and subject to changes at any time.
+ */
 #include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-- 
2.13.0

