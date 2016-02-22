From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup: fix error return value of cgroup_addrm_files()
Date: Mon, 22 Feb 2016 18:05:44 -0500
Message-ID: <1456182349-18156-2-git-send-email-tj@kernel.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WgIpdADNzl/SwMBnfdfrl1htxFlC9CYDRPKxsvqg7E0=;
        b=h0GqJ5CdlsQHadTKVXzKHGIyE2B76PcnEpS4LfZefDG0Wq4lt4qn+r3yeFKyZ/nNph
         k2hZvKw9nh28o1LqY7q/n8/iaz5GbWvKD01Xb5enhBEA8/2Fek4j14+DQbY4ps4FMzgc
         Wk2WrHajRYgzwmLbTXKUqzG/mVFmkainqHvGMM3xBfZB4O0oVANRB6joZ+j302BFJSIL
         vHQHQfRzKnKZNt/279O85t0yunyKbIS3uc+R5tiLGZ2XSI9pb4d23mPfYilWTCXJCjYt
         AFj8yKGcKQSjZPYSQhP4VhHCLdRE81NrVyjX4wzeR/pcC6OupgVDlLhbw91voaS/4Cx/
         AaIA==
In-Reply-To: <1456182349-18156-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup_addrm_files() incorrectly returned 0 after add failure.  Fix
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7ad6191..68b032d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3369,7 +3369,7 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 			      bool is_add)
 {
 	struct cftype *cft, *cft_end = NULL;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -3398,7 +3398,7 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 			cgroup_rm_file(cgrp, cft);
 		}
 	}
-	return 0;
+	return ret;
 }
 
 static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
-- 
2.5.0

