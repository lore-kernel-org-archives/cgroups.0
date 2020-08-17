From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 1/8] memcg: Enable fine-grained control of over
 memory.high action
Date: Mon, 17 Aug 2020 11:38:45 -0400
Message-ID: <934e4bc3-bab6-b19a-49f9-6a6ae8638570@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200817140831.30260-2-longman@redhat.com>
 <20200817143044.GA1987@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597678734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkWVLRXZ5vVFgxHkOqqYvCoNjff7Y5hvG4el3ZRbhHA=;
        b=PCDaGtJ/hYwQosgCRiZvDPtF2KD4EwEYW+2PzBs1Q8bPSbI+xoqq5wfL5tD5FMIwUO600G
        2Hi3U4T6N9RXRMp6DUhLqy+GeAZZ1H77qpDkqQj72hdTlOdOZjnx766ggofFtJdNmWSakE
        a3y70DhJCknHgmLV+i4P5Nde5wE78uA=
In-Reply-To: <20200817143044.GA1987@chrisdown.name>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On 8/17/20 10:30 AM, Chris Down wrote:
> Astractly, I think this really overcomplicates the API a lot. If these 
> are truly generally useful (and I think that remains to be 
> demonstrated), they should be additions to the existing API, rather 
> than a sidestep with prctl.
This patchset is derived from customer requests. With existing API, I 
suppose you mean the memory cgroup API. Right? The reason to use prctl() 
is that there are users out there who want some kind of per-process 
control instead of for a whole group of processes unless the users try 
to create one cgroup per process which is not very efficient.
>
> I also worry about some other more concrete things:
>
> 1. Doesn't this allow unprivileged applications to potentially bypass 
>    memory.high constraints set by a system administrator?
The memory.high constraint is for triggering memory reclaim. The new 
mitigation actions introduced by this patchset will only be applied if 
memory reclaim alone fails to limit the physical memory consumption. The 
current memory cgroup memory reclaim code will not be affected by this 
patchset.
> 2. What's the purpose of PR_MEMACT_KILL, compared to memory.max?
A user can use this to specify which processes are less important and 
can be sacrificed first instead of the other more important ones in case 
they are really in a OOM situation. IOW, users can specify the order 
where OOM kills can happen.
> 3. Why add this entirely separate signal delivery path when we already 
> have eventfd/poll/inotify support, which makes a lot more sense for 
> modern    applications?

Good question, I will look further into this to see if it can be 
applicable in this case.

Cheers,
Longman


