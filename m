From: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] cpu/hotplug: wait for cpuset_hotplug_work to finish
 on cpu onlining
Date: Thu, 1 Apr 2021 15:06:03 +0100
Message-ID: <20210401140603.hvtbxjxw2izuhwus@e107158-lin>
References: <20210317003616.2817418-1-aklimov@redhat.com>
 <87tuowcnv3.ffs@nanos.tec.linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87tuowcnv3.ffs-ecDvlHI5BZPZikZi3RtOZ1XZhhPuCNm+@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 03/27/21 22:01, Thomas Gleixner wrote:
> And while you carefully reworded the comment, did you actually read what
> it said and what is says now?
> 
> > -		 * cpu_down() which takes cpu maps lock. cpu maps lock
> > -		 * needs to be held as this might race against in kernel
> > -		 * abusers of the hotplug machinery (thermal management).
> 
> vs.
> 
> > +	 * cpu_down() which takes cpu maps lock. cpu maps lock
> > +	 * needed to be held as this might race against in-kernel
> > +	 * abusers of the hotplug machinery (thermal management).
> 
> The big fat hint is: "cpu maps lock needs to be held as this ...." and
> it still needs to be held for the above loop to work correctly at
> all. See also below.
> 
> So just moving comments blindly around and making them past tense is not
> cutting it. Quite the contrary the comments make no sense anymore. They
> became uncomprehensible word salad.
> 
> Now for the second part of that comment:
> 
> > +      *                                          ....  This is
> > +	 * called under the sysfs hotplug lock, so it is properly
> > +	 * serialized against the regular offline usage.
> 
> So there are two layers of protection:
> 
>    cpu_maps_lock and sysfs hotplug lock
> 
> One protects surprisingly against concurrent sysfs writes and the other
> is required to serialize in kernel usage.
> 
> Now lets look at the original protection:
> 
>    lock(sysfs)
>      lock(cpu_maps)
>        hotplug
>         dev->offline = new_state
>         uevent()
>      unlock(cpu_maps)
>    unlock(sysfs)
> 
> and the one you created:
> 
>    lock(sysfs)
>      lock(cpu_maps)
>        hotplug
>      unlock(cpu_maps)
>      dev->offline = new_state
>      uevent()
>    unlock(sysfs)
> 
> Where is that protection scope change mentioned in the change log and
> where is the analysis that it is correct?

The comment do still need updating though. Its reference to thermal management
is cryptic. I couldn't see who performs hotplug operations in thermal code.

I also think generally that comment is no longer valid after the refactor I did
to 'prevent' in-kernel users from calling cpu_up/down() directly and force them
all to go via device_offline/online() which is wrapped via the add/remove_cpu()

	33c3736ec888 cpu/hotplug: Hide cpu_up/down()

So I think except for suspend/resume/hibernate/kexec, all in-kernel users
should be serialized by lock(hotplug) now. Since uevents() don't matter for
suspend/resume/hiberante/kexec I think moving it outside of lock(cpu_maps) is
fine.

So IIUC in the past we had the race

	userspace			in-kernel users

	lock(hotplug)
	cpuhp_smt_disable()
	   lock(cpu_maps)		cpu_down()
					  lock(cpu_maps)

So they were serialized by cpu_maps lock. But that should not happen now since
in-kernel (except for the aforementioned) users should use remove_cpu().

	userspace			in-kernel users

	lock(hotplug)
	cpuhp_smt_disable()
	   lock(cpu_maps)		remove_cpu()
					  lock(hotplug)
					  device_offline()
					    cpu_down()
					      lock(cpu_maps)

Which forces the serialization at lock(hotplug), which is what
lock_device_hotplug_sysfs() is actually tries to hold.

So I think that race condition should not happen now. Or did I miss something?

The only loophole is that cpu_device_up() could be abused if not caught by
reviewers. I didn't find a way to warn/error if someone other than
cpu_subsys_online() uses it. We rely on a comment explaining it..

I think cpuhp_smt_disable/enable can safely call device_offline/online now.
Although it might still be more efficient to hold lock(cpu_maps) once than
repeatedly in a loop.

If we do that, then cpu_up_down_serialize_trainwrech() can be called from
cpu_device_up/down() which implies !task_frozen.

Can't remember now if Alexey moved the uevent() handling out of the loop for
efficiency reasons or was seeing something else. I doubt it was the latter.


Thanks
