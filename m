From: Jianyu Zhan <nasa4836@gmail.com>
Subject: [PATCH] hugetlb_cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:30:20 +0800
Message-ID: <1398144620-9630-1-git-send-email-nasa4836@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=YVgkjX/gqiO9MfRl+BmPDbpDBjKOo8cxknR2xFym2F0=;
        b=0ij4aTKn1M1a8bTo8DCtHHXDdHRKuZVTM7W+FbbBWZJYP0UUfuMm9LF5jvCzyak3D/
         NyVyIBWkm/xxp38w3QEbTFW9KQw1o/HoXS9cqyvVPQylY42B+BvKEmJ8X9IQCoMSRDy9
         8T4W1/TMjXvac94VOr8CBv8pPULIDdHPzIz/+h5m1LExaPTZ/Ko5rt6ubXINxNjC5LPv
         o9smn3AdodqiB0zXQBjV1DrzD5ToSL8j/+f8SjUzx1D5kqAwLQUAmaNKAZVqAlR3HLqQ
         5gO5naQaLTvc7Znu971WHxwHglbmciPiCVB+5WYINhVEKaGGHo1Yqx8fG9Eh4eCe4myB
         Pr/w==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com

For a cgroup subsystem who should init early, then it should carefully
take care of the implementation of css_alloc, because it will be called
before mm_init() setup the world.

Luckily we don't, and we better explicitly assign the early_init field
to 0, for document reason.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/hugetlb_cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 595d7fd..b5368f8 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -405,4 +405,5 @@ struct cgroup_subsys hugetlb_cgrp_subsys = {
 	.css_alloc	= hugetlb_cgroup_css_alloc,
 	.css_offline	= hugetlb_cgroup_css_offline,
 	.css_free	= hugetlb_cgroup_css_free,
+	.early_init	= 0,
 };
-- 
2.0.0-rc0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
