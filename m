From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/6] cgroup/cpuset: Properly handle partition root tree
Date: Thu, 12 Aug 2021 12:18:40 -1000
Message-ID: <YRWeQH6gY5PqIanD@slm.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-3-longman@redhat.com>
 <YRQSKZB8rQUsfF2K@slm.duckdns.org>
 <b7897818-8fe6-8dd8-3ff6-6b15401162ba@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8zFCvlCdjE9f7sPEj6Bash+YWPaS4lcq1GCfTDwodeA=;
        b=R4yXwtdcvocwR/bdi8p+iX4Ffhyp8BtxcPTMUe3KaMmMcL1xZcLE1vuGp3F+9TdP8s
         dcdiW38YxfL7HE1FEOsByI0q89D59M470EtczPWxls4gAKkZCVpWm8S3vtG+tqrudv5v
         iHMG81t3Qc0Sf6N8VvoQqo5NhBfUb2x7FUlnJf5rwedYdXxYmNIEuOzvCV1rwq3AEtvl
         nWr8FlzZzZHYpft+FuA/4H7fvr3ch3zOHKlg6zcM9pAw4l+fz+850kwswV+B/kfb17Uf
         FrCh5S5NxORAqyS3QZTWFqQLNdxbEZJQBLHr3ILpsZfUO/WxiNpSd0slQY8bifjFOZLP
         XVdQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b7897818-8fe6-8dd8-3ff6-6b15401162ba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hello,

On Wed, Aug 11, 2021 at 03:27:20PM -0400, Waiman Long wrote:
> Disabling partition at the parent level does invalidate all the child
> partitions under it. So it must be done with care when we disable a
> partition.
> 
> How about we give some indication that a child partition exist when reading
> cpuset.cpus.partition and recommend double-checking it before disabling a
> partition? For example, we keep track of the number of cpus delegated to
> child partitions. Perhaps we can list that information on read.
> 
> With that information available, I have no objection to allow disabling a
> parent partition with child partitions under it.

This is a general problem which has always existed regardless of whether the
errors are synchronous or not. There are many different reasons that a write
to a cpuset interface file could fail and it has never been easy to tell why
a given operation was rejected. Making error notifications asynchronous
doesn't really change anything fundamental although it does make the
situation a bit more opaque.

I'm all for improving visibility. Now that we can consolidate most error
states into a unified failure state, this might actually be easier to do.
IOW, we now just have to explain why a given cgroup is in an invalid state
rather than additionally having to explain why a given write has been
rejected, which is pretty awkward to do as those failures are transient and
local to the writer.

So, if you wanna tackle this, let's do it right and provide something
comprehensive rather than explaining just one failure.

Thanks.

-- 
tejun
