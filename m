From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v14 12/12] cpuset: Show descriptive text when reading
 cpuset.sched.partition
Date: Wed, 17 Oct 2018 11:20:08 -0400
Message-ID: <55f76a9b-9e6d-0e5f-c07a-c94777555d4e@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-13-git-send-email-longman@redhat.com>
 <20181017150836.GS270328@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017150836.GS270328@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On 10/17/2018 11:08 AM, Tejun Heo wrote:
> On Mon, Oct 15, 2018 at 04:29:37PM -0400, Waiman Long wrote:
>> Currently, cpuset.sched.partition returns the values, 0, 1 or -1 on
>> read. A person who is not familiar with the partition code may not
>> understand what they mean.
>>
>> In order to make cpuset.sched.partition more user-friendly, it will
>> now display the following descriptive text on read:
>>
>>   "normal" - A normal cpuset, not a partition root
>>   "partition" - A partition root
>>   "partition invalid" - An invalid partition root
>>
>> Suggested-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> Can you also make this consistent when writing to the file?
>
> Thanks.
>
Yes, sure.

-Longman

