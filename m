From: Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for triggers
Date: Wed, 1 Mar 2023 13:00:43 -0800
Message-ID: <CAC_TJvfZu7-3QWF6EyEphZusnk8gjM-w3bw3K26TBnoY221yeQ@mail.gmail.com>
References: <20230301193403.1507484-1-surenb@google.com> <Y/+wlg5L8A1iebya@cmpxchg.org>
 <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677704454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2kasoRjb1+wciE4LnUC2thgmhUmXODjqV4vRSm0GrQ=;
        b=W7barMoQHh4OpBpyETO0/gkI5dClRC/69osO6LGoB7PZbyXAonsXRwPJeNy0OBf5UL
         LXrKyhtV5pnGDcCIi4Piv/DxPPYhzjcQY6T6uNuSed9veKu1yjBJL4X+FkKb5bJYV9Yt
         sE10hdpblg9K3wuqUwCurVvteg0oZ2CQ2bR4f73Gnt83eCIkCgy9LyANkDgWVMDqEBeJ
         YZBj7K+xVkhICy6nS06wRn/bS8ni9axi1Ee9BCCArZ2aJbtEc/4KOm7qBrwJnCf7/X1M
         WUrCsMG7Zvo1Tp+cjmRkFYImZEqA3rnUxBKoAy8NQeC6T/HaG9u5iIbM+jKerspIbLfZ
         3YFw==
In-Reply-To: <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 1, 2023 at 12:48=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Mar 1, 2023 at 12:07=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Wed, Mar 01, 2023 at 11:34:03AM -0800, Suren Baghdasaryan wrote:
> > > Current 500ms min window size for psi triggers limits polling interva=
l
> > > to 50ms to prevent polling threads from using too much cpu bandwidth =
by
> > > polling too frequently. However the number of cgroups with triggers i=
s
> > > unlimited, so this protection can be defeated by creating multiple
> > > cgroups with psi triggers (triggers in each cgroup are served by a si=
ngle
> > > "psimon" kernel thread).
> > > Instead of limiting min polling period, which also limits the latency=
 of
> > > psi events, it's better to limit psi trigger creation to authorized u=
sers
> > > only, like we do for system-wide psi triggers (/proc/pressure/* files=
 can
> > > be written only by processes with CAP_SYS_RESOURCE capability). This =
also
> > > makes access rules for cgroup psi files consistent with system-wide o=
nes.
> > > Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers a=
nd
> > > remove the psi window min size limitation.
> > >
> > > Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
> > > Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja@=
quicinc.com/
> > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  kernel/cgroup/cgroup.c | 10 ++++++++++
> > >  kernel/sched/psi.c     |  4 +---
> > >  2 files changed, 11 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > > index 935e8121b21e..b600a6baaeca 100644
> > > --- a/kernel/cgroup/cgroup.c
> > > +++ b/kernel/cgroup/cgroup.c
> > > @@ -3867,6 +3867,12 @@ static __poll_t cgroup_pressure_poll(struct ke=
rnfs_open_file *of,
> > >       return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
> > >  }
> > >
> > > +static int cgroup_pressure_open(struct kernfs_open_file *of)
> > > +{
> > > +     return (of->file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESO=
URCE)) ?
> > > +             -EPERM : 0;
> > > +}
> >
> > I agree with the change, but it's a bit unfortunate that this check is
> > duplicated between system and cgroup.
> >
> > What do you think about psi_trigger_create() taking the file and
> > checking FMODE_WRITE and CAP_SYS_RESOURCE against file->f_cred?
>
> That's definitely doable and we don't even need to pass file to
> psi_trigger_create() since it's called only when we write to the file.
> However by moving the capability check into psi_trigger_create() we
> also postpone the check until write() instead of failing early in
> open(). I always assumed failing early is preferable but if
> consolidating the code here makes more sense then I can make the
> switch. Please let me know if you still prefer to move the check.
>

I always assumed the convention is to check the credentials on open()
per Linus comment here:

https://lore.kernel.org/r/CAHk-=3DwhDkekE8n2LdPiKHeTdRnV--ys0V0nPZ76oPaE0fn=
-d+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/#t

--Kalesh
