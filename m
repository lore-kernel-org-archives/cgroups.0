From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 22:22:04 +0400
Message-ID: <4FE9FDCC.80000@parallels.com>
References: <1340717428-9009-1-git-send-email-glommer@parallels.com> <20120626181209.GR3869@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120626181209.GR3869-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 06/26/2012 10:12 PM, Tejun Heo wrote:
> On Tue, Jun 26, 2012 at 05:30:28PM +0400, Glauber Costa wrote:
>> Okay, so after recent discussions, I am proposing the following
>> patch. It won't remove hierarchy, or anything like that. Just default
>> to true in the root cgroup, and print a warning once if you try
>> to set it back to 0.
>>
>> I am not adding it to feature-removal-schedule.txt because I don't
>> view it as a consensus. Rather, changing the default would allow us
>> to give it a time around in the open, and see if people complain
>> and what we can learn about that.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Just in case it wasn't clear in the other posting.
>
>   Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> You can't change the default behavior silently.  Not in this scale.
>
> Thanks.
>
I certainly don't share your views of the matter here.

I would agree with you if we were changing a fundamental algorithm,
with no way to resort back to a default setup. We are not removing any
functionality whatsoever here.

I would agree with you if we were actually documenting explicitly
that this is an expected default behavior.

But we never made the claim that use_hierarchy would default to 0.

Well, we seldom make claims about default values of any tunables. We 
just expect them to be reasonable values, and we seem to agree that this 
is, indeed, reasonable.

I personally consider this even better than a mount option. It doesn't 
add or remove any new interface, since use_hierarchy was already there.

It doesn't change the behavior of any interface. What would happen for 
instance if I rely on a multitude of use_hierarchy = 0 and 1 and 
suddenly a mount option would override that?
