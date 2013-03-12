From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
Date: Tue, 12 Mar 2013 17:09:38 +0100
Message-ID: <1363104578.24558.9.camel@laptop>
References: <513ECCFE.3070201@huawei.com>
	 <20130312101555.GB30758@dhcp22.suse.cz>
	 <20130312110750.GC30758@dhcp22.suse.cz>
	 <20130312130504.GD30758@dhcp22.suse.cz> <1363102105.24558.4.camel@laptop>
	 <20130312154341.GB18852@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130312154341.GB18852-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

On Tue, 2013-03-12 at 08:43 -0700, Greg Kroah-Hartman wrote:
> On Tue, Mar 12, 2013 at 04:28:25PM +0100, Peter Zijlstra wrote:
> > On Tue, 2013-03-12 at 14:05 +0100, Michal Hocko wrote:
> > > @@ -111,17 +111,17 @@ struct bus_type {
> > >         struct iommu_ops *iommu_ops;
> > >  
> > >         struct subsys_private *p;
> > > +       struct lock_class_key __key;
> > >  };
> > 
> > Is struct bus_type constrained to static storage or can people go an
> > allocate this stuff dynamically? If so, this patch is broken.
> 
> I don't think anyone is creating this dynamically, it should be static.
> Why does this matter, does the lockdep code care about where the
> variable is declared (heap vs. static)?

Yeah, lockdep needs keys to be in static storage since its data
structures are append-only. Dynamic stuff would require being able to
remove everything related to a key so that we can re-purpose it for the
next allocation etc.

Lockdep will in fact warn (and disable itself) if you try and feed it
dynamic addresses, so using it like this will effectively check your
bus_type static storage 'requirement'.
