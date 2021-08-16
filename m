From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 16 Aug 2021 07:08:31 -1000
Message-ID: <YRqbj5+ZdS+7k0Fn@slm.duckdns.org>
References: <20210814205743.3039-1-longman@redhat.com>
 <20210814205743.3039-6-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ezzl1wWnIMpMxrnM4W7DDVrnVpy6eCY3TnCdM56lXyY=;
        b=bz0Ae35bR0EHDskVbOAz6ZJTJsciOg38ggObJYVxbzJbN6FSJ2ga3D1fhPcm3CBqpu
         3K137eUco3rmgdvBI9wOWnRzVqJSHdIRWwzQRZVMq9CYCbapAYdanPceAefq2A03pnEk
         ScQnPxf2oxwtXTyjKIK2YI3gVybmud2L8ktcDPC9qxhthbEbk0zZQlIxeZhSeuwb5oYW
         9X2NF47UZc9uMfeoB5Wkg07GZfJzpqJDFJGhSzqy2xMdfwd2JTZXm6fOFfqwndB7PkVO
         ZXyVbhwHcMWgPdS0q0PU8vFbLywFpxrvVfNCdp9x+byGTE+82sJ4puxpdMTTOxtrG8/d
         OFdA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210814205743.3039-6-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Sat, Aug 14, 2021 at 04:57:42PM -0400, Waiman Long wrote:
> +	A parent partition may distribute all its CPUs to its child
> +	partitions as long as it is not the root cgroup and there is no
> +	task directly associated with that parent partition.  Otherwise,

"there is not task directly associated with the parent partition" isn't
necessary, right? That's already enforced by the cgroup hierarchy itself.

> +	there must be at least one cpu left in the parent partition.
> +	A new task cannot be moved to a partition root with no effective
> +	cpu.
> +
> +	Once becoming a partition root, changes to "cpuset.cpus"
> +	is generally allowed as long as the first condition above
> +	(cpu exclusivity rule) is true.

All the above ultimately says is that "a new task cannot be moved to a
partition root with no effective cpu", but I don't understand why this would
be a separate rule. Shouldn't the partition just stop being a partition when
it doesn't have any exclusive cpu? What's the benefit of having multiple its
own failure mode?

> +	Sometimes, changes to "cpuset.cpus" or cpu hotplug may cause
> +	the state of the partition root to become invalid when the
> +	other constraints of partition root are violated.  Therefore,
> +	it is recommended that users should always set "cpuset.cpus"
> +	to the proper value first before enabling partition.  In case
> +	"cpuset.cpus" has to be modified after partition is enabled,
> +	users should check the state of "cpuset.cpus.partition" after
> +	making change to it to make sure that the partition is still
> +	valid.

So, idk why the this doesn't cover the one above it. Also, this really
should be worded a lot stronger. It's not just recommended - confirming and
monitoring the transitions is an integral and essential part of using
cpuset.

...
> +	An invalid partition is not a real partition even though the
> +	restriction of the cpu exclusivity rule will still apply.

Is there a reason we can't bring this in line with other failure behaviors?

> +	In the special case of a parent partition competing with a child
> +	partition for the only CPU left, the parent partition wins and
> +	the child partition becomes invalid.

Given that parent partitions are *always* empty, this rule doesn't seem to
make sense.

So, I think this definitely is a step in the right direction but still seems
to be neither here or there. Before, we pretended that we could police the
input when we couldn't. Now, we're changing the interface so that it
includes configuration failures as an integral part; however, we're still
policing some particular inputs while letting other inputs pass through and
trigger failures and why one is handled one way while the other differently
seems rather arbitrary.

Thanks.

-- 
tejun
