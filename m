From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v9 6/7] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 15 Dec 2021 15:44:51 +0100
Message-ID: <20211215144450.GC25459@blackbody.suse.cz>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-7-longman@redhat.com>
 <Ybe0YWEo7Wp7wib9@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639579492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L+FwlFr7sookecjc9+Z4KJH3P8puADKn4avrNKuh3fg=;
        b=V2YNGn1ryxEnaOg+uqD0czIqum5A+yvyyOQF3/o+zFpawFNR+AbAXZhquxTqZxu3w7E5n2
        F0ottN2Pw6JXwcZNGP9VFmAgQ2j6z7rsoVTVmkKucdC1IAv+nbmrE/aj9oaCO4INsLri9u
        /mi/m484fVNsR3E1xOvslXFMEQJcp6I=
Content-Disposition: inline
In-Reply-To: <Ybe0YWEo7Wp7wib9-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Dec 13, 2021 at 11:00:17AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> * When a valid partition turns invalid, now we have a reliable way of
>   discovering what exactly caused the transition. However, when a user now
>   fails to turn a member into partition, all they get is -EINVAL and there's
>   no way to discover why it failed and the failure conditions that -EINVAL
>   represents aren't simple.
> 
> * In an automated configuration scenarios, this operation mode may be
>   difficult to make reliable and lead to sporadic failures which can be
>   tricky to track down. The core problem is that whether a given operation
>   succeeds or not may depend on external states (CPU on/offline) which may
>   change asynchronously in a way that the configuring entity doesn't have
>   any control over.
> 
> It's true that both are existing problems with the current partition
> interface and given that this is a pretty spcialized feature, this can be
> okay. Michal, what are your thoughts?

Because of asynchronous changes, the return value should not be that
important and the user should watch cpuset.partitions for the result
(end state) anyway.
Furthermore, the reasons should be IMO just informative (i.e. I like
they're not explicitly documented) and not API.

But I see there could be a distinction between -EINVAL (the supplied
input makes no sense) and -EAGAIN(?) denoting that the switch to
partition root could not happen (due to outer constraints).

You seem to propose to replace the -EAGAIN above with a success code and
allow the switch to an invalid root.
The action of the configuring entity would be different: retry (when?)
vs wait till transition happens (notification) (although the immediate
effect (the change did not happen) is same).
I considered the two variants equal but the clear information about when
the change can happen I'd favor the variant allowing the switch to
invalid root now.


Michal
