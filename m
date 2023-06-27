From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 10:03:15 -0700
Message-ID: <CAJuCfpGUTMP2FTzzx+bq9_5KZjo1r_qspHYZXK2Ors-yU3XhqQ@mail.gmail.com>
References: <20230626201713.1204982-1-surenb@google.com> <2023062757-hardening-confusion-6f4e@gregkh>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687885407; x=1690477407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwJpQjqEtRpc/SEmt5pFPTPTYI4cOuq5x7buDx5ZuQ0=;
        b=VNU6l8MQAHnG/R3gJ3KAuxwjiBJWuDsgo0tU96FjtiRPcbwah5Beuv6ZFNsUbpKf+Y
         od3zt5MqA8N/KnROUYO5UBxfbReNGZwSm0DKfdYg7HKQ6tJm0r7cupQznzsSGNMZHxQu
         R2HsDLOK/kVS1KnpxoGBybdPHBX/zJPfu4Al4J3gN6dJ/ywxc8sy2uxfttDpeMaru5x0
         KmKCRrLJNja0vWGI2qMoyYuxgHgR7bGCrFz5XH05BII/O5/2HW7PUuhklZ/8K2jpnfwG
         jTxxxS7tkMfbGze3Jgd7fqt5WINMKOS6wR07oPT0lM1R/uhJdWBnM3utYlqTbs8Tdi/e
         9EXw==
In-Reply-To: <2023062757-hardening-confusion-6f4e@gregkh>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Mon, Jun 26, 2023 at 11:25=E2=80=AFPM Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG8Xa4x6EXUF0@public.gmane.org=
g> wrote:
>
> On Mon, Jun 26, 2023 at 01:17:12PM -0700, Suren Baghdasaryan wrote:
> > kernfs_ops.release operation can be called from kernfs_drain_open_files
> > which is not tied to the file's real lifecycle. Introduce a new kernfs_=
ops
> > free operation which is called only when the last fput() of the file is
> > performed and therefore is strictly tied to the file's lifecycle. This
> > operation will be used for freeing resources tied to the file, like
> > waitqueues used for polling the file.
>
> This is confusing, shouldn't release be the "last" time the file is
> handled and then all resources attached to it freed?  Why do we need
> another callback, shouldn't release handle this?

That is what I thought too but apparently kernfs_drain_open_files()
can also cause ops->release to be called while the file keeps on
living (see details here:
https://lore.kernel.org/all/CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru=3D=
=3DMdEHQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/#t).

>
>
> >
> > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/kernfs/file.c       | 8 +++++---
> >  include/linux/kernfs.h | 5 +++++
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> > index 40c4661f15b7..acc52d23d8f6 100644
> > --- a/fs/kernfs/file.c
> > +++ b/fs/kernfs/file.c
> > @@ -766,7 +766,7 @@ static int kernfs_fop_open(struct inode *inode, str=
uct file *file)
> >
> >  /* used from release/drain to ensure that ->release() is called exactl=
y once */
> >  static void kernfs_release_file(struct kernfs_node *kn,
> > -                             struct kernfs_open_file *of)
> > +                             struct kernfs_open_file *of, bool final)
>
> Adding flags to functions like this are a pain, now we need to look it
> up every time to see what that bool means.
>
> And when we do, we see that it is not documented here so we have no idea
> of what it is :(
>
> This is not going to be maintainable as-is, sorry.

It's a static function with only two places it's used in the same
file. I can add documentation too if that helps.

>
> >  {
> >       /*
> >        * @of is guaranteed to have no other file operations in flight a=
nd
> > @@ -787,6 +787,8 @@ static void kernfs_release_file(struct kernfs_node =
*kn,
> >               of->released =3D true;
> >               of_on(of)->nr_to_release--;
> >       }
> > +     if (final && kn->attr.ops->free)
> > +             kn->attr.ops->free(of);
> >  }
> >
> >  static int kernfs_fop_release(struct inode *inode, struct file *filp)
> > @@ -798,7 +800,7 @@ static int kernfs_fop_release(struct inode *inode, =
struct file *filp)
> >               struct mutex *mutex;
> >
> >               mutex =3D kernfs_open_file_mutex_lock(kn);
> > -             kernfs_release_file(kn, of);
> > +             kernfs_release_file(kn, of, true);
> >               mutex_unlock(mutex);
> >       }
> >
> > @@ -852,7 +854,7 @@ void kernfs_drain_open_files(struct kernfs_node *kn=
)
> >               }
> >
> >               if (kn->flags & KERNFS_HAS_RELEASE)
> > -                     kernfs_release_file(kn, of);
> > +                     kernfs_release_file(kn, of, false);
>
> Why isn't this also the "last" time things are touched here?  why is it
> false?

Because it's called from the context of the process doing rmdir() and
if another process has the file in the directory opened it will have
that file alive until it calls the last fput(). These are the call
paths:

do_rmdir
  cgroup_rmdir
    kernfs_drain_open_files
      kernfs_release_file(..., false)
        kn->attr.ops->release(), of->released=3Dtrue

fput()
  kernfs_fop_release()
    kernfs_release_file(..., true), of->released=3D=3Dtrue,
kn->attr.ops->release() is not called.

So, when kn->attr.ops->release() is called by do_rmdir() the file is
still kept alive by another process holding a reference to the file.
It's a problem in our case because if we free the resources associated
with that file (waitqueue head) from inside our release() operation
then the ongoing poll() operation on that file will step on that freed
resource.

>
>
> >       }
> >
> >       WARN_ON_ONCE(on->nr_mmapped || on->nr_to_release);
> > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > index 73f5c120def8..a7e404ff31bb 100644
> > --- a/include/linux/kernfs.h
> > +++ b/include/linux/kernfs.h
> > @@ -273,6 +273,11 @@ struct kernfs_ops {
> >        */
> >       int (*open)(struct kernfs_open_file *of);
> >       void (*release)(struct kernfs_open_file *of);
> > +     /*
> > +      * Free resources tied to the lifecycle of the file, like a
> > +      * waitqueue used for polling.
> > +      */
> > +     void (*free)(struct kernfs_open_file *of);
>
> I agree with Tejun, this needs to be documented much better and show how
> you really should never need to use this :)

I'll be happy not to use it if we can fix the release() to be called
only when the file is truly going away.
Thanks,
Suren.

>
> thanks,
>
> greg k-h
