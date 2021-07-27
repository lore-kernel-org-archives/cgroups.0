From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 01/10] memcg: enable accounting for mnt_cache entries
Date: Mon, 26 Jul 2021 23:44:40 -0700
Message-ID: <CALvZod6YaVBqV_LrqgXO13kBS20uoXdm5EGx2CJfBfPC9yj6Cg@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <045db11f-4a45-7c9b-2664-5b32c2b44943@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Euv6d/VBn7xvedb0PcbV5a82pu9t4491iTmwHLNJp7I=;
        b=RWdMBsMjYyJoxlc/1RTqMFBbaC2BMCSQiiV07WITf1eAPO7CdkgOCGLOi85FCEytyG
         epbIRnbdA64sEVrCWsA+Sjzgms3sc8nhuX1+nYHpHoGfaWREoLPxrN0+0qUFEVo3jBu5
         TJd06PEdQUlVpDDylyAWH/jbeyIPyTIQpdGDd3duk0GK4HkIVbXt5RIZyJRjhTLVSbnF
         XyE4b8SzFvCaCSUkH3TzVyN/Z/yBhQrstGZUxPpjdKZYQWOHZaEB3U1QWc/OgFXL4AL6
         sbdHBNs2OkPvH5NhRlwEwicjEFFQ+GaV6kM+oBVOHqMf1eUehW4WeYqI+mDfDDC/U2ye
         b3WQ==
In-Reply-To: <045db11f-4a45-7c9b-2664-5b32c2b44943-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 26, 2021 at 10:33 PM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> The kernel allocates ~400 bytes of 'strcut mount' for any new mount.

*struct mount*

> Creating a new mount namespace clones most of the parent mounts,
> and this can be repeated many times. Additionally, each mount allocates
> up to PATH_MAX=4096 bytes for mnt->mnt_devname.
>
> It makes sense to account for these allocations to restrict the host's
> memory consumption from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
