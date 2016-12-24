From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] cgroup: fix a comment typo
Date: Sat, 24 Dec 2016 23:28:35 +0800
Message-ID: <be849a0bff86e529baa95bf0d896cb5a28d43ab3.1482300177.git.geliangtang@gmail.com>
References: <33bee1ec2bea0a063ad6f6cf003e91ccfa6daab1.1482300478.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RpiPx1n/IBmSNILb9hAAM/GfD3nivnUtTVuxJMZ8C80=;
        b=e7c6LnTUubQBBYNYJ4bT+yGJyAIWo8PkQFd3Koti1haqlDIAXze9WFFHyAfTgZh9ic
         K9yLPXR4zzk88gkxjN790/+5yqRrnrsbyEKzW8v/LyaQMH35N3iv4bhCdKPa7BZKJR1e
         AuVw/lPdVEgmundNTXXZfNKdh5RjMUWiVbSPE4HQwjQQH9L5d12rH1WBTp0pWxoOP3W8
         oDGqT+cqqzPXv1omQGmSaxZiPr+SEAKMSSwxdZi0cHcRjolQIUh6M5CLOyP4YRMf1rqi
         Vnkqj2f1zRFobCMplo1FqPsOI+VJ4JWCGZiYuwWciF6AYrhjYuoBzU4e+0SSM7C1Kr2N
         TJiw==
In-Reply-To: <33bee1ec2bea0a063ad6f6cf003e91ccfa6daab1.1482300478.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jiri Kosina <trivial@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Fix a comment typo in cgroup.h.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 include/linux/cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c83c23f..f6b43fb 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -266,7 +266,7 @@ void css_task_iter_end(struct css_task_iter *it);
  * cgroup_taskset_for_each_leader - iterate group leaders in a cgroup_taskset
  * @leader: the loop cursor
  * @dst_css: the destination css
- * @tset: takset to iterate
+ * @tset: taskset to iterate
  *
  * Iterate threadgroup leaders of @tset.  For single-task migrations, @tset
  * may not contain any.
-- 
2.9.3

