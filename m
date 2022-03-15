From: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Subject: RE: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Tue, 15 Mar 2022 15:49:52 +0000
Message-ID: <84e5b8652edd47d29597d499f29753d6@saabgroup.com>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <20220314164332.GA20424@blackbody.suse.cz>
 <bf2ea0888a9e45d3aafe412f0094cf86@saabgroup.com>
 <20220315103553.GA3780@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220315103553.GA3780-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: =?iso-8859-1?Q?Michal_Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> (Actually when I take a step back and read your motivational example
> of a legacy game in VM, I don't think FIFO (or another RT policy) is
> suited for this case. Plain SCHED_OTHER and cpu controller's
> bandwidth limitation could do just fine -- you can apply to a
> (threaded) cgroup with chosen threads only.)

As you might have already surmised it was a placeholder example to
give the general idea. I think it is time to add some more details. :)

Assume that you have an embedded system running some kind of software
with real time like properties. You want to develop and debug your
software locally on your high-end machine since it is much more
convenient. Alas the software runs way too fast due to the difference
in performance so you can't detect overruns etc.

Assume also that you have a special scheduler that behaves in a very
strange way compared to ordinary schedulers. Each scheduling tick it
waits a configurable time before it lets the scheduled task execute
its tick. This effectively means that the task is throttled and thus
executes slower than it normally would. By tuning the waiting time you
can tune the execution speed so comes close enough to what it is on
the target system.

Assume also that you have enough cores in your system so you can
dedicate one core for the VMM and one core for the virtual core thread
the Guest uses to execute the software. One way of implementing this
kind of scheduler would be to create a fork of the FIFO scheduler that
have this behavior.

This crazy(?) technique can of course be used for other things such as
running old DOS games or running an RTOS intended for embedded systems
as the Guest in the VM and so on. ;)


/John

-----Original Message-----
From: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>=20
Sent: den 15 mars 2022 11:36
To: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [EXTERNAL] Re: Split process across multiple schedulers?

On Tue, Mar 15, 2022 at 08:19:26AM +0000, Olsson John <john.olsson-zlDGZTLO=
Euz3oGB3hsPCZA@public.gmane.org> wrote:
> If I'm understanding you correctly this effectively means that it is=20
> possible to spread a process and its threads across multiple cgroups=20
> that in turn may have different schedulers (and CPU affinity)=20
> associated with them?

Yes, the docs is here
https://www.kernel.org/doc/html/v5.17-rc8/admin-guide/cgroup-v2.html#threads

> > (Without CONFIG_RT_GROUP_SCHED all RT threads are effectively in the=20
> > root cgroup.)
>=20
> Interesting! I have missed this little tidbit of information. This is=20
> indeed very good to know!

Maybe I should have added this applies from the POV of the cpu controller i=
n particular...

> A side effect of this is that in V2 you can't have an RT thread pinned=20
> to a specific core that is evacuated, right?

...it has no effect for grouping of cpuset controller (assuming both cpu an=
d cpuset are enabled in given subtree).

> If you could do this it would also be possible to remove the portion=20
> of the scheduling interval that is left for non-RT threads in the=20
> cgroup config since there would not be any other threads on this=20
> evacuated core.
> By doing that you would eliminate jitter due to that otherwise the=20
> scheduler would interrupt the RT thread and immediately re-schedule it=20
> again. And thus you would theoretically get very good RT properties=20
> (unless you make system calls).

Well, there are more jobs that can interfere with RT workload on a cpu (see=
 isolcpus=3D [1]) and there's some ongoing work to make these more convenie=
nt via cpuset controller [2]. The currently working approach would be to us=
e isolcpus=3D cmdline to isolate the CPUs and use either
sched_setaffinity() or cpuset controller to place tasks on the reserved CPU=
s (the cpuset approach is more strict as it may prevent unprivileged thread=
s to switch to another CPU).=20

> If you instead used FIFO scheduling (which handles RT threads only,
> right?) then you could eliminate this noise. Or I am just showing off=20
> how little I understand about scheduling in Linux. ;)

(Actually when I take a step back and read your motivational example of a l=
egacy game in VM, I don't think FIFO (or another RT policy) is suited for t=
his case. Plain SCHED_OTHER and cpu controller's bandwidth limitation could=
 do just fine -- you can apply to a (threaded) cgroup with chosen threads o=
nly.)

HTH,
Michal


[1] https://www.kernel.org/doc/html/v5.17-rc8/admin-guide/kernel-parameters=
.html?highlight=3Disolcpus
[2] https://lore.kernel.org/all/20211205183220.818872-1-longman-H+wXaHxf7aL=
QT0dZR+AlfA@public.gmane.org/
