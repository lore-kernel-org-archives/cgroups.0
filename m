From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Wed, 30 May 2012 17:33:00 +0200
Message-ID: <20120530153256.GA27008@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
 <20120530130416.GD25094@somewhere.redhat.com>
 <4FC61B4E.2060206@parallels.com>
 <20120530133736.GF25094@somewhere.redhat.com>
 <4FC622B5.9080600@parallels.com>
 <20120530135319.GG25094@somewhere.redhat.com>
 <4FC626DA.3030408@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=x4aUayEK8WUfniMZiseUawRt5C2HjQaItyzA8kPib00=;
        b=eUD3ceH9ohhTFaJ5LpZklKg4gvIM7jLhFxxzFAlVP7oHbD6L8BUv7shPn+b/HWd06a
         s0moE6DeNCIRHetgvoNaLxxVLQcG5N6zZYGtKwdm8cl1fOD5/6kTUWSkIZeHwhC8pLCc
         tEGPZaiPD/91/k7YUdgtBzIkynSxywIOLAlGbnNGu2yuMZFkYLlMM07CU3quikmvFeHi
         SZ38H4beQPiBBii5ZMghfShG2bXZvB/xBUpUPKrgWjvWYBdgc4Y9ThDKFc2TBE0GF150
         Pb9H8GPkvi0X7I+mj20ovBAsCqLBRjdrT9v/wlVyoPC5RAhu85jdjmF0hQaQfrPs8pxR
         mV9A==
Content-Disposition: inline
In-Reply-To: <4FC626DA.3030408-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Wed, May 30, 2012 at 05:55:38PM +0400, Glauber Costa wrote:
> On 05/30/2012 05:53 PM, Frederic Weisbecker wrote:
> >On Wed, May 30, 2012 at 05:37:57PM +0400, Glauber Costa wrote:
> >>On 05/30/2012 05:37 PM, Frederic Weisbecker wrote:
> >>>Right. __mem_cgroup_get_kmem_cache() fetches the memcg of the owner
> >>>and calls memcg_create_cache_enqueue() which does css_tryget(&memcg->css).
> >>>After this tryget I think you're fine. And in-between you're safe against
> >>>css_set removal due to rcu_read_lock().
> >>>
> >>>I'm less clear with __mem_cgroup_new_kmem_page() though...
> >>
> >>That one does not get memcg->css but it does call mem_cgroup_get(),
> >>that does prevent against the memcg structure being freed, which I
> >>believe to be good enough.
> >
> >What if the owner calls cgroup_exit() between mem_cgroup_from_task()
> >and mem_cgroup_get()? The css_set which contains the memcg gets freed.
> >Also the reference on the memcg doesn't even prevent the css_set to
> >be removed, does it?
> It doesn't, but we don't really care. The css can go away, if the
> memcg structure stays.

Ah right, the memcg itself is only freed at destroy time.

> The caches will outlive the memcg anyway,
> since it is possible that you delete it, with some caches still
> holding objects that
> are not freed (they will be marked as dead).

I guess I need to look at how the destroy path is handled in your patchset
then. Or how you ensure that __mem_cgroup_new_kmem_page() can't race against
destroy.
