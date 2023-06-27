From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 19:30:26 +0200
Message-ID: <20230627-ausgaben-brauhaus-a33e292558d8@brauner>
References: <20230626201713.1204982-1-surenb@google.com>
 <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
 <20230627-kanon-hievt-bfdb583ddaa6@brauner>
 <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687887034;
        bh=r04FJeB+aVXEw3+VGzeA7ERawnho+uOP3FnxGvrlWnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s4MdskLJ54XjiMB1gziJh03q8HBOOaMEQYrKbSeLtPzGx7CVDZmefNksLr1VuttCw
         VocNJzH21DpjkIvSqD6WFj/ezDfvYxcmMCwmPFCq64qXRoJY2ovikFcDbBpfOIcVkg
         lQJBAj6tXa0FJy9lgBa+RViZrkgqrPB2Z60V+6LZElVVd9TvrUrnk8WlnY3ySQOmQg
         eKZKUzo58KMKbWg1ApS9nYLBoqkmjHVvkYGulhVPNq99hPCisjEV6SIXbPW7j+tOMM
         kYS6Gutrml5ebMAfJkozqeIqsmPQXjQZnBS+6WDG3xE/PpF7vXB9HsE36DEG20y9EV
         +ftnEtEcw+D3A==
Content-Disposition: inline
In-Reply-To: <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Tue, Jun 27, 2023 at 10:09:27AM -0700, Suren Baghdasaryan wrote:
> On Tue, Jun 27, 2023 at 1:24=E2=80=AFAM Christian Brauner <brauner-DgEjT+=
Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon, Jun 26, 2023 at 10:31:49AM -1000, Tejun Heo wrote:
> > > On Mon, Jun 26, 2023 at 01:17:12PM -0700, Suren Baghdasaryan wrote:
> > > > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > > > index 73f5c120def8..a7e404ff31bb 100644
> > > > --- a/include/linux/kernfs.h
> > > > +++ b/include/linux/kernfs.h
> > > > @@ -273,6 +273,11 @@ struct kernfs_ops {
> > > >      */
> > > >     int (*open)(struct kernfs_open_file *of);
> > > >     void (*release)(struct kernfs_open_file *of);
> > > > +   /*
> > > > +    * Free resources tied to the lifecycle of the file, like a
> > > > +    * waitqueue used for polling.
> > > > +    */
> > > > +   void (*free)(struct kernfs_open_file *of);
> > >
> > > I think this can use a bit more commenting - ie. explain that release=
 may be
> > > called earlier than the actual freeing of the file and how that can l=
ead to
> > > problems. Othre than that, looks fine to me.
> >
> > It seems the more natural thing to do would be to introduce a ->drain()
> > operation and order it before ->release(), no?
>=20
> I assume you mean we should add a ->drain() operation and call it when
> kernfs_drain_open_files()  causes kernfs_release_file()? That would
> work but if any existing release() handler counts on the current
> behavior (release() being called while draining) then we should find
> and fix these. Hopefully they don't really depend on the current
> behavior but I dunno.

Before I wrote that I did a naive

        > git grep -A 20 kernfs_ops | grep \\.release
        kernel/cgroup/cgroup.c- .release                =3D cgroup_file_rel=
ease,
        kernel/cgroup/cgroup.c- .release                =3D cgroup_file_rel=
ease,

which only gave cgroup_release_file(). Might be I'm missing some convoluted
callchains though or macro magic...

->release() was added in

    commit 0e67db2f9fe91937e798e3d7d22c50a8438187e1
    kernfs: add kernfs_ops->open/release() callbacks

    Add ->open/release() methods to kernfs_ops.  ->open() is called when
    the file is opened and ->release() when the file is either released or
    severed.  These callbacks can be used, for example, to manage
    persistent caching objects over multiple seq_file iterations.

    Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@p=
ublic.gmane.org>
    Acked-by: Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gma=
ne.org>


which mentions "either releases or severed" which imho already points to
separate methods.
