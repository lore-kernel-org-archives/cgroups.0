From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/2] memcontrol: support cgroup level OOM protection
Date: Thu, 25 May 2023 10:19:20 -0700
Message-ID: <CAJD7tkaQdSTDX0Q7zvvYrA3Y4TcvLdWKnN3yc8VpfWRpUjcYBw@mail.gmail.com>
References: <CAJD7tkZwCreOS_XxDM_9mOTBo=Gatr12r1xtc64B_e5+HJhRqg@mail.gmail.com>
 <B438A058-7C4A-46B3-B6FB-4CF32BD7D294@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685035197; x=1687627197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wavdum6yYAqpFeopZHwVVFgnm4JMHiQDU/53zz3FxBY=;
        b=goawVQC5jsSd/ZTijZq1yB03zafWo77t7+Zao+UGglnPeOunriCGqUVh062x+pz1AY
         Tm6HF3/F6232FkJS/srHiOjoWJ2WkCfRbkSzQmEN5ODbd7yGZCOQ5sLH4DYv5CrGa+s5
         e0VL41YYNBfodf21AAsHSNGeEZXBPWbV6TSR/vppHSrWwPAjso3m69mzGaS7WCIsY2qk
         YHv4D1XAI2Hh7zUAqDDxfH/EH3R8VK0LKb7a4VOuaSMqwY/BqZ7j6t6IO9IYPhg0aIRw
         /Ls6gN2GUX2SboOkFRqwC832l5xeBUyf3o+FzvunNuWi6pJRcGXO7ckZjC16TypYGtTQ
         yPeg==
In-Reply-To: <B438A058-7C4A-46B3-B6FB-4CF32BD7D294-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?56iL5Z6y5rabIENoZW5na2FpdGFvIENoZW5n?= <chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, May 25, 2023 at 1:19=E2=80=AFAM =E7=A8=8B=E5=9E=B2=E6=B6=9B Chengka=
itao Cheng
<chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
>
> At 2023-05-24 06:02:55, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >On Sat, May 20, 2023 at 2:52=E2=80=AFAM =E7=A8=8B=E5=9E=B2=E6=B6=9B Chen=
gkaitao Cheng
> ><chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
> >>
> >> At 2023-05-20 06:04:26, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >> >On Wed, May 17, 2023 at 10:12=E2=80=AFPM =E7=A8=8B=E5=9E=B2=E6=B6=9B =
Chengkaitao Cheng
> >> ><chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
> >> >>
> >> >> At 2023-05-18 04:42:12, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
> >> >> >On Wed, May 17, 2023 at 3:01=E2=80=AFAM =E7=A8=8B=E5=9E=B2=E6=B6=
=9B Chengkaitao Cheng
> >> >> ><chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
> >> >> >>
> >> >> >> At 2023-05-17 16:09:50, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
> >> >> >> >On Wed, May 17, 2023 at 1:01=E2=80=AFAM =E7=A8=8B=E5=9E=B2=E6=
=B6=9B Chengkaitao Cheng
> >> >> >> ><chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
> >> >> >> >>
> >> >> >>
> >> >> >> Killing processes in order of memory usage cannot effectively pr=
otect
> >> >> >> important processes. Killing processes in a user-defined priorit=
y order
> >> >> >> will result in a large number of OOM events and still not being =
able to
> >> >> >> release enough memory. I have been searching for a balance betwe=
en
> >> >> >> the two methods, so that their shortcomings are not too obvious.
> >> >> >> The biggest advantage of memcg is its tree topology, and I also =
hope
> >> >> >> to make good use of it.
> >> >> >
> >> >> >For us, killing processes in a user-defined priority order works w=
ell.
> >> >> >
> >> >> >It seems like to tune memory.oom.protect you use oom_kill_inherit =
to
> >> >> >observe how many times this memcg has been killed due to a limit i=
n an
> >> >> >ancestor. Wouldn't it be more straightforward to specify the prior=
ity
> >> >> >of protections among memcgs?
> >> >> >
> >> >> >For example, if you observe multiple memcgs being OOM killed due t=
o
> >> >> >hitting an ancestor limit, you will need to decide which of them t=
o
> >> >> >increase memory.oom.protect for more, based on their importance.
> >> >> >Otherwise, if you increase all of them, then there is no point if =
all
> >> >> >the memory is protected, right?
> >> >>
> >> >> If all memory in memcg is protected, its meaning is similar to that=
 of the
> >> >> highest priority memcg in your approach, which is ultimately killed=
 or
> >> >> never killed.
> >> >
> >> >Makes sense. I believe it gets a bit trickier when you want to
> >> >describe relative ordering between memcgs using memory.oom.protect.
> >>
> >> Actually, my original intention was not to use memory.oom.protect to
> >> achieve relative ordering between memcgs, it was just a feature that
> >> happened to be achievable. My initial idea was to protect a certain
> >> proportion of memory in memcg from being killed, and through the
> >> method, physical memory can be reasonably planned. Both the physical
> >> machine manager and container manager can add some unimportant
> >> loads beyond the oom.protect limit, greatly improving the oversold
> >> rate of memory. In the worst case scenario, the physical machine can
> >> always provide all the memory limited by memory.oom.protect for memcg.
> >>
> >> On the other hand, I also want to achieve relative ordering of interna=
l
> >> processes in memcg, not just a unified ordering of all memcgs on
> >> physical machines.
> >
> >For us, having a strict priority ordering-based selection is
> >essential. We have different tiers of jobs of different importance,
> >and a job of higher priority should not be killed before a lower
> >priority task if possible, no matter how much memory either of them is
> >using. Protecting memcgs solely based on their usage can be useful in
> >some scenarios, but not in a system where you have different tiers of
> >jobs running with strict priority ordering.
>
> If you want to run with strict priority ordering, it can also be achieved=
,
> but it may be quite troublesome. The directory structure shown below
> can achieve the goal.
>
>              root
>            /      \
>    cgroup A       cgroup B
> (protect=3Dmax)    (protect=3D0)
>                 /          \
>            cgroup C      cgroup D
>         (protect=3Dmax)   (protect=3D0)
>                        /          \
>                   cgroup E      cgroup F
>                (protect=3Dmax)   (protect=3D0)
>
> Oom kill order: F > E > C > A

This requires restructuring the cgroup hierarchy which comes with a
lot of other factors, I don't think that's practically an option.

>
> As mentioned earlier, "running with strict priority ordering" may be
> some extreme issues, that requires the manager to make a choice.

We have been using strict priority ordering in our fleet for many
years now and we depend on it. Some jobs are simply more important
than others, regardless of their usage.

>
> >>
> >> >> >In this case, wouldn't it be easier to just tell the OOM killer th=
e
> >> >> >relative priority among the memcgs?
> >> >> >
> >> >> >>
> >> >> >> >If this approach works for you (or any other audience), that's =
great,
> >> >> >> >I can share more details and perhaps we can reach something tha=
t we
> >> >> >> >can both use :)
> >> >> >>
> >> >> >> If you have a good idea, please share more details or show some =
code.
> >> >> >> I would greatly appreciate it
> >> >> >
> >> >> >The code we have needs to be rebased onto a different version and
> >> >> >cleaned up before it can be shared, but essentially it is as
> >> >> >described.
> >> >> >
> >> >> >(a) All processes and memcgs start with a default score.
> >> >> >(b) Userspace can specify scores for memcgs and processes. A highe=
r
> >> >> >score means higher priority (aka less score gets killed first).
> >> >> >(c) The OOM killer essentially looks for the memcg with the lowest
> >> >> >scores to kill, then among this memcg, it looks for the process wi=
th
> >> >> >the lowest score. Ties are broken based on usage, so essentially i=
f
> >> >> >all processes/memcgs have the default score, we fallback to the
> >> >> >current OOM behavior.
> >> >>
> >> >> If memory oversold is severe, all processes of the lowest priority
> >> >> memcg may be killed before selecting other memcg processes.
> >> >> If there are 1000 processes with almost zero memory usage in
> >> >> the lowest priority memcg, 1000 invalid kill events may occur.
> >> >> To avoid this situation, even for the lowest priority memcg,
> >> >> I will leave him a very small oom.protect quota.
> >> >
> >> >I checked internally, and this is indeed something that we see from
> >> >time to time. We try to avoid that with userspace OOM killing, but
> >> >it's not 100% effective.
> >> >
> >> >>
> >> >> If faced with two memcgs with the same total memory usage and
> >> >> priority, memcg A has more processes but less memory usage per
> >> >> single process, and memcg B has fewer processes but more
> >> >> memory usage per single process, then when OOM occurs, the
> >> >> processes in memcg B may continue to be killed until all processes
> >> >> in memcg B are killed, which is unfair to memcg B because memcg A
> >> >> also occupies a large amount of memory.
> >> >
> >> >I believe in this case we will kill one process in memcg B, then the
> >> >usage of memcg A will become higher, so we will pick a process from
> >> >memcg A next.
> >>
> >> If there is only one process in memcg A and its memory usage is higher
> >> than any other process in memcg B, but the total memory usage of
> >> memcg A is lower than that of memcg B. In this case, if the OOM-killer
> >> still chooses the process in memcg A. it may be unfair to memcg A.
> >>
> >> >> Dose your approach have these issues? Killing processes in a
> >> >> user-defined priority is indeed easier and can work well in most ca=
ses,
> >> >> but I have been trying to solve the cases that it cannot cover.
> >> >
> >> >The first issue is relatable with our approach. Let me dig more info
> >> >from our internal teams and get back to you with more details.
>
> --
> Thanks for your comment!
> chengkaitao
>
>
