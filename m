From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 4/6] cgroup/cpuset: Allow non-top parent partition
 root to distribute out all CPUs
Date: Wed, 11 Aug 2021 08:13:33 -1000
Message-ID: <YRQTTf+bJZ8f3O3+@slm.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oxQKOHGye+MyhmSjAPDSxHRbSa9bCfsfF6Mw0U8AVzM=;
        b=PseIk0/DWf35agIBKnWlLhgPHqav/JgKG0k5s8EiUzzgeCwLBb2m1Sn/lvtUuH5hme
         WjEEyGzn9WUHoqahMfHQD95qt2HFXeHe+lGjo4+TQhLZ8x2eLz07CU5wOQN7N7FDf4Tx
         Q5gKASNRyhA5zirkx0pRzoLGzJV4xnF1foLzOV3FwlUmOCXcEkphiyuyiWuurTv7gHbm
         XsQfx+X11Ur+n5nlIGSa1ECsQz2W6k4oR66x7IL+ka3iA/RoVr9TSJHHBGqPVzE3y+xP
         XniI+cAeiv6YVDTTOOvzabO4VImKBRCNru81vDbxzRulUMBRKAjfFTRU4q8pDsZPeIxg
         WLMQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210811030607.13824-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Tue, Aug 10, 2021 at 11:06:05PM -0400, Waiman Long wrote:
> Currently, a parent partition root cannot distribute all its CPUs to
> child partition roots with no CPUs left. However in some use cases,
> a management application may want to create a parent partition root as
> a management unit with no task associated with it and has all its CPUs
> distributed to various child partition roots dynamically according to
> their needs. Leaving a cpu in the parent partition root in such a case is
> now a waste.
> 
> To accommodate such use cases, a parent partition root can now have
> all its CPUs distributed to its child partition roots as long as:
>  1) it is not the top cpuset; and

>  2) there is no task directly associated with the parent.
> 
> Once an empty parent partition root is formed, no new task can be moved
> into it.

The above are already enforced by cgroup2 core, right? No intermediate
cgroup with controllers enabled can have processes. From controllers' POV,
only leaves can have processes.

Thanks.

-- 
tejun
