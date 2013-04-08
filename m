From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
Date: Mon, 8 Apr 2013 20:03:44 +0200
Message-ID: <20130408180335.GA22512@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627DBB.5050005@huawei.com>
 <20130408144750.GK17178@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=MZ5+0HD4hjcEfqHs3NyWEAL1iorcYmuWojOPFDN1768=;
        b=nQJKQH9d+xue5wwqMVNnn+aQq9I0tTIKUnea7xC1MfY19p4VMmvcKF5+FquMPwMxdh
         X6Tr7WSDpGWnO/yr/9ggu+h4jij/mzlxBFN+VRMagOVm+wgz9+DH1EKpmfB3lyce0WAl
         1QOQwWZDXSugq86a7Msd2NO55hI09//Mi5NSAOtPQ6U4eoYUE74K6V0l9eF+7NU9us+W
         PrGHsZ8ObSXyenIdjXNe6MXYuHXFIaaxPcOgkGP+J7jS3dhw1inuq6s3FTwzmTzr/ma7
         qqr/gubL7RtLdPrZdX6CRV2PKq2fqB8cUbKdGmfmcz0dnmhOxYe4el4goprD3Ez5ldpw
         OKvg==
Content-Disposition: inline
In-Reply-To: <20130408144750.GK17178@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Mon 08-04-13 16:47:50, Michal Hocko wrote:
> On Mon 08-04-13 16:20:11, Li Zefan wrote:
> [...]
> > @@ -5299,6 +5300,26 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
> >  	return css ? css : ERR_PTR(-ENOENT);
> >  }
> >  
> > +/**
> > + * cgroup_is_ancestor - test "root" cgroup is an ancestor of "child"
> > + * @child: the cgroup to be tested.
> > + * @root: the cgroup supposed to be an ancestor of the child.
> > + *
> > + * Returns true if "root" is an ancestor of "child" in its hierarchy.
> > + */
> > +bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root)
> > +{
> > +	int depth = child->depth;
> 
> Is this functionality helpful for other controllers but memcg?
> css_is_ancestor is currently used only by memcg code AFAICS and we can
> get the same functionality easily by using something like:

And as it turned out using css_is_ancestor is not correct. Here
is a patch to fix the issue. I will leave the decision whether
cgroup_is_ancestor makes sense even without users to you.
Would you be willing to take this into your current series so that we to
not clash over that code?
---
From 684e90bf2fcd5e0f376a3c7bb0176c1267add7df Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 8 Apr 2013 19:46:34 +0200
Subject: [PATCH] memcg: fix __mem_cgroup_same_or_subtree

__mem_cgroup_same_or_subtree relies on css_is_ancestor if hierarchy is
enabled for ages. This, however, is not correct because use_hierarchy
doesn't need to be true all the way up the cgroup hierarchy. Consider
the following example:
root (use_hierarchy=0)
 \
  A (use_hierarchy=0)
   \
    B (use_hierarchy=1)
     \
      C (use_hierarchy=1)

__mem_cgroup_same_or_subtree(A, C) would return true even though C is
not from the same hierarchy subtree. The bug shouldn't be critical but
at least dump_tasks might print unrelated tasks (via
task_in_mem_cgroup).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f608546..177bec2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1470,9 +1470,12 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy || !memcg)
+	if (!memcg)
 		return false;
-	return css_is_ancestor(&memcg->css, &root_memcg->css);
+	while ((memcg = parent_mem_cgroup(memcg)))
+		if (memcg == root_memcg)
+			return true;
+	return false;
 }
 
 static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
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
