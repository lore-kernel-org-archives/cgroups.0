From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Date: Thu, 8 Nov 2012 09:15:32 -0800
Message-ID: <20121108171532.GI12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
 <20121108095013.GA31821@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=T/x/QLUY42d8ekz9YEkY3vj/WBgF0ZVomtgFdbkEOa8=;
        b=JUi7OjpV6BUFewBq7DJxHB1Eq5h/RQcDRV+M6fp94CFlZiAt3tjNLPtBoGlINUBav0
         lxG0j8SiNXmgjF43630hZY6LYPftBUIrI+v3TWsPtv/iY3P0Rm58nbiXYXErh4aThX6N
         9Glyh9EhmAg1u/21c02MdJ8lc4ZQPKT4h/lp03pQH+Xl5bZOD8k3RJRNAUFHjNGZ+zrc
         CNrHvzGL/rZHvyml2VC8Ou6poDuycKfCJoWMLJ+qWJem1KVCA0HmIsMebVBQwwPNXhxF
         Fz8mTdZ7o1z7Zl6bMeT7YJW4xM5EdewyR33zNl/4qEKyBdC3n1vYuXKda0AxY6BxD3CM
         lbDA==
Content-Disposition: inline
In-Reply-To: <20121108095013.GA31821@dhcp22.suse.cz>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

Hey, Michal.

On Thu, Nov 08, 2012 at 10:50:13AM +0100, Michal Hocko wrote:
> On Sat 03-11-12 01:38:29, Tejun Heo wrote:
> > Currently, cgroup doesn't provide any generic helper for walking a
> > given cgroup's children or descendants.  This patch adds the following
> > three macros.
> > 
> > * cgroup_for_each_child() - walk immediate children of a cgroup.
> > 
> > * cgroup_for_each_descendant_pre() - visit all descendants of a cgroup
> >   in pre-order tree traversal.
> > 
> > * cgroup_for_each_descendant_post() - visit all descendants of a
> >   cgroup in post-order tree traversal.
> > 
> > All three only require the user to hold RCU read lock during
> > traversal.  Verifying that each iterated cgroup is online is the
> > responsibility of the user.  When used with proper synchronization,
> > cgroup_for_each_descendant_pre() can be used to propagate config
> > updates to descendants in reliable way.  See comments for details.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> I will convert mem_cgroup_iter to use this rather than css_get_next
> after this gets into the next tree so that it can fly via Andrew.
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 
> Just a minor knit. You are talking about a config propagation while I
> would consider state propagation more clear and less confusing. Config
> is usually stable enough so that post_create is not necessary for
> syncing (e.g. memcg.swappiness). It is a state which must be consistent
> throughout the hierarchy which matters here.

Did s/config/state/g

Thanks.

-- 
tejun
