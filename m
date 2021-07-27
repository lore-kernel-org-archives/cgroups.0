From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v7 09/10] memcg: enable accounting for tty-related objects
Date: Tue, 27 Jul 2021 11:30:58 +0200
Message-ID: <YP/SUlucImu11zT7@kroah.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com>
 <b8baa04f-e789-0321-b39d-07c5696ff755@virtuozzo.com>
 <1eef95fe-6172-796e-edd1-095545da6e74@kernel.org>
 <d42bd2a3-74a0-163f-6e3a-ad702f6d2817@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627378260;
        bh=gs7eJAOqHz0y0MgMzJHu3ENkS4NCcGHEBd0dG2aBni0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v8yO2l0eRWB/MYAfEFD4kEBZ0ammK/F7vGp/bD8qlkWhbdzyXMf5OTl/WV6aCmwRr
         NjqHbDxoErEydeC8LzISazDpfl2UqCz38OFhI8qHtoyHWruTnfX7LCq06bvpwH0OCe
         3FVEiM1doxBuTndQ+PNs0joLCTlKBAsCLyBhHks8=
Content-Disposition: inline
In-Reply-To: <d42bd2a3-74a0-163f-6e3a-ad702f6d2817-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 27, 2021 at 11:02:31AM +0300, Vasily Averin wrote:
> On 7/27/21 9:54 AM, Jiri Slaby wrote:
> > On 27. 07. 21, 7:34, Vasily Averin wrote:
> >> At each login the user forces the kernel to create a new terminal and
> >> allocate up to ~1Kb memory for the tty-related structures.
> >>
> >> By default it's allowed to create up to 4096 ptys with 1024 reserve for
> >> initial mount namespace only and the settings are controlled by host a=
dmin.
> >>
> >> Though this default is not enough for hosters with thousands
> >> of containers per node. Host admin can be forced to increase it
> >> up to NR_UNIX98_PTY_MAX =3D 1<<20.
> >>
> >> By default container is restricted by pty mount_opt.max =3D 1024,
> >> but admin inside container can change it via remount. As a result,
> >> one container can consume almost all allowed ptys
> >> and allocate up to 1Gb of unaccounted memory.
> >>
> >> It is not enough per-se to trigger OOM on host, however anyway, it all=
ows
> >> to significantly exceed the assigned memcg limit and leads to troubles
> >> on the over-committed node.
> >>
> >> It makes sense to account for them to restrict the host's memory
> >> consumption from inside the memcg-limited container.
> >>
> >> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.=
org>
> >> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@=
public.gmane.org>
> >> ---
> >> =A0 drivers/tty/tty_io.c | 4 ++--
> >> =A0 1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> >> index 26debec..e787f6f 100644
> >> --- a/drivers/tty/tty_io.c
> >> +++ b/drivers/tty/tty_io.c
> >> @@ -1493,7 +1493,7 @@ void tty_save_termios(struct tty_struct *tty)
> >> =A0=A0=A0=A0=A0 /* Stash the termios data */
> >> =A0=A0=A0=A0=A0 tp =3D tty->driver->termios[idx];
> >> =A0=A0=A0=A0=A0 if (tp =3D=3D NULL) {
> >> -=A0=A0=A0=A0=A0=A0=A0 tp =3D kmalloc(sizeof(*tp), GFP_KERNEL);
> >> +=A0=A0=A0=A0=A0=A0=A0 tp =3D kmalloc(sizeof(*tp), GFP_KERNEL_ACCOUNT);
> >=20
> > termios are not saved for PTYs (TTY_DRIVER_RESET_TERMIOS). Am I missing=
 something?
>=20
> No, you are right, I've missed this.
> Typical terminals inside containers use TTY_DRIVER_RESET_TERMIOS flag and=
 therefore do not save termios.
> So its accounting have near-to-zero impact in real life.
> I'll prepare fixup to drop GFP_KERNEL_ACCOUNT here.

I'll go drop this patch from my tree.

thanks,

greg k-h
