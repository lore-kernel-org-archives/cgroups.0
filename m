From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Tue, 24 Aug 2021 09:04:31 -1000
Message-ID: <YSVCv0WjTzwPUWUN@slm.duckdns.org>
References: <20210814205743.3039-1-longman@redhat.com>
 <20210814205743.3039-6-longman@redhat.com>
 <YRqbj5+ZdS+7k0Fn@slm.duckdns.org>
 <95b72d36-32a9-8356-05b7-2829e4cc29ad@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/UA6BwC0CYO3Y/QhMBFUGVm/MkfIStQXJiA2tvHOy2E=;
        b=InWzEdcms5aFyJNybcPjVBSg4/YyHC4fs7zj6R3+Yv8npQ+KHDzLn7itVIJu+p0sHT
         Q6/AUyTgYzD4VmqdR9mT1dT/7tCLVlhkqQ/1fiIhbCTjlCBCkR0yPpVP4Ca8n7w2ruLK
         XWlTNoMagLkN9eGT4Cw2YtHTD8+Z3VwnEmanlqU5CZ0xTq6kvLeWtXHeIAqIeABYjt0f
         d3erx68+4v5ESugAEzgpSqPJvh3Y/ygsLs1WR4yWXbCmSqKrnG7ph4qWLPKhvlxAPqQn
         sKyLbd5GGKgF0NFzQJ/4M8M/eNrdTnpp2PZvqEyxbd5bFuVuIpnAOVFlYGR1lUTG1JJ5
         CFDQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <95b72d36-32a9-8356-05b7-2829e4cc29ad-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hello,

On Tue, Aug 24, 2021 at 01:35:33AM -0400, Waiman Long wrote:
> Sorry for the late reply as I was on vacation last week.

No worries. Hope you enjoyed the vacation. :)

> > All the above ultimately says is that "a new task cannot be moved to a
> > partition root with no effective cpu", but I don't understand why this would
> > be a separate rule. Shouldn't the partition just stop being a partition when
> > it doesn't have any exclusive cpu? What's the benefit of having multiple its
> > own failure mode?
>
> A partition with 0 cpu can be considered as a special partition type for
> spawning child partitions. This can be temporary as the cpus will be given
> back when a child partition is destroyed.

But it can also happen by cpus going offline while the partition is
populated, right? Am I correct in thinking that a partition without cpu is
valid if its subtree contains cpus and invalid otherwise? If that's the
case, it looks like the rules can be made significantly simpler. The parent
cgroups never have processes anyway, so a partition is valid if its subtree
contains cpus, invalid otherwise.

> > So, I think this definitely is a step in the right direction but still seems
> > to be neither here or there. Before, we pretended that we could police the
> > input when we couldn't. Now, we're changing the interface so that it
> > includes configuration failures as an integral part; however, we're still
> > policing some particular inputs while letting other inputs pass through and
> > trigger failures and why one is handled one way while the other differently
> > seems rather arbitrary.
> > 
> The cpu_exclusive and load_balance flags are attributes associated directly
> with the partition type. They are not affected by cpu availability or
> changing of cpu list. That is why they are kept even when the partition
> become invalid. If we have to remove them, it will be equivalent to changing
> partition back to member and we may not need an invalid partition type at
> all. Also, we will not be able to revert back to partition again when the
> cpus becomes available.

Oh, yeah, I'm not saying to lose those states. What I'm trying to say is
that the rules and failure modes seem a lot more complicated than they need
to be. If the configuration becomes invalid for whatever reason, transition
the partition into invalid state and report why. If the situation resolves
for whatever reason, transition it back to valid state. Shouldn't that work?

Thanks.

-- 
tejun
