From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Wed, 27 Jun 2012 12:57:12 +0400
Message-ID: <4FEACAE8.6000500@parallels.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com> <1340725634-9017-3-git-send-email-glommer@parallels.com> <20120626180451.GP3869@google.com> <20120626185542.GE27816@cmpxchg.org> <20120626191450.GT3869@google.com> <20120626205924.GH27816@cmpxchg.org> <20120626211907.GX3869@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120626211907.GX3869@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>

>>    And because there is nothing to gain, it is in addition really
>>    trivial to fix the insane setups by simply undoing the nesting,
>>    there is no downside for them.
>
> I have to disagree with that.  Deployment sometimes can be very
> painful.  In some cases, even flipping single parameter in sysfs
> depending on kernel version takes considerable effort.  The behavior
> has been the contract that we offered userland for quite some time
> now.  We shouldn't be changing that underneath them without any clear
> way for them to notice it.

Yes, and that's why once you deploy, you keep your updates to a minimum. 
Because hell, even *perfectly legitimate bug fixes* can change your 
behavior in a way you don't want. And you don't expect people to refrain 
from fixing bugs because of that.

>
>> The only point where I agree with you is that it may indeed be
>> non-obvious to detect in case you were relying on the filesystem
>> hierarchy not being reflected in the controller hierarchy.  But even
>> that depends on the usecase, whether it's a subtle performance
>> regression or a total failure to execute a previously supported
>> workload, which would be pretty damn obvious.
>
> And imagine that happening in serveral thousand machine cluster with
> fairly complicated cgroup setup and kernel update rolling out for
> subset of machine types.  I would be screaming bloody murder.


That is precisely why people in serious environments tend to run 
-stable, distro LTSes, or anything like that. Because they don't want 
any change, however minor, to potentially affect their stamped behavior. 
I am not proposing this patch to -stable, btw...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
