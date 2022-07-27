From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH cgroup/for-5.20] cgroup: remove "no" prefixed mount
 options options
Date: Wed, 27 Jul 2022 11:27:15 +0200
Message-ID: <20220727092715.GA1569@blackbody.suse.cz>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <20220726143246.GA23794@blackbody.suse.cz>
 <YuBIACfZDk72yjI3@slm.duckdns.org>
 <YuB5ICv3bXsy5Xuh@slm.duckdns.org>
 <YuB9QXapVUy1t8TZ@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658914036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=anqnE2KfGtEVOPeKnZ+sVTbUC4usJ64Dv0txy9AxFfA=;
        b=uD35DKCURHlRIeXliZPxVGX4Y/Z6a5x/Vgou/m87fXh1CMhyJePsMik/zc2Sr1ocVRvviC
        S6y/HKcJCUM7rvIrjV4zE7FmLlq9YJisl5zB1wltvJbZumHGP5r1BwfyDXLWvgrszCjy3e
        tB2ROOFWjOPeSrcVzcYJPrHQSccQqZ4=
Content-Disposition: inline
In-Reply-To: <YuB9QXapVUy1t8TZ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 26, 2022 at 01:48:17PM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
Thanks.

> While a bit confusing, given that there is a way to turn off the options,
> there's no reason to have the explicit "no" prefixed options. Let's remove
> them.

This is sensible...

>  Documentation/admin-guide/cgroup-v2.rst |    8 ++++----
>  kernel/cgroup/cgroup.c                  |   24 ++++--------------------
>  2 files changed, 8 insertions(+), 24 deletions(-)

...and cleaner.

Michal
