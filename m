From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Tue, 26 Sep 2017 14:04:41 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709261340150.103010@chino.kir.corp.google.com>
References: <20170913215607.GA19259@castle> <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz> <20170914160548.GA30441@castle> <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz> <20170915152301.GA29379@castle> <20170918061405.pcrf5vauvul4c2nr@dhcp22.suse.cz>
 <20170920215341.GA5382@castle> <20170925122400.4e7jh5zmuzvbggpe@dhcp22.suse.cz> <20170925170004.GA22704@cmpxchg.org> <alpine.DEB.2.10.1709251510430.15961@chino.kir.corp.google.com> <20170926084602.sloinq7gdoyxo23y@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YwlzvIklwZuZiB/SCmEZ8rM53Ieo/haXcGiLoZeDaQs=;
        b=S7Bdj2BrQp8S0SGQtD6xEkzIxX5JDTHwSYL0gyTIfwXfitJeP7uX15Vqf3cEtQSjbK
         7CiS4sToDFUSkI5EGnAV11V+DCWt1iJWM+yDPloSeM9QMFYVFXAogxMdxxDKBG64ol2u
         sJFkDL1flMrmYFHP7/2JxuCfkElH3cRA50cacSQuYG3bst8scBIrHntDLyonrr9vmuFQ
         hxm4vHlX9hCqHAIWIfselsEJhFg4SCWylLe8x1Df9ASDeRWYCcViuH1lweYsZbE8IPeh
         KTIWb3hKhlq8leuIBBSrNFZ9OrLGwsvhU9Fg4exmBhlHQ/PVUiNUW0C+2exZozCuXHtg
         33xA==
In-Reply-To: <20170926084602.sloinq7gdoyxo23y@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 26 Sep 2017, Michal Hocko wrote:

> > No, I agree that we shouldn't compare sibling memory cgroups based on 
> > different criteria depending on whether group_oom is set or not.
> > 
> > I think it would be better to compare siblings based on the same criteria 
> > independent of group_oom if the user has mounted the hierarchy with the 
> > new mode (I think we all agree that the mount option is needed).  It's 
> > very easy to describe to the user and the selection is simple to 
> > understand. 
> 
> I disagree. Just take the most simplistic example when cgroups reflect
> some other higher level organization - e.g. school with teachers,
> students and admins as the top level cgroups to control the proper cpu
> share load. Now you want to have a fair OOM selection between different
> entities. Do you consider selecting students all the time as an expected
> behavior just because their are the largest group? This just doesn't
> make any sense to me.
> 

Are you referring to this?

	root
       /    \
students    admins
/      \    /    \
A      B    C    D

If the cumulative usage of all students exceeds the cumulative usage of 
all admins, yes, the choice is to kill from the /students tree.  This has 
been Roman's design from the very beginning.  If the preference is to kill 
the single largest process, which may be attached to either subtree, you 
would not have opted-in to the new heuristic.

> > Then, once a cgroup has been chosen as the victim cgroup, 
> > kill the process with the highest badness, allowing the user to influence 
> > that with /proc/pid/oom_score_adj just as today, if group_oom is disabled; 
> > otherwise, kill all eligible processes if enabled.
> 
> And now, what should be the semantic of group_oom on an intermediate
> (non-leaf) memcg? Why should we compare it to other killable entities?
> Roman was mentioning a setup where a _single_ workload consists of a
> deeper hierarchy which has to be shut down at once. It absolutely makes
> sense to consider the cumulative memory of that hierarchy when we are
> going to kill it all.
> 

If group_oom is enabled on an intermediate memcg, I think the intuitive 
way to handle it would be that all descendants are also implicitly or 
explicitly group_oom.  It is compared to sibling cgroups based on 
cumulative usage at the time of oom and the largest is chosen and 
iterated.  The point is to separate out the selection heuristic (policy) 
from group_oom (mechanism) so that we don't bias or prefer subtrees based 
on group_oom, which makes this much more complex.

> But what you are proposing is something different from oom_score_adj.
> That only sets bias to the killable entities while priorities on
> intermediate non-killable memcgs controls how the whole oom hierarchy
> is traversed. So a non-killable intermediate memcg can hugely influence
> what gets killed in the end.

Why is there an intermediate non-killable memcg allowed?  Cgroup oom 
priorities should not be allowed to disable oom killing, it should only 
set a priority.  The only reason an intermediate cgroup should be 
non-killable is if there are no processes attached, but I don't think 
anyone is arguing we should just do nothing in that scenario.  The point 
is that the user has infleunce over the decisionmaking with a per-process 
heuristic with oom_score_adj and should also have influence over the 
decisionmaking with a per-cgroup heuristic.

> This is IMHO a tricky and I would even dare
> to claim a wrong semantic. I can see priorities being very useful on
> killable entities for sure. I am not entirely sure what would be the
> best approach yet and that is why I've suggested that to postpone to
> after we settle with a simple approach first. Bringing priorities back
> to the discussion again will not help to move that forward I am afraid.
> 

I agree to keep it as simple as possible, especially since some users want 
specific victim selection, it should be clear to document, and it 
shouldn't be influenced by some excessive amount of usage in another 
subtree the user has no control over (/admins over /students) to prevent 
the user from defining that it really wants to be the first oom victim or 
the admin from defining it really prefers something else killed first.

My suggestion is that Roman's implementation is clear, well defined, and 
has real-world usecases and it should be the direction that this moves in.  
I think victim selection and group_oom are distinct and should not 
influence the decisionmaking.  I think that oom_priority should influence 
the decisionmaking.

When mounted with the new option, as the oom hierarchy is iterated, 
compare all sibling cgroups regarding cumulative size unless an oom 
priority overrides that (either user specifying it wants to be oom killed 
or admin specifying it prefers something else).  When a victim memcg is 
chosen, use group_oom to determine what should be killed, otherwise choose 
by oom_score_adj.  I can't imagine how this can be any simpler.
