From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: bpf: use cgroup_lock()/cgroup_unlock() wrappers
Date: Fri, 3 Mar 2023 13:03:20 -0800
Message-ID: <CAADnVQJcKAvhUqJO9HJUQu6BfRw=dN=q+0o3CdhHX0Ei9-waAw@mail.gmail.com>
References: <20230303095310.238553-1-kamalesh.babulal@oracle.com> <ZAJfB/LuHtE5Iq3i@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xllx/4GgK01h9KDl9QewJkuHS87v6oTCMIDEx+iw3vI=;
        b=nDA7wfgEeJY40M+BaOy5eLe+6K/mkMQ4ReZ3tVGy+7wnuxcu4rILBVqRr5d6NzNy1w
         L9mVFPg5YsE+mkRbm/WgFDkL0yLWJSullyuVZm17sInKeDvCjBsX+1JIvg6T8yrFDsBT
         gIdkYGw8t1uZszwPOGzQYxzD5xkgBoboc+UBWD0GpMnuy+9tTesdFioEnEbIM8ASv9Fp
         sxwJd3sGxsEKY4fwpR+qCCgxcaES2AC9KNvVTCr8vWiX8Bs6McXFflYJNm1py/PvBMVt
         KPNHFjYa/pK9x7fYiN5HENdp4xObGIVxDYuwM4Yrd5qaCr9SGTePiO9w1epqhkFGhg46
         mZiw==
In-Reply-To: <ZAJfB/LuHtE5Iq3i-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Mar 3, 2023 at 12:56=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Mar 03, 2023 at 03:23:10PM +0530, Kamalesh Babulal wrote:
> > Replace mutex_[un]lock() with cgroup_[un]lock() wrappers to stay
> > consistent across cgroup core and other subsystem code, while
> > operating on the cgroup_mutex.
>
> cgroup_[un]lock() were added because multi-gen lru wanted to lock
> cgroup_mutex from code which may be enabled even when cgroup is not enabl=
ed.
> That's the only place where that's the case. Hmm... it doesn't really mat=
ter
> I guess. Yeah, let's do this.
>
>   Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Alexei, if you wanna take it through the bpf tree, please go ahead.
> Otherwise, I can route it through cgroup tree.

Either way is fine. diff stat says that cgroup directory has more changes,
so probably lesser chance of conflicts if it goes through cgroup tree.
So go ahead. Pls add:
Acked-by: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
