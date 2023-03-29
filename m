From: Waiman Long <longman@redhat.com>
Subject: Re: CLONE_INTO_CGROUP probably needs to call controller attach
 handlers
Date: Tue, 28 Mar 2023 22:48:49 -0400
Message-ID: <5937b51b-164a-b6b3-532d-43b46f2d49a2@redhat.com>
References: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
 <c3d9cf24-1c3a-cda4-5063-6b7d27e9116f@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680058131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L6oe7fC3/mHI/luYdbPv+vw9eT1o83NLKjT6NHGcNrY=;
        b=K8POhdRGA9l6areWdpPRqKKBjpTNNUJKTbFhTuP0qJWkBD+5rINVe8sZY5CrW8IqBH+sLG
        sbjkjg0j2QjRtEqj0uxnXDFUnCI6KJl0cFUgMQHGd2xrO0+GjxlU/teWRR61RnA5tOXBgl
        PJLV+Jhkc0hmhY9qHEDaFQFTMFPWvag=
Content-Language: en-US
In-Reply-To: <c3d9cf24-1c3a-cda4-5063-6b7d27e9116f@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christian Brauner <brauner@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, gscrivan@redhat.com

On 3/28/23 21:30, Waiman Long wrote:
> On 3/28/23 11:39, Christian Brauner wrote:
>> Hey,
>>
>> Giuseppe reported that the the affinity mask isn't updated when a
>> process is spawned directly into the target cgroup via
>> CLONE_INTO_CGROUP. However, migrating a process will cause the affinity
>> mask to be updated (see the repro at [1].
>>
>> I took a quick look and the issue seems to be that we don't call the
>> various attach handlers during CLONE_INTO_CGROUP whereas we do for
>> migration. So the solution seems to roughly be that we need to call the
>> various attach handlers during CLONE_INTO_CGROUP as well when the
>> parent's cgroups is different from the child cgroup. I think we need to
>> call all of them, can, cancel and attach.
>>
>> The plumbing here might be a bit intricate since the arguments that the
>> fork handlers take are different from the attach handlers.
>>
>> Christian
>>
>> [1]: https://paste.centos.org/view/f434fa1a
>>
> I saw that the current cgroup code already have the can_fork, fork and 
> cancel_fork callbacks. Unfortunately such callbacks are not defined 
> for cpuset yet. That is why the cpu affinity isn't correctly updated. 
> I can post a patch to add those callback functions to cpuset which 
> should then able to correctly address this issue.

Looking further into this issue, I am thinking that forking into a 
cgroup should be equivalent to write the child pid into the 
"cgroup.threads" file of the target cgroup. By taking this route, all 
the existing can_attach, attach and cancel_attach methods can be used. I 
believe the original fork method is for the limited use case of forking 
into the same cgroup. So right now, only the pids controller has the 
fork methods. Otherwise, we will have to modify a number of different 
controllers to add the necessary fork methods. They will be somewhat 
similar to the existing attach methods and so it will be a lot of 
duplication. What do you think about this idea?

Cheers,
Longman

