From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 15:20:09 -0400
Message-ID: <80456788-efd9-bc95-5ac6-5a828be23009@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200817152655.GE28270@dhcp22.suse.cz>
 <e66d6b5f-6f02-8c8f-681e-1d6da7a72224@redhat.com>
 <20200817192625.GF28270@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597778416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kTw7qpPswkkc4L0pFLjBtR+b0/Du3MlSdJNi0daaxfs=;
        b=ekC9ZySaEKZf205xUXdjShcoQvf3EEyhXWDdxoyAY1q7hOyD5TJXpn1bq0fOqYj5qhUxIn
        Hdbi6pM/TDTLylhCkPXVdBKsbxmLRrVnzF57Zq7YxlaeQnfvGq9enu3xXZ09NwNmWMd0Rh
        E+wAZsasf0/rer2WhFwIs7otP3VIlQw=
In-Reply-To: <20200817192625.GF28270-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 8/17/20 3:26 PM, Michal Hocko wrote:
> On Mon 17-08-20 11:55:37, Waiman Long wrote:
>> On 8/17/20 11:26 AM, Michal Hocko wrote:
>>> On Mon 17-08-20 10:08:23, Waiman Long wrote:
>>>> Memory controller can be used to control and limit the amount of
>>>> physical memory used by a task. When a limit is set in "memory.high" in
>>>> a v2 non-root memory cgroup, the memory controller will try to reclaim
>>>> memory if the limit has been exceeded. Normally, that will be enough
>>>> to keep the physical memory consumption of tasks in the memory cgroup
>>>> to be around or below the "memory.high" limit.
>>>>
>>>> Sometimes, memory reclaim may not be able to recover memory in a rate
>>>> that can catch up to the physical memory allocation rate. In this case,
>>>> the physical memory consumption will keep on increasing.  When it reaches
>>>> "memory.max" for memory cgroup v2 or when the system is running out of
>>>> free memory, the OOM killer will be invoked to kill some tasks to free
>>>> up additional memory. However, one has little control of which tasks
>>>> are going to be killed by an OOM killer. Killing tasks that hold some
>>>> important resources without freeing them first can create other system
>>>> problems down the road.
>>>>
>>>> Users who do not want the OOM killer to be invoked to kill random
>>>> tasks in an out-of-memory situation can use the memory control
>>>> facility provided by this new patchset via prctl(2) to better manage
>>>> the mitigation action that needs to be performed to various tasks when
>>>> the specified memory limit is exceeded with memory cgroup v2 being used.
>>>>
>>>> The currently supported mitigation actions include the followings:
>>>>
>>>>    1) Return ENOMEM for some syscalls that allocate or handle memory
>>>>    2) Slow down the process for memory reclaim to catch up
>>>>    3) Send a specific signal to the task
>>>>    4) Kill the task
>>>>
>>>> The users that want better memory control for their applicatons can
>>>> either modify their applications to call the prctl(2) syscall directly
>>>> with the new memory control command code or write the desired action to
>>>> the newly provided memctl procfs files of their applications provided
>>>> that those applications run in a non-root v2 memory cgroup.
>>> prctl is fundamentally about per-process control while cgroup (not only
>>> memcg) is about group of processes interface. How do those two interact
>>> together? In other words what is the semantic when different processes
>>> have a different views on the same underlying memcg event?
>> As said in a previous mail, this patchset is derived from a customer request
>> and per-process control is exactly what the customer wants. That is why
>> prctl() is used. This patchset is intended to supplement the existing memory
>> cgroup features. Processes in a memory cgroup that don't use this new API
>> will behave exactly like before. Only processes that opt to use this new API
>> will have additional mitigation actions applied on them in case the
>> additional limits are reached.
> Please keep in mind that you are proposing a new user API that we will
> have to maintain for ever. That requires that the interface is
> consistent and well defined. As I've said the fundamental problem with
> this interface is that you are trying to hammer a process centric
> interface into a framework that is fundamentally process group oriented.
> Maybe there is a sensible way to do that without all sorts of weird
> corner cases but I haven't seen any of that explained here.
>
> Really just try to describe a semantic when two different tasks in the
> same memcg have a different opinion on the same event. One wants ENOMEM
> and other a specific signal to be delivered. Right now the behavior will
> be timing specific because who hits the oom path is non-deterministic
> from the userspace POV. Let's say that you can somehow handle that, now
> how are you going implement ENOMEM for any context other than current
> task? I am pretty sure the more specific questions you will have the
> more this will get awkward.

The basic idea of triggering a user-specified memory-over-high 
mitigation is when the actual memory usage exceed a threshold which is 
supposed to be between "high" and "max". The additional limit that is 
passed in is for setting this additional threshold. We want to avoid OOM 
at all cost.

The ENOMEM error may not be suitable for all applications as some of 
them may not be able to handle ENOMEM gracefully. That is for 
applications that are designed to handle that.

Cheers,
Longman

