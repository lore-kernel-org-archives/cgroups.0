From: =?utf-8?B?TWF4aW0g4oCcTUFYUEFJTuKAnSBNYWthcm92?= 
        <maxpain177-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups v2 cpuset partition bug
Date: Mon, 29 Aug 2022 20:16:23 +0300
Message-ID: <26A2A485-B70C-4361-8368-1A0081570E7C@gmail.com>
References: <C98773C9-F5ED-4664-BED1-5C03351130D4@gmail.com>
 <YwT/BNqIdCEyUpFR@slm.duckdns.org>
 <ef183fe9-8458-8a7f-2b8e-1c38666b6399@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc;
        bh=X6VmYsgMW8K15KBs3jUfjE+heWPeLcY8CtwqiX8/U7g=;
        b=M4QGkW3ptdqm71GWxKRUeBll7XiacNWh893RwsJPYgWFWBnh9Zggap/ig8nQavJHpH
         DCapLVvJudLtUcz0FT33djVjCUi5hWprvjjCm5gk4OnBbhHxmh2tQzzKA+tWFKq0g8Pb
         /v0iVSe7/FxUMWYlg2inn9QaOdW5M1w0AT/rFg6v4lAoglF3/+s6Zo9hcVg2suMFyOd7
         IpU+XP2RYOznfsY8w7yYcVnbIaKG+kK1q/K/hOuWLWflbOacLchd7nP02MME8kq8Onix
         xKxtXEsV+ZeQRNiwyBgwbWJO/Tx5Ggy+XJDwkhUbyWfSTDb2YXeQOT+3D1ASXRYStZRC
         Yelg==
In-Reply-To: <ef183fe9-8458-8a7f-2b8e-1c38666b6399-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi. I used top and htop programs to check what CPU is using, and it's =
showing that this task is running on CPU 2, so I think it shows the =
correct CPU that is currently being used.
Please note that the containerd process has /system/runtime cgroup, =
which inherits cpuset from the root cgroup. /system/runtime cgroup =
doesn't have any cpuset settings. Maybe this is the reason?

I tried to remove the lowlatency group with cpuset.cpus.partition=3Droot =
and do taskset -cp 4 1079 manually, and it works without any restart.

I updated my post on StackExchange and added some new screenshots, so =
please check it out.

> On 29 Aug 2022, at 18:24, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> On 8/23/22 12:23, Tejun Heo wrote:
>> (cc'ing Waiman for visibilty)
>>=20
>> On Tue, Aug 23, 2022 at 03:13:30PM +0300, Maxim =E2=80=9CMAXPAIN=E2=80=9D=
 Makarov wrote:
>>> Hello. I have no idea where I can ask questions about cgroups v2. I =
have a problem with cpuset partitions.
>>> Could you please, check this question?
>>> =
https://unix.stackexchange.com/questions/714454/cgroups-v2-cpuset-doesnt-t=
ake-an-effect-without-process-restart
>=20
> When a partition is created, the cpuset code will update the cpu =
affinity of the tasks in the parent cpuset using update_tasks_cpumask(). =
This function will set the new cpu affinity for those tasks and move it =
over to the new cpus. However, if the tasks aren't running at the time, =
the move may be delayed until those tasks are waken up. The fact the =
task affinity is correct means that the cpuset code has done the right =
thing.
>=20
> I am not sure what tool do you use to check the task's cpus. I believe =
the tool may show what cpu the task is previously running on. It does =
not means the the task will run on that cpu when it is waken up. It is =
only a bug if the task is running and it is on the wrong cpu.
>=20
> Cheers,
> Longman
>=20

