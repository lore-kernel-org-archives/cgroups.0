From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 6/7] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 12 Jan 2022 11:21:00 -1000
Message-ID: <Yd9GPLytGQ6XpYK6@slm.duckdns.org>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-7-longman@redhat.com>
 <Ybe0YWEo7Wp7wib9@slm.duckdns.org>
 <20211215144450.GC25459@blackbody.suse.cz>
 <96018978-6b7f-1e7f-1012-9df7f7996ec5@redhat.com>
 <Ybo1jmNvM6sblcJq@slm.duckdns.org>
 <58c06961-ffc4-27d7-01d2-4c91b0c9161d@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rMcwZZyzD4aLSfK+vIDiFeDvvWtNOlRHmP8s8YMbIOw=;
        b=cFPRS+JHB1Ou8jEaT14elVfUqR6AB4wKvYBEFO27k2tF4/lrAdI4f0HyAhDpya/8aq
         SrxqhX8tP4MI5XV07OmN2PrmxE6y7yWDkS4TX2B1INkQeStdjgsMy5W0OXIFVNWGT+gu
         +e3d0s49VBZnfheeE9DgxcL43vHldgvfMEoYrGz21MXCYL7qgfpt56PSaDwqjGYHwSZu
         NEd6rDSnG7qTwCZ/rOefH96fXbEToEeEUu174yrHx/F4pPyEXUUwfrDSJy9lYYawK/TL
         7+VcwPqszEk03hVL1tXf4YEaW2ESnnOW9ZhGRWWDqjasA64N3q3tQZ9PdCxJl+AKvKIr
         bvnw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58c06961-ffc4-27d7-01d2-4c91b0c9161d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Dec 15, 2021 at 01:55:05PM -0500, Waiman Long wrote:
> How about we allow transition to an invalid partition state but still return
> an error?

Like -EAGAIN as Michal suggested? I don't know. I understand the motivation
but one problem is that error return usually means that the operation didn't
change the state of the system and that holds even for -EAGAIN. So, we'd be
trading one locally jarring thing (this thing is asynchrnous and the actual
state transitions should be monitored separately) to another one which is
jarring in a wider context (this thing returned error but the system state
changed anyway). To me, the latter seems noticeably worse given how common
the assumption that an error return indicate that nothing actually happened.

We have other cases where we split operation submissions and completions
(aios being the obvious one) but I don't think we have any where -EAGAIN
indicates successful initiation of an operation. At least I hope not.

Thanks.

-- 
tejun
