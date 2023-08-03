From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: use rstat for non-hierarchical stats
Date: Thu, 3 Aug 2023 11:52:21 -0700
Message-ID: <CAJD7tkZ2u0db3UP3K+2ag12VCRhzjJVrwipsyMV2fb9jdfwCzg@mail.gmail.com>
References: <20230726153223.821757-1-yosryahmed@google.com>
 <20230726153223.821757-2-yosryahmed@google.com> <ZMkXDuwD8RFRKnNQ@dhcp22.suse.cz>
 <CAJD7tkbb8AWR-duWb+at-S9MMz48b0JqnM+b5ok83TzvXvPb+A@mail.gmail.com>
 <CAJD7tkbZi16w4mYngVK8qA84FMijmHvwzMjHfrJiCsV=WjixOA@mail.gmail.com>
 <ZMoIYLwITUZzXp4C@dhcp22.suse.cz> <CAJD7tkY4hTTCfqSGa_XexbH=WSTJ4WXWeMXSU+6KW8qfr7agfQ@mail.gmail.com>
 <CAJD7tkb17x=qwoO37uxyYXLEUVp15BQKR+Xfh7Sg9Hx-wTQ_=w@mail.gmail.com> <ZMu/+ysmksCZqcem@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691088778; x=1691693578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16O8o09yKlIrWJqVGKmGPXtBxRWH/JyAAhiz2PZ5hMc=;
        b=GzW5xwJ4SS3NFZxvIos1RPhdVI40cJHjHyRgQFOtkhHPZz7b+nSGci357csx/1V2IB
         WF/FvNJGDDyqO/t3E1XggUbY9hOBM9OuzEOLda5rk/HOZdxPZ99UbIg5nx5kFScVSxEb
         lv/ICaBqhOvyMSyCpzHn100B4O3Xlrt3LZcr3JiV5+wHKHd6ztj7RzCygsqmrZhY6dvv
         pyM5Kdh2l7+Ba4qn5QYe8t68ZnsyC56FMznLyFS9c8erDQnQz5aNcCsr0vgMF5pStmOr
         xfMftZnQ/q87+szHwrXALvSxxMSMtils8s1jU3ZbaDbZn4DP4akZAjg2dSLbWbGm8Iig
         vblg==
In-Reply-To: <ZMu/+ysmksCZqcem-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Aug 3, 2023 at 7:55=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Wed 02-08-23 15:02:55, Yosry Ahmed wrote:
> [...]
> > Let me know if the testing is satisfactory for you. I can send an
> > updated commit log accordingly with a summary of this conversation.
>
> Yes this should be sufficient as it exercises all the CPUs so the
> overhead in flushing should be visible if this was a real deal. I would
> have gone with kernel build test as that has a broader code coverage but
> this artificial test should give some red flags as well. So good enough.
> Amending the changelog with this would be helpful as well so that future
> us and others will know what kind of testing has been done.
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks! I sent a v4 with your Ack and an amended changelog that
describes the testing done and points to the script attached here.

>
> >
> > > > --
> > > > Michal Hocko
> > > > SUSE Labs
>
> > #!/bin/bash
> >
> > NR_CPUS=3D$(getconf _NPROCESSORS_ONLN)
> > NR_CGROUPS=3D$(( NR_CPUS * 2 ))
> > TEST_MB=3D50
> > TOTAL_MB=3D$((TEST_MB * NR_CGROUPS))
> > TMPFS=3D$(mktemp -d)
> > ROOT=3D"/sys/fs/cgroup/"
> > ZRAM_DEV=3D"/mnt/devtmpfs/zram0"
> >
> > cleanup() {
> >   umount $TMPFS
> >   rm -rf $TMPFS
> >   for i in $(seq $NR_CGROUPS); do
> >     cgroup=3D"$ROOT/cg$i"
> >     rmdir $cgroup
> >   done
> >   swapoff $ZRAM_DEV
> >   echo 1 > "/sys/block/zram0/reset"
> > }
> > trap cleanup INT QUIT EXIT
> >
> > # Setup zram
> > echo $((TOTAL_MB << 20)) > "/sys/block/zram0/disksize"
> > mkswap $ZRAM_DEV
> > swapon $ZRAM_DEV
> > echo "Setup zram done"
> >
> > # Create cgroups, set limits
> > echo "+memory" > "$ROOT/cgroup.subtree_control"
> > for i in $(seq $NR_CGROUPS); do
> >   cgroup=3D"$ROOT/cg$i"
> >   mkdir $cgroup
> >   echo $(( (TEST_MB << 20) / 4)) > "$cgroup/memory.max"
> > done
> > echo "Setup cgroups done"
> >
> > # Start workers to allocate tmpfs memory
> > mount -t tmpfs none $TMPFS
> > for i in $(seq $NR_CGROUPS); do
> >   cgroup=3D"$ROOT/cg$i"
> >   f=3D"$TMPFS/tmp$i"
> >   (echo 0 > "$cgroup/cgroup.procs" &&
> >     dd if=3D/dev/zero of=3D$f bs=3D1M count=3D$TEST_MB status=3Dnone &&
> >     cat $f > /dev/null)&
> > done
> >
> > # Wait for workers
> > wait
>
>
> --
> Michal Hocko
> SUSE Labs
