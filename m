From: Qais Yousef <qais.yousef@arm.com>
Subject: Re: [PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Fri, 5 Feb 2021 11:22:19 +0000
Message-ID: <20210205112219.kxdjpvjykrv6fi3x@e107158-lin>
References: <20210204010157.1823669-1-aklimov@redhat.com>
 <YBvCYhdPai+pb8u2@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <YBvCYhdPai+pb8u2@hirez.programming.kicks-ass.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Alexey Klimov <aklimov@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yury.norov@gmail.com, daniel.m.jordan@oracle.com, tglx@linutronix.de, jobaker@redhat.com, audralmitchel@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org, rafael@kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, klimov.linux@gmail.com

On 02/04/21 10:46, Peter Zijlstra wrote:
> On Thu, Feb 04, 2021 at 01:01:57AM +0000, Alexey Klimov wrote:
> > @@ -1281,6 +1282,11 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
> >  	err = _cpu_up(cpu, 0, target);
> >  out:
> >  	cpu_maps_update_done();
> > +
> > +	/* To avoid out of line uevent */
> > +	if (!err)
> > +		cpuset_wait_for_hotplug();
> > +
> >  	return err;
> >  }
> >  
> 
> > @@ -2071,14 +2075,18 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
> >  	struct device *dev = get_cpu_device(cpu);
> >  
> >  	dev->offline = false;
> > -	/* Tell user space about the state change */
> > -	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> >  }
> >  
> 
> One concequence of this is that you'll now get a bunch of notifications
> across things like suspend/hybernate.

And the resume latency will incur 5-30ms * nr_cpu_ids.

Since you just care about device_online(), isn't cpu_device_up() a better place
for the wait? This function is special helper for device_online(), leaving
suspend/resume and kexec paths free from having to do this unnecessary wait.

Thanks

--
Qais Yousef
