From: Tom Hromatka <tom.hromatka@oracle.com>
Subject: Re: [PATCH v13 01/11] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 15 Oct 2018 13:10:52 -0600
Message-ID: <f461a6b4-fe95-ab7c-675a-734a02342a6d@oracle.com>
References: <1539366951-8498-1-git-send-email-longman@redhat.com>
 <1539366951-8498-2-git-send-email-longman@redhat.com>
 <bfa8d0a2-ce78-8a0b-2a2e-45b02d6a8239@oracle.com>
 <ebff503c-291c-345c-a0ab-e2a4ceb6ad0c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=PGGtRlRfNP6a3RhwNgdkUGCVn4NE70S8u+xqtqELuhg=;
 b=mBqWmEXnZ0OtUywDH0cezZDnzj18w4J8ai9JJVYxQMoYkRiiW9Odgx24gaNkcBgdOQ6Z
 16BzO3/Ea3J/95UM5sbz/CSvjfAOX403kn9jiWSd/mFkKhrvff44xmFH4c0S7lftK6Oz
 kl1pV8faqIBJdMnddUSw8Vx7IwB2iPt7+2LKHjQJZUBS5t5PAD+2QGaSPmzSLSm93hQX
 qgbW/yTyYEeN/vhl2mHgBZv+3rf4/xB+/hAmaPxvobzxOVap8ZDS7PqZON71T3aE4hbn
 npvSZ6xioK20aZHzHcw1cCR8HztKmx7iW63/AVtDT16ez6I0TzZ4akjswAQ8dD0uaV9e Ow== 
In-Reply-To: <ebff503c-291c-345c-a0ab-e2a4ceb6ad0c@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>



On 10/15/2018 12:41 PM, Waiman Long wrote:
> On 10/15/2018 02:31 PM, Tom Hromatka wrote:
>>
>> On 10/12/2018 11:55 AM, Waiman Long wrote:
>>> Given the fact that thread mode had been merged into 4.14, it is now
>>> time to enable cpuset to be used in the default hierarchy (cgroup v2)
>>> as it is clearly threaded.
>>>
>>> The cpuset controller had experienced feature creep since its
>>> introduction more than a decade ago. Besides the core cpus and mems
>>> control files to limit cpus and memory nodes, there are a bunch of
>>> additional features that can be controlled from the userspace. Some of
>>> the features are of doubtful usefulness and may not be actively used.
>>>
>>> This patch enables cpuset controller in the default hierarchy with
>>> a minimal set of features, namely just the cpus and mems and their
>>> effective_* counterparts.  We can certainly add more features to the
>>> default hierarchy in the future if there is a real user need for them
>>> later on.
>> I really appreciate this simplification of the cpuset controller.
>>
>> I currently have an in-house customer that is unhappy with the
>> way cgroups cpuset v1 handles offlined CPUs.  This patchset makes two
>> significant improvements over current cpuset v1 behavior.  1) It allows
>> for offlined CPUs to be added to a cpuset (even though the CPU is
>> offline) and 2) it restores CPUs back to the requested cpuset when they
>> come back online.  This is more intuitive and secure for my customers.
>> Thank you!
>>
>> In part because of this patchset, I plan on proposing similar behavior
>> for offlined CPUs to cpuset v1.
>>
>> Thanks.
>>
>> Tom
> If you are just talking about the ability for cpuset to revert back to
> its original state when an offlined CPU becomes online again, that
> capability can be activated in v1 using the "cpuset_v2_mode" mount
> option when mounting the cpuset cgroup. However, that is not the default
> for v1.
>
> -Longman
>
>

Thanks!!!  I didn't realize cpuset_v2_mode exists.  (I see you
added it last year.  Thank you!)  I'll try it out and see if it
meets my customer's needs.

Tom



