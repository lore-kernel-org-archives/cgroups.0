From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Mon, 29 Jan 2018 11:46:57 +0100
Message-ID: <20180129104657.GC21609@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
 <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
 <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
 <20180126143950.719912507bd993d92188877f@linux-foundation.org>
 <alpine.DEB.2.10.1801261441340.20954@chino.kir.corp.google.com>
 <20180126161735.b999356fbe96c0acd33aaa66@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180126161735.b999356fbe96c0acd33aaa66@linux-foundation.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri 26-01-18 16:17:35, Andrew Morton wrote:
> On Fri, 26 Jan 2018 14:52:59 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
[...]
> > Those use cases are also undocumented such that the user doesn't know the 
> > behavior they are opting into.  Nowhere in the patchset does it mention 
> > anything about oom_score_adj other than being oom disabled.  It doesn't 
> > mention that a per-process tunable now depends strictly on whether it is 
> > attached to root or not.  It specifies a fair comparison between the root 
> > mem cgroup and leaf mem cgroups, which is obviously incorrect by the 
> > implementation itself.  So I'm not sure the user would know which use 
> > cases it is valid for, which is why I've been trying to make it generally 
> > purposeful and documented.
> 
> Documentation patches are nice.  We can cc:stable them too, so no huge
> hurry.

What about this?

From c02d8bc1396d5ab3785d01f577e2ee74e5dd985e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Mon, 29 Jan 2018 11:42:59 +0100
Subject: [PATCH] oom, memcg: clarify root memcg oom accounting

David Rientjes has pointed out that the current way how the root memcg
is accounted for the cgroup aware OOM killer is undocumented. Unlike
regular cgroups there is no accounting going on in the root memcg
(mostly for performance reasons). Therefore we are suming up oom_badness
of its tasks. This might result in an over accounting because of the
oom_score_adj setting. Document this for now.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 Documentation/cgroup-v2.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 2eaed1e2243d..7dff106bba57 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1292,7 +1292,11 @@ the memory controller considers only cgroups belonging to the sub-tree
 of the OOM'ing cgroup.
 
 The root cgroup is treated as a leaf memory cgroup, so it's compared
-with other leaf memory cgroups and cgroups with oom_group option set.
+with other leaf memory cgroups and cgroups with oom_group option
+set. Due to internal implementation restrictions the size of the root
+cgroup is a cumulative sum of oom_badness of all its tasks (in other
+words oom_score_adj of each task is obeyed). This might change in the
+future.
 
 If there are no cgroups with the enabled memory controller,
 the OOM killer is using the "traditional" process-based approach.
-- 
2.15.1
-- 
Michal Hocko
SUSE Labs
