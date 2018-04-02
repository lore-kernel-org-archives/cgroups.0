From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] cgroup: Make cgroup_rstat_updated() ready for root cgroup
 usage
Date: Mon, 2 Apr 2018 14:49:13 -0700
Message-ID: <20180402214913.GH388343@devbig577.frc2.facebook.com>
References: <20180323231313.1254142-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OzEBIHp+/XrE1ogh7PAIR/3+4G2fiSTIGpkLXfFnHMk=;
        b=JjUu+ljQLctZVju30j+YPcGVYURRhwnMlTPXtwLMoAccXgV6plt5MoXcuVrBLptZrc
         Fho8etQp0AZRqfk53RSmUTumQqRvyh6kDA5R4z/5jchxj+jaavQSMhRIUte671sPSJve
         uH7Ja4Tj5ogJPvOpA9eVgSfBjl6LFdA2KplxwkK7cLG3KePtQjEP8dV2KB2OhEHQtXU2
         i4vdgswEwYLJn/Svuy9MWE3Uc6ZWV4OI9QY0uevbhfhiJ8IHNs4/quAFy85EuQwaQB9C
         px7I5or0fZpy6MSF2zF6ZugLGHcfxf2eYmxQYa4MzajNTfU/A9xSGUJMLCqHph4bp33S
         fmKw==
Content-Disposition: inline
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com

From b7be022bf811d02605098fa61b7545bc146b78e7 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 2 Apr 2018 14:45:20 -0700

cgroup_rstat_updated() ensures that the cgroup's rstat is linked to
the parent.  If there's no parent, it never gets linked and the
function ends up grabbing and releasing the cgroup_rstat_lock each
time for no reason which can be expensive.

This hasn't been a problem till now because nobody was calling the
function for the root cgroup but rstat is gonna be exposed to
controllers and use cases, so let's get ready.  Make
cgroup_rstat_updated() an no-op for the root cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

This should address the scalability issue reported by kenrel test bot.
All git branches updated accordingly.

Thanks.

 kernel/cgroup/rstat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 0d1d5fc..9a30b51 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -27,6 +27,10 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 	struct cgroup *parent;
 	unsigned long flags;
 
+	/* nothing to do for root */
+	if (!cgroup_parent(cgrp))
+		return;
+
 	/*
 	 * Paired with the one in cgroup_rstat_cpu_pop_upated().  Either we
 	 * see NULL updated_next or they see our updated stat.
-- 
2.9.5

