From: Roman Gushchin <guro@fb.com>
Subject: [RFC 4/4] cgroup: re-use the parent pointer in cgroup_destroy_locked()
Date: Wed, 2 Aug 2017 17:55:32 +0100
Message-ID: <20170802165532.22277-5-guro@fb.com>
References: <20170802165532.22277-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Tw//oB6GP94ozc+xQqOsNzlRkmMGncezgcyIjEZK/FE=;
 b=PsYYIL4gM+KjDRqmOjVUaBM/ABZ7H18qKSYMdtYZLJscOjWr/DlZNsoN43h6aDIjgbZl
 JcOoEE/iHwfpof5tHAslKNtlFLE2W6KMSskTfv952bKv5wV6TF5K/MGwNadaNhSB4x3k
 jPBZFOVwWLzCH70axHrIMxFKakRBnTZibuI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Tw//oB6GP94ozc+xQqOsNzlRkmMGncezgcyIjEZK/FE=;
 b=DhTIbz9TjAmYSpsg55b3FWFkVTNZKareeOObzzBrdfE4oCKfPbqWydgQWTvYO1Y2St1p6Pl9Lkg7/Wcho9NJvl6wKK7j/eaQIpExKTj5nqLdH4qYu5gdEr73M2X/pT3bAyIdId9ZKj5LR/I+CyRj5qBFmf4sThHEHCVNafkwrFw=
In-Reply-To: <20170802165532.22277-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-kernel@vger.kernel.org

As we already have a pointer to the parent cgroup in
cgroup_destroy_locked(), we don't need to calculate it again
to pass as an argument for cgroup1_check_for_release().

Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel-team@fb.com
Cc: linux-kernel@vger.kernel.org
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f58e1fe8bebd..2d9de4ec7727 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5022,7 +5022,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		tcgrp->nr_dying_descendants++;
 	}
 
-	cgroup1_check_for_release(cgroup_parent(cgrp));
+	cgroup1_check_for_release(parent);
 
 	/* put the base reference */
 	percpu_ref_kill(&cgrp->self.refcnt);
-- 
2.13.3

