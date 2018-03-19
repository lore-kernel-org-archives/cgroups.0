From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 2/2] cpuset: Add cpuset.flags control knob to v2
Date: Mon, 19 Mar 2018 12:33:14 -0400
Message-ID: <8e553b7e-cab6-1b5d-9110-cc5770ae16c4@redhat.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-3-git-send-email-longman@redhat.com>
 <20180319162654.GR2943022@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180319162654.GR2943022@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/19/2018 12:26 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Mar 15, 2018 at 05:20:42PM -0400, Waiman Long wrote:
>> +	The currently supported flag is:
>> +
>> +	  sched_load_balance
>> +		When it is not set, there will be no load balancing
>> +		among CPUs on this cpuset.  Tasks will stay in the
>> +		CPUs they are running on and will not be moved to
>> +		other CPUs.
>> +
>> +		When it is set, tasks within this cpuset will be
>> +		load-balanced by the kernel scheduler.  Tasks will be
>> +		moved from CPUs with high load to other CPUs within
>> +		the same cpuset with less load periodically.
> Hmm... looks like this is something which can be decided by the cgroup
> itself and should be made delegatable.  Given that different flags
> might need different delegation settings and the precedence of
> memory.oom_group, I think it'd be better to make the flags separate
> bool files - ie. cpuset.sched_load_balance which contains 0/1 and
> marked delegatable.
>
> Thanks.
>
Sure. Will do that.

-Longman

