From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 27 Aug 2021 13:35:39 -1000
Message-ID: <YSl2yxEvnDrPxzUV@slm.duckdns.org>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com>
 <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
 <32e27fcc-32f1-b26c-ae91-9e03f7e433af@redhat.com>
 <YShjb2WwvuB4s4gX@slm.duckdns.org>
 <d22ea3be-2429-5923-a80c-5af3b384def9@redhat.com>
 <YSlY0H/qeXQIGOfk@slm.duckdns.org>
 <392c3724-f583-c7fc-cfa1-a3f1665114c9@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=prQGEZISCROhNVrZYgfW+RC/t0atKeeXslehrhwqbKM=;
        b=JVKQMqIk5zflT5U8YILqRhxIh0RbHGgU2gJ/VgQiRBTi+AYzDW0B+/RartoyZkUvtv
         0aIPVgKqWSag9KjmoSmL9tIWHn1wBjacgIraxFnfDb5qGOZIUWO89s/DReEueEyUwyCU
         xBvOq80P4g1ck6ZkFkbUuJXgJhQXW8bc4jx0W3R6bkzBf/GFgpdxXOI9qR3i3aZM7gd5
         k1QK34eoX7chwVUadq/Zz9w7KcoJP7gm1tTl686YBb5Wf7RXf5lNfYrYfB7UEh+SWZtl
         YKdr/zTz3TNPmZM45KKMPXB5YYh4yXEr6TJ8VDPPtbo+4L2n3eYoWYI/mfPVR3fadHXs
         3a4Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <392c3724-f583-c7fc-cfa1-a3f1665114c9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hello,

On Fri, Aug 27, 2021 at 06:50:10PM -0400, Waiman Long wrote:
> The cpu exclusivity rule is due to the setting of CPU_EXCLUSIVE bit. This is
> a pre-existing condition unless you want to change how the
> cpuset.cpu_exclusive works.
>
> So the new rules will be:
> 
> 1) The "cpuset.cpus" is not empty and the list of CPUs are exclusive.

Empty cpu list can be considered an exclusive one.

> 2) The parent cgroup is a partition root (can be an invalid one).

Does this mean a partition parent can't stop being a partition if one or
more of its children become partitions? If so, it violates the rule that a
descendant shouldn't be able to restrict what its ancestors can do.

> 3) The "cpuset.cpus" is a subset of the parent's cpuset.cpus.allowed.

Why not just go by effective? This would mean that a parent can't withdraw
CPUs from its allowed set once descendants are configured. Restrictions like
this are fine when the entire hierarchy is configured by a single entity but
become awkward when configurations are multi-tiered, automated and dynamic.

> 4) No child cgroup with cpuset enabled.

idk, maybe? I'm having a hard time seeing the point in adding these
restrictions when the state transitions are asynchronous anyway. Would it
help if we try to separate what's absoluately and technically necessary and
what seems reasonable or high bar and try to justify why each of the latter
should be added?

Thanks.

-- 
tejun
