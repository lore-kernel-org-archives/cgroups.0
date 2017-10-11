From: David Rientjes <rientjes@google.com>
Subject: Re: [v11 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 11 Oct 2017 13:27:44 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710111323380.98307@chino.kir.corp.google.com>
References: <20171005130454.5590-1-guro@fb.com> <20171005130454.5590-4-guro@fb.com> <alpine.DEB.2.10.1710091414260.59643@chino.kir.corp.google.com> <20171010122306.GA11653@castle.DHCP.thefacebook.com> <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
 <20171011130815.qjw7jfnnqz3gpn4s@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=1lT8LIfgOBIiz0Ey6jeJ3kPAdOUPRrJ7DRlRoilJmzI=;
        b=ug8JtvScN+AT/nT+tDRTdgeii05VHbNjzRVsPdT6irms7kvoOF23AZ48So8Ts1GhJe
         RQvzZ9gQximOUuLXYFvfQnAldcZw1+1pr3rIf1LWnBLTaElCwO2G08altpU4KITVG08W
         4jJSSbE+A0WCzgyrbP6Z6bPcdDqNnUWFCSt17EdMfShKWV4p1qboPjwb7uAetADVP9Wi
         upyL/jvEqJvR4SNbrKL7IC3y88Y2nfjSF/2OlnWhPri/REV9xPFApdZAknjUGgLa/A//
         +jqtaZCquuo421k9jDGPVXO2q87xKiyDk+M8wsYxZFkcCzl2bI7tWGQoprkia5AGg86i
         Do7w==
In-Reply-To: <20171011130815.qjw7jfnnqz3gpn4s@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 11 Oct 2017, Michal Hocko wrote:

> > For these reasons: unfair comparison of root mem cgroup usage to bias 
> > against that mem cgroup from oom kill in system oom conditions, the 
> > ability of users to completely evade the oom killer by attaching all 
> > processes to child cgroups either purposefully or unpurposefully, and the 
> > inability of userspace to effectively control oom victim selection:
> > 
> > Nacked-by: David Rientjes <rientjes@google.com>
> 
> I consider this NACK rather dubious. Evading the heuristic as you
> describe requires root privileges in default configuration because
> normal users are not allowed to create subtrees. If you
> really want to delegate subtree to an untrusted entity then you do not
> have to opt-in for this oom strategy. We can work on an additional means
> which would allow to cover those as well (e.g. priority based one which
> is requested for other usecases).
> 

You're missing the point that the user is trusted and it may be doing 
something to circumvent oom kill unknowingly.  With a single unified 
hierarchy, the user is forced to attach its processes to subcontainers if 
it wants to constrain resources with other controllers.  Doing so ends up 
completely avoiding oom kill because of this implementation detail.  It 
has nothing to do with trust and the admin who is opting-in will not know 
a user has cirumvented oom kill purely because it constrains its processes 
with controllers other than the memory controller.

> A similar argument applies to the root memcg evaluation. While the
> proposed behavior is not optimal it would work for general usecase
> described here where the root memcg doesn't really run any large number
> of tasks. If somebody who explicitly opts-in for the new strategy and it
> doesn't work well for that usecase we can enhance the behavior. That
> alone is not a reason to nack the whole thing.
> 
> I find it really disturbing that you keep nacking this approach just
> because it doesn't suite your specific usecase while it doesn't break
> it. Moreover it has been stated several times already that future
> improvements are possible and cover what you have described already.

This has nothing to do with my specific usecase.
