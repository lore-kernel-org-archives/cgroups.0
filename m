From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 10:09:27 -0700
Message-ID: <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
References: <20230626201713.1204982-1-surenb@google.com> <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
 <20230627-kanon-hievt-bfdb583ddaa6@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687885779; x=1690477779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEfOOj7zZRsR4093w5Xezdtfqq/JXEJS/CeyQ2VX6y0=;
        b=qAGBVo+6BR+jme9c+D+CU2a/HdzfRO4Smyw+4vv/W4I1jKgLWzo2vd5hMJUHdw3fkX
         IJNH8qRtKo+5gPnluLFgDX0SPxosg2Tr1jNfFqqoiSu11uqRJYvDMtanGXBT1x0IkF6Y
         ba6+9LwZiwkO7sWkoB43e404iG9OBoNL5QBSX0MGxliMIjCNPke9m99etfmYL8jhdCUV
         tX883ywh8R4BwLNDanA/fkNoFWFXCJC5yWiuCCLPQoJxcVJR+gMgtIVUupMj4ruxQvGL
         ebhN165884+Diht68TH0anDDe0ObeWm+6pLlX+boJpCHjSxzQPWEWJVmPkxSSa+JouHz
         JL0w==
In-Reply-To: <20230627-kanon-hievt-bfdb583ddaa6@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christian Brauner <brauner@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, gregkh@linuxfoundation.org, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

On Tue, Jun 27, 2023 at 1:24=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Mon, Jun 26, 2023 at 10:31:49AM -1000, Tejun Heo wrote:
> > On Mon, Jun 26, 2023 at 01:17:12PM -0700, Suren Baghdasaryan wrote:
> > > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > > index 73f5c120def8..a7e404ff31bb 100644
> > > --- a/include/linux/kernfs.h
> > > +++ b/include/linux/kernfs.h
> > > @@ -273,6 +273,11 @@ struct kernfs_ops {
> > >      */
> > >     int (*open)(struct kernfs_open_file *of);
> > >     void (*release)(struct kernfs_open_file *of);
> > > +   /*
> > > +    * Free resources tied to the lifecycle of the file, like a
> > > +    * waitqueue used for polling.
> > > +    */
> > > +   void (*free)(struct kernfs_open_file *of);
> >
> > I think this can use a bit more commenting - ie. explain that release m=
ay be
> > called earlier than the actual freeing of the file and how that can lea=
d to
> > problems. Othre than that, looks fine to me.
>
> It seems the more natural thing to do would be to introduce a ->drain()
> operation and order it before ->release(), no?

I assume you mean we should add a ->drain() operation and call it when
kernfs_drain_open_files()  causes kernfs_release_file()? That would
work but if any existing release() handler counts on the current
behavior (release() being called while draining) then we should find
and fix these. Hopefully they don't really depend on the current
behavior but I dunno.
