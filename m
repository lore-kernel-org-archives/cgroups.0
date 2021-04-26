From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] ipc: use kmalloc for msg_queue and shmid_kernel
Date: Mon, 26 Apr 2021 09:23:26 -0700
Message-ID: <CALvZod4oW1jPJtR938zSAMBaeKdJ82NAa1Ht858XLrmWWSiCTw@mail.gmail.com>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com> <b0845b85-f4fe-601d-3328-d707d7db27f5@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rPEBwOmjBEydXEY6alqbD5j0u/fm5bOySKZNXJROtWY=;
        b=CBzfFfpbQdGiZGklxymOeIysY8Y6hqvvafywuFnyZm6XCRiozmcpptpmxATr6B3N0Y
         2vwiwSapsbNuusSQtu58mBVhgW2QufIP9TM7J5pSkb6mERUc7qS7rFqBzMSa7TMMT0Ou
         bvy/yy4qDXOWefutGUTPkcbmAWaGWd2I7Bf8VRdRNzYB5RiXDnllKR8T6O/snx2YxBgz
         gOjFmCC5Oowjjx0oMclL3mq4z8LkEUcHSNaDxKmuBjoBgGa9Rie1o9m6vWmlh38T/4uB
         31FPfSi2QMEmYeOxCHwkimIbpn2jrkbI2cLUrJbzyKLI91rhSgM28PmMv2Zd9zVHP2C6
         Fjvg==
In-Reply-To: <b0845b85-f4fe-601d-3328-d707d7db27f5-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Apr 26, 2021 at 3:18 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> msg_queue and shmid_kernel are quite small objects, no need to use
> kvmalloc for them.
> Previously these objects was allocated via ipc_alloc/ipc_rcu_alloc(),
> common function for several ipc objects. It had kvmalloc call inside().
> Later, this function went away and was finally replaced by direct
> kvmalloc call, and now we can use more suitable kmalloc/kfree for them.
>
> Reported-by: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
