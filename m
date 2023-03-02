From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for triggers
Date: Thu, 2 Mar 2023 08:13:54 -0800
Message-ID: <CAJuCfpHF=9Dv_Yzph5jNmR1ZfTf7Lf=_oShztyLUq0ps_D=osQ@mail.gmail.com>
References: <20230301193403.1507484-1-surenb@google.com> <Y/+wlg5L8A1iebya@cmpxchg.org>
 <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ@mail.gmail.com> <ZADBCEk68W1aGJAV@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677773645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pk3jxwGhDgrO97j71qZC7hN119s30TroFhBoZ90aiOw=;
        b=HOLaGjYG+E2moOTroF7Lrc+FT8kjPg8eO+2zq2UinSgu1L3KwflN5gtuQz0aDv9ZXP
         KckvhiQgN1sVCm2Hc5Yn1+cw9i8SMozFfdHsbL+AU7QVUr4jkT41uTH8LZGQmb0a6Zyi
         no4FFwYyuvgxDpfoo1taagMzOvHW+ePVVwvWXz9LTXbSNMqosnxaF+IsYpUHOzyH/Tkz
         /mwwZKGFNHwd/jt6Ud2+aiJBOGFURPV4LXpc9DU863O/dmd53NCqR/t6vQL5cmqrwzq8
         BjAV+kKZjlzQjPbo/AWcbYqHbGcwwvSf8THi1bV9ZERZZazHoRYC2q3QV6kNacTBeMmq
         XXQw==
In-Reply-To: <ZADBCEk68W1aGJAV-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 2, 2023 at 7:30 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Wed, Mar 01, 2023 at 12:48:38PM -0800, Suren Baghdasaryan wrote:
> > On Wed, Mar 1, 2023 at 12:07=E2=80=AFPM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Wed, Mar 01, 2023 at 11:34:03AM -0800, Suren Baghdasaryan wrote:
> > > > Current 500ms min window size for psi triggers limits polling inter=
val
> > > > to 50ms to prevent polling threads from using too much cpu bandwidt=
h by
> > > > polling too frequently. However the number of cgroups with triggers=
 is
> > > > unlimited, so this protection can be defeated by creating multiple
> > > > cgroups with psi triggers (triggers in each cgroup are served by a =
single
> > > > "psimon" kernel thread).
> > > > Instead of limiting min polling period, which also limits the laten=
cy of
> > > > psi events, it's better to limit psi trigger creation to authorized=
 users
> > > > only, like we do for system-wide psi triggers (/proc/pressure/* fil=
es can
> > > > be written only by processes with CAP_SYS_RESOURCE capability). Thi=
s also
> > > > makes access rules for cgroup psi files consistent with system-wide=
 ones.
> > > > Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers=
 and
> > > > remove the psi window min size limitation.
> > > >
> > > > Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
> > > > Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraj=
a@quicinc.com/
> > > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >  kernel/cgroup/cgroup.c | 10 ++++++++++
> > > >  kernel/sched/psi.c     |  4 +---
> > > >  2 files changed, 11 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > > > index 935e8121b21e..b600a6baaeca 100644
> > > > --- a/kernel/cgroup/cgroup.c
> > > > +++ b/kernel/cgroup/cgroup.c
> > > > @@ -3867,6 +3867,12 @@ static __poll_t cgroup_pressure_poll(struct =
kernfs_open_file *of,
> > > >       return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
> > > >  }
> > > >
> > > > +static int cgroup_pressure_open(struct kernfs_open_file *of)
> > > > +{
> > > > +     return (of->file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RE=
SOURCE)) ?
> > > > +             -EPERM : 0;
> > > > +}
> > >
> > > I agree with the change, but it's a bit unfortunate that this check i=
s
> > > duplicated between system and cgroup.
> > >
> > > What do you think about psi_trigger_create() taking the file and
> > > checking FMODE_WRITE and CAP_SYS_RESOURCE against file->f_cred?
> >
> > That's definitely doable and we don't even need to pass file to
> > psi_trigger_create() since it's called only when we write to the file.
> > However by moving the capability check into psi_trigger_create() we
> > also postpone the check until write() instead of failing early in
> > open(). I always assumed failing early is preferable but if
> > consolidating the code here makes more sense then I can make the
> > switch. Please let me know if you still prefer to move the check.
>
> Just for context, a person on our team is working on allowing
> unprivileged polls with windows that are multiples of 2s, which can be
> triggered from the regular aggregator threads. This should be useful
> for container delegation, and also for the desktop monitor app usecase
> that Chris Down brought up some time ago. At that point, everybody can
> open the file for write, and permissions are checked against the
> trigger parameters.
>
> So I don't think it's a big deal to check this particular permission
> at write time. But if you prefer we can also merge your patch as-is
> and do the refactor as part of the other series.

Let's roll this check without additional changes and then consolidate
the checking inside psi_trigger_create() in a separate patch. If
anybody objects to the late permission check we will just revert that
last change without affecting anything else.

>
> Your call. In either case, please feel free to add
>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks! Will post the final patch with Ack's later today. Originally
it was purely cgroup-related change but now it's more of a PSI change.
Therefore Peter's tree will probably be the right place for it.
