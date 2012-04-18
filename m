From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 5/5] expose per-taskgroup schedstats in cgroup
Date: Wed, 18 Apr 2012 22:57:12 +0800
Message-ID: <CAFj3OHVMHLyD+XoMQoi4cq8cNTZ35MK1vgkZPaRias2Xs+roww@mail.gmail.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com>
	<1334010315-4453-6-git-send-email-glommer@parallels.com>
	<CAFj3OHUwF2My5c-+ZCwLNynNTokYwioXP2jTJ4FtKg_=jPed0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=xPIQjIq8JJN7iIFSRADr/D8SKsnU9YfFgSit71ld5gw=;
        b=xK32R7C1h5LL6XizsFgOGxfpBVH1kf6gmA9v+iOCZkh+3kmVVexd66YHMNzCrInyx/
         BDqNfyRzpS2QEyANBdEIVSCgNYrbt7UoLySSH5nIjNqR0zWu/Nih+B1tKPBOuolJrTIU
         bP/3cRghq/ThoDPRfRtabxbqJn5S2hwZGeteLlTef67zbg3ZIYV5z1lP1GQ4TWyBzIk6
         wUkeHPPySixBwgiltTiy3RiQKubmKqpFmnDbTmDmd+wc3ZlUkdlG1g0loy+5t7LRNz9y
         WpGHA6zCwVdfO2WmD3K4z1mPecOclBogmGAkOk6/423Ehwd3DAZyr0FpgH6QMLgbO8LZ
         qG8A==
In-Reply-To: <CAFj3OHUwF2My5c-+ZCwLNynNTokYwioXP2jTJ4FtKg_=jPed0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org

On Wed, Apr 18, 2012 at 10:44 PM, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> On Mon, Apr 9, 2012 at 6:25 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>=
 wrote:
>> This patch aims at exposing stat information per-cgroup, such as:
>> =A0* idle time,
>> =A0* iowait time,
>> =A0* steal time,
>> =A0* # context switches
>> and friends. The ultimate goal is to be able to present a per-contai=
ner view of
>> /proc/stat inside a container. With this patch, everything that is n=
eeded to do
>> that is in place, except for number of tasks.
>>
>> For most of the data, I achieve that by hooking into the schedstats =
framework,
>> so although the overhead of that is prone to discussion, I am not ad=
ding anything,
>> but reusing what's already there instead. The exception being that t=
he data is
>> now computed and stored in non-task se's as well, instead of entity_=
is_task() branches.
>> However, I expect this to be minimum comparing to the alternative of=
 adding new
>> hierarchy walks. Those are kept intact.
>>
>> The format of the new file added is the same as the one recently
>> introduced for cpuacct:
>>
>> =A0cpu0.idle X
>> =A0cpu0.steal Y
>> =A0...
>> =A0cpu1.idle X1
>> =A0cpu1.steal Y1
>> =A0...
>>
>
> You define the idle time as the sum of task's sleeping time which i
> think it needs to
> discuss. It changes the current meaning of idle time which might be c=
onfusing
> and can not reflect the the actual cpu busy-idle situation. IMHO, idl=
e
> time can just
> be the true system value. Personally I prefer to your last version in
> the way of computing
> idle time (http://thread.gmane.org/gmane.linux.kernel/1194838). And
> iowait can be
> computed in the similar way.
>
> As to steal time, "Steal time is the percentage of time a virtual CPU
> waits for a real
> CPU while the hypervisor is servicing another virtual processor".
> Speaking from the
> point of view of resource controlling(isolation), cgroup is a
> lightweight method towards
> virtualiztion, so I think obeying its primitive meaning is more
> appropriate: the time not
> servicing me including time stolen by the tasks of other cgroup.

I have a different version of exposing per-cgroup /proc/stat (parts of
them come from your patchset : )  ). I can sent them out if necessary.


Thanks,
Sha
