From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v10 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 4 May 2022 13:25:52 +0200
Message-ID: <20220504112552.GA15266@blackbody.suse.cz>
References: <20220503162149.1764245-1-longman@redhat.com>
 <20220503162149.1764245-8-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651663553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IHotc1tLxNFQnMsMhQ4/PAmmsXVX/ZrmEY2hoLkhoeY=;
        b=prmLabugZEs93348NyPI+Rk+PvbnW03y6T9MnWqgkElCaLaxD76fSofTgRaeDBgj+VsO+6
        JJrL0pJY5taH3pcpCX3mOYmFXRH4wLu2FwI9+uFoFQy61iIBDOsN98iOmHbJLnWAaSemYH
        wBbOqgwKNBoCX7DWQOQHFbvaRdjwiaA=
Content-Disposition: inline
In-Reply-To: <20220503162149.1764245-8-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

Hello.

On Tue, May 03, 2022 at 12:21:48PM -0400, Waiman Long <longman@redhat.com> wrote:
>  Documentation/admin-guide/cgroup-v2.rst | 145 +++++++++++++-----------
>  1 file changed, 79 insertions(+), 66 deletions(-)

A note across various lines -- it seems your new text accidentally mixes
both spaces and tabs for indentation.

> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 69d7a6983f78..94e1e3771830 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> [...]
> +	The value shown in "cpuset.cpus.effective" of a partition root is
> +	the CPUs that the parent partition root can dedicate to the new
> +	partition root.  They are subtracted from "cpuset.cpus.effective"
> +	of the parent and may be different from "cpuset.cpus"

I find this paragraph a bit hard to comprehend (I read it as it talks
about three levels of cgroups (parent, child, grandparent). It is
correct but I'd suggect following formulation (where I additionally
simplifed it by talking about "available" cpus):

> The value shown in "cpuset.cpus.effective" of a partition root is
> the CPUs that the partition root can dedicate to a potential new child
> partition root. The new child subtracts available CPUs from its parent
> "cpuset.cpus.effective".


> +	For a partition root to become valid, the following conditions
> +	must be met.
> +
> +	1) The "cpuset.cpus" is exclusive, i.e. they are not shared by
> +	   any of its siblings (exclusivity rule).
> +	2) The parent cgroup is a valid partition root.
> +	3) The "cpuset.cpus" is not empty and must contain at least
> +	   one of the CPUs from parent's "cpuset.cpus", i.e. they overlap.
> +        4) The "cpuset.cpus.effective" must be a subset of "cpuset.cpus"
> +           and cannot be empty unless there is no task associated with
> +           this partition.

This sounds good to me.

> +        Care must be taken to change a valid partition root to "member"
> +        as all its child partitions, if present, will become invalid.

This does not talk about recovering. Is it intentional? (I.e. to left
implementation defined)

Except the remarks above, I find the concepts described here good. I'll
reply to implementation separately & later.

Regards,
Michal
