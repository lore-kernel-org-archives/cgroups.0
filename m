From: syzbot <syzbot+a526c269335f529d25c8-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] linux-next test error: WARNING in __mod_memcg_lruvec_state
Date: Mon, 28 Feb 2022 03:06:22 -0800
Message-ID: <000000000000e3387805d912097c@google.com>
References: <YhysqzlMHWTXLR4B@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YhysqzlMHWTXLR4B-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/staging.git 71d365035711aef4c4b1018d02fcf7868e3cb0c5

This crash does not have a reproducer. I cannot test it.

>
> On 2022-02-27 22:09:43 [-0800], Andrew Morton wrote:
>> (cc bigeasy)
>> 
>>                         WARN_ON_ONCE(!irqs_disabled());
>> 
>> in __mod_memcg_lruvec_state(), methinks.
>
> This report ist from before you added
>    mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch
>
> to your tree. So it can be ignored. The next -next tree should be fine.
>
> Sebastian
