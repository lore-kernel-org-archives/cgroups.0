From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/2] memcontrol: support cgroup level OOM protection
Date: Fri, 19 May 2023 15:04:26 -0700
Message-ID: <CAJD7tkb7zSFT5VnZ-00CA0mBE8dFmVqwPwvMpCYG9c-J3ovjyA@mail.gmail.com>
References: <CAJD7tkaOMeeGNqm6nFyHgPhd9VpnCVqCAYCY725NoTohTMAnmw@mail.gmail.com>
 <B66FDA24-50C6-444D-BD84-124E68A2AEEE@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684533903; x=1687125903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JS9bsmb2ExhOm+g4Lt75nCSXcOXphRaQoc6aXCE0Cw=;
        b=RnHJnnkj1VIHqje8IVNGPXgjD9OytYKxqYmMWS+0edD6d8Vlh452IK5UUoVYNHA0m/
         JrZSLCWIuJkr/qFmn1GwZ0Z9okNmo3X9wIG4aOXiJQ71dR9N+z/hpGwqL9OucT/xYJs8
         sXEdyf8eOAvooUYTi70XJlwMMww38PhJnoEwn+5ccVFnCUU0iBMWPYHYxxF+nFh6BS11
         hlwa6Rx019RR4e90c7/yYg70FhEHrfU21w6a39b0FXQyYvZVkLYv79wYuo3K268S+3qN
         t9JlkLqNgoKr9rx/LuewcGO1LO3srqyemDzUIMJlk4pSxE08v9Vre2LHZVt2SYIitl+8
         7ARQ==
In-Reply-To: <B66FDA24-50C6-444D-BD84-124E68A2AEEE-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?56iL5Z6y5rabIENoZW5na2FpdGFvIENoZW5n?= <chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, May 17, 2023 at 10:12=E2=80=AFPM =E7=A8=8B=E5=9E=B2=E6=B6=9B Chengk=
aitao Cheng
<chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
>
> At 2023-05-18 04:42:12, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >On Wed, May 17, 2023 at 3:01=E2=80=AFAM =E7=A8=8B=E5=9E=B2=E6=B6=9B Chen=
gkaitao Cheng
> ><chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
> >>
> >> At 2023-05-17 16:09:50, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >> >On Wed, May 17, 2023 at 1:01=E2=80=AFAM =E7=A8=8B=E5=9E=B2=E6=B6=9B C=
hengkaitao Cheng
> >> ><chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> wrote:
> >> >>
> >> >> At 2023-05-17 14:59:06, "Yosry Ahmed" <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
> >> >> >+David Rientjes
> >> >> >
> >> >> >On Tue, May 16, 2023 at 8:20=E2=80=AFPM chengkaitao <chengkaitao@d=
idiglobal.com> wrote:
> >> >> >>
> >> >> Thank you for providing a new application scenario. You have descri=
bed a
> >> >> new per-memcg approach, but a simple introduction cannot explain th=
e
> >> >> details of your approach clearly. If you could compare and analyze =
my
> >> >> patches for possible defects, or if your new approach has advantage=
s
> >> >> that my patches do not have, I would greatly appreciate it.
> >> >
> >> >Sorry if I was not clear, I am not implying in any way that the
> >> >approach I am describing is better than your patches. I am guilty of
> >> >not conducting the proper analysis you are requesting.
> >>
> >> There is no perfect approach in the world, and I also seek your advice=
 with
> >> a learning attitude. You don't need to say sorry, I should say thank y=
ou.
> >>
> >> >I just saw the thread and thought it might be interesting to you or
> >> >others to know the approach that we have been using for years in our
> >> >production. I guess the target is the same, be able to tell the OOM
> >> >killer which memcgs/processes are more important to protect. The
> >> >fundamental difference is that instead of tuning this based on the
> >> >memory usage of the memcg (your approach), we essentially give the OO=
M
> >> >killer the ordering in which we want memcgs/processes to be OOM
> >> >killed. This maps to jobs priorities essentially.
> >>
> >> Killing processes in order of memory usage cannot effectively protect
> >> important processes. Killing processes in a user-defined priority orde=
r
> >> will result in a large number of OOM events and still not being able t=
o
> >> release enough memory. I have been searching for a balance between
> >> the two methods, so that their shortcomings are not too obvious.
> >> The biggest advantage of memcg is its tree topology, and I also hope
> >> to make good use of it.
> >
> >For us, killing processes in a user-defined priority order works well.
> >
> >It seems like to tune memory.oom.protect you use oom_kill_inherit to
> >observe how many times this memcg has been killed due to a limit in an
> >ancestor. Wouldn't it be more straightforward to specify the priority
> >of protections among memcgs?
> >
> >For example, if you observe multiple memcgs being OOM killed due to
> >hitting an ancestor limit, you will need to decide which of them to
> >increase memory.oom.protect for more, based on their importance.
> >Otherwise, if you increase all of them, then there is no point if all
> >the memory is protected, right?
>
> If all memory in memcg is protected, its meaning is similar to that of th=
e
> highest priority memcg in your approach, which is ultimately killed or
> never killed.

Makes sense. I believe it gets a bit trickier when you want to
describe relative ordering between memcgs using memory.oom.protect.

>
> >In this case, wouldn't it be easier to just tell the OOM killer the
> >relative priority among the memcgs?
> >
> >>
> >> >If this approach works for you (or any other audience), that's great,
> >> >I can share more details and perhaps we can reach something that we
> >> >can both use :)
> >>
> >> If you have a good idea, please share more details or show some code.
> >> I would greatly appreciate it
> >
> >The code we have needs to be rebased onto a different version and
> >cleaned up before it can be shared, but essentially it is as
> >described.
> >
> >(a) All processes and memcgs start with a default score.
> >(b) Userspace can specify scores for memcgs and processes. A higher
> >score means higher priority (aka less score gets killed first).
> >(c) The OOM killer essentially looks for the memcg with the lowest
> >scores to kill, then among this memcg, it looks for the process with
> >the lowest score. Ties are broken based on usage, so essentially if
> >all processes/memcgs have the default score, we fallback to the
> >current OOM behavior.
>
> If memory oversold is severe, all processes of the lowest priority
> memcg may be killed before selecting other memcg processes.
> If there are 1000 processes with almost zero memory usage in
> the lowest priority memcg, 1000 invalid kill events may occur.
> To avoid this situation, even for the lowest priority memcg,
> I will leave him a very small oom.protect quota.

I checked internally, and this is indeed something that we see from
time to time. We try to avoid that with userspace OOM killing, but
it's not 100% effective.

>
> If faced with two memcgs with the same total memory usage and
> priority, memcg A has more processes but less memory usage per
> single process, and memcg B has fewer processes but more
> memory usage per single process, then when OOM occurs, the
> processes in memcg B may continue to be killed until all processes
> in memcg B are killed, which is unfair to memcg B because memcg A
> also occupies a large amount of memory.

I believe in this case we will kill one process in memcg B, then the
usage of memcg A will become higher, so we will pick a process from
memcg A next.

>
> Dose your approach have these issues? Killing processes in a
> user-defined priority is indeed easier and can work well in most cases,
> but I have been trying to solve the cases that it cannot cover.

The first issue is relatable with our approach. Let me dig more info
from our internal teams and get back to you with more details.

>
> --
> Thanks for your comment!
> chengkaitao
>
>
