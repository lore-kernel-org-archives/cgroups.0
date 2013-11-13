From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Wed, 13 Nov 2013 09:51:44 +0800
Message-ID: <5282DB30.5000700@huawei.com>
References: <20131031192732.2dbb14b3@gandalf.local.home> <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com> <5277932C.40400@huawei.com> <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com> <5278B3F1.9040502@huawei.com> <20131107235301.GB1092@cmpxchg.org> <20131108001437.GC1092@cmpxchg.org> <CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com> <20131111153943.GA22384@dhcp22.suse.cz> <CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com> <20131112135844.GA6049@dhcp22.suse.cz> <CA+SBX_MWM1iU7kyT5Ct3OJ7S3oMgbz_EWbFH1dGae+r_UnDxOA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+SBX_MWM1iU7kyT5Ct3OJ7S3oMgbz_EWbFH1dGae+r_UnDxOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>> Btw. how reproducible is this? Do you think you could try to bisect
>> it down? Reducing bisection to mm/ and kernel/ diretories should be
>> sufficient I guess.
> 
> The bug is quite reproducible here .. within a few minutes at most.
> Since we have diskless clients with nfsroot and aufs, bisectioning
> proved to be a bit difficult (means the kernel compiled and booted but
> aufs failed on /etc). But then I have tried bisectioning the whole
> kernel sources. Tomorrow, I will first try to test without
> CONFIG_MEMCG_SWAP_ENABLED and CONFIG_MEMCG_KMEM, and then give
> bisectioning only the two directories another try. Btw. I never saw
> this bug before 3.11, but it may well be, that because of some trivial
> code change, it became much more likely to trigger.
> 

This is possible, given we got another bug report which happened in 3.10
and we've been changing the cgroup teardown code in the past few releases
by using workqueue and brand-new percpu ref.

Still I'd suggest you bisect from 3.10 to 3.11.
