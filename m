From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: Only free spare array when readers are done
Date: Fri, 15 Jan 2016 15:56:53 -0500
Message-ID: <20160115205653.GA26524@cmpxchg.org>
References: <001a113abaa499606605294b5b17@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001a113abaa499606605294b5b17-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martijn Coenen <maco-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 14, 2016 at 02:33:52PM +0100, Martijn Coenen wrote:
> A spare array holding mem cgroup threshold events is kept around
> to make sure we can always safely deregister an event and have an
> array to store the new set of events in.
> 
> In the scenario where we're going from 1 to 0 registered events, the
> pointer to the primary array containing 1 event is copied to the spare
> slot, and then the spare slot is freed because no events are left.
> However, it is freed before calling synchronize_rcu(), which means
> readers may still be accessing threshold->primary after it is freed.
> 
> Fixed by only freeing after synchronize_rcu().
> 
> Signed-off-by: Martijn Coenen <maco-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
