From: "Daniel Xu" <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Subject: Re: [PATCH 0/2] Support user xattrs in cgroupfs
Date: Tue, 03 Mar 2020 11:20:32 -0800
Message-ID: <C11FZ3TMTIH1.2KP5NIUPPQBWT@dlxu-fedora-R90QNFJV>
References: <CALvZod5m3otRRqcLBebbgiZbhoYWAMbMg+ESkacJuj64OP
 =H4Q@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:cc
        :subject:from:to:message-id; s=fm2; bh=FJ6KELxyo/zYZfyW+0Pn8m70T
        4Tx2JSVTx48BzYMJvg=; b=tkLGfZkSv5J9psMO+WQWVj4I6UVu6g4z0tOr6y64Q
        qasyR5Q7LFNOS3wRB1Fts5bIDy7jD6TnGYbt+QVV3wjIhzY5xzKPydwZGckLaWCv
        iZN3EUeGwRvu65muDaE60yATilaeeEYLUxIvyWCe08GETO4Hp6O0isa1rpaaoM2c
        Gex1JZn7kNhZnmJhCsHFOwzMK2ylg5NgqK50fMt4C+8v9RJ02un+mOtLf+4iB7FZ
        9h08uWg/Kl2rJ5nytZZhT4JXuKH5QGKsfUUw9NsXDYyNcQFEU7Lxr80NWb5kQvyX
        LtT7YAGyMQbu/s5aG881J7UR5CjYgftzAzqPwV/aVyvPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FJ6KEL
        xyo/zYZfyW+0Pn8m70T4Tx2JSVTx48BzYMJvg=; b=hy/0/NtTPq7PPl0uM4niAG
        Os5W20Gk/M2MwlNSZ/RxvXdWcQEE93Ilam/7BN+uUm4qeFiWW4lpWhCxBhKBWoDC
        b42sPcbuwWU/LLmwGAE2lGmti6noCFUSjjj0ZXNMhtHVgTH8TC723SbGZdagCDMB
        LR22vsFb7I0pumNzENvll+8iJ7thsaUXedFPzRFckiBjpr7LhfYp5q2Fb3tifKKC
        WX5TJNBdxUhaQWozRsKVGFafjtvsXLCr/479LMPQMjG6BCH5wcAD1uKEfDnI2CaD
        EI7T3r0f5iVSi6y5m3cjQZhH4UAH2F2IF2c2iNtr4+v8hMh+mi7BzuZDrn3Wgvvw
        ==
In-Reply-To: <CALvZod5m3otRRqcLBebbgiZbhoYWAMbMg+ESkacJuj64OP
 =H4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue Mar 3, 2020 at 8:50 AM, Shakeel Butt wrote:
> Hi Daniel,
>
>=20
> On Mon, Mar 2, 2020 at 5:42 PM Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org> wrote:
> >
> > User extended attributes are useful as metadata storage for kernfs
> > consumers like cgroups. Especially in the case of cgroups, it is useful
> > to have a central metadata store that multiple processes/services can
> > use to coordinate actions.
> >
> > A concrete example is for userspace out of memory killers. We want to
> > let delegated cgroup subtree owners (running as non-root) to be able to
> > say "please avoid killing this cgroup". In server environments this is
> > less important as everyone is running as root.
>
>=20
> I would recommend removing the "everyone is running as root" statement
> as it is not generally true.
>
>=20
> Shakeel

Good point, thanks.
