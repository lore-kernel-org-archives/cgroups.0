From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 4/6] cgroup/cpuset: Allow non-top parent partition
 root to distribute out all CPUs
Date: Thu, 12 Aug 2021 11:51:27 -1000
Message-ID: <YRWX3z6Nl41GsXR8@slm.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-5-longman@redhat.com>
 <YRQTTf+bJZ8f3O3+@slm.duckdns.org>
 <abfa6f2f-aa13-f18e-5a16-f568082d07bc@redhat.com>
 <YRQVFkNX5DcKixzy@slm.duckdns.org>
 <ef02d96b-325c-87f6-a6a3-d840feefef24@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jH45JI3TRK33maJqrgZXXznOLgIkQBFryW79S8eId3M=;
        b=Y9WHxm/HccEPeJfkiPBSqOtIQdiDsYdt/RUttWpOGC4h8GALHwr5TYVrcHS/FwHdAW
         brH64YsniZ1m2CNdrbrRALQs4yxFN228FlIYSp3S0S81J4b6QJOTWS/mu0gD20utmJ4x
         mB0yPjJdiz3mudogXhcCUvzXk7KEW3/afkG4GAVpFUIkWVh+DvpPNLLJu2S0RFYmI34h
         2l3Qd9IzJRZjgCQqH93U+FiFNpHfZT5x9yWgcHrcG+V3oXyZa/BN7M+FKmnG3winetMh
         U2i52F02EYfs7f0/kK4ctk7+orUAr3RLJDZxf9bOxVyu9FtRjPORwymlSEnsMzmX7cmf
         Rq2Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ef02d96b-325c-87f6-a6a3-d840feefef24-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Wed, Aug 11, 2021 at 02:46:24PM -0400, Waiman Long wrote:
> On 8/11/21 2:21 PM, Tejun Heo wrote:
> > On Wed, Aug 11, 2021 at 02:18:17PM -0400, Waiman Long wrote:
> > > I don't think that is true. A task can reside anywhere in the cgroup
> > > hierarchy. I have encountered no problem moving tasks around.
> > Oh, that shouldn't be happening with controllers enabled. Can you please
> > share a repro?
> 
> I have done further testing. Enabling controllers won't prohibit moving a
> task into a parent cgroup as long as the child cgroups have no tasks. Once

Should be "as long as there's no child cgroups".

  root@test /s/f/cgroup# mkdir test
  root@test /s/f/cgroup# mkdir -p test/A
  root@test /s/f/cgroup# echo +io > test/cgroup.subtree_control 
  root@test /s/f/cgroup# echo $fish_pid > test/cgroup.procs
  write: Device or resource busy

> the child cgroup has task, moving another task to the parent is not allowed
> (-EBUSY). Similarly if a parent cgroup has tasks, you can't put new tasks
> into the child cgroup. I don't realize that we have such constraints as I

You can't enable controller from a populated cgroup:

  root@test /s/f/cgroup# mkdir test
  root@test /s/f/cgroup# echo +io > test/cgroup.subtree_control 
  root@test /s/f/cgroup# echo $fish_pid > test/cgroup.procs

> usually do my testing with a cgroup hierarchy with no tasks initially.
> Anyway, a new lesson learned.

The invariant is that from each controller's POV, all cgroups with processes
in them are leaves. This is all pretty well documented in cgroup-v2.rst.

Thanks.

-- 
tejun
