From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 10:28:06 -0500
Message-ID: <60c59bed-d9aa-5e49-7a1b-d3463ff267ad@redhat.com>
References: <20221128033057.1279383-1-longman@redhat.com>
 <20221128140631.GI25160@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669649292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omHAWSGVOrqdistvF1mI4veeF3fLfIz9T/z0L/hp1Dw=;
        b=IxOr4AytRl94kiG5gnH1ChBIhDpasQw8MFIoYWRCy67om+lp0UAmrsInvI/6Yi8CQNfKff
        54y2qSgOI05pRdq8Zmb+VXyzTKcFamZv4ZFx3CFvizbuGAO22PAhXiSxmwr36BrtpdlmjO
        LOUVyrV+SGNR1IuFCnABOG6K6iI5bec=
Content-Language: en-US
In-Reply-To: <20221128140631.GI25160-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 11/28/22 09:06, Michal Koutn=C3=BD wrote:
> Hello.
>
> On Sun, Nov 27, 2022 at 10:30:57PM -0500, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> That may not be true if there is no blkg associated with the blkcg. If
>> css_get() fails, the subsequent css_put() call may lead to data
>> corruption as was illustrated in a test system that it crashed on
>> bootup when that commit was included.
> Do you have a stacktrace of the underflowing css_put() in
> blkcg_destroy_blkgs()?
>
> It looks to me slightly as a mistake of the caller site that it passes
> struct blkcg * without any references.
>
> By a cursory look, could it be cgwb_release_workfn?
>
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -390,11 +390,11 @@ static void cgwb_release_workfn(struct work_struct =
*work)
>          wb_shutdown(wb);
>
>          css_put(wb->memcg_css);
> -       css_put(wb->blkcg_css);
>          mutex_unlock(&wb->bdi->cgwb_release_mutex);
>
>          /* triggers blkg destruction if no online users left */
>          blkcg_unpin_online(wb->blkcg_css);
> +       css_put(wb->blkcg_css);
>
>          fprop_local_destroy_percpu(&wb->memcg_completions);
>
> Does your crash involve this stack?

That looks like a possible cause for the system crash that we are=20
seeing. In my testing, I do see one case out of more than a dozen calls=20
to blkcg_destroy_blkgs() where css_tryget() fail in the reproducing=20
system during bootup. However, I didn't force a stack dump at that point=20
and so I am not sure if that is the place, though it looks likely. One=20
of the crashes that was reported does involve blkcg_unpin_online(). So=20
maybe that is it.

Cheers,
Longman


