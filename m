From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memcg: performance degradation since v5.9
Date: Fri, 9 Apr 2021 12:05:41 -0400
Message-ID: <20210409160541.4tfkeex7mcfrwras@gabell>
References: <20210408193948.vfktg3azh2wrt56t@gabell>
 <YG9tW1h9VSJcir+Y@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QhmfWW84CRFKzl562/MmBkeBA4j+Ef4ragxrzhUeTuU=;
        b=Eylqsk546yTCAujbrrggfp0ZBcs7wNmlHZprEboYUeU4SNxe13tkPD/ozr3mcVvdtf
         xq9EMd0BUPtqwL8hQthmumMKKE78alM8pxypx8//Z5UrZURGeuifdT+9+ypNxhyJFDI8
         4sQq8XG6Fdz6n2pJnnrSAwn9ouG4XYPyqM8IJliaYfI5IMHGKH3xIUGuKz66g3fWavhS
         /A0OUXxWNoOT2vHUlcFV8uVMC07mjuwEhq+jbqsOGz9PmWMgpzEQ4lvqdejeduYziD9+
         XKNncvhp800wz1YKboRfWKrccd1FGKGe1OfBsHPQyE69W9jUemqPY2UzHKm3v5kl5uVB
         YONA==
Content-Disposition: inline
In-Reply-To: <YG9tW1h9VSJcir+Y-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 08, 2021 at 01:53:47PM -0700, Roman Gushchin wrote:
> On Thu, Apr 08, 2021 at 03:39:48PM -0400, Masayoshi Mizuma wrote:
> > Hello,
> > 
> > I detected a performance degradation issue for a benchmark of PostgresSQL [1],
> > and the issue seems to be related to object level memory cgroup [2].
> > I would appreciate it if you could give me some ideas to solve it.
> > 
> > The benchmark shows the transaction per second (tps) and the tps for v5.9
> > and later kernel get about 10%-20% smaller than v5.8.
> > 
> > The benchmark does sendto() and recvfrom() system calls repeatedly,
> > and the duration of the system calls get longer than v5.8.
> > The result of perf trace of the benchmark is as follows:
> > 
> >   - v5.8
> > 
> >    syscall            calls  errors  total       min       avg       max       stddev
> >                                      (msec)    (msec)    (msec)    (msec)        (%)
> >    --------------- --------  ------ -------- --------- --------- ---------     ------
> >    sendto            699574      0  2595.220     0.001     0.004     0.462      0.03%
> >    recvfrom         1391089 694427  2163.458     0.001     0.002     0.442      0.04%
> > 
> >   - v5.9
> > 
> >    syscall            calls  errors  total       min       avg       max       stddev
> >                                      (msec)    (msec)    (msec)    (msec)        (%)
> >    --------------- --------  ------ -------- --------- --------- ---------     ------
> >    sendto            699187      0  3316.948     0.002     0.005     0.044      0.02%
> >    recvfrom         1397042 698828  2464.995     0.001     0.002     0.025      0.04%
> > 
> >   - v5.12-rc6
> > 
> >    syscall            calls  errors  total       min       avg       max       stddev
> >                                      (msec)    (msec)    (msec)    (msec)        (%)
> >    --------------- --------  ------ -------- --------- --------- ---------     ------
> >    sendto            699445      0  3015.642     0.002     0.004     0.027      0.02%
> >    recvfrom         1395929 697909  2338.783     0.001     0.002     0.024      0.03%
> > 
> > I bisected the kernel patches, then I found the patch series, which add
> > object level memory cgroup support, causes the degradation.
> > 
> > I confirmed the delay with a kernel module which just runs
> > kmem_cache_alloc/kmem_cache_free as follows. The duration is about
> > 2-3 times than v5.8.
> > 
> >    dummy_cache = KMEM_CACHE(dummy, SLAB_ACCOUNT);
> >    for (i = 0; i < 100000000; i++)
> >    {
> >            p = kmem_cache_alloc(dummy_cache, GFP_KERNEL);
> >            kmem_cache_free(dummy_cache, p);
> >    }
> > 
> > It seems that the object accounting work in slab_pre_alloc_hook() and
> > slab_post_alloc_hook() is the overhead.
> > 
> > cgroup.nokmem kernel parameter doesn't work for my case because it disables
> > all of kmem accounting.
> > 
> > The degradation is gone when I apply a patch (at the bottom of this email)
> > that adds a kernel parameter that expects to fallback to the page level
> > accounting, however, I'm not sure it's a good approach though...
> 
> Hello Masayoshi!
> 
> Thank you for the report!

Hi!

> 
> It's not a secret that per-object accounting is more expensive than a per-page
> allocation. I had micro-benchmark results similar to yours: accounted
> allocations are about 2x slower. But in general it tends to not affect real
> workloads, because the cost of allocations is still low and tends to be only
> a small fraction of the whole cpu load. And because it brings up significant
> benefits: 40%+ slab memory savings, less fragmentation, more stable workingset,
> etc, real workloads tend to perform on pair or better.
> 
> So my first question is if you see the regression in any real workload
> or it's only about the benchmark?

It's only about the benchmark so far. I'll let you know if I get the issue with
real workload.

> 
> Second, I'll try to take a look into the benchmark to figure out why it's
> affected so badly, but I'm not sure we can easily fix it. If you have any
> ideas what kind of objects the benchmark is allocating in big numbers,
> please let me know.

The benchmark does sendto() and recvfrom() to the unix domain socket
repeatedly, and kmem_cache_alloc_node()/kmem_cache_free() is called
to allocate/free the socket buffers.
The call graph to allocate the object is as flllows.

  do_syscall_64
    __x64_sys_sendto
      __sys_sendto
        sock_sendmsg
          unix_stream_sendmsg
            sock_alloc_send_pskb
              alloc_skb_with_frags
                __alloc_skb
                  kmem_cache_alloc_node

kmem_cache_alloc_node()/kmem_cache_free() is called about 1,400,000 times
during the benchmark and the object size is 216 byte, the GFP flag is 0x400cc0:
 ___GFP_ACCOUNT | ___GFP_KSWAPD_RECLAIM | ___GFP_DIRECT_RECLAIM | ___GFP_FS | ___GFP_IO

I got the data by following bpftrace script.

  # cat kmem.bt 
  #!/usr/bin/env bpftrace

  tracepoint:kmem:kmem_cache_alloc_node /comm == "pgbench"/
  {
	@alloc[comm, args->bytes_req, args->bytes_alloc, args->gfp_flags] = count();
  }

  tracepoint:kmem:kmem_cache_free /comm == "pgbench"/
  {
	@free[comm] = count();
  }
  # ./kmem.bt 
  Attaching 2 probes...
  ^C

  @alloc[pgbench, 11784, 11840, 3264]: 1
  @alloc[pgbench, 216, 256, 3264]: 23
  @alloc[pgbench, 216, 256, 4197568]: 1400046

  @free[pgbench]: 1400560

  # 

I hope this helps...

Thanks!
Masa
