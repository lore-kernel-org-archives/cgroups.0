From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/3] vmpressure: document why css_get/put is not
 necessary for work queue based signaling
Date: Mon, 15 Jul 2013 12:27:58 +0200
Message-ID: <20130715102758.GC26199@dhcp22.suse.cz>
References: <20130712084039.GA13224@dhcp22.suse.cz>
 <1373621098-15261-1-git-send-email-mhocko@suse.cz>
 <20130712184836.GC23680@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130712184836.GC23680-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 12-07-13 11:48:36, Tejun Heo wrote:
> On Fri, Jul 12, 2013 at 11:24:56AM +0200, Michal Hocko wrote:
> > Cgroup events are unregistered from the workqueue context by
> > cgroup_event_remove scheduled by cgroup_destroy_locked (when a cgroup is
> > removed by rmdir).
> > 
> > cgroup_event_remove removes the eventfd wait queue from the work
> > queue, then it unregisters all the registered events and finally
> > puts a reference to the cgroup dentry. css_free which triggers memcg
> > deallocation is called after the last reference is dropped.
> > 
> > The scheduled vmpressure work item either happens before
> > cgroup_event_remove or it is not triggered at all so it always happen
> > _before_ the last dput thus css_free.
> 
> I don't follow what the above has to do with ensuring work item
> execution is finished before the underlying data structure is
> released.  How are the above relevant?  What am I missing here?

OK, it seems I managed to confuse myself. I thought that 
remove_wait_queue(event->wqh, &event->wait) called from
cgroup_event_remove guarantee that vmpr event would go away with that
workqueue. But now that I am looking at it, vmpr->work seems to be
living in a completely independent queue.

> > This patch just documents this trickiness.
> 
> This doesn't have to be tricky at all.  It's a *completely* routine
> thing.  Would you please stop making it one?

Fair enough. I will repost the series shortly.
-- 
Michal Hocko
SUSE Labs
