From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 18:36:22 +0100
Message-ID: <ZJseFr/BHh+bZ7NM@casper.infradead.org>
References: <20230626201713.1204982-1-surenb@google.com>
 <2023062757-hardening-confusion-6f4e@gregkh>
 <CAJuCfpGUTMP2FTzzx+bq9_5KZjo1r_qspHYZXK2Ors-yU3XhqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=ilydTjdTS9jPS3Q531k5dt3/10xWOBh9LY6FBdmbcHw=; b=cXWltV79wDZw6RHYQjchi8TzHq
        6Kc6/NEUYJlQkKY8P9EiMBEP6KFDPdWnHxsHtPaeeFbNx0FS8iShKjqtxHxqTelUktI5TnHr5pepl
        iv/zfF5pzzgoIuN46eiRmCbgTu23x9Lal5BK/nU0AcHQ5m09H94J22R6OC1DvHGDn0f+whuK1lgqJ
        zMHN+oSdlUqf6qpoCwIT5xbTr78wbd4LR6kIBHy5d+JjeTVLKNwDyVh1NUB8tHdY/K6FJurYL1aY2
        yjEivrmcWKqF3kueW64pt3BfKVrr7aaE5iqahwMe8J72Ng/sqpqzlgXPw2elPZdJkcV8oKB8fs1Pq
        8tJg3p8Q==;
Content-Disposition: inline
In-Reply-To: <CAJuCfpGUTMP2FTzzx+bq9_5KZjo1r_qspHYZXK2Ors-yU3XhqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

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

If we're splitting these two functions apart, can we use the same naming
as the VFS please?

``flush``
        called by the close(2) system call to flush a file

``release``
        called when the last reference to an open file is closed

