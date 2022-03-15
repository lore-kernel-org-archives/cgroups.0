From: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Subject: RE: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Tue, 15 Mar 2022 08:19:26 +0000
Message-ID: <bf2ea0888a9e45d3aafe412f0094cf86@saabgroup.com>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <20220314164332.GA20424@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 weald.air.saab.se 22F8JTxJ094642
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=saabgroup.com;
        s=weald; t=1647332369;
        bh=Ta1UU1ZM9feM3kIV3ZbiDmewkZry9QpuDsZ21Fr45XE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ueKodJhjDRiv6sqU6EZeL46LXdLsT6Lh6JZZhBpARnls7pXmYufWpJDTTuq7iyU6M
         c87HScapL+X6ZK+aYGHY2pBoi0CKk65vkk9aHNF9/8f3+i0sDhgHeMjSAbYaHuuDpw
         LBu7LYoBARcT1OceKkD0lUD8InRl0OGry1xWojM8=
In-Reply-To: <20220314164332.GA20424-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?iso-8859-1?Q?Michal_Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thank you for your pointers Michal! :)


> Are you missing CONFIG_RT_GROUP_SCHED and v1 cpu controller's
> cpu.rt_{runtime,period}_us? (Just asking, you didn't mention this
> explicitly in your e-mail but it sounds so and it's a thing that's
> indeed missing in v2.)

I'm not sure. I have to double check. If I'm indeed missing
CONFIG_RT_GROUP_SCHED I'll let you know. ;)


> sched_setscheduler(2) applies to threads regardless of cgroup
> membership, there's no change between v1 and v2.

If I'm understanding you correctly this effectively means that it is
possible to spread a process and its threads across multiple cgroups
that in turn may have different schedulers (and CPU affinity)
associated with them?


> (Without CONFIG_RT_GROUP_SCHED all RT threads are effectively in the
> root cgroup.)

Interesting! I have missed this little tidbit of information. This is
indeed very good to know!

A side effect of this is that in V2 you can't have an RT thread pinned
to a specific core that is evacuated, right? If you could do this it
would also be possible to remove the portion of the scheduling
interval that is left for non-RT threads in the cgroup config since
there would not be any other threads on this evacuated core. By doing
that you would eliminate jitter due to that otherwise the scheduler
would interrupt the RT thread and immediately re-schedule it
again. And thus you would theoretically get very good RT properties
(unless you make system calls).

Now one could argue that there is no point in having a pinned RT
thread on a single core that is evacuated, but that means that the
thread would be interrupted HZ times per second. If you instead used
FIFO scheduling (which handles RT threads only, right?) then you could
eliminate this noise. Or I am just showing off how little I understand
about scheduling in Linux. ;)


> You may need to enable threaded mode on v2 (see cgroup.type) to
> manipulate with individual threads across cgroups. (E.g. if you want
> to use cpuset controller to pin/restrict individual threads.)

I'll read up a bit more and try what you suggest. If we have
misunderstood each other I'll contact the mailing list again with more
details. :)

