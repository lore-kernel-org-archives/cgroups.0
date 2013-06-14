From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Fri, 14 Jun 2013 09:56:10 +0900
Message-ID: <51BA6A2A.3060107@jp.fujitsu.com>
References: <20130603193147.GC23659@dhcp22.suse.cz> <alpine.DEB.2.02.1306031411380.22083@chino.kir.corp.google.com> <20130604095514.GC31242@dhcp22.suse.cz> <alpine.DEB.2.02.1306042329320.20610@chino.kir.corp.google.com> <20130605093937.GK15997@dhcp22.suse.cz> <alpine.DEB.2.02.1306051657001.29626@chino.kir.corp.google.com> <20130610142321.GE5138@dhcp22.suse.cz> <alpine.DEB.2.02.1306111321360.32688@chino.kir.corp.google.com> <20130612202348.GA17282@dhcp22.suse.cz> <alpine.DEB.2.02.1306121408490.24902@chino.kir.corp.google.com> <20130613151602.GG23070@dhcp22.suse.cz> <alpine.DEB.2.02.1306131508300.8686@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.02.1306131508300.8686@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

(2013/06/14 7:25), David Rientjes wrote:
> On Thu, 13 Jun 2013, Michal Hocko wrote:
>
>>> That's not at all the objective, the changelog quite explicitly states
>>> this is a deadlock as the result of userspace having disabled the oom
>>> killer so that its userspace oom handler can resolve the condition and it
>>> being unresponsive or unable to perform its job.
>>
>> Ohh, so another round. Sigh. You insist on having user space handlers
>> running in the context of the limited group. OK, I can understand your
>> use case, although I think it is pushing the limits of the interface and
>> it is dangerous.
>
> Ok, this is where our misunderstanding is, and I can see why you have
> reacted the way you have.  It's my fault for not describing where we're
> going with this.
>

Reading your discussion, I think I understand your requirements.
The problem is that I can't think you took into all options into
accounts and found the best way is this new oom_delay. IOW, I can't
convice oom-delay is the best way to handle your issue.

Your requeirement is
  - Allowing userland oom-handler within local memcg.

Considering straightforward, the answer should be
  - Allowing oom-handler daemon out of memcg's control by its limit.
    (For example, a flag/capability for a task can archive this.)
    Or attaching some *fixed* resource to the task rather than cgroup.

    Allow to set task->secret_saving=20M.


Going back to your patch, what's confusing is your approach.
Why the problem caused by the amount of memory should be solved by
some dealy, i.e. the amount of time ?

This exchanging sounds confusing to me.

I'm not against what you finally want to do, but I don't like the fix.

Thanks,
-Kame





--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
