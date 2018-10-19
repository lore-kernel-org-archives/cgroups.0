From: Tom Hromatka <tom.hromatka@oracle.com>
Subject: Re: [PATCH v14 03/12] cpuset: Simply allocation and freeing of
 cpumasks
Date: Fri, 19 Oct 2018 09:28:51 -0600
Message-ID: <daecd3d4-0fb9-dd50-3282-affad1d21bf3@oracle.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-4-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xO6mOkvKjTumL7VUnexCh0alTTod+vkexKmilM7Pe7M=;
 b=3VwpxBitjvImWvgUcV2PLbI2hvVzTMaAUQj8FHE6mFpS9OTzEolJlrRU0YC9MQsZwskE
 VsyQSYdirNKLxEO5bvtTPRKQA/4uKtEU67z1Vd3DigUe6eeG6iaYU6RlQJBe78LjKh8e
 FMB3u4AfSjQIlytr1chJa/5De6zi2tXWW1dgfCyQq8lkRVQzH6o6GVg5LzH4X/1JTn6l
 jxYyKAhbprpzJzbylt9pi6NdUfaMfii/DF/Bere/NzHzQQzZ7iDGO/zyzHzdXmJRs7VG
 zwjHzGBxSQ7um1PY2qAqk7lESyphz672XcVgv0+RS2CSfCLQCcZyK5MVcMJk5ZfyQ+vE 6w== 
In-Reply-To: <1539635377-22335-4-git-send-email-longman@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>



On 10/15/2018 02:29 PM, Waiman Long wrote:
> The previous commit introduces a new subparts_cpus mask into the cpuset
> data structure and a new tmpmasks structure.  Managing the allocation
> and freeing of those cpumasks is becoming more complex.
>
> So a number of helper functions are added to simplify and streamline
> the management of those cpumasks. To make it simple, all the cpumasks
> are now pre-cleared on allocation.
>
> Signed-off-by: Waiman Long <longman@redhat.com>

Thanks!

Reviewed-by: Tom Hromatka <tom.hromatka@oracle.com>
