From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH] mm/memcontrol: Increase threshold for draining
 per-cpu stocked bytes.
Date: Tue, 5 Jan 2021 20:26:30 -0800
Message-ID: <20210106042630.GA1110904@carbon.dhcp.thefacebook.com>
References: <1609862862-3573-1-git-send-email-imran.f.khan@oracle.com>
 <20210105182352.GE371241@carbon.dhcp.thefacebook.com>
 <20210105184558.GF371241@carbon.dhcp.thefacebook.com>
 <127fa24c-d4c4-5c24-ec30-ea6349f37923@oracle.com>
 <20210106032909.GG371241@carbon.dhcp.thefacebook.com>
 <9bd3018e-7182-fe4a-3ba2-ed0cf2e0875a@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0LAztK/1ttBt+WBb6oUnoEtr86qt4gMuPISh3DCFVgE=;
 b=ZQ7xv8suf2ANljJ1j0fFaqcFYAPjhEhRVO6FASR9K5rFXb+OVivQU7H37iObMNWgOxrT
 elOuLj3nXOIFRgz8NvVbuVotE18cEFuG3fR3Yx5JKmVLct98acwMEdq9o7iXrPYfToTj
 nrh3kdBAw5uxrCmz8DZDnQqKYZWAP0XER8g= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LAztK/1ttBt+WBb6oUnoEtr86qt4gMuPISh3DCFVgE=;
 b=Jhha8P2M36bHKDY+n+vof5gF3FsQkiMq+kWnr7UFolChSE95uiJB0/H/1j79PsOPz5/g8048BIMcX4JvfrR//bdTncyAdQUXNfjV3eprQW2czYwzJWoFbO3N89RxSKpgSAMawAX5VRYW8AfMwxQG/YxVlqpOBDOISy2eVLECc9k=
Content-Disposition: inline
In-Reply-To: <9bd3018e-7182-fe4a-3ba2-ed0cf2e0875a-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 06, 2021 at 02:39:05PM +1100, Imran Khan wrote:
> On 6/1/21 2:29 pm, Roman Gushchin wrote:
> 
> > On Wed, Jan 06, 2021 at 02:07:12PM +1100, Imran Khan wrote:
> > > On 6/1/21 5:45 am, Roman Gushchin wrote:
> > > > On Tue, Jan 05, 2021 at 10:23:52AM -0800, Roman Gushchin wrote:
> > > > > On Tue, Jan 05, 2021 at 04:07:42PM +0000, Imran Khan wrote:
> > > > > > While allocating objects whose size is multiple of PAGE_SIZE,
> > > > > > say kmalloc-4K, we charge one page for extra bytes corresponding
> > > > > > to the obj_cgroup membership pointer and remainder of the charged
> > > > > > page gets added to per-cpu stocked bytes. If this allocation is
> > > > > > followed by another allocation of the same size, the stocked bytes
> > > > > > will not suffice and thus we endup charging an extra page
> > > > > > again for membership pointer and remainder of this page gets added
> > > > > > to per-cpu stocked bytes. This second addition will cause amount of
> > > > > > stocked bytes to go beyond PAGE_SIZE and hence will result in
> > > > > > invocation of drain_obj_stock.
> > > > > > 
> > > > > > So if we are in a scenario where we are consecutively allocating,
> > > > > > several PAGE_SIZE multiple sized objects, the stocked bytes will
> > > > > > never be enough to suffice a request and every second request will
> > > > > > trigger draining of stocked bytes.
> > > > > > 
> > > > > > For example invoking __alloc_skb multiple times with
> > > > > > 2K < packet size < 4K will give a call graph like:
> > > > > > 
> > > > > > __alloc_skb
> > > > > >       |
> > > > > >       |__kmalloc_reserve.isra.61
> > > > > >       |    |
> > > > > >       |    |__kmalloc_node_track_caller
> > > > > >       |    |    |
> > > > > >       |    |    |slab_pre_alloc_hook.constprop.88
> > > > > >       |    |     obj_cgroup_charge
> > > > > >       |    |    |    |
> > > > > >       |    |    |    |__memcg_kmem_charge
> > > > > >       |    |    |    |    |
> > > > > >       |    |    |    |    |page_counter_try_charge
> > > > > >       |    |    |    |
> > > > > >       |    |    |    |refill_obj_stock
> > > > > >       |    |    |    |    |
> > > > > >       |    |    |    |    |drain_obj_stock.isra.68
> > > > > >       |    |    |    |    |    |
> > > > > >       |    |    |    |    |    |__memcg_kmem_uncharge
> > > > > >       |    |    |    |    |    |    |
> > > > > >       |    |    |    |    |    |    |page_counter_uncharge
> > > > > >       |    |    |    |    |    |    |    |
> > > > > >       |    |    |    |    |    |    |    |page_counter_cancel
> > > > > >       |    |    |
> > > > > >       |    |    |
> > > > > >       |    |    |__slab_alloc
> > > > > >       |    |    |    |
> > > > > >       |    |    |    |___slab_alloc
> > > > > >       |    |    |    |
> > > > > >       |    |    |slab_post_alloc_hook
> > > > > > 
> > > > > > This frequent draining of stock bytes and resultant charging of pages
> > > > > > increases the CPU load and hence deteriorates the scheduler latency.
> > > > > > 
> > > > > > The above mentioned scenario and it's impact can be seen by running
> > > > > > hackbench with large packet size on v5.8 and subsequent kernels. The
> > > > > > deterioration in hackbench number starts appearing from v5.9 kernel,
> > > > > > 'commit f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
> > > > > > instead of pages")'.
> > > > > > 
> > > > > > Increasing the draining limit to twice of KMALLOC_MAX_CACHE_SIZE
> > > > > > (a safe upper limit for size of slab cache objects), will avoid draining
> > > > > > of stock, every second allocation request, for the above mentioned
> > > > > > scenario and hence will reduce the CPU load for such cases. For
> > > > > > allocation of smaller objects or other allocation patterns the behaviour
> > > > > > will be same as before.
> > > > > > 
> > > > > > This change increases the draining threshold for per-cpu stocked bytes
> > > > > > from PAGE_SIZE to KMALLOC_MAX_CACHE_SIZE * 2.
> > > > > Hello, Imran!
> > > > > 
> > > > > Yes, it makes total sense to me.
> > > Hi Roman,
> > > 
> > > Thanks for reviewing this patch.
> > > 
> > > > > Btw, in earlier versions of the new slab controller there was a separate stock
> > > > > for byte-sized charging and it was 32 pages large. Later Johannes suggested
> > > > > the current layered design and he thought that because of the layering a single
> > > > > page is enough for the upper layer.
> > > > > 
> > > > > > Below are the hackbench numbers with and without this change on
> > > > > > v5.10.0-rc7.
> > > > > > 
> > > > > > Without this change:
> > > > > >       # hackbench process 10 1000 -s 100000
> > > > > >       Running in process mode with 10 groups using 40 file descriptors
> > > > > >       each (== 400 tasks)
> > > > > >       Each sender will pass 100 messages of 100000 bytes
> > > > > >       Time: 4.401
> > > > > > 
> > > > > >       # hackbench process 10 1000 -s 100000
> > > > > >       Running in process mode with 10 groups using 40 file descriptors
> > > > > >       each (== 400 tasks)
> > > > > >       Each sender will pass 100 messages of 100000 bytes
> > > > > >       Time: 4.470
> > > > > > 
> > > > > > With this change:
> > > > > >       # hackbench process 10 1000 -s 100000
> > > > > >       Running in process mode with 10 groups using 40 file descriptors
> > > > > >       each (== 400 tasks)
> > > > > >       Each sender will pass 100 messages of 100000 bytes
> > > > > >       Time: 3.782
> > > > > > 
> > > > > >       # hackbench process 10 1000 -s 100000
> > > > > >       Running in process mode with 10 groups using 40 file descriptors
> > > > > >       each (== 400 tasks)
> > > > > >       Each sender will pass 100 messages of 100000 bytes
> > > > > >       Time: 3.827
> > > > > > 
> > > > > > As can be seen the change gives an improvement of about 15% in hackbench
> > > > > > numbers.
> > > > > > Also numbers obtained with the change are inline with those obtained
> > > > > > from v5.8 kernel.
> > > > > The difference is quite impressive!
> > > > > 
> > > > > I wonder if you tried smaller values than KMALLOC_MAX_CACHE_SIZE * 2?
> > > > > Let's say 16 and 32?
> > > I have tested my change with smaller sizes as well and could see similar difference
> > > in hackbench numbers
> > > 
> > > Without change(5.10.0-rc7 vanilla):
> > > 
> > > # hackbench process 10 1000 -s 16
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 16 bytes
> > > Time: 0.429
> > > 
> > > # hackbench process 10 1000 -s 32
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 32 bytes
> > > Time: 0.458
> > > 
> > > With my changes on top of 5.10.0-rc7
> > > # hackbench process 10 1000 -s 16
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 16 bytes
> > > Time: 0.347
> > > 
> > > # hackbench process 10 1000 -s 32
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 32 bytes
> > > Time: 0.324
> > > 
> > > I am confirming using BCC based argdist tool that these sizes result in call to
> > > __alloc_skb with size as 16 and 32 respectively.
> > > 
> > > > > KMALLOC_MAX_CACHE_SIZE * 2 makes sense to me, but then the whole construction
> > > > > with two layer caching is very questionable. Anyway, it's not a reason to not
> > > > > merge your patch, just something I wanna look at later.
> > > > Hm, can you, please, benchmark the following change (without your change)?
> > > > 
> > > > @@ -3204,7 +3204,7 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
> > > >    		if (nr_pages) {
> > > >    			rcu_read_lock();
> > > > -			__memcg_kmem_uncharge(obj_cgroup_memcg(old), nr_pages);
> > > > +			refill_stock(obj_cgroup_memcg(old), nr_pages);
> > > >    			rcu_read_unlock();
> > > >    		}
> > > I have tested this change on top of v5.10-rc7 and this too gives performance improvement.
> > > I further confirmed using flamegraphs that with this change too we are avoiding following
> > > CPU intensive path
> > > 
> > > |__memcg_kmem_uncharge
> > >      |
> > >      |page_counter_uncharge
> > >      |    |
> > >      |    |page_counter_cancel
> > > 
> > > Please find the hackbench numbers with your change as given below:
> > > # hackbench process 10 1000 -s 100000
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 100000 bytes
> > > Time: 3.841
> > > 
> > > # hackbench process 10 1000 -s 100000
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 100000 bytes
> > > Time: 3.863
> > > 
> > > # hackbench process 10 1000 -s 16
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 16 bytes
> > > Time: 0.306
> > > 
> > > # hackbench process 10 1000 -s 32
> > > Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
> > > Each sender will pass 100 messages of 32 bytes
> > > Time: 0.320
> > Thank you for testing it!
> > 
> > If there is no significant difference, I'd prefer to stick with this change instead of increasing
> > the size of the percpu batch, because it will preserve the accuracy of accounting.
> > 
> > Will it work for you?
> 
> Yes, this works for me too.

Great!

Just sent the full version of the patch (you're in cc).

It's slightly different: initially I've missed the handling of a separate kmem page counter.
There should be no difference on cgroup v2, and hopefully it will be still acceptable on cgroup v1.
Your Tested-by will be highly appreciated.

Thank you!

Roman
