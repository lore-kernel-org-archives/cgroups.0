From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Date: Wed, 16 Jun 2021 11:23:34 -0400
Message-ID: <YMoXdljfOFjoVO93@slm.duckdns.org>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4RkdmNkrf3BBo78m/TAwjqmLT/OENZZH2eOGrb77vX4=;
        b=bzw1YVXlqLHxxl0qzwq/c6+VuhQjm1Q7apIuxtL9KODROgrBOp8xFfHPc7sdYh58zK
         Qlx3fMYO2vZG2Sqt7uot9as7F2HRHaQhoL5sLOWTiYZb/ghMCKTEg1rqfXiZg44IeC/F
         vzDKzrZnhMmo6h2PyiMMna8wFpVapRgjYKymXkGnijnQ74KqiFUZLrNFRvmzAQK40Wvc
         StrYm4C8OG7gM6fi2qit+uz6odcqhOPiJN8rKAL92+PumUvpkXcIS3w13gT4L6y2oCsW
         eX5cbx/HLm4kTGoXWUvQ46S+xa/OBpHAxIo57bMx6Kmrpuga5JrIoSd36nPP+VouLgIg
         muXg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210616125157.438837-1-paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Purdie <richard.purdie-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Hello,

On Wed, Jun 16, 2021 at 08:51:57AM -0400, Paul Gortmaker wrote:
> A fix would be to not leave the stale reference in fc->root as follows:
>=20
>    --------------
>   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dput(fc->root);
>   +               fc->root =3D NULL;
>   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deactivate_locked_super=
(sb);
>    --------------
>=20
> ...but then we are just open-coding a duplicate of fc_drop_locked() so we
> simply use that instead.

As this is unlikely to be a real-world problem both in probability and
circumstances, I'm applying this to cgroup/for-5.14 instead of
cgroup/for-5.13-fixes.

Thanks.

--=20
tejun
