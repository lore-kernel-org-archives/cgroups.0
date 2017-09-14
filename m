From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Thu, 14 Sep 2017 13:07:32 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709141257400.91150@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz> <alpine.DEB.2.10.1709131340020.146292@chino.kir.corp.google.com>
 <20170914133407.e7gstxssq6j5lo25@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YDt7ZEktO1M8BroccR7SehUM9goDsFJR/otOsTL2dw4=;
        b=hhHZkUJYUBL8wvrkLOd7yD1l5AfAfMFm/x7CfsdhgwlV/z/3gbU4Dy0+ojNglpdwW3
         19EzEGis1+ckCiliF6GQpKoMxk/gJX7WWPcM7EN5ezXkPQ5rJZxmQnYrxEjxKhQChslY
         4ghxSoAFpOGHvyyLG9Bo5XjSoc81+/S4W7otTRV+aQxgj0Q/zrGSckObasV2F47C1HIK
         pr3p69dqYvsqzDx3XAYVGZRkH6sb2SFprQDiI+kZPZWRj4OANweDegSjp4V40zziL6NA
         HjXJpmwnR6YCVHDsld4wIx/as3IXNRjvLAqO5eE/+kjy8+KNNvkFuSmhG62k5tgZIAsy
         yY2g==
In-Reply-To: <20170914133407.e7gstxssq6j5lo25@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 14 Sep 2017, Michal Hocko wrote:

> > It is certainly possible to add oom priorities on top before it is merged, 
> > but I don't see why it isn't part of the patchset.
> 
> Because the semantic of the priority for non-leaf memcgs is not fully
> clear and I would rather have the core of the functionality merged
> before this is sorted out.
> 

We can't merge the core of the feature before this is sorted out because 
then users start to depend on behavior and we must be backwards 
compatible.  We need a full patchset that introduces the new selection 
heuristic and a way for userspace to control it to either bias or prefer 
one cgroup over another.  The kill-all mechanism is a more orthogonal 
feature for the cgroup-aware oom killer than oom priorities.

I have a usecase for both the cgroup-aware oom killer and its oom 
priorities from previous versions of this patchset, I assume that Roman 
does as well, and would like to see it merged bacause there are real-world 
usecases for it rather than hypothetical usecases that would want to do 
something different.

> > We need it before its 
> > merged to avoid users playing with /proc/pid/oom_score_adj to prevent any 
> > killing in the most preferable memcg when they could have simply changed 
> > the oom priority.
> 
> I am sorry but I do not really understand your concern. Are you
> suggesting that users would start oom disable all tasks in a memcg to
> give it a higher priority? Even if that was the case why should such an
> abuse be a blocker for generic memcg aware oom killer being merged?

If users do not have any way to control victim selection because of a 
shortcoming in the kernel implementation, they will be required to oom 
disable processes and let that be inherited by children they fork in the 
memcg hierarchy to protect cgroups that they do not want to be oom killed, 
regardless of their size.  They simply are left with no other alternative 
if they want to use the cgroup-aware oom killer and/or the kill-all 
mechanism.
