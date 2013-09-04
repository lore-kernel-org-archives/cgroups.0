From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Wed, 04 Sep 2013 14:10:00 +0200
Message-ID: <20130904141000.0F910EFA@pobox.sk>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>, <20130803170831.GB23319@cmpxchg.org>, <20130830215852.3E5D3D66@pobox.sk>, <20130902123802.5B8E8CB1@pobox.sk>, <20130903204850.GA1412@cmpxchg.org>, <20130904114523.A9F0173C@pobox.sk> <20130904115741.GA28285@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130904115741.GA28285-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?utf-8?q?Andrew_Morton?= <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?utf-8?q?David_Rientjes?= <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>[...]
>> My script has just detected (and killed) another freezed cgroup. I
>> must say that i'm not 100% sure that cgroup was really freezed but it
>> has 99% or more memory usage for at least 30 seconds (well, or it has
>> 99% memory usage in both two cases the script was checking it). Here
>> are stacks of processes inside it before they were killed:
>[...]
>> pid: 26536
>> stack:
>> [<ffffffff81080a45>] refrigerator+0x95/0x160
>> [<ffffffff8106ac2b>] get_signal_to_deliver+0x1cb/0x540
>> [<ffffffff8100188b>] do_signal+0x6b/0x750
>> [<ffffffff81001fc5>] do_notify_resume+0x55/0x80
>> [<ffffffff815cb662>] retint_signal+0x3d/0x7b
>> [<ffffffffffffffff>] 0xffffffffffffffff
>
>[...]
>
>This task is sitting in the refigerator which means it has been frozen
>by the freezer cgroup most probably. I am not familiar with the
>implementation but my recollection is that you have to thaw that group
>in order the killed process can pass away.
>-- 
>Michal Hocko
>SUSE Labs
>



Yes, my script is freezing the cgroup before killing processes inside it. Stacks are taken after the freeze, it that problem?

azur
