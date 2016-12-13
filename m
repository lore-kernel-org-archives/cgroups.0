From: =?UTF-8?B?SmVzw7pzIFJvZHLDrWd1ZXogQWNvc3Rh?= 
        <jesus.rodriguez.acosta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.10] cgroup: cgroup_sk_alloc() is allowed to
 increase reference on a dead cgroup
Date: Tue, 13 Dec 2016 09:57:49 +0000
Message-ID: <CAH=7=un2UhE30+-eZ22QhEvD6t4O60DA74pjjUDc4=ZLXPH_aQ@mail.gmail.com>
References: <CAH=7=un56LL12Meu0j+6+ZRcdsnUHomfDLuq=raC6ZtQEwLqTA@mail.gmail.com>
 <20161212214811.GJ13864@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4zbuyxtKCGnPbZJRnnQYAsL7WX+X3oFD5Hr7TC6BQ7w=;
        b=hu0VosKLnFfMOkvvzK5cFh2Kb9ZYaXTJehKXtM0/Y7l7kS5td3non/KTgZAPnOnWOa
         lTkMI6Naw6DbaXDqF78wiQNteM6N6lsQvZ88xrVakuCIN2DxWBVNZTlpMh7uj83/u9uZ
         kTc5qjfyp3cpkonsznl9RcoawvV9tjFmsEhRbq3pMhY68NdXvsPj/1iUIg3e3K91CX5q
         qQflegNFJ0JifxgK7QKElJi+4g6AQ4YbCPMVTYqV/21YFqWlZCivkGDGA+HrlJKGozcJ
         KiwujQ4fqq6UmNLIILoB6SPG5yf1kQl3O2t02FlHvQJCXpA5LNDfpMEtWphIakrI9uP7
         3gzg==
In-Reply-To: <20161212214811.GJ13864-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun, hi all:

I applied the patch this morning and I'm happy to confirm you that the
warning went away.

Thank you!
Un saludo,
Jes=C3=BAs Rodr=C3=ADguez Acosta

--
http://es.linkedin.com/in/jesusrodriguezacosta
(+34) 653 79 09 64

IMPORTANTE: Este mensaje de correo est=C3=A1 destinado =C3=BAnicamente a la
persona o entidad a la cual se dirige y puede contener informaci=C3=B3n
privilegiada, confidencial y/o de acceso restringido seg=C3=BAn la
legislaci=C3=B3n vigente. Si usted no es el destinatario indicado, por la
presente queda informado de que cualquier uso, distribuci=C3=B3n o copia de
la comunicaci=C3=B3n est=C3=A1 estrictamente prohibido. Si usted ha recibid=
o
esta comunicaci=C3=B3n por error, por favor, av=C3=ADseme de inmediato. Gra=
cias.

IMPORTANT: This email message is intended only for the use of the
individual to whom, or entity to which, it is addressed and may
contain information that is privileged, confidential and/or exempt
from disclosure under applicable law. If you are NOT the intended
recipient, you are hereby notified that any use, dissemination,
distribution or copying of the communication is strictly prohibited.
If you have received this communication in error, please notify me
immediately. Thank you.


2016-12-12 21:48 GMT+00:00 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> Jes=C3=BAs,
>
> I applied the following patch to cgroup/for-4.10 and will soon push
> out to Linus.  I'm pretty sure this is what you saw but can you please
> verify that the warning goes away with it applied?
>
> Thanks a lot for the report.
>
> ------ 8< ------
> From 89bb3eed858ec2ea36ceae822bbf81f1ef24e80d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Mon, 12 Dec 2016 16:30:29 -0500
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> When a listening socket associated with a cgroup creates a new
> connection, it gets cloned and the reference on the cgroup is
> incremented by calling cgroup_get().  Such a socket can be left behind
> in an empty cgroup after processes are migrated away from it.  As an
> empty cgroup may be removed, the socket may end up trying to clone new
> sockets while associated with a removed cgroup.
>
> This doesn't break anything in terms of reference counting; however,
> as a precaution, cgroup_get() triggers WARN when it's called on a
> removed cgroup, which cgroup_sk_alloc() can trigger spuriously.
>
> We know this path is legit, open code cgroup_get() in
> cgroup_sk_alloc() without the sanity check to avoid spuriously
> triggering the warning.
>
> Reported-by: Jes=C3=BAs Rodr=C3=ADguez Acosta <jesus.rodriguez.acosta@gma=
il.com>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Link: http://lkml.kernel.org/r/CAH=3D7=3Dun56LL12Meu0j+6+ZRcdsnUHomfDLuq=
=3DraC6ZtQEwLqTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning soc=
kets")
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.5+
> Cc: Johannes Weiner <jweiner-b10kYP2dOMg@public.gmane.org>
> ---
>  kernel/cgroup.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 85bc9be..7fe26595 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -6318,9 +6318,13 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd=
)
>         if (cgroup_sk_alloc_disabled)
>                 return;
>
> -       /* Socket clone path */
> +       /*
> +        * Socket clone path.  We open-code cgroup_get() here to avoid th=
e
> +        * cgroup_is_dead() sanity check as a listening socket left in a
> +        * dead cgroup can still get cloned for new connections.
> +        */
>         if (skcd->val) {
> -               cgroup_get(sock_cgroup_ptr(skcd));
> +               css_get(&sock_cgroup_ptr(skcd)->self);
>                 return;
>         }
>
> --
> 2.9.3
>
