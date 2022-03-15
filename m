From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Tue, 15 Mar 2022 11:35:53 +0100
Message-ID: <20220315103553.GA3780@blackbody.suse.cz>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <20220314164332.GA20424@blackbody.suse.cz>
 <bf2ea0888a9e45d3aafe412f0094cf86@saabgroup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647340555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4MLqG2jYAqMJVFGVl9uQo/qZHJDtNUCqj95IKfyjlIs=;
        b=HQerq55GnNl/XQ/47+SzBS7xttc161pt08lvmSb65Z8HOxQdpYo3rQ1TQAu7rHp5l2uc0Z
        Ruy1QXyd1k2jFE5OO+7fRimcoMYEDvRIlALar+HLfhb30Wd2PXPs60TvYFjtsyesugSU7h
        6ALDxYxT90jysW1JwcMW6c4vqQiUT1s=
Content-Disposition: inline
In-Reply-To: <bf2ea0888a9e45d3aafe412f0094cf86-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 15, 2022 at 08:19:26AM +0000, Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org> wrote:
> If I'm understanding you correctly this effectively means that it is
> possible to spread a process and its threads across multiple cgroups
> that in turn may have different schedulers (and CPU affinity)
> associated with them?

Yes, the docs is here
https://www.kernel.org/doc/html/v5.17-rc8/admin-guide/cgroup-v2.html#threads

> > (Without CONFIG_RT_GROUP_SCHED all RT threads are effectively in the
> > root cgroup.)
> 
> Interesting! I have missed this little tidbit of information. This is
> indeed very good to know!

Maybe I should have added this applies from the POV of the cpu
controller in particular...

> A side effect of this is that in V2 you can't have an RT thread pinned
> to a specific core that is evacuated, right?

...it has no effect for grouping of cpuset controller (assuming both cpu
and cpuset are enabled in given subtree).

> If you could do this it would also be possible to remove the portion
> of the scheduling interval that is left for non-RT threads in the
> cgroup config since there would not be any other threads on this
> evacuated core.
> By doing that you would eliminate jitter due to that otherwise the
> scheduler would interrupt the RT thread and immediately re-schedule it
> again. And thus you would theoretically get very good RT properties
> (unless you make system calls).

Well, there are more jobs that can interfere with RT workload on a cpu
(see isolcpus= [1]) and there's some ongoing work to make these more
convenient via cpuset controller [2]. The currently working approach
would be to use isolcpus= cmdline to isolate the CPUs and use either
sched_setaffinity() or cpuset controller to place tasks on the reserved
CPUs (the cpuset approach is more strict as it may prevent unprivileged
threads to switch to another CPU). 

> If you instead used FIFO scheduling (which handles RT threads only,
> right?) then you could eliminate this noise. Or I am just showing off
> how little I understand about scheduling in Linux. ;)

(Actually when I take a step back and read your motivational example of
a legacy game in VM, I don't think FIFO (or another RT policy) is suited
for this case. Plain SCHED_OTHER and cpu controller's bandwidth
limitation could do just fine -- you can apply to a (threaded) cgroup
with chosen threads only.)

HTH,
Michal


[1] https://www.kernel.org/doc/html/v5.17-rc8/admin-guide/kernel-parameters.html?highlight=isolcpus
[2] https://lore.kernel.org/all/20211205183220.818872-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
