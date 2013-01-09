From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Date: Thu, 10 Jan 2013 01:27:07 +0400
Message-ID: <50EDE0AB.1030509@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-12-git-send-email-glommer@parallels.com> <20130109124220.ad9f1a54.akpm@linux-foundation.org> <50EDDCAA.6070004@parallels.com> <20130109131705.4156ba5c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130109131705.4156ba5c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>

On 01/10/2013 01:17 AM, Andrew Morton wrote:
> On Thu, 10 Jan 2013 01:10:02 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> The main advantage I see in this approach, is that there is way less
>> data to be written using a header. Although your way works, it means we
>> will write the strings "nice", "system", etc. #cpu times. Quite a waste.
> 
> Yes, overhead can be a significant issue with this type of interface. 
> But we already incurred a massive overhead by using a human-readable
> ascii interface.  If performance is an issue, perhaps the whole thing
> should be grafted onto taskstats instead.  Or create a new
> taskstats-like thing.

I think this would be a little alienish in the already alien world of
cgroups.

However, I was not so much talking about plain performance overhead as
measurable in miliseconds-to-parse, but rather just alluding to the fact
that we would be writing the same set of strings multiple times when a
header would do just fine.

This is the same method used for instance by slabinfo.

> 
> btw, a more typical interface would be
> 
> cat /.../cpu0
> nice:nn
> system:nn
> irq:nn
> 

Well, yes. But welcome to cgroups: directories have a meaning, so the
only way to organize stuff is with plain files in the current hierarchy
is by filling it with files. As many files as we have cpus.

At this point you are certain to miss all the other files present in the
directory.


> - the traditional one-per-line name:value tuples.  But I'd assumed that
> having a file per CPU would be aawkward.
> 
Indeed.
