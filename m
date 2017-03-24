From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] cgroup: drop duplicate header nsproxy.h
Date: Fri, 24 Mar 2017 22:13:35 +0800
Message-ID: <622620bc9c85ce62cd7857e80acc2d0bcaff3aaf.1490342770.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sfo7nV2ALaeYLrEfOLmqEgjQ9qXAJoGZ0zeSvg7vrec=;
        b=XKFN/v6XGF2JirItvbTwDvWM2yn8Fyay9L+w0/TYWEhuxn514T1fmIpR3J7kvQjm5Q
         0INEB06YYGUvWtkvVka4uE8g8nYakR3mV6sTQcsXcn8b8FUfAqBqqhc3eZg7pZfhbUDQ
         wPWyNPERKsJmH69n67UjRl1BccVe2jcKW4KKfhmLTYHeUFmMFmSi1/OirA+uCil9biTp
         fEyPLXwz0Qul/XQyieMjqxlB9/TaJicCYNMH1dcvJZUk/PShk+8E4JRtOvO4xaZyCJsP
         d5iVfMXCOE027HsIWE3DlzoFhElArq8klOnid/cSrhlYDXAkJ+KxgipldYN4gsiqfKgL
         5kMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Geliang Tang <geliangtang@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Drop duplicate header nsproxy.h from linux/cgroup.h.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 include/linux/cgroup.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4341441..ed2573e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -17,7 +17,6 @@
 #include <linux/seq_file.h>
 #include <linux/kernfs.h>
 #include <linux/jump_label.h>
-#include <linux/nsproxy.h>
 #include <linux/types.h>
 #include <linux/ns_common.h>
 #include <linux/nsproxy.h>
-- 
2.9.3

