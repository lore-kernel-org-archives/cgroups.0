From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Date: Wed, 23 Jan 2013 18:26:48 +0400
Message-ID: <50FFF328.9070200@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-12-git-send-email-glommer@parallels.com> <20130109124220.ad9f1a54.akpm@linux-foundation.org> <50EDDCAA.6070004@parallels.com> <20130109131705.4156ba5c.akpm@linux-foundation.org> <50EDE0AB.1030509@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50EDE0AB.1030509-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 01/10/2013 01:27 AM, Glauber Costa wrote:
> On 01/10/2013 01:17 AM, Andrew Morton wrote:
>> On Thu, 10 Jan 2013 01:10:02 +0400
>> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>>
>>> The main advantage I see in this approach, is that there is way less
>>> data to be written using a header. Although your way works, it means we
>>> will write the strings "nice", "system", etc. #cpu times. Quite a waste.
>>
>> Yes, overhead can be a significant issue with this type of interface. 
>> But we already incurred a massive overhead by using a human-readable
>> ascii interface.  If performance is an issue, perhaps the whole thing
>> should be grafted onto taskstats instead.  Or create a new
>> taskstats-like thing.
> 
> I think this would be a little alienish in the already alien world of
> cgroups.
> 
> However, I was not so much talking about plain performance overhead as
> measurable in miliseconds-to-parse, but rather just alluding to the fact
> that we would be writing the same set of strings multiple times when a
> header would do just fine.
> 
> This is the same method used for instance by slabinfo.
> 
>>
>> btw, a more typical interface would be
>>
>> cat /.../cpu0
>> nice:nn
>> system:nn
>> irq:nn
>>
> 
> Well, yes. But welcome to cgroups: directories have a meaning, so the
> only way to organize stuff is with plain files in the current hierarchy
> is by filling it with files. As many files as we have cpus.
> 
> At this point you are certain to miss all the other files present in the
> directory.
> 
> 
>> - the traditional one-per-line name:value tuples.  But I'd assumed that
>> having a file per CPU would be aawkward.
>>
> Indeed.
> 

Andrew,

Given my arguments above, which interface would you prefer for me to
settle down? I still don't see any problems with the header, specially
given the fact that it exists precisely to allow fields to come and go
if needed.

