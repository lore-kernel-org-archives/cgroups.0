From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for
 triggers
Date: Thu, 2 Mar 2023 10:30:16 -0500
Message-ID: <ZADBCEk68W1aGJAV@cmpxchg.org>
References: <20230301193403.1507484-1-surenb@google.com>
 <Y/+wlg5L8A1iebya@cmpxchg.org>
 <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1677771018;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MLSfo+hz5vTJ5ohI3IndEOkVuqNdnrD+B9QuUnbZ7t0=;
        b=Yuc3GjL5Ae3STASZNhGMCqtIxArcAh5Wnnbvn4E9b8+BMSkHR1RoivucbdqQ/fcWMb
         pUqUgMFarQvdmGoZEOycuK8epRhiUmc3k8itieZ6PwaIla/rlWd8hVJjACl/b3oqemuw
         7JN1JLE/p0Jd9o/WpjBcsFZ9qAJ2kAZ0XvvIW28lUpEwsJgluteqYbfF0IDigG6MlJfI
         KbHP+F86TOuVcoSsouz+IUw9UwdSOg5N3LugwO1HlldQl2spyTX/dh5e5grSMQOhdIrq
         XnvvCM7U4ynFjeQLWUvR3t0P/dTBiWq7LQN6dRssMQtt5fGIJ5psvko5kv1o0ITqDoGt
         slJQ==
Content-Disposition: inline
In-Reply-To: <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 01, 2023 at 12:48:38PM -0800, Suren Baghdasaryan wrote:
> On Wed, Mar 1, 2023 at 12:07=E2=80=AFPM Johannes Weiner <hannes-druUgvl0L=
CNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Wed, Mar 01, 2023 at 11:34:03AM -0800, Suren Baghdasaryan wrote:
> > > Current 500ms min window size for psi triggers limits polling interval
> > > to 50ms to prevent polling threads from using too much cpu bandwidth =
by
> > > polling too frequently. However the number of cgroups with triggers is
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
> > > Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y=
7TUQ@public.gmane.org>
> > > Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja-=
jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org/
> > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@publ=
ic.gmane.org>
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
>=20
> That's definitely doable and we don't even need to pass file to
> psi_trigger_create() since it's called only when we write to the file.
> However by moving the capability check into psi_trigger_create() we
> also postpone the check until write() instead of failing early in
> open(). I always assumed failing early is preferable but if
> consolidating the code here makes more sense then I can make the
> switch. Please let me know if you still prefer to move the check.

Just for context, a person on our team is working on allowing
unprivileged polls with windows that are multiples of 2s, which can be
triggered from the regular aggregator threads. This should be useful
for container delegation, and also for the desktop monitor app usecase
that Chris Down brought up some time ago. At that point, everybody can
open the file for write, and permissions are checked against the
trigger parameters.

So I don't think it's a big deal to check this particular permission
at write time. But if you prefer we can also merge your patch as-is
and do the refactor as part of the other series.

Your call. In either case, please feel free to add

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
