From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] kthread, cgroup: close race window where new
        kthreads can be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 17:17:57 +0100
Message-ID: <20170316161756.GA27613@redhat.com>
References: <20170315231827.GA13656@htj.duckdns.org> <20170315231920.GB13656@htj.duckdns.org> <20170316150233.GB24478@redhat.com> <20170316160544.GC15810@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com DC56E3DBEF
Content-Disposition: inline
In-Reply-To: <20170316160544.GC15810-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/16, Tejun Heo wrote:
>
> Hello,
>
> On Thu, Mar 16, 2017 at 04:02:34PM +0100, Oleg Nesterov wrote:
> > > +bool kthread_initialized(struct task_struct *k)
> > > +{
> > > +	struct kthread *kthread = to_kthread(k);
> > > +
> > > +	return kthread && test_bit(KTHREAD_INITIALIZED, &kthread->flags);
> > > +}
> >
> > Not sure I understand...
> >
> > With this patch you can no longer migrate a kernel thread created by
> > kernel_thread() ? Note that to_kthread() is NULL unless it was created
> > by kthread_create().
>
> Yeah, what it does is preventing migration of kthreads until the
> kthread owner wakes it up for the first time.  The problem is that
> kthread_bind() seals up future cgroup migrations from userland but
> doesn't move back the kthread to the root cgroup, so the userland has
> a window where it can mangle with cgroup membership inbetween and
> break things.

This is clear,

> The NULL test is there because the test may be performed before the
> kthread itself sets up its struct kthread.

This too.

But this also means that __cgroup_procs_write() will always fail if
this task is a kernel thread which was not created by kthread_create().

Currently you can use kernel_thread() (although you shouldn't) and it
can be migrated, this won't work after your patch.

Oleg.
