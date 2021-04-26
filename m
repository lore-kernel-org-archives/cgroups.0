From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Mon, 26 Apr 2021 09:08:32 -0700
Message-ID: <CALvZod5=eLQMdVXxuhj9ia=PkoRvT5oBxeqZAVtQpSukZ=tCxA@mail.gmail.com>
References: <20210423171351.3614430-1-brauner@kernel.org> <YIbRZeWIl8i6soSN@blackbook>
 <20210426152932.ekay5rfyqeojzihc@wittgenstein>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCAc8uLKViQfUk6B9sQWnMNVd4nGJwcjR6PW4cxuT2A=;
        b=MzCzIiVtMu1qdJI/u9e7KD/8RmMP8y12i8ZSPtKP62d9lMQPum9lvtHdiRC8oHx/qh
         XffKtPgLq0Su+RJ5q+ESjxgur66Phf9k8nqh+RdvNdoD6KiKthenym8pjlzysAYqMRvC
         yE2VYwXpeTkAQi9kbB/QfLC3XmyzDBLuBx68WBxljpr74J3xca1Y28ExEDwCa1LPOt7o
         BO8bwn4beRzTJFNsB4ILYHbHvyPK0hgk9pDcAhk111GosEN6pkXxitqOCD+JcFO3ChkL
         IWe25tp7V5+Csw1QtUmxLzsIVfvrOV3eS3Mo6KhGSeY9FgLN+KCvIr7TbRmS96MP00Zy
         TAig==
In-Reply-To: <20210426152932.ekay5rfyqeojzihc@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Apr 26, 2021 at 8:29 AM Christian Brauner
<christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
>
[...]
> > Have you considered accepting a cgroup fd to pidfd_send_signal and
> > realize this operation through this syscall? (Just asking as it may
> > prevent some of these consequences whereas bring other unclarities.)
>
> That's semantically quite wrong on several fronts, I think.
> pidfd_send_signal() operates on pidfds (and for a quirky historical
> reason /proc/<pid> though that should die at some point). Making this
> operate on cgroup fds is essentially implicit multiplexing which is
> pretty nasty imho. In addition, this is a cgroup concept not a pidfd
> concept.

What's your take on a new syscall cgroupfd_send_signal()? One
complexity would be potentially different semantics for v1 and v2.
