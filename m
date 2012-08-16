From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] execute the whole memcg freeing in rcu callback
Date: Thu, 16 Aug 2012 13:10:24 +0400
Message-ID: <502CB900.1010907@parallels.com>
References: <1344861970-9999-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344861970-9999-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 08/13/2012 04:46 PM, Glauber Costa wrote:
> A lot of the initialization we do in mem_cgroup_create() is done with
> softirqs enabled. This include grabbing a css id, which holds
> &ss->id_lock->rlock, and the per-zone trees, which holds
> rtpz->lock->rlock. All of those signal to the lockdep mechanism that
> those locks can be used in SOFTIRQ-ON-W context. This means that the
> freeing of memcg structure must happen in a compatible context,
> otherwise we'll get a deadlock.
> 
> The reference counting mechanism we use allows the memcg structure to be
> freed later and outlive the actual memcg destruction from the
> filesystem. However, we have little, if any, means to guarantee in which
> context the last memcg_put will happen. The best we can do is test it
> and try to make sure no invalid context releases are happening. But as
> we add more code to memcg, the possible interactions grow in number and
> expose more ways to get context conflicts.
> 
> Context-related problems already appeared for static branches
> destruction, since their locking forced us to disable them from process
> context, which we could not always guarantee. Now that we're trying to
> add kmem controller, the possibilities of where the freeing can be
> triggered from just increases.
> 
> Greg Thelen reported a bug with that patchset applied that would trigger
> if a task would hold a reference to a memcg through its kmem counter.
> This would mean that killing that task would eventually get us to
> __mem_cgroup_free() after dropping the last kernel page reference, in an
> invalid IN-SOFTIRQ-W.
> 
> We already moved a part of the freeing to a worker thread to be
> context-safe for the static branches disabling. Although we could move
> the new offending part to such a place as well, I see no reason not
> to do it for the whole freeing action. I consider this to be the safe
> choice.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Reported-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> ---
> I am adding this to the kmemcg tree, but I am hoping this can get
> independent review, and maybe be applied independently as well. As you
> can see, this is a problem that was made visible by that patchset, but
> is, ultimately, already there.
> 
> Also, please note that this bug would be mostly invisible with the slab
> patches applied ontop, since killing the task would unlikely release the
> last reference on the structure. But still, theorectically present. This
> is exactly the kind of issues I am trying to capture by applying the two
> parts independently.

After discussing the last discussion I had with Greg, I believe I have a
slightly better idea about this one.

We can do most of the freeing synchronously from a predictable context
in mem_cgroup_destroy(), including the release of the css_id. We would
be left then with only the static branches decrement and final free pending.

I am stressing this a bit here, and will send another version shortly



