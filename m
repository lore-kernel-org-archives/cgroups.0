From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v13 5/7] mm, oom: add cgroup v2 mount option for
 cgroup-aware OOM killer
Date: Fri, 1 Dec 2017 17:00:09 +0000
Message-ID: <20171201170004.GA27436@castle.DHCP.thefacebook.com>
References: <20171130152824.1591-1-guro@fb.com>
 <20171130152824.1591-6-guro@fb.com>
 <20171201084113.47lnuo3diwxts732@dhcp22.suse.cz>
 <20171201131530.GA7741@castle.DHCP.thefacebook.com>
 <20171201133145.w4b4cekruklcgtol@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=9LhydcVT0INA7/ffzBUdGSm7/nj4yA1oe+IkwvpYnuM=;
 b=A6LhrVOb5RX7z51E9BigihuU8L/GraKq35MGuJ8N0OkdqlwO8DqhhMr0A9FG64/z/wWK
 j1Y0TvbVFO9jRgxJDO7nMnunPkrndOIwtsXoGLry8rhB0VTsgaOLQLjSY90TQGYLPAE+
 StwilFvOHknHZ+mjtFI76rgHTGzPdfA0HFA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9LhydcVT0INA7/ffzBUdGSm7/nj4yA1oe+IkwvpYnuM=;
 b=RdDjm4sGPHgfmUT3Iw4BoHHrfAzWZ1BNtz2rj04wLu7gMK/rajEm6nSC9WSPlUr4rMwU57uaqqR1fnNwOyGPCcN5+CQV3ZuFBEl6mz/sMTMoo/JXZlfHTX4+lY+Nb8M3l05YLDAp4y910d8apN0Lls3sJQKOIdu75mJiiSN/d0Q=
Content-Disposition: inline
In-Reply-To: <20171201133145.w4b4cekruklcgtol@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri, Dec 01, 2017 at 02:31:45PM +0100, Michal Hocko wrote:
> On Fri 01-12-17 13:15:38, Roman Gushchin wrote:
> [...]
> > So, maybe we just need to return -EAGAIN (or may be -ENOTSUP) on any read/write
> > attempt if option is not enabled?
> 
> Yes, that would work as well. ENOTSUP sounds better to me.
> -- 
> Michal Hocko
> SUSE Labs

From 78bf2c00abf450bcd993d02a7dc1783144005fbd Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Fri, 1 Dec 2017 14:30:14 +0000
Subject: [PATCH] mm, oom: return error on access to memory.oom_group if
 groupoom is disabled

Cgroup-aware OOM killer depends on cgroup mount option and is turned
off by default, despite the user interface (memory.oom_group file) is
always present. As it might be confusing to a user, let's return
-ENOTSUPP on an attempt to access to memory.oom_group if groupoom is not
enabled globally.

Example:
  $ cd /sys/fs/cgroup/user.slice/
  $ cat memory.oom_group
    cat: memory.oom_group: Unknown error 524
  $ echo 1 > memory.oom_group
    -bash: echo: write error: Unknown error 524
  $ mount -o remount,groupoom /sys/fs/cgroup
  $ echo 1 > memory.oom_group
  $ cat memory.oom_group
    1

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c76d5fb55c5c..b709ee4f914b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5482,6 +5482,9 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	bool oom_group = memcg->oom_group;
 
+	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
+		return -ENOTSUPP;
+
 	seq_printf(m, "%d\n", oom_group);
 
 	return 0;
@@ -5495,6 +5498,9 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	int oom_group;
 	int err;
 
+	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
+		return -ENOTSUPP;
+
 	err = kstrtoint(strstrip(buf), 0, &oom_group);
 	if (err)
 		return err;
-- 
2.14.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
