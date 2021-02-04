From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Thu, 4 Feb 2021 10:46:10 +0100
Message-ID: <YBvCYhdPai+pb8u2@hirez.programming.kicks-ass.net>
References: <20210204010157.1823669-1-aklimov@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QF37dPCi57HEpfqUEK+5VUOa3KKAQXFiBdpPks8yG20=; b=NlCodaOYD+cypLcm3DpzdiK5SG
        enboRJqS7Gco2hpMe/1qaYVqdyNlxcLRp4nvUZJEg2FjEMadpp2grRgO50XSeWSi+2pvzxTpJt2xU
        L80uLyOvmhiADkKp93jPjS1slDGSoMJCY36LVm3Px1jF/9iCRd5EIyUa/PS1ohZEmlctc7vnci27C
        Og2Cd3illgZyC3Ie6gF4QqEFVonx/tmvnXfvKBVXVzFFUGvoBVGvTRvwzMod/u2JSP25tj1q44UkO
        qApjLYLA7hTMClH89C37qIuoIugDL2WAOM+hK8EE/upbpZTd1D4mj5i/ekzPehAFe5E6GgA9EoRon
        usv3VBgQ==;
Content-Disposition: inline
In-Reply-To: <20210204010157.1823669-1-aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Feb 04, 2021 at 01:01:57AM +0000, Alexey Klimov wrote:
> @@ -1281,6 +1282,11 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
>  	err = _cpu_up(cpu, 0, target);
>  out:
>  	cpu_maps_update_done();
> +
> +	/* To avoid out of line uevent */
> +	if (!err)
> +		cpuset_wait_for_hotplug();
> +
>  	return err;
>  }
>  

> @@ -2071,14 +2075,18 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
>  	struct device *dev = get_cpu_device(cpu);
>  
>  	dev->offline = false;
> -	/* Tell user space about the state change */
> -	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
>  }
>  

One concequence of this is that you'll now get a bunch of notifications
across things like suspend/hybernate.
