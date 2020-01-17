From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: Iterate tasks that did not finish do_exit()
Date: Fri, 17 Jan 2020 10:41:29 -0800
Message-ID: <CAJuCfpFqEUVFXsjD8XcCKsGXKTf72r0Ek5_1yqu_k5UZAssKTw@mail.gmail.com>
References: <20200116043612.52782-1-surenb@google.com> <20200117151533.12381-1-mkoutny@suse.com>
 <20200117151533.12381-3-mkoutny@suse.com> <20200117172806.GK2677547@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hl2KZMvca+Q8kuDbq/WhLs/Rb2uaYU/dE+p/JdLh8Ok=;
        b=pya+t3ljvih0NEjKSrRArdnH313MxZONXt8kTq2RCSmOCsZP7KR3baPZAFPehTPQxx
         VuKQfkLNIc4O7hDdNydFUo+Rit+LleyvNPqIqy5948KMTJxnyj2MVgDSFofqnZqQS5Nx
         Or3Zo594/EnJk39EWoCRDMjG4V8NF2BmHRXws3l/1nFpofa/+Bvxs6YNhCcdsqG7x3wk
         vR24AbaUtYr8X6KA5iQGuwz6Z7LgbIrcG2vC/4HLMaSGjk6nSLQU3vF89b7ikkhwAMpc
         A800IqSQpGRJuHLz6yxrYHsfaVbVemOGjrYeY0sTZTYGZtjBtpiMZzaKyNvlSn/ysOZH
         U/KQ==
In-Reply-To: <20200117172806.GK2677547-LpCCV3molIbIZ9tKgghJQw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, kernel-team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, JeiFeng Lee <linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Tom Cherry <tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Jan 17, 2020 at 9:28 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, Jan 17, 2020 at 04:15:32PM +0100, Michal Koutn=C3=BD wrote:
> > PF_EXITING is set earlier than actual removal from css_set when a task
> > is exitting. This can confuse cgroup.procs readers who see no PF_EXITIN=
G
> > tasks, however, rmdir is checking against css_set membership so it can
> > transitionally fail with EBUSY.
> >
> > Fix this by listing tasks that weren't unlinked from css_set active
> > lists.
> > It may happen that other users of the task iterator (without
> > CSS_TASK_ITER_PROCS) spot a PF_EXITING task before cgroup_exit(). This
> > is equal to the state before commit c03cd7738a83 ("cgroup: Include dyin=
g
> > leaders with live threads in PROCS iterations") but it may be reviewed
> > later.

Tested-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

>
> Yeah, this looks fine to me.  Any chance you can order this before the
> clean up so that we can mark it for -stable.
>

+1 for reordering. Makes it easier to backport.
Thanks,
Suren.

> Thanks.
>
> --
> tejun
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
>
