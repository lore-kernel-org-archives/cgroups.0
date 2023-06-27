From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 14:58:08 -0700
Message-ID: <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
References: <20230626201713.1204982-1-surenb@google.com> <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
 <20230627-kanon-hievt-bfdb583ddaa6@brauner> <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
 <20230627-ausgaben-brauhaus-a33e292558d8@brauner> <ZJstlHU4Y3ZtiWJe@slm.duckdns.org>
 <CAJuCfpFUrPGVSnZ9+CmMz31GjRNN+tNf6nUmiCgx0Cs5ygD64A@mail.gmail.com> <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687903099; x=1690495099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJ+N2CuvmAc+wSVX5vK53Z8eetMsRLGAFF7lJpIJfks=;
        b=yZmGrcWcj5pZWgnmUzy8P0MNqCMof88icxobA86fP/l45vue+mRRI6eWcXK63Ef3Go
         FTI//QnmS1jCsU1O7a31qy/2/oGu88vMSOXH8iw0oXdmRDwQZWkmqSaSJPov/40JcKyV
         R8UEG143N5iPzajAx0cfIecyu4OYnohi1A8XXcKOiUgXMYNd0LCmG3b+4UHogC3kUBjZ
         5nAwVTsD2r92uhw3P9j/uCFa5F4nh8POi4STatDMKBzfObiIAE0j3BT79Kz+R4dhmsYE
         ZhpOfEfuAHped4zA05Qz+Jbp+x7TpwvW1OjM67VFetV3y+OphL91lSriK/CmLXfG7f9i
         FkIg==
In-Reply-To: <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Tue, Jun 27, 2023 at 2:43=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Jun 27, 2023 at 1:09=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Tue, Jun 27, 2023 at 11:42=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> > >
> > > Hello, Christian.
> > >
> > > On Tue, Jun 27, 2023 at 07:30:26PM +0200, Christian Brauner wrote:
> > > ...
> > > > ->release() was added in
> > > >
> > > >     commit 0e67db2f9fe91937e798e3d7d22c50a8438187e1
> > > >     kernfs: add kernfs_ops->open/release() callbacks
> > > >
> > > >     Add ->open/release() methods to kernfs_ops.  ->open() is called=
 when
> > > >     the file is opened and ->release() when the file is either rele=
ased or
> > > >     severed.  These callbacks can be used, for example, to manage
> > > >     persistent caching objects over multiple seq_file iterations.
> > > >
> > > >     Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > >     Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> > > >     Acked-by: Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > >
> > > > which mentions "either releases or severed" which imho already poin=
ts to
> > > > separate methods.
> > >
> > > This is because kernfs has revoking operation which doesn't exist for=
 other
> > > filesystems. Other filesystem implemenations can't just say "I'm done=
. Bye!"
> > > and go away. Even if the underlying filesystem has completely failed,=
 the
> > > code still has to remain attached and keep aborting operations.
> > >
> > > However, kernfs serves as the midlayer to a lot of device drivers and=
 other
> > > internal subsystems and it'd be really inconvenient for each of them =
to have
> > > to implement "I want to go away but I gotta wait out this user who's =
holding
> > > onto my tuning knob file". So, kernfs exposes a revoke or severing se=
mantics
> > > something that's exposing interface through kernfs wants to stop doin=
g so.
> > >
> > > If you look at it from file operation implementation POV, this seems =
exactly
> > > like ->release. All open files are shutdown and there won't be any fu=
ture
> > > operations. After all, revoke is forced closing of all fd's. So, for =
most
> > > users, treating severing just like ->release is the right thing to do=
.
> > >
> > > The PSI file which caused this is a special case because it attaches
> > > something to its kernfs file which outlives the severing operation by=
passing
> > > kernfs infra. A more complete way to fix this would be supporting the
> > > required behavior from kernfs side, so that the PSI file operates on =
kernfs
> > > interface which knows the severing event and detaches properly. That =
said,
> > > currently, this is very much an one-off.
> > >
> > > Suren, if you're interested, it might make sense to pipe poll through=
 kernfs
> > > properly so that it has its kernfs operation and kernfs can sever it.=
 That
> > > said, as this is a fix for something which is currently causing crash=
es,
> > > it'd be better to merge this simpler fix first no matter what.
> >
> > I'm happy to implement the right fix if you go into more details.
> > AFAIKT kernfs_ops already has poll() operation, we are hooking
> > cgroup_file_poll() to it and using kernfs_generic_poll(). I thought
> > this is the right way to pipe poll through kernfs but if that's
> > incorrect, please let me know. I'm happy to fix that.
>
> Ah, sorry, for PSI we are not using kernfs_generic_poll(), so my claim
> misrepresents the situation. Let me look into how
> kernfs_generic_poll() is implemented and maybe I can find a better
> solution for PSI.

Ok in kernfs_generic_poll() we are using kernfs_open_node.poll
waitqueue head for polling and kernfs_open_node is freed from inside
kernfs_unlink_open_file() which is called from kernfs_fop_release().
So, it is destroyed only when the last fput() is done, unlike the
ops->release() operation which we are using for destroying PSI
trigger's waitqueue. So, it seems we still need an operation which
would indicate that the file is truly going away.

Christian's suggestion to rename current ops->release() operation into
ops->drain() (or ops->flush() per Matthew's request) and introduce a
"new" ops->release() which is called only when the last fput() is done
seems sane to me. Would everyone be happy with that approach?


> Thanks,
> Suren.
>
> > Thanks,
> > Suren.
> >
> > >
> > > Thanks.
> >
> > >
> > > --
> > > tejun
