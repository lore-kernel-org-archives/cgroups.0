From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: Return error when attempting to migrate a
 zombie process
Date: Tue, 9 May 2023 12:03:48 +0200
Message-ID: <cetfatnt2cy2pmcskg243ebau36au2vy6fi6mu7hpgg3e7kjp4@gg7l5zoix4xt>
References: <20230503125359.14789-1-mkoutny@suse.com>
 <ZFVTRdP6eK1soMVR@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kajz4hm6ew66s2tm"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683626629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jVOcH3ojLkF2oleErumS69jiq2T/Qhx9NHw4f5gaQfM=;
        b=EkRevYyx8PlFZqTaDOGZUy0A3OlcDuXYp+8WnEwhteSXOC+jm4o+uVjFd3PqkV3+b9/ULI
        0fNxYIR1s/7M3CIJ0OYb6jixod9/IoCmGW47JhMnPPfc/6tkEpp0AwQZ+bpEwLtv8cNBQK
        PRSt9u7dk3pavlC5Dqdk0gMzT0d5s1w=
Content-Disposition: inline
In-Reply-To: <ZFVTRdP6eK1soMVR-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>


--kajz4hm6ew66s2tm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 05, 2023 at 09:04:37AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> This seems racy to me. The liveness state can change between here and the
> PF_EXITING check in cgroup_migrate_add_task(), right?

You're right, threadgroup lock won't prevent that (as I got wrongly in
the patch):

  cgroup_procs_write_start                                =20
                                                     do_exit
                                                       exit_signals
                                                         cgroup_threadgroup=
_change_begin
                                                           tsk->flags |=3D =
PF_EXITING
                                                         cgroup_threadgroup=
_change_end
    percpu_down_write(&cgroup_threadgroup_rwsem)          =20
      ...                                                 =20
      atomic_read(&live)                                  =20
                                                       ...
                                                       atomic_dec_and_test(=
live)
      ...                                                 =20
      cgroup_migrate_add_task                             =20
      ...                                                 =20
    percpu_up_write(&cgroup_threadgroup_rwsem)


> Wouldn't it be better to just track how many tasks are tracked and
> return -ESRCH if none was migrated?

Thanks, such an integral sounds better, will see.

Michal

--kajz4hm6ew66s2tm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZFoagQAKCRAkDQmsBEOq
uV58AP0YJRo7aRKynt665xXOLH1SQSTX1MShDbDSZVr+4pBULgEAx887fE5n3Mar
tkkG4OI6a6Bof2v6liLPXWWg50Giigo=
=CdaX
-----END PGP SIGNATURE-----

--kajz4hm6ew66s2tm--
