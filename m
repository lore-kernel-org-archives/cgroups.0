From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Tue, 16 Mar 2021 06:26:58 -0400
Message-ID: <YFCH8vzFGmfFRCvV@cmpxchg.org>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V0BTN/Z2jXatx08nLmn2iGZ7O1WuylzrrulrDON6R9k=;
        b=xCib9ZN+FiOtHqn2f2GIRYRiTffT7uatWQxo/AtFklW7YHFihG2zQ/vTE6gNPQNf+9
         vRO50HskMB8FxFuo2e/yIPiiEjRMNR2akfE/kxzq3hVHcZW6gbBwrXGM/nkazzsBxspT
         IDDzm1pyKpT157y7ETbYQl89HFKamnR3YLguRbBuNUGLzFKgCZyAKpgnaNfuYaC+pVa6
         LpmHEpA95pzB9VWM6M9mop0H7Z1xD8Vy9M7yIxp15Me9nGIHP1oJuFRaG4tLl0wyVweM
         Pvxba1+vGHWQ9Sr05/mHjYuGYAaztxJfRkzf+J9pX0/vBFCFzOae7JoD3GMPcoWagsvR
         gusg==
Content-Disposition: inline
In-Reply-To: <20210316041645.144249-1-arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjun Roy <arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Mar 15, 2021 at 09:16:45PM -0700, Arjun Roy wrote:
> From: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> TCP zerocopy receive is used by high performance network applications
> to further scale. For RX zerocopy, the memory containing the network
> data filled by the network driver is directly mapped into the address
> space of high performance applications. To keep the TLB cost low,
> these applications unmap the network memory in big batches. So, this
> memory can remain mapped for long time. This can cause a memory
> isolation issue as this memory becomes unaccounted after getting
> mapped into the application address space. This patch adds the memcg
> accounting for such memory.
> 
> Accounting the network memory comes with its own unique challenges.
> The high performance NIC drivers use page pooling to reuse the pages
> to eliminate/reduce expensive setup steps like IOMMU. These drivers
> keep an extra reference on the pages and thus we can not depend on the
> page reference for the uncharging. The page in the pool may keep a
> memcg pinned for arbitrary long time or may get used by other memcg.

The page pool knows when a page is unmapped again and becomes
available for recycling, right? Essentially the 'free' phase of that
private allocator. That's where the uncharge should be done.

For one, it's more aligned with the usual memcg charge lifetime rules.

But also it doesn't add what is essentially a private driver callback
to the generic file unmapping path.

Finally, this will eliminate the need for making up a new charge type
(MEMCG_DATA_SOCK) and allow using the standard kmem charging API.

> This patch decouples the uncharging of the page from the refcnt and
> associates it with the map count i.e. the page gets uncharged when the
> last address space unmaps it. Now the question is, what if the driver
> drops its reference while the page is still mapped? That is fine as
> the address space also holds a reference to the page i.e. the
> reference count can not drop to zero before the map count.
> 
> Signed-off-by: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Co-developed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> 
> Changelog since v1:
> - Pages accounted for in this manner are now tracked via MEMCG_SOCK.
> - v1 allowed for a brief period of double-charging, now we have a
>   brief period of under-charging to avoid undue memory pressure.

I'm afraid we'll have to go back to v1.

Let's address the issues raised with it:

1. The NR_FILE_MAPPED accounting. It is longstanding Linux behavior
   that driver pages mapped into userspace are accounted as file
   pages, because userspace is actually doing mmap() against a driver
   file/fd (as opposed to an anon mmap). That is how they show up in
   vmstat, in meminfo, and in the per process stats. There is no
   reason to make memcg deviate from this. If we don't like it, it
   should be taken on by changing vm_insert_page() - not trick rmap
   into thinking these arent memcg pages and then fixing it up with
   additional special-cased accounting callbacks.

   v1 did this right, it charged the pages the way we handle all other
   userspace pages: before rmap, and then let the generic VM code do
   the accounting for us with the cgroup-aware vmstat infrastructure.

2. The double charging. Could you elaborate how much we're talking
   about in any given batch? Is this a problem worth worrying about?

   The way I see it, any conflict here is caused by the pages being
   counted in the SOCK counter already, but not actually *tracked* on
   a per page basis. If it's worth addressing, we should look into
   fixing the root cause over there first if possible, before trying
   to work around it here.

   The newly-added GFP_NOFAIL is especially worrisome. The pages
   should be charged before we make promises to userspace, not be
   force-charged when it's too late.

   We have sk context when charging the inserted pages. Can we
   uncharge MEMCG_SOCK after each batch of inserts? That's only 32
   pages worth of overcharging, so not more than the regular charge
   batch memcg is using.

   An even better way would be to do charge stealing where we reuse
   the existing MEMCG_SOCK charges and don't have to get any new ones
   at all - just set up page->memcg and remove the charge from the sk.

   But yeah, it depends a bit if this is a practical concern.

Thanks,
Johannes
