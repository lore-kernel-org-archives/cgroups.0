From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for triggers
Date: Wed, 1 Mar 2023 12:48:38 -0800
Message-ID: <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ@mail.gmail.com>
References: <20230301193403.1507484-1-surenb@google.com> <Y/+wlg5L8A1iebya@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677703729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJ2NmEPepPcvJe3Ak3yvSzcJWQBbkK4dHDuYNukFsA4=;
        b=ZxKqVSfGUt6z5p9e4Sh1vteLyfGnKL+sAJJBJkTnttLJNPVFFrb6Q8lkW4nTVy/X2l
         N5/JO3+zD3LYuIc2tT3uQ9kIHFoLQRkCFwDLNeck6pX6qG69jf8xc79xIfmdgBxeS2ae
         gPO0iZxFqzN5e0MFXgXFukI6ZT1Qrza33kJHQMolayOC/Za+3ACrukE+LUqaukvDjFBr
         OCIs7/uvb4O8rRAJLPZcEaseFUhGWxhoiyvpdWyK/dTN0FhnoLz0yXoGm3A/ONfizmTE
         f5SPURgiWH8B09lMfmeWhs9AhcPquBUDJmmxlJq+e+o8001eO34zMlf4yk7u8TJKsluk
         F2zw==
In-Reply-To: <Y/+wlg5L8A1iebya-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 1, 2023 at 12:07=E2=80=AFPM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org=
> wrote:
>
> On Wed, Mar 01, 2023 at 11:34:03AM -0800, Suren Baghdasaryan wrote:
> > Current 500ms min window size for psi triggers limits polling interval
> > to 50ms to prevent polling threads from using too much cpu bandwidth by
> > polling too frequently. However the number of cgroups with triggers is
> > unlimited, so this protection can be defeated by creating multiple
> > cgroups with psi triggers (triggers in each cgroup are served by a sing=
le
> > "psimon" kernel thread).
> > Instead of limiting min polling period, which also limits the latency o=
f
> > psi events, it's better to limit psi trigger creation to authorized use=
rs
> > only, like we do for system-wide psi triggers (/proc/pressure/* files c=
an
> > be written only by processes with CAP_SYS_RESOURCE capability). This al=
so
> > makes access rules for cgroup psi files consistent with system-wide one=
s.
> > Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers and
> > remove the psi window min size limitation.
> >
> > Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
> > Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja@qu=
icinc.com/
> > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  kernel/cgroup/cgroup.c | 10 ++++++++++
> >  kernel/sched/psi.c     |  4 +---
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 935e8121b21e..b600a6baaeca 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -3867,6 +3867,12 @@ static __poll_t cgroup_pressure_poll(struct kern=
fs_open_file *of,
> >       return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
> >  }
> >
> > +static int cgroup_pressure_open(struct kernfs_open_file *of)
> > +{
> > +     return (of->file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOUR=
CE)) ?
> > +             -EPERM : 0;
> > +}
>
> I agree with the change, but it's a bit unfortunate that this check is
> duplicated between system and cgroup.
>
> What do you think about psi_trigger_create() taking the file and
> checking FMODE_WRITE and CAP_SYS_RESOURCE against file->f_cred?

That's definitely doable and we don't even need to pass file to
psi_trigger_create() since it's called only when we write to the file.
However by moving the capability check into psi_trigger_create() we
also postpone the check until write() instead of failing early in
open(). I always assumed failing early is preferable but if
consolidating the code here makes more sense then I can make the
switch. Please let me know if you still prefer to move the check.
