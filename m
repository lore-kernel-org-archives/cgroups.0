From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 19:23:10 +0200
Message-ID: <20230627-zujubeln-umwandeln-b99f443dae73@brauner>
References: <20230626201713.1204982-1-surenb@google.com>
 <2023062757-hardening-confusion-6f4e@gregkh>
 <CAJuCfpGUTMP2FTzzx+bq9_5KZjo1r_qspHYZXK2Ors-yU3XhqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687886597;
        bh=YHqC3AkIjMcI+zZQb7xY54+8KynOZ1FmAl0y11vUJyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TwjKtzg06tHfoQiroLS0nj5i+HAz8qy8eTCGpTVWBUGGS/is8kNjYC2Thf2NxjYu5
         /AGVHt2yYFDLbqUUkgnmyopy7jrIbagKSXQhl0lqqMk/0PZtXKBjRI6MK82T/y3vUA
         4L/6Z1nS5KXyXlab6LC0HVZqUNXD4a1jjWx/bVTilwrcrnxhD8fHlg6HU2u0xdbKCM
         IWd2OPqbEakWOkaBKEt1qE/ucbI5pgPB8ZFzTRPKFRK7BYK4Np42Ow8jgP2E6rtsd8
         m3y1ra6aPE4hhjJbY0+tVRWKO2eeHPpniv3M5mc/KzN5J/ov5WDRYrzPFpyZ6ElSvC
         zRLbBhzlbZttA==
Content-Disposition: inline
In-Reply-To: <CAJuCfpGUTMP2FTzzx+bq9_5KZjo1r_qspHYZXK2Ors-yU3XhqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Tue, Jun 27, 2023 at 10:03:15AM -0700, Suren Baghdasaryan wrote:
> On Mon, Jun 26, 2023 at 11:25=E2=80=AFPM Greg KH <gregkh-hQyY1W1yCW8ekmWl=
sbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >
> > On Mon, Jun 26, 2023 at 01:17:12PM -0700, Suren Baghdasaryan wrote:
> > > kernfs_ops.release operation can be called from kernfs_drain_open_fil=
es
> > > which is not tied to the file's real lifecycle. Introduce a new kernf=
s_ops
> > > free operation which is called only when the last fput() of the file =
is
> > > performed and therefore is strictly tied to the file's lifecycle. This
> > > operation will be used for freeing resources tied to the file, like
> > > waitqueues used for polling the file.
> >
> > This is confusing, shouldn't release be the "last" time the file is
> > handled and then all resources attached to it freed?  Why do we need
> > another callback, shouldn't release handle this?
>=20
> That is what I thought too but apparently kernfs_drain_open_files()
> can also cause ops->release to be called while the file keeps on
> living (see details here:
> https://lore.kernel.org/all/CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru=
=3D=3DMdEHQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/#t).
>=20
> >
> >
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@publ=
ic.gmane.org>
> > > ---
> > >  fs/kernfs/file.c       | 8 +++++---
> > >  include/linux/kernfs.h | 5 +++++
> > >  2 files changed, 10 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> > > index 40c4661f15b7..acc52d23d8f6 100644
> > > --- a/fs/kernfs/file.c
> > > +++ b/fs/kernfs/file.c
> > > @@ -766,7 +766,7 @@ static int kernfs_fop_open(struct inode *inode, s=
truct file *file)
> > >
> > >  /* used from release/drain to ensure that ->release() is called exac=
tly once */
> > >  static void kernfs_release_file(struct kernfs_node *kn,
> > > -                             struct kernfs_open_file *of)
> > > +                             struct kernfs_open_file *of, bool final)
> >
> > Adding flags to functions like this are a pain, now we need to look it
> > up every time to see what that bool means.
> >
> > And when we do, we see that it is not documented here so we have no idea
> > of what it is :(
> >
> > This is not going to be maintainable as-is, sorry.
>=20
> It's a static function with only two places it's used in the same
> file. I can add documentation too if that helps.
>=20
> >
> > >  {
> > >       /*
> > >        * @of is guaranteed to have no other file operations in flight=
 and
> > > @@ -787,6 +787,8 @@ static void kernfs_release_file(struct kernfs_nod=
e *kn,
> > >               of->released =3D true;
> > >               of_on(of)->nr_to_release--;
> > >       }
> > > +     if (final && kn->attr.ops->free)
> > > +             kn->attr.ops->free(of);
> > >  }
> > >
> > >  static int kernfs_fop_release(struct inode *inode, struct file *filp)
> > > @@ -798,7 +800,7 @@ static int kernfs_fop_release(struct inode *inode=
, struct file *filp)
> > >               struct mutex *mutex;
> > >
> > >               mutex =3D kernfs_open_file_mutex_lock(kn);
> > > -             kernfs_release_file(kn, of);
> > > +             kernfs_release_file(kn, of, true);
> > >               mutex_unlock(mutex);
> > >       }
> > >
> > > @@ -852,7 +854,7 @@ void kernfs_drain_open_files(struct kernfs_node *=
kn)
> > >               }
> > >
> > >               if (kn->flags & KERNFS_HAS_RELEASE)
> > > -                     kernfs_release_file(kn, of);
> > > +                     kernfs_release_file(kn, of, false);
> >
> > Why isn't this also the "last" time things are touched here?  why is it
> > false?
>=20
> Because it's called from the context of the process doing rmdir() and
> if another process has the file in the directory opened it will have
> that file alive until it calls the last fput(). These are the call
> paths:
>=20
> do_rmdir
>   cgroup_rmdir
>     kernfs_drain_open_files
>       kernfs_release_file(..., false)
>         kn->attr.ops->release(), of->released=3Dtrue

This seems weird to me. Why would that trigger a ->release() call. In
general, calling ->release() kinda betrays the name.
So imho, this really wants to be a separate ->drain() or ->shutdown()
call (and seems conceptually related to f_op->flush()).

>=20
> fput()
>   kernfs_fop_release()
>     kernfs_release_file(..., true), of->released=3D=3Dtrue,
> kn->attr.ops->release() is not called.
