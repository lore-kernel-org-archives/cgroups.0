From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/6] sched/cpuset: Bring back cpuset_mutex
Date: Thu, 27 Apr 2023 07:53:27 +0200
Message-ID: <ZEoN1wq47uhE201p@localhost.localdomain>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-3-juri.lelli@redhat.com>
 <fa585497-5c6d-f0ed-bdda-c71a81d315ad@redhat.com>
 <ZEkRq9iGkYP/8T5w@localhost.localdomain>
 <d53a8af3-46e7-fe6e-5cdd-0421796f80d2@redhat.com>
 <CAB8ipk-ns=d+jNkKi1sjkSQmQidziCj34COkHZt6ZkRiG47HHA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682574821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TACSMy7Ug2sStH4pdeuOCgf93fUckqHIu/mqCYHofQw=;
        b=BExXH43zl/lMYtMnqZ0Gwm5AbDjCLKnqu/VOISxih+bqLuXw9gU7aHjiWZYk9eXDFS9bsq
        k8+VPn8C3y5409KO+DHR1cz7ITJhcmXSbmfpDBiLGNjYKtNRv/flVv8rUOVnqrDMcJ/tfU
        Rf1sIjm50WVEYEvOVkiqf+CW7uv6avw=
Content-Disposition: inline
In-Reply-To: <CAB8ipk-ns=d+jNkKi1sjkSQmQidziCj34COkHZt6ZkRiG47HHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

Hi,

On 27/04/23 10:58, Xuewen Yan wrote:
> HI Juri,
> 
> Would this patch be merged tobe stable-rc? In kernel5.15, we also find
> that the rwsem would be blocked for a long  time, when we change the
> task's cpuset cgroup.
> And when we revert to the mutex, the delay would disappear.

Honestly, I'm not sure. This change is mostly improving performance, but
it is also true that it's fixing some priority inheritance corner cases.
So, I'm not sure it qualifies for stable, but it would be probably good to
have it there.

Thanks,
Juri

