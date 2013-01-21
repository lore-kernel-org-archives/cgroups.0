From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Date: Mon, 21 Jan 2013 16:14:27 +0400
Message-ID: <50FD3123.6090003@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Colin Cross <ccross@google.com>
Cc: cgroups@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>

On 01/16/2013 04:33 AM, Colin Cross wrote:
> On Wed, Jan 9, 2013 at 3:45 AM, Glauber Costa <glommer@parallels.com> wrote:
>> [ update: I thought I posted this already before leaving for holidays. However,
>>   now that I am checking for replies, I can't find nor replies nor the original
>>   mail in my boxes or archives. I am posting again for safety sake, but sorry
>>   you are getting this twice by any chance ]
>>
>> Hi all,
>>
>> This is an attempt to provide userspace with enough information to reconstruct
>> per-container version of files like "/proc/stat". In particular, we are
>> interested in knowing the per-cgroup slices of user time, system time, wait
>> time, number of processes, and a variety of statistics.
>>
>> This task is made more complicated by the fact that multiple controllers are
>> involved in collecting those statistics: cpu and cpuacct. So the first thing I
>> am doing here, is ressurecting Tejun's patches that aim at deprecating cpuacct.
>>
>> This is one of the major differences from earlier attempts: all data is provided
>> by the cpu controller, resulting in greater simplicity.
> 
> Android userspace is currently using both cpu and cpuacct, and not
> co-mounting them.  They are used for fundamentally different uses such
> that creating a single hierarchy for both of them while maintaining
> the existing behavior is not possible.
> 
> We use the cpu cgroup primarily as a priority container.  A simple
> view is that each thread is assigned to a foreground cgroup when it is
> user-visible, and a background cgroup when it is not.  The foreground
> cgroup is assigned a significantly higher cpu.shares value such that
> when each group is fully loaded the background group will get 5% and
> the foreground group will get 95%.
> 
> We use the cpuacct cgroup to measure cpu usage per uid, primarily to
> estimate one cause of battery usage.  Each uid gets a cgroup, and when
> spawning a task for a new uid we put it in the appropriate cgroup.

As we are all in a way sons of Linus the Great, the fact that you have
this usecase should be by itself a reason for us not to deprecate it.

I still view this, however, as a not common use case. And from the
scheduler PoV, we still have all the duplicate hierarchy walks. So
assuming we would carry on all the changes in this patchset, except the
deprecation, would it be okay for you?

This way we could take steps to make sure the scheduler codepaths for
cpuacct are not taking during normal comounted operation, and you could
still have your setup unchanged.

Tejun, any words here?
