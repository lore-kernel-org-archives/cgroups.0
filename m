From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Date: Tue, 6 Nov 2012 12:31:54 -0800
Message-ID: <20121106203154.GV30069@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IqH6kxv3RKuZNwdbI1fOvbeTGBklY1wE9hCOzOv0aXI=;
        b=kL9eeveWeCQyQVTKZZ7cZR2jpyWbz0ZvOsJOLmYyk0u28SNPKxAundFZnaF5DzGF2j
         Q71BKRitaDcx1imQv7ZufOGmxd2EmcKkINdonW/sQ4rWWbac40wBpqdKnHcFVLMEOVZt
         tny1wZBr99Q6Ey2kCmkluR18a604IB2SJzur7aagCABo6vRdaNKfb5d1WIRQ9iy5jn0v
         vbvQqM/+NnqEfVtAWmBibPWcb3rJteYwrvF0+zD8c+mAuSVt4rSW2xSTYORhPd7kHqUB
         YKRo+AfKyYXK4j+mBXGHHQzKEMw6LE+fgXPKSXOyHnATWGLtQ2yaEfq/fH3HS8jJHPYc
         TK8Q==
Content-Disposition: inline
In-Reply-To: <1351931915-1701-4-git-send-email-tj@kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

On Sat, Nov 03, 2012 at 01:38:29AM -0700, Tejun Heo wrote:
> Currently, cgroup doesn't provide any generic helper for walking a
> given cgroup's children or descendants.  This patch adds the following
> three macros.
> 
> * cgroup_for_each_child() - walk immediate children of a cgroup.
> 
> * cgroup_for_each_descendant_pre() - visit all descendants of a cgroup
>   in pre-order tree traversal.
> 
> * cgroup_for_each_descendant_post() - visit all descendants of a
>   cgroup in post-order tree traversal.
> 
> All three only require the user to hold RCU read lock during
> traversal.  Verifying that each iterated cgroup is online is the
> responsibility of the user.  When used with proper synchronization,
> cgroup_for_each_descendant_pre() can be used to propagate config
> updates to descendants in reliable way.  See comments for details.

Michal, Li, how does this look to you?  Would this be okay for memcg
too?  Li, do you think the comment on cgroup_for_each_descendant_pre()
is correct?

Thanks.

-- 
tejun
