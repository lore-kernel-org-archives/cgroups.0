From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/6] Also record sleep start for a task group
Date: Wed, 30 May 2012 04:35:13 -0700
Message-ID: <CAPM31R+VXsffUOSOtMPG=g+G9OdzWMKQvx9usTFa3KBbrqPe6A@mail.gmail.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=NWLPUtZMxF3GeDWkU0HL35Q1JLNBdzRli+f3+fSih+c=;
        b=j7fOgu6Eptjoa94PQNumE0Nkms6ydjNOU8gRzyQpMCnys79TaQ72NEEe5reN2lZB8T
         SJ2NLfgPjRVjdK7GUAsXZUz3UoVONeTKIt1gviwTLyNRzOim2bOZWglEi9kDCnh2wQ0d
         Ajbd6tuDy//21sjvu5mjHLJv3Vx1+uSsUvSBFbiORvn5gnlXQ4P0BXzeZIzps4GZ+Gq4
         Z8V/Tn7KUvo/GN9LIbbIMrK0jb9gOz5JS+Z2w8Itbg+XJlFPNRTYlKW40w6qlSL9eXnQ
         a7a+UCc0ayRgVJdwdR1zofs0fc5qyj5ir2NaJynCbycCS6v9n3BD43hkdz+xSaecjITC
         a8lQ==
In-Reply-To: <1338371317-5980-6-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, May 30, 2012 at 2:48 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> When we're dealing with a task group, instead of a task, also record
> the start of its sleep time. Since the test agains TASK_UNINTERRUPTIB=
LE
> does not really make sense and lack an obvious analogous, we always
> record it as sleep_start, never block_start.
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> =A0kernel/sched/fair.c | =A0 =A03 ++-
> =A01 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c26fe38..d932559 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1182,7 +1182,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sc=
hed_entity *se, int flags)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0se->st=
atistics.sleep_start =3D rq_of(cfs_rq)->clock;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (tsk->state & TASK_=
UNINTERRUPTIBLE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0se->st=
atistics.block_start =3D rq_of(cfs_rq)->clock;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 se->statistics.sleep_st=
art =3D rq_of(cfs_rq)->clock;

You can't sanely account sleep on a group entity.

Suppose you have 2 sleepers on 1 cpu: you account 1s/s of idle
Suppose you have 2 sleepers now on 2 cpus: you account 2s/s of idle

=46urthermore, in the latter case when one wakes up you still continue
to accrue sleep time whereas in the former you don't.

Just don't report/collect this.

> =A0#endif
> =A0 =A0 =A0 =A0}
>
> --
> 1.7.10.2
>
