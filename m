From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 02/10] drm: Update file owner during use
Date: Fri, 21 Apr 2023 13:13:07 +0100
Message-ID: <CACvgo52Bb3kBua8dh+eac6dhSwiJLMGAdGDAa+LQYoOwCLPLNA@mail.gmail.com>
References: <20230314141904.1210824-1-tvrtko.ursulin@linux.intel.com> <20230314141904.1210824-3-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682079198; x=1684671198;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pOvME7tAXZ9JphDrU67XmOOlY2Dekn7UQzOnjzIbu/w=;
        b=dOj7qsSoqusi9JzHDMCTpPvIgyQPzCzKLm+sIKYvK1CvZPROIce1ddULWduEJd7jrh
         h9EtoGJ6m1GHmYGpXJU6/6FNPLsCuLt6cW8q2qImYUU4Me5AQY5TlzdLNG24YUAq4d/b
         zlGbTzgDvqJDlOwMKaEiRsVixMQR0LYg8I9uzwd9DuXOQdacYh2RKW3yFarSSqIZm0e5
         jXgDJyaLluMrwFMsYHZLR3DOju3AwGzSKT33SyiKGKcL6YgeBrcoJbjsBjTKixLnXlG+
         W46y8eXZCiHZVJ+VEK2Y83z5BnDuzZ4ANfbtnti4CzoG2KX/btAfDEYaiJwWihMcIxck
         x68g==
In-Reply-To: <20230314141904.1210824-3-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Greetings everyone,

Above all - hell yeah. Thank you Tvrtko, this has been annoying the
hell out of me for ages.

On Tue, 14 Mar 2023 at 14:19, Tvrtko Ursulin
<tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
> From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> With the typical model where the display server opends the file descriptor
> and then hands it over to the client we were showing stale data in
> debugfs.

s/opends/opens/

But as a whole the sentence is fairly misleading. Story time:

The traditional model, the server was the orchestrator managing the
primary device node. From the fd, to the master status and
authentication. But looking at the fd alone, this has varied across
the years.

IIRC in the DRI1 days, Xorg (libdrm really) would have a list of open
fd(s) and reuse those whenever needed, DRI2 the client was responsible
for open() themselves and with DRI3 the fd was passed to the client.

Around the inception of DRI3 and systemd-logind, the latter became
another possible orchestrator. Whereby Xorg and Wayland compositors
could ask it for the fd. For various reasons (hysterical and genuine
ones) Xorg has a fallback path going the open(), whereas Wayland
compositors are moving to solely relying on logind... some never had
fallback even.

Over the past few years, more projects have emerged which provide
functionality similar (be that on API level, Dbus, or otherwise) to
systemd-logind.


Apart from that, the commit is spot on. I like the use of rcu and the
was_master handling is correct. With some message polish this commit
is:
Reviewed-by: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I also had a brief look at 01/10, although I cannot find many
references for the pid <> tguid mappings. Be that on the kernel side
or userspace - do you have any links that I can educate myself?

Thanks
Emil
