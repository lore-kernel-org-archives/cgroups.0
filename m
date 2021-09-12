From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipc: remove memcg accounting for sops objects in do_semtimedop()
Date: Sun, 12 Sep 2021 09:05:41 -0700
Message-ID: <CALvZod5vBkoJ5PpXTW7CCMD9UjMkqK2sQuxK_LXn+W8ddDP5Nw@mail.gmail.com>
References: <90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=08mAPjyxBKrJAINcSHI5DwIe03TZTttNNN61qA9Q5BI=;
        b=WGHGy2wTwEa24xnd0LxtlPuE1NdaZtAac70TQ59rf4FCpLXG4snXCOzj26Eq9wc+ZH
         UMZSXdGP4oVIKywhZS0qlnqoWJBgiq3kFoRaOnLu6yCW1OjYKGSYnKbq8CF6T09LUNzG
         bG5Qlt8g/l/0FRrCFdRHREY54BGmwMQhd+BDMp1cIDM+GZ32/dQsjKGpcpio31T6PtPl
         Mhdu/isuIxrUBMg3L5hMWxUo1lhPHjDP0xpe50er80KHRN5LL84pMoNlommMKYVl5N4/
         mFPnJSR3HVCa8OgAe1tpUVSQ/hMCufYdKoMUNoopOXSCLZPaujn8u78vA5lM1tX7xh5e
         OkFg==
In-Reply-To: <90e254df-0dfe-f080-011e-b7c53ee7fd20-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, Sep 11, 2021 at 12:40 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> Linus proposes to revert an accounting for sops objects in
> do_semtimedop() because it's really just a temporary buffer
> for a single semtimedop() system call.
>
> This object can consume up to 2 pages, syscall is sleeping one,
> size and duration can be controlled by user, and this allocation
> can be repeated by many thread at the same time.
>
> However Shakeel Butt pointed that there are much more popular objects
> with the same life time and similar memory consumption, the accounting
> of which was decided to be rejected for performance reasons.
>
> In addition, any usual task consumes much more accounted memory,
> so 2 pages of this temporal buffer can be safely ignored.
>
> Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/20171005222144.123797-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
>
> Fixes: 18319498fdd4 ("memcg: enable accounting of ipc resources")
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Thanks Vasily.

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
