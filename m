From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Tue, 4 Sep 2012 16:35:52 +0200
Message-ID: <20120904143552.GB15683@dhcp22.suse.cz>
References: <1346687211-31848-1-git-send-email-glommer@parallels.com>
 <20120903170806.GA21682@dhcp22.suse.cz>
 <5045BD25.10301@parallels.com>
 <20120904130905.GA15683@dhcp22.suse.cz>
 <504601B8.2050907@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <504601B8.2050907@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>, Lennart Poettering <lennart@poettering.net>, Kay Sievers <kay.sievers@vrfy.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>

On Tue 04-09-12 17:27:20, Glauber Costa wrote:
> On 09/04/2012 05:09 PM, Michal Hocko wrote:
> > Not really. Do it slowly means that somebody actually _notices_ that
> > something is about to change and they have a lot of time for that. This
> > will be really hard with the config option saying N by default.  People
> > will ignore that until it's too late.
> > We are interested in those users who would keep the config default N and
> > they are (ab)using use_hierarchy=0 in a way which is hard/impossible to
> > fix. This is where distributions might help and they should IMHO but why
> > to put an additional code into upstream? Isn't it sufficient that those
> > who would like to help (and take the risk) would just take the patch?
> 
> At least Fedora, seem to frown upon heavily at non-upstream patches.

OK, so what about the following approach instead? We won't change the
default but rather shout at people when they actually create subtrees
with use_hierarchy==0. This shouldn't make pointless noise. I do not
remember whether we have considered this previously so sorry if this was
shot down as well.
---
From 5e6e9dbe09dc6144d84a76d936327d17bbad9ecb Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 4 Sep 2012 15:55:03 +0200
Subject: [PATCH] memcg: warn on deeper hierarchies with use_hierarchy==0

The memory controller supports both hierarchical and non-hierarchical
behavior which is controlled by use_hierarchy knob (0 by default).
The primary motivation for this distinction was an ineffectiveness
of hierarchical accounting. This has improved a lot since it was
introduced.

This schizophrenia makes the code and integration with other controllers
more complicated (e.g. mounting it with fully hierarchical one could
have an unexpected side effects) for no good reason so it would be good
to make the memory controller behave only hierarchically.

It seems that there is no good reasons for deep cgroup hierarchies which
are not truly hierarchical so we could set the default to 1. This might,
however, lead to unexpected regressions when somebody relies on the
current default behavior. For example, consider the following setup:
		 Root[cpuset,memory]
		  |
		  A (use_hierarchy=0)
		 / \
		B  C

All three A, B, C have some tasks and their memory limits. The hierarchy
is created only because of the cpuset and its configuration.
Say the default is changed. Then a memory pressure in C could influence
both A and B which wouldn't happen before. The problem might be really
hard to notice (unexpected slowdown).
This configuration could be fixed up easily by reorganization, though:
		 Root
		  |
		  A' (use_hierarchy=1, limit=unlimited, no tasks)
		 /|\
		A B C

The problem is that we don't know whether somebody has an use case which
cannot be transformed like that. Therefore this patch starts the slow
transition to hierarchical only memory controller by warning users who
are using flat hierarchies. The warning triggers only if a subgroup of
non-root group is created with use_hierarchy==0.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 795e525..87cb83f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4958,6 +4958,11 @@ mem_cgroup_create(struct cgroup *cont)
 		parent = mem_cgroup_from_cont(cont->parent);
 		memcg->use_hierarchy = parent->use_hierarchy;
 		memcg->oom_kill_disable = parent->oom_kill_disable;
+		WARN_ONCE(!memcg->use_hierarchy && parent != root_mem_cgroup,
+				"Creating hierarchies with use_hierarchy==0 "
+				"(flat hierarchy) is considered deprecated. "
+				"If you believe that your setup is correct, "
+				"we kindly ask you to contact linux-mm@kvack.org and let us");
 	}
 
 	if (parent && parent->use_hierarchy) {
-- 
1.7.10.4


-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
