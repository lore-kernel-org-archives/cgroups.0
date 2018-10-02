From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v12 9/9] cpuset: Support forced turning off of partition
 flag
Date: Tue, 2 Oct 2018 16:44:22 -0400
Message-ID: <9d356cf9-0256-338c-0854-cf52c5d0f8fe@redhat.com>
References: <1535380884-31308-1-git-send-email-longman@redhat.com>
 <1535380884-31308-10-git-send-email-longman@redhat.com>
 <20180827164004.GE3978217@devbig004.ftw2.facebook.com>
 <0daf1f43-2292-0281-3ab8-aef20d0475dc@redhat.com>
 <20181002200627.GI270328@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002200627.GI270328@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 10/02/2018 04:06 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> My apologies for the delay.
>
> On Mon, Aug 27, 2018 at 01:50:18PM -0400, Waiman Long wrote:
>> My current code has explicitly assumed the following relationship for
>> partition root.
>>
>>     cpus_allowed = effective_cpus + reserved_cpus
>>
>> Also effective_cpus cannot be empty. Specifically, cpus_allowed has to
>> be equal to effective_cpus before a cpuset can be made a partition root.
>>
>> Any changes that break the above conditions will turn off the partition
>> flag forcefully. The only exception is cpu offlining where cpus_allowed
>>> effective_cpus + reserved_cpus can happen.
>> One reason for doing so is because reserved_cpus is hidden. So the main
>> way to infer that is to do cpus_allowed - effective_cpus.
>>
>> It is probably doable to make cpus_allowed >= effective_cpus +
>> reserved_cpus in general, but we may need to expose reserved_cpus as a
>> read-only file, for instance. There may also be other complications that
>> we will need to take care of if this is supported. My current preference
>> is to not doing that unless there is compelling reason to do so.
> So, if we're gonna make this hierarchical, I think it probably would
> be better to go in all the way.  It's kinda weird to mix the two
> approaches - the normal cpuset operation following the usual
> convention (it'd be really great to fix the removal part too) and
> parition code doing something else.
>
> I think adding another interface file should be fine here.
>
> Thanks.
>
OK, I will revise the patch to make it work without the removal part.

Thanks,
Longman

