From: Roman Gushchin <guro@fb.com>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Wed, 6 Sep 2017 18:40:43 +0100
Message-ID: <20170906174043.GA12579@castle.DHCP.thefacebook.com>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
 <20170905143021.GA28599@castle.dhcp.TheFacebook.com>
 <20170905151251.luh4wogjd3msfqgf@dhcp22.suse.cz>
 <20170905191609.GA19687@castle.dhcp.TheFacebook.com>
 <20170906084242.l4rcx6n3hdzxvil6@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=17JTlTO9fPi+iJLg8uUOlbr8j9qpUzfl9VY0C7H6GHo=;
 b=EQ9dpcPAB2zjpzGYkGtiLCc2OpVrUp/OjIsnovNc947KaeEjlhNEi7ITu2yrKwQhS9Po
 LQNz7Dk5lcuZh1MOSz943znToszerCc4QS/NsUMWmzqJ82TPTEUS0pT5aXXTTCo2NqD9
 YXf1dp9af8gkQAU9AmK02PfXS3PYMUWFSoc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=17JTlTO9fPi+iJLg8uUOlbr8j9qpUzfl9VY0C7H6GHo=;
 b=g986lnfzdl3RIE4YBaAicIRht6g3S4QDKJoiHLbNNTfwo4/AdAPiviJ+wWb3zPC4LyDARFyCRDWBA5QLbUWX7zRvbNKeSJ0hI+2wkqOZRa+EggafZ1XAYJOCD/q5zhsX9Kr7Ijf160bfjDUViG2X5tlX01TKxkH812G/6d+AtaY=
Content-Disposition: inline
In-Reply-To: <20170906084242.l4rcx6n3hdzxvil6@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

sOn Wed, Sep 06, 2017 at 10:42:42AM +0200, Michal Hocko wrote:
> On Tue 05-09-17 20:16:09, Roman Gushchin wrote:
> > On Tue, Sep 05, 2017 at 05:12:51PM +0200, Michal Hocko wrote:
> [...]
> > > > Then we should probably hide corresponding
> > > > cgroup interface (oom_group and oom_priority knobs) by default,
> > > > and it feels as unnecessary complication and is overall against
> > > > cgroup v2 interface design.
> > > 
> > > Why. If we care enough, we could simply return EINVAL when those knobs
> > > are written while the corresponding strategy is not used.
> > 
> > It doesn't look as a nice default interface.
> 
> I do not have a strong opinion on this. A printk_once could explain why
> the knob is ignored and instruct the admin how to enable the feature
> completely.
>  
> > > > > I think we should instead go with
> > > > > oom_strategy=[alloc_task,biggest_task,cgroup]
> > > > 
> > > > It would be a really nice interface; although I've no idea how to implement it:
> > > > "alloc_task" is an existing sysctl, which we have to preserve;
> > > 
> > > I would argue that we should simply deprecate and later drop the sysctl.
> > > I _strongly_ suspect anybody is using this. If yes it is not that hard
> > > to change the kernel command like rather than select the sysctl.
> > 
> > I agree. And if so, why do we need a new interface for an useless feature?
> 
> Well, I won't be opposed just deprecating the sysfs and only add a
> "real" kill-allocate strategy if somebody explicitly asks for it.


I think we should select this approach.
Let's check that nobody actually uses it.

Thanks!

--

From f6e2339926a07500834d86548f3f116af7335d71 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Wed, 6 Sep 2017 17:43:44 +0100
Subject: [PATCH] mm, oom: first step towards oom_kill_allocating_task
 deprecation

The oom_kill_allocating_task sysctl which causes the OOM killer
to simple kill the allocating task is useless. Killing the random
task is not the best idea.

Nobody likes it, and hopefully nobody uses it.
We want to completely deprecate it at some point.

To make a first step towards deprecation, let's warn potential
users about deprecation plans.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/sysctl.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 655686d546cb..9158f1980584 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -220,6 +220,17 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 
 #endif
 
+static int proc_oom_kill_allocating_tasks(struct ctl_table *table, int write,
+				   void __user *buffer, size_t *lenp,
+				   loff_t *ppos)
+{
+	pr_warn_once("The oom_kill_allocating_task sysctl will be deprecated.\n"
+		     "If you're using it, please, report to "
+		     "linux-mm@kvack.kernel.org.\n");
+
+	return proc_dointvec(table, write, buffer, lenp, ppos);
+}
+
 static struct ctl_table kern_table[];
 static struct ctl_table vm_table[];
 static struct ctl_table fs_table[];
@@ -1235,7 +1246,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_oom_kill_allocating_task,
 		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_oom_kill_allocating_tasks,
 	},
 	{
 		.procname	= "oom_dump_tasks",
-- 
2.13.5

