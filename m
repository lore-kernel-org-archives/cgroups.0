From: Roman Gushchin <guro@fb.com>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Mon, 4 Sep 2017 18:51:18 +0100
Message-ID: <20170904175118.GA25219@castle.DHCP.thefacebook.com>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <CALvZod4TtA8myYSqCL87dDXfyk1qkYx+v-MO6nt-cA+bKTcGUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=R21/qt6B6SRIlA19iL7fd7tD+1YgQRipaLVOoKdOfds=;
 b=ZMQB+gXjUZs43EfHtT11S4y7WjdV61EQIjJ7o6uVANAXE6aGZ+BYA0yvO/B2TnK0CL9D
 DdvIUyiKTQtfDFZLN40K6Dpa7IAPenZG2lD/pspbuq5tRtsXAVgYJjs8CaYZGbpn4YqR
 J6BwDX7LtfLO7TYvYj7acRPYz+pjpWMBU80= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=R21/qt6B6SRIlA19iL7fd7tD+1YgQRipaLVOoKdOfds=;
 b=N6iqOAofn30ya8qjTDKi1VTqx335BuBNlEDSqYFg9zpNRnzjLvBIBfNIYXRa7zasLbVzpjEQuuyOEWRHEwNR5wbZwxqJSIMnPeDZ1n5OaeJ32JxA41ZwSP9+ZQhliMjEajtf5/ZKFBvtHeeVham+mEJxKZWSbuWt6HWhzl1hcTA=
Content-Disposition: inline
In-Reply-To: <CALvZod4TtA8myYSqCL87dDXfyk1qkYx+v-MO6nt-cA+bKTcGUA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, Sep 04, 2017 at 10:32:37AM -0700, Shakeel Butt wrote:
> On Mon, Sep 4, 2017 at 7:21 AM, Roman Gushchin <guro@fb.com> wrote:
> > Introducing of cgroup-aware OOM killer changes the victim selection
> > algorithm used by default: instead of picking the largest process,
> > it will pick the largest memcg and then the largest process inside.
> >
> > This affects only cgroup v2 users.
> >
> > To provide a way to use cgroups v2 if the old OOM victim selection
> > algorithm is preferred for some reason, the nogroupoom mount option
> > is added.
> 
> Is this mount option or boot parameter? From the code, it seems like a
> boot parameter.

Sure, you're right.

Fixed version below.

Thank you!

--

From 0b4757ec8d339fa883e17d4e25a92f45bf5565e0 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Mon, 4 Sep 2017 12:08:52 +0100
Subject: [v7 5/5] mm, oom: allow disabling cgroup-aware OOM killer

Introducing of cgroup-aware OOM killer changes the victim selection
algorithm used by default: instead of picking the largest process,
it will pick the largest memcg and then the largest process inside.

This affects only cgroup v2 users.

To provide a way to use cgroups v2 if the old OOM victim selection
algorithm is preferred for some reason, the cgroup.memory=nogroupoom
boot option is added.

If set, the OOM selection is performed in a "traditional" per-process
way. Both oom_priority and oom_group memcg knobs are ignored.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 Documentation/admin-guide/kernel-parameters.txt | 1 +
 mm/memcontrol.c                                 | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 28f1a0f84456..07891f1030aa 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -489,6 +489,7 @@
 			Format: <string>
 			nosocket -- Disable socket memory accounting.
 			nokmem -- Disable kernel memory accounting.
+			nogroupoom -- Disable cgroup-aware OOM killer.
 
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d7dd293897ca..6a8235dc41f6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -87,6 +87,9 @@ static bool cgroup_memory_nosocket;
 /* Kernel memory accounting disabled? */
 static bool cgroup_memory_nokmem;
 
+/* Cgroup-aware OOM  disabled? */
+static bool cgroup_memory_nogroupoom;
+
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
 int do_swap_account __read_mostly;
@@ -2822,6 +2825,9 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
 	if (mem_cgroup_disabled())
 		return false;
 
+	if (cgroup_memory_nogroupoom)
+		return false;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
@@ -6188,6 +6194,8 @@ static int __init cgroup_memory(char *s)
 			cgroup_memory_nosocket = true;
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
+		if (!strcmp(token, "nogroupoom"))
+			cgroup_memory_nogroupoom = true;
 	}
 	return 0;
 }
-- 
2.13.5

