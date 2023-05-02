From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] psi: remove 500ms min window size limitation for triggers
Date: Tue, 2 May 2023 10:28:32 -0700
Message-ID: <CAJuCfpHLJGD8U3D_-fpK0njPwLGAZEXuDA9q9DGjd0Q6TxGSjw@mail.gmail.com>
References: <20230303011346.3342233-1-surenb@google.com> <CAJuCfpHcgu5Cti0t+U=S1C5-0ZgebhxzrOnhDiSu5qCyuq5_Wg@mail.gmail.com>
 <CAJuCfpE_aB6KQZj6A0NTCcv09bJ26L1hECDho3M2OyiNoMfFEA@mail.gmail.com> <20230502172404.GI1597538@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683048523; x=1685640523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kqzz+/GxncWIao9Bock5vwwaZbkqqeGi4SiiZlGw4u0=;
        b=uk5HHqrF+3xUFhy6LGfdRt3HWRbHBpYFpPilBiiA6uhDESt/dztgdL+iVfum5GV5Su
         14Yx0eRcvuTMtT43xEy0DA/tAwpgy/J1QbiP4UaHKrGpnnCNEgi/7TWQxLQApTNsTd16
         YZBZlhmXiWGuTNoXeBL52n4/ASZT+G5osIUz29dnI0roDnThHAIj/Q5oO0VAru1zeaGP
         vfuLP7VoFoQGs6GYPGsSRp/L64sBlV6S0qHo1z5xVFiQcAT1GLwzJ8vVVbMIh2H4zLyY
         JniQhfTu4iu5aYxMHjurDSGbPfXE80hefAljZgoaO1fAS5NlG4YI6EqvyJl3tPLi8mzd
         6XWA==
In-Reply-To: <20230502172404.GI1597538-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 2, 2023 at 10:24=E2=80=AFAM Peter Zijlstra <peterz-wEGCiKHe2LouzsEnZMApLA@public.gmane.org=
g> wrote:
>
> On Tue, May 02, 2023 at 10:20:34AM -0700, Suren Baghdasaryan wrote:
> > On Thu, Mar 2, 2023 at 5:16=E2=80=AFPM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> > >
> > > On Thu, Mar 2, 2023 at 5:13=E2=80=AFPM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> > > >
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
> > > > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > >
> > > Forgot to change the --to field from Tejun to PeterZ.
> > > Peter, just to clarify, this change is targeted for inclusion in your=
 tree.
> >
> > I think this patch slipped through the cracks. Peter, could you please
> > take it into your tree?
>
> Sorry, yes, got lost. I'll go queue it for post -rc1. No urgency with
> this right?

Yes, I'll be merging it into Android branches counting on it making
upstream later on :) Greg will hate me for that but I'll survive.
Thanks!
