From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] ipc: remove memcg accounting for sops objects in
 do_semtimedop()
Date: Tue, 14 Sep 2021 16:23:16 +0200
Message-ID: <20210914142316.GA23024@blackbody.suse.cz>
References: <90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com>
 <YT8NrsaztWNDpKXk@dhcp22.suse.cz>
 <CALvZod7Y4pC4XvqVp+tJ==CnS5Ay8YPqrxeUzA8tMLu+0U3hjQ@mail.gmail.com>
 <YUBLrJOL6DGxmira@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631629398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPLjlxNiMy8SE7UjNTK8tngq7pn7HiFIBgi/dU4IiY4=;
        b=RHBOwzDGUJPzZPe5F1N+ijWFfwWf18Vb1viFqcFbzGn1pNyswLU9xhfJWkC3kfqxfT3cQK
        ASD9bWHOnAZDFsQpQ1ynhod/htXkglaRNsUdBxKpn7/nI/xk19+CoO4aINaWO4k22bBslH
        d1n25oTi+dd0w5BtyfqC7w+1HHmLwYM=
Content-Disposition: inline
In-Reply-To: <YUBLrJOL6DGxmira-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Sep 14, 2021 at 09:13:48AM +0200, Michal Hocko <mhocko-IBi9RG/b67k@=
public.gmane.org> wrote:
> "
> This object can consume up to 2 pages, syscall is sleeping one,
> size and duration can be controlled by user, and this allocation
> can be repeated by many thread at the same time.
> "
>=20
> It sounds like a problem, except it is not because? A worst case
> scenario evaluation would be beneficial for example

AFAICS, the offending allocation is in place only during the duration of
the syscall. So it's basically O(#tasks).
Considering at least 2 pages for task_struct + 2 pages for kernel stack,
back of the envelope calculation gives me the footprint amplification is
<1.5.
The factor would IMO be interesting if it was >> 2 (from the PoV of
excessive (ab)use, fine-grained accounting seems to be currently
unfeasible due to performance impact).

The commit message can be more explicit about this but to the patch
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
