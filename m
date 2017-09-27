From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Wed, 27 Sep 2017 10:57:56 +0100
Message-ID: <20170927095756.GA4159@castle>
References: <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
 <20170915152301.GA29379@castle>
 <20170918061405.pcrf5vauvul4c2nr@dhcp22.suse.cz>
 <20170920215341.GA5382@castle>
 <20170925122400.4e7jh5zmuzvbggpe@dhcp22.suse.cz>
 <20170925170004.GA22704@cmpxchg.org>
 <alpine.DEB.2.10.1709251510430.15961@chino.kir.corp.google.com>
 <20170926084602.sloinq7gdoyxo23y@dhcp22.suse.cz>
 <alpine.DEB.2.10.1709261340150.103010@chino.kir.corp.google.com>
 <20170927073744.5g7dq5c5spmtgz5g@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=/llvobH4WOJuV9hcnopWhkRYJI1ropq84HZw4IbLLWw=;
 b=AggWVH0PsUxVJ5gPH/6ustI3svwKYwvszahhdyMlXWR29z0K7oqimd0tdG9B6ySKwM5I
 /dICriHSOOCrqnu8t5p13c7QyhmCAUT5h9S3dam7R3dx/G/ZgLu5OPc8u72xblNJxUzf
 UcUx+y79/mo8YEtbFZdIotGPW9fzjkf9FuE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/llvobH4WOJuV9hcnopWhkRYJI1ropq84HZw4IbLLWw=;
 b=IgaDmWhNkaD7Z41Hj4mB3dmniWtja73nB7TNygf5AavLMElA/8M+jcLRlV4UbCHn62bWQ717D5HcyVgeEwWPythhMxK2C4aSUBQncrTdTv5QMHacnDHsQJKX+Gpd/WYZMZAe3WctDCqIfdNG6qYxhazxu8wFq9nV+DXMMxO7tSY=
Content-Disposition: inline
In-Reply-To: <20170927073744.5g7dq5c5spmtgz5g@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 27, 2017 at 09:37:44AM +0200, Michal Hocko wrote:
> On Tue 26-09-17 14:04:41, David Rientjes wrote:
> > On Tue, 26 Sep 2017, Michal Hocko wrote:
> > 
> > > > No, I agree that we shouldn't compare sibling memory cgroups based on 
> > > > different criteria depending on whether group_oom is set or not.
> > > > 
> > > > I think it would be better to compare siblings based on the same criteria 
> > > > independent of group_oom if the user has mounted the hierarchy with the 
> > > > new mode (I think we all agree that the mount option is needed).  It's 
> > > > very easy to describe to the user and the selection is simple to 
> > > > understand. 
> > > 
> > > I disagree. Just take the most simplistic example when cgroups reflect
> > > some other higher level organization - e.g. school with teachers,
> > > students and admins as the top level cgroups to control the proper cpu
> > > share load. Now you want to have a fair OOM selection between different
> > > entities. Do you consider selecting students all the time as an expected
> > > behavior just because their are the largest group? This just doesn't
> > > make any sense to me.
> > > 
> > 
> > Are you referring to this?
> > 
> > 	root
> >        /    \
> > students    admins
> > /      \    /    \
> > A      B    C    D
> > 
> > If the cumulative usage of all students exceeds the cumulative usage of 
> > all admins, yes, the choice is to kill from the /students tree.
> 
> Which is wrong IMHO because the number of stutends is likely much more
> larger than admins (or teachers) yet it might be the admins one to run
> away. This example simply shows how comparing siblinks highly depends
> on the way you organize the hierarchy rather than the actual memory
> consumer runaways which is the primary goal of the OOM killer to handle.
> 
> > This has been Roman's design from the very beginning.
> 
> I suspect this was the case because deeper hierarchies for
> organizational purposes haven't been considered.
> 
> > If the preference is to kill 
> > the single largest process, which may be attached to either subtree, you 
> > would not have opted-in to the new heuristic.
> 
> I believe you are making a wrong assumption here. The container cleanup
> is sound reason to opt in and deeper hierarchies are simply required in
> the cgroup v2 world where you do not have separate hierarchies.
>  
> > > > Then, once a cgroup has been chosen as the victim cgroup, 
> > > > kill the process with the highest badness, allowing the user to influence 
> > > > that with /proc/pid/oom_score_adj just as today, if group_oom is disabled; 
> > > > otherwise, kill all eligible processes if enabled.
> > > 
> > > And now, what should be the semantic of group_oom on an intermediate
> > > (non-leaf) memcg? Why should we compare it to other killable entities?
> > > Roman was mentioning a setup where a _single_ workload consists of a
> > > deeper hierarchy which has to be shut down at once. It absolutely makes
> > > sense to consider the cumulative memory of that hierarchy when we are
> > > going to kill it all.
> > > 
> > 
> > If group_oom is enabled on an intermediate memcg, I think the intuitive 
> > way to handle it would be that all descendants are also implicitly or 
> > explicitly group_oom.
> 
> This is an interesting point. I would tend to agree here. If somebody
> requires all-in clean up up the hierarchy it feels strange that a
> subtree would disagree (e.g. during memcg oom on the subtree). I can
> hardly see a usecase that would really need a different group_oom policy
> depending on where in the hierarchy the oom happened to be honest.
> Roman?

Yes, I'd say that it's strange to apply settings from outside the OOMing
cgroup to the subtree, but actually it's not. The oom_group setting should
basically mean that the OOM killer will not kill a random task in the subtree.
And it doesn't matter if it was global or memcg-wide OOM.

Applied to v9. Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
