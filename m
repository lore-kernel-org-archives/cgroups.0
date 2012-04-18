From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 5/5] expose per-taskgroup schedstats in cgroup
Date: Wed, 18 Apr 2012 22:44:25 +0800
Message-ID: <CAFj3OHUwF2My5c-+ZCwLNynNTokYwioXP2jTJ4FtKg_=jPed0Q@mail.gmail.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com>
	<1334010315-4453-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=CxpaO34X2UV/aJkc2sB/HPizKlNE++dJTU5Fpap2byo=;
        b=B5Bf9IC0mAyNOdb+w8MX6YfqGyT7AOWg3zyLoJPxBD+1xf9pK1/ORNE1kYNSHuOy8P
         vMn7kMFPcZo5ms4liGX90JAHsMzrO5ITJPnibib8jn+5oRp14cAz8c9klCwX5KhGX/wC
         36+94pajHOI7+RCbLI/kGIQ2Mob4JxHsLBjseMoD+goDYDqFCtRw48YnDviyDA9Ixo5i
         yKvJVP3mBciHPtqIDEWhnyKUr4LiUtgegQu0gl+0jilrBp9FGVOWOM4NcUSWL7XfirSY
         cn3j93NLMfr7XcbH4ZalFydy/mioDzk6iKrqf4IsYIzei+g1iHdFvtzj72DQ+wedYH/7
         kUaA==
In-Reply-To: <1334010315-4453-6-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org

On Mon, Apr 9, 2012 at 6:25 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> w=
rote:
> This patch aims at exposing stat information per-cgroup, such as:
> =A0* idle time,
> =A0* iowait time,
> =A0* steal time,
> =A0* # context switches
> and friends. The ultimate goal is to be able to present a per-contain=
er view of
> /proc/stat inside a container. With this patch, everything that is ne=
eded to do
> that is in place, except for number of tasks.
>
> For most of the data, I achieve that by hooking into the schedstats f=
ramework,
> so although the overhead of that is prone to discussion, I am not add=
ing anything,
> but reusing what's already there instead. The exception being that th=
e data is
> now computed and stored in non-task se's as well, instead of entity_i=
s_task() branches.
> However, I expect this to be minimum comparing to the alternative of =
adding new
> hierarchy walks. Those are kept intact.
>
> The format of the new file added is the same as the one recently
> introduced for cpuacct:
>
> =A0cpu0.idle X
> =A0cpu0.steal Y
> =A0...
> =A0cpu1.idle X1
> =A0cpu1.steal Y1
> =A0...
>

You define the idle time as the sum of task's sleeping time which i
think it needs to
discuss. It changes the current meaning of idle time which might be con=
fusing
and can not reflect the the actual cpu busy-idle situation. IMHO, idle
time can just
be the true system value. Personally I prefer to your last version in
the way of computing
idle time (http://thread.gmane.org/gmane.linux.kernel/1194838). And
iowait can be
computed in the similar way.

As to steal time, "Steal time is the percentage of time a virtual CPU
waits for a real
CPU while the hypervisor is servicing another virtual processor".
Speaking from the
point of view of resource controlling(isolation), cgroup is a
lightweight method towards
virtualiztion, so I think obeying its primitive meaning is more
appropriate: the time not
servicing me including time stolen by the tasks of other cgroup.
