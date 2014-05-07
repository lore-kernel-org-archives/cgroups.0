From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.16] cgroup: remove unused CGRP_SANE_BEHAVIOR
Date: Wed, 7 May 2014 09:23:28 -0400
Message-ID: <20140507132328.GE16702@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=knhe5Z89YoMh7exsBwPc0BqsbIR0nAZu/Ku2xIm9zyU=;
        b=xkcb8LJPmnbhDYULyTE2SWm1tv93AwrYcP20CMWtUCsCiRi77p5M2gbfDGRRdvKTvu
         QKOQD4jcOyJiSpPYAGhoq28bH3RiboPav4JJfX0iCLiXbf7mUXO+z7+Y4oGcUq8wd24U
         zIL1SzahEgSXFAfloEDEl9N32+GgvI4NBoyRZpxRctyTHHH2Gg/itl72Hw/yd1A+4+L0
         cEx3kZxZbewmvYwYVfSsrkArqGU7o6sPxdF/7gwwUSIbuVqigfdOii5f3iUtowFIAlR5
         d7ghkjqnfIb5/P6P+pXKEqBJNRuhM+7STqto/zMy6kHzRbu2k8h4wJr74n4RrYjycP49
         8Dgg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From 2b53f41fa8604845f4f7c538723694a453088b15 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 7 May 2014 09:21:56 -0400

This cgroup flag has never been used.  Only CGRP_ROOT_SANE_BEHAVIOR is
used.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to cgroup/for-3.16.

Thanks.

 include/linux/cgroup.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2dfabb3..f482f95 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -140,8 +140,6 @@ enum {
 	 * specified at mount time and thus is implemented here.
 	 */
 	CGRP_CPUSET_CLONE_CHILDREN,
-	/* see the comment above CGRP_ROOT_SANE_BEHAVIOR for details */
-	CGRP_SANE_BEHAVIOR,
 };
 
 struct cgroup {
-- 
1.9.0
