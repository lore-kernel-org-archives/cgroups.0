From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 1/3] loop: Use worker per cgroup instead of kworker
Date: Thu, 27 Feb 2020 13:14:30 -0500
Message-ID: <20200227181430.GA44024@cmpxchg.org>
References: <cover.1582581887.git.schatzberg.dan@gmail.com>
 <eab018412a0c9feb573d757b1bbd5f58b33e2a8d.1582581887.git.schatzberg.dan@gmail.com>
 <1582736558.7365.131.camel@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=19sQdZH67v9yOy/BduEXSg0i7G3USqaAUKmseX8opy0=;
        b=0IG8plhA6YTGx0j6rHUrt9WyouEz5FGMjybnDuDbUR7axVZhu+rgZlDa76gtdh8YwP
         /BhvP4PrfAUfKbf4wWhSFJOqBrI7JQ+9WpS63f7uxvjPet4NPXoB3dmwuNdmFwjnk4FX
         1jVKXf8c2T1gFBZuOnwIqt51u2dUPq1cgjvR7zFm0WU9lL6ANWW6XIFJIHX6vK0OhLS1
         J7DzHM0N4FEAk+lKkdDVdPBUOvPR0KzwO8QnjgEOy/J9Ojgvd04vxXAf02MIPcEGOpxb
         EivvMkXIRJkPfKGgDKl8kcG3bTQe25P1HIgY1nQs6rbBZBfIFa/9YWSNslzmqZbSVSLN
         u4lw==
Content-Disposition: inline
In-Reply-To: <1582736558.7365.131.camel-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Feb 26, 2020 at 12:02:38PM -0500, Qian Cai wrote:
> On Mon, 2020-02-24 at 17:17 -0500, Dan Schatzberg wrote:
> > Existing uses of loop device may have multiple cgroups reading/writing
> > to the same device. Simply charging resources for I/O to the backing
> > file could result in priority inversion where one cgroup gets
> > synchronously blocked, holding up all other I/O to the loop device.
> >=20
> > In order to avoid this priority inversion, we use a single workqueue
> > where each work item is a "struct loop_worker" which contains a queue of
> > struct loop_cmds to issue. The loop device maintains a tree mapping blk
> > css_id -> loop_worker. This allows each cgroup to independently make
> > forward progress issuing I/O to the backing file.
> >=20
> > There is also a single queue for I/O associated with the rootcg which
> > can be used in cases of extreme memory shortage where we cannot allocate
> > a loop_worker.
> >=20
> > The locking for the tree and queues is fairly heavy handed - we acquire
> > the per-loop-device spinlock any time either is accessed. The existing
> > implementation serializes all I/O through a single thread anyways, so I
> > don't believe this is any worse.
> >=20
> > Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@pu=
blic.gmane.org>
> > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.o=
rg>
>=20
> The locking in loop_free_idle_workers() will trigger this with sysfs read=
ing,
>=20
> [ 7080.047167] LTP: starting read_all_sys (read_all -d /sys -q -r 10)
> [ 7239.842276] cpufreq transition table exceeds PAGE_SIZE. Disabling
>=20
> [ 7247.054961] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 7247.054971] WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
> [ 7247.054983] 5.6.0-rc3-next-20200226 #2 Tainted: G=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0O=A0=A0=A0=A0=A0
> [ 7247.054992] -----------------------------------------------------
> [ 7247.055002] read_all/8513 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [ 7247.055014] c0000006844864c8 (&fs->seq){+.+.}, at: file_path+0x24/0x40
> [ 7247.055041]=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0and this task is already hol=
ding:
> [ 7247.055061] c0002006bab8b928 (&(&lo->lo_lock)->rlock){..-.}, at:
> loop_attr_do_show_backing_file+0x3c/0x120 [loop]
> [ 7247.055078] which would create a new lock dependency:
> [ 7247.055105]=A0=A0(&(&lo->lo_lock)->rlock){..-.} -> (&fs->seq){+.+.}
> [ 7247.055125]=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0but this new dependency conn=
ects a SOFTIRQ-irq-safe lock:
> [ 7247.055155]=A0=A0(&(&lo->lo_lock)->rlock){..-.}
> [ 7247.055156]=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0... which became SOFTIRQ-irq=
-safe at:
> [ 7247.055196]=A0=A0=A0lock_acquire+0x130/0x360
> [ 7247.055221]=A0=A0=A0_raw_spin_lock_irq+0x68/0x90
> [ 7247.055230]=A0=A0=A0loop_free_idle_workers+0x44/0x3f0 [loop]
> [ 7247.055242]=A0=A0=A0call_timer_fn+0x110/0x5f0
> [ 7247.055260]=A0=A0=A0run_timer_softirq+0x8f8/0x9f0
> [ 7247.055278]=A0=A0=A0__do_softirq+0x34c/0x8c8
> [ 7247.055288]=A0=A0=A0irq_exit+0x16c/0x1d0
> [ 7247.055298]=A0=A0=A0timer_interrupt+0x1f0/0x680
> [ 7247.055308]=A0=A0=A0decrementer_common+0x124/0x130
> [ 7247.055328]=A0=A0=A0arch_local_irq_restore.part.8+0x34/0x90
> [ 7247.055352]=A0=A0=A0cpuidle_enter_state+0x11c/0x8f0
> [ 7247.055361]=A0=A0=A0cpuidle_enter+0x50/0x70
> [ 7247.055389]=A0=A0=A0call_cpuidle+0x4c/0x90
> [ 7247.055398]=A0=A0=A0do_idle+0x378/0x470
> [ 7247.055414]=A0=A0=A0cpu_startup_entry+0x3c/0x40
> [ 7247.055442]=A0=A0=A0start_secondary+0x7a8/0xa80
> [ 7247.055461]=A0=A0=A0start_secondary_prolog+0x10/0x14

That's kind of hilarious.

So even though it's a spin_lock_irq(), suggesting it's used from both
process and irq context, Dan appears to be adding the first user that
actually runs from irq context. It looks like it should have been a
regular spinlock all along. Until now, anyway.

Fixing it should be straight-forward. Use get_file() under lock to pin
the file, drop the lock to do file_path(), release file with fput().
