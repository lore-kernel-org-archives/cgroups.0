From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] sched/cpuset: Fix DL BW accounting in case
 can_attach() fails
Date: Thu, 23 Mar 2023 10:33:22 +0100
Message-ID: <ZBwc4l0ZyyRQPiSP@localhost.localdomain>
References: <20230322135959.1998790-1-dietmar.eggemann@arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679564008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UvjK3G8PubwXqQtONySfIeDtd3meQ2XWO8kr4rkCdUw=;
        b=Zlw1Ha0OeDKk3ojOBCbTMc0J/NhGBylv+k2yRgK50nD+BJGInUxi4207Gu1mJf3s12qPZh
        Inqjqbw/GSJL+Ck4yjAiD9JJPzGFq+e9/iuVL1EeOvF4N0iU8GJD2l9U0jky+jxnPjYg1A
        JVTKvcvUhOYf29UpmZX41niy798HyGA=
Content-Disposition: inline
In-Reply-To: <20230322135959.1998790-1-dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luca Abeni <luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Tommaso Cucinotta <tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 22/03/23 14:59, Dietmar Eggemann wrote:
> I followed Longman's idea to add a `deadline task transfer count` into
> cpuset and only update the `dl task count` in cpuset_attach().
> 
> Moreover, I switched from per-task DL BW request to a per-cpuset one.
> This way we don't have to free per-task in case xxx_can_attach() fails.
> 
> The DL BW freeing is handled in cpuset_cancel_attach() for the case
> `multiple controllers and one of the non-cpuset can_attach() fails`.
> 
> Only lightly tested on cgroup v1 with exclusive cpusets so far.

This makes sense to me. Thanks for working on it!

Guess I might incorporate these in my (RFC) series and re-post the whole
lot?

Best,
Juri

