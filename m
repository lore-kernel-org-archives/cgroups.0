From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 04/10] memcg: enable accounting for fasync_cache
Date: Tue, 27 Jul 2021 14:50:50 -0700
Message-ID: <CALvZod6H8atu5k3xhKf11SEMjyVjXMYFGWKBLsXStYhYs3FNCw@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <1b408625-d71c-0b26-b0b6-9baf00f93e69@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5GJDqmdaLtkaW7Otz+OuKF+u9n9yLDONH7a1pUz+R4g=;
        b=vU99ZBKDzMVUNqf5sfsmKOTh7f/nFBljme/8vZdWEh6VMl+6pjjr+Fh1/llaa1Tmu6
         E9e293cJN6TpD5hWLPrX7NX8k8plP1ci4gLMwOoW9HRfOhn/zBJTz95wIGo8wmUwy72t
         Q8tIijJECxZZ/W7XHUlaS1CYRF5ZbobafO8eG4ZXzbODrSoQrWT+KHtcnPJ+eTgQiKCN
         PGhFkiev0aEVZ+yPmByqlCAKbem3VGZ8EI60BhFe7uveUqq3jRNUoMwJTeq236JUuDip
         Qoxh+xV/V4nysMXdXY/TVCpkHGqeXFqXWYC3SFsVAGOZZIfMsH+Nw6n2bnmPy0sihGCH
         GWEw==
In-Reply-To: <1b408625-d71c-0b26-b0b6-9baf00f93e69-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 26, 2021 at 10:33 PM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> fasync_struct is used by almost all character device drivers to set up
> the fasync queue, and for regular files by the file lease code.
> This structure is quite small but long-living and it can be assigned
> for any open file.
>
> It makes sense to account for its allocations to restrict the host's
> memory consumption from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
