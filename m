From: Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Query regarding deadlock involving cgroup_threadgroup_rwsem and cpu_hotplug_lock
Date: Mon, 15 Aug 2022 17:25:52 +0800
Message-ID: <CAB8ipk90LxNNbq5OKamd-ArkqhEZjxS1fFZJXtnbQwGzyyJ3wQ@mail.gmail.com>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com> <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com> <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org> <YuGTBLkFerUboctl@slm.duckdns.org>
 <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com> <20220815090556.GB27407@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=m64dCm5y6abMgyqwAQFCPVcLqHA6yb02EbRC6+noQbw=;
        b=nnmZdSGgeYdNQlt7klf2KWrMATSS13t2yHEkVMt+x0DICtLrR28QtzNdoDTRaEmPom
         z+Gs8Dqq57cX383CEv81ElNXe4hwEdFC/yx/espCw2xpTQameFuDpE7JbCuTbWB+Kbol
         yO27DHFvxupX+VcmZM86sl6boJZeqggbNf4o8YzZtEaZQeYGSShIxAUkWIBfNtoTsM9T
         Cr27BqXZo98/XfG56V1Yvc/jztezBrzouNmTZvHA/wtgonY4MU0pci1t+I+tRr3mf5HO
         sdAx6MpIxbc1GK37dE/4nGERixFc6AjZOLsoU/8XHkj2Yc63r6S/c5WZxknVrcBXx/3D
         7pig==
In-Reply-To: <20220815090556.GB27407-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi Michal

On Mon, Aug 15, 2022 at 5:06 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> +Cc: Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhang Qiao <zhangqiao22@huawei.=
com>
>
> On Fri, Aug 12, 2022 at 03:57:00PM +0530, Mukesh Ojha <quic_mojha@quicinc=
.com> wrote:
> > The original patch of yours [1]  and the revert of [2] is fixing the is=
sue
> > and it is also confirmed here [3].
> > Can we get proper fix merge on your tree?
> >
> > [1] https://lore.kernel.org/lkml/YuGbYCfAG81mZBnN-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/
> >
> > [2]
> > https://lore.kernel.org/all/20220121101210.84926-1-zhangqiao22@huawei.c=
om/
>
> The revert + Tejun's patch looks fine wrt the problem of the reverted
> patch (just moves cpus_read_lock to upper callers).

Your means is that the problem should be fixed by [1]+[2]'s revert ?
I just tested the case which reverted the [2]. Need I test with [1] and [2]=
?

Thanks!

>
> I'd just suggest a comment that'd explicitly document also the lock
> order that we stick to, IIUC, it should be:
>
>         cpu_hotplug_lock // cpus_read_lock
>         cgroup_threadgroup_rwsem
>         cpuset_rwsem
>
> Michal
>
> >
> > [3] https://lore.kernel.org/lkml/CAB8ipk-72V-bYRfL-VcSRSyXTeQqkBVj+1d5M=
HSVV5CTar9a0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> >
> > -Mukesh
