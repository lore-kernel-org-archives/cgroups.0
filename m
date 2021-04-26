From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] ipc sem: use kvmalloc for sem_undo allocation
Date: Mon, 26 Apr 2021 09:22:41 -0700
Message-ID: <CALvZod4odrSHAbizhxZggk3debNawz5gLph50f=xmJWS66iAwA@mail.gmail.com>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com> <722774d8-d46b-f8a6-a88e-3c56b4968622@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1oXQ0k3C+TJ3+pK/S1RsiGeYgBqWj1N5rB2o3PFlsA=;
        b=BUxoyU4CiG9iUane0XR67GRpWWSdf87lIDjVSy1iIQhILWMI3zn4M9c/PriB5DLhe+
         xCBtdkuK5mCMtR/TxvOM1X58GqWMn7eIjzEvaRMSdJM2B2pVV/j/QBqA/s81v/XH2oh7
         wa9+RZi580kYMAhvqA+0g0+Gqy/mPDEpEA8DKQvPtgQHIHgBLOWNGb0SHSco3ZpL7RDF
         vZchyLvdNZxR3U+K1AHKxglHyrOtrfmpgU4FCaSnFOVrQIkSJoiLWOtUoZha4RuESPYI
         rUud5LZCVHgWyhQmNsjfHZUIOpPaegPtpUAYlUH+GdSOqCfMHiF5p93zVD6bCkB1Izeu
         tQXg==
In-Reply-To: <722774d8-d46b-f8a6-a88e-3c56b4968622-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Apr 26, 2021 at 3:18 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> size of sem_undo can exceed one page and with the maximum possible
> nsems = 32000 it can grow up to 64Kb. Let's switch its allocation
> to kvmalloc to avoid user-triggered disruptive actions like OOM killer
> in case of high-order memory shortage.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
