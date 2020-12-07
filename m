From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC][PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish
 on cpu online
Date: Mon, 7 Dec 2020 09:38:27 +0100
Message-ID: <20201207083827.GD3040@hirez.programming.kicks-ass.net>
References: <20201203171431.256675-1-aklimov@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tt7kYwGZL/f9gqTlt1OKvzsn0qmf++skmQ2P5/DR7To=; b=bV9WbCuibWCCvRZSVNtx4ueWon
        AdM3PcTwc0oGZWl0yGHetGgyPsqdAmMrbvmAM7MjW2ex605SPcrhgyylVOIGxkIj6wJLtEfeHCif9
        /lz3kFjewNZ4yXWBcu58WWaFZPY2biePzkI+VkQAQIASe45vv+V63PEM3MRCtqwfQrqLCcZ36PMwd
        4c4F8IsRynK1Fvs6HXVDP+tavmb4/Aifv4Gw0dcKZYG0ATgNtVNL95UjpX6R/jsMLa8ZnTezY9So9
        jgpcOFTfiZkFsyr7PZibeYGWqbmzz6Id4J7PDaAE7bBtUbcJgMworSUKPTN0CkwSGxVJANF7QA0Do
        g639Bnkg==;
Content-Disposition: inline
In-Reply-To: <20201203171431.256675-1-aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Dec 03, 2020 at 05:14:31PM +0000, Alexey Klimov wrote:
> When a CPU offlined and onlined via device_offline() and device_online()
> the userspace gets uevent notification. If, after receiving uevent,
> userspace executes sched_setaffinity() on some task trying to move it
> to a recently onlined CPU, then it will fail with -EINVAL. Userspace needs
> to wait around 5..30 ms before sched_setaffinity() will succeed for
> recently onlined CPU after receiving uevent.

Right.

>  Unfortunately, the execution time of
> echo 1 > /sys/devices/system/cpu/cpuX/online roughly doubled with this
> change (on my test machine).

Nobody cares, it's hotplug, it's supposed to be slow :-) That is,
we fundamentally shift the work _to_ the hotplug path, so as to keep
everybody else fast.

> The nature of this bug is also described here (with different consequences):
> https://lore.kernel.org/lkml/20200211141554.24181-1-qais.yousef-5wv7dgnIgG8@public.gmane.org/

Yeah, pesky deadlocks.. someone was going to try again.


>  kernel/cpu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 6ff2578ecf17..f39a27a7f24b 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -15,6 +15,7 @@
>  #include <linux/sched/smt.h>
>  #include <linux/unistd.h>
>  #include <linux/cpu.h>
> +#include <linux/cpuset.h>
>  #include <linux/oom.h>
>  #include <linux/rcupdate.h>
>  #include <linux/export.h>
> @@ -1275,6 +1276,8 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
>  	}
>  
>  	err = _cpu_up(cpu, 0, target);
> +	if (!err)
> +		cpuset_wait_for_hotplug();
>  out:
>  	cpu_maps_update_done();
>  	return err;

My only consideration is if doing that flush under cpu_add_remove_lock()
is wise.
