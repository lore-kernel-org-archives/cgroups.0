From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Thu, 26 Aug 2021 07:35:14 -1000
Message-ID: <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EZSEycsP4qShPCh1rVVDGzpSXPPGPKKt4tNdiEEa5Yo=;
        b=c94jOw6mYlRttgV/ELojAGblRHKn2cClqABKr0Rvj2jkxVok/L/2iBafzHm+g/ccHc
         W9R0GGnvBRh0fDrFaOgkTIcPtoaluXGUrLvFqa8Yh+KxKHeCQeSlkFA89mn3jvrRkRP1
         fGr97QjrUTLFCaEO12/dK154B2bAXnCGhCh8L32Kd7ZONxYdm1ispu+eBkW5si1Gs1uX
         hvMTI3drWfbpfGiYw9LRuL3xXT1FJVCW65JZm9q6oVQP9kSYO8mSg4NZXnHatM/tb+Z6
         /CKBO6g+WRERs1NDPKp4ymYaIWkU1hUNJVAVYLZWGW7xll6zIUiQSTuOLzVvzDsMFke0
         d9qw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210825213750.6933-6-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello, Waiman.

Let's stop iterating on the patchset until we reach a consensus.

On Wed, Aug 25, 2021 at 05:37:49PM -0400, Waiman Long wrote:
>  	1) The "cpuset.cpus" is not empty and the list of CPUs are
>  	   exclusive, i.e. they are not shared by any of its siblings.

Part of it can be reached by cpus going offline.

>  	2) The parent cgroup is a partition root.

This condition can happen if a parent stop being a partition.

> -	3) The "cpuset.cpus" is also a proper subset of the parent's
> +	3) The "cpuset.cpus" is a subset of the parent's
>  	   "cpuset.cpus.effective".

This can happen if cpus go offline.

>  	4) There is no child cgroups with cpuset enabled.  This is for
>  	   eliminating corner cases that have to be handled if such a
>  	   condition is allowed.

This may make sense as a short cut for us but doesn't really stem from
interface or behavior requirements.

Of the four conditions listed, two are bogus (the states can be
reached through a different path and the configuration success or
failure can be timing dependent if configuration racaes against cpu
hotplug operations) and one maybe makes sense half-way and one is more
of a shortcut.

Can't we just replace these with transitions to invalid state with
proper explanation? That'd get rid of the error handling duplications
from both the kernel and user side, make automated configurations
which may race against hot plug operations reliable, and consistently
provide users with why something failed.

Thank you.

-- 
tejun
