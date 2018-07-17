From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Mon, 16 Jul 2018 20:59:29 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1807162053190.157949@chino.kir.corp.google.com>
References: <20171130152824.1591-1-guro@fb.com> <20180605114729.GB19202@dhcp22.suse.cz> <alpine.DEB.2.21.1807131438380.194789@chino.kir.corp.google.com> <20180716093630.GJ17280@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=jHrn07gzUHpPm2gCNFENX79CHktkBI6qepWDsVP0Uus=;
        b=XoPJvAq+l///furXh85SaohAqcdI78JfNcRHBgsKmPsXPUbpxyI+x3AAxYNwBA1AJs
         tvRatX9Kb8QbqcQKXZr/+J31ePgM+9ge+yJvTqQcN31AI2Dk8yBgeWUcMykpaB8hqeje
         C1uGNlJ/Z/SAT5CLwddSvb4ucdXjdYucR9+x/ssV4VSUY0CiVf3hEWrUoLUMJbKyddj1
         ulc45SpFASY+c9J4DcUABAcpl52kdalJXtugAivpZVY+ohh5JJsbA1C3R7h85cf5B0SL
         5F3OkkpwdHocoZ26+amAybJzyr7HsaiZV0iTNJiQtARQ/TAjcuxQh7ZUOC0cIkFHuBZX
         fCeg==
In-Reply-To: <20180716093630.GJ17280@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, 16 Jul 2018, Michal Hocko wrote:

> Well, I didn't really get to your patches yet. The last time I've
> checked I had some pretty serious concerns about the consistency of your
> proposal. Those might have been fixed in the lastest version of your
> patchset I haven't seen. But I still strongly suspect that you are
> largerly underestimating the complexity of more generic oom policies
> which you are heading to.
> 

I don't believe it's underestimated since it's used.  It's perfectly valid 
the lock an entire hierarchy or individual subtrees into a single policy 
if that's what is preferred.  Any use of a different policy at a subtree 
root is a conscious decision made by the owner of that subtree.  If they 
prefer to kill the largest process, the largest descendant cgroup, or the 
largest subtree, it is up to them.  All three have valid usecases, the 
goal is not to lock the entire hierarchy into a single policy: this 
introduces the ability for users to subvert the selection policy either 
intentionally or unintentionally because they are using a unified single 
hierarchy with cgroup v2 and they are using controllers other than mem 
cgroup.

> Considering user API failures from the past (oom_*adj fiasco for
> example) suggests that we should start with smaller steps and only
> provide a clear and simple API. oom_group is such a simple and
> semantically consistent thing which is the reason I am OK with it much
> more than your "we can be more generic" approach. I simply do not trust
> we can agree on sane and consistent api in a reasonable time.
> 
> And it is quite mind boggling that a simpler approach has been basically
> blocked for months because there are some concerns for workloads which
> are not really asking for the feature. Sure your usecase might need to
> handle root memcg differently. That is a fair point but that shouldn't
> really block containers users who can use the proposed solution without
> any further changes. If we ever decide to handle root memcg differently
> we are free to do so because the oom selection policy is not carved in
> stone by any api.
>  

Please respond directly to the patchset which clearly enumerates the 
problems with the current implementation in -mm.
