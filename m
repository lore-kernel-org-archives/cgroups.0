From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipc: remove memcg accounting for sops objects in do_semtimedop()
Date: Mon, 13 Sep 2021 21:32:25 -0700
Message-ID: <CALvZod7Y4pC4XvqVp+tJ==CnS5Ay8YPqrxeUzA8tMLu+0U3hjQ@mail.gmail.com>
References: <90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com> <YT8NrsaztWNDpKXk@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fu4lIl+FKgt34SvsZzswMOLfBBmVaqouMxJqzvs5GUE=;
        b=Wz8/qbTPuO2gFsebTp8dF07QwNkcGKHJMIVgEfNxylqPVZk6OBBEkaVAdxFl12egu7
         l97RUWL/RGR8c934GwssB4/036sjsHpT9g0uqhwaOqSjYuXOsqG1yftRdoOu/8BIc9cl
         6voG47yQxfvp9VzEVI9Iif5Icr86qsK7yGWbgCOsrBwFx2Jr+WK4n9+Syk4/kwti/G0V
         nM5qOvg8C/2cJB40l7jsLaIeAnGw2ZFv+dElbWu8D9BO2Gt6R30tVUrztrdx7+U1Yux6
         xFN2S8CNPAjBD2AY+FHArieeB3XWjHrOCCqrKRk/SSiCyDCnoxoBZeRQWTVCBTZLYVi8
         dT9Q==
In-Reply-To: <YT8NrsaztWNDpKXk-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 13, 2021 at 1:37 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
[...]
> > However Shakeel Butt pointed that there are much more popular objects
> > with the same life time and similar memory consumption, the accounting
> > of which was decided to be rejected for performance reasons.
>
> Is there any measurable performance impact in this particular case?
>

I don't think there was any regression report or any performance
evaluation. Linus raised the concern on the potential performance
impact. I suggested to backoff for this allocation for now and revisit
again once we have improved the memcg accounting for kernel memory.
