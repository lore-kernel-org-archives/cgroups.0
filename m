From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Tue, 9 May 2023 17:19:10 +0000
Message-ID: <20230509171910.yka3hucbwfnnq5fq@google.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683652753; x=1686244753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IBTSBftt1PJZ947KTT5HuLmK9Q4JRp1ckp/xOLvbM2Y=;
        b=uKEfNpdw9WWrPRRTrj9h9foiBlNLT3WJq9pqOpE0YJHCEjNNaI4D5e5x8ELW8Q/bMI
         Pj0vnF9eTPxfw/ebSZ11JjYWE6hK6804ytp1NBPJ/uTC1i/wNay4e6osrUIIo2Jb3Gfa
         eMCArBpj9e7crAws57r8k4yEyjUKPMs9qC6D2/WBe6/cxlSlJhHjNmlhiPFyioeGPwDu
         vSaJRd+eDJr87t1zT9uXO6tSHdm2cp/o5kVEohG9qH650W9DB23S11Tmw34ykZHcR1Se
         8Mymhg2d5yjvkXuVPohyN752Sz1nP5nRx8keUCCYOe+WhCANlSO6+5t/svXtH2MdvlGE
         a3wQ==
In-Reply-To: <20230508020801.10702-2-cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Cathy Zhang <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, May 07, 2023 at 07:08:00PM -0700, Cathy Zhang wrote:
> Before commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible"), each TCP can forward allocate up to 2 MB of memory and
> tcp_memory_allocated might hit tcp memory limitation quite soon.

Not just the system level tcp memory limit but we have actually seen in
production unneeded and unexpected memcg OOMs and the commit 4890b686f408
fixes those OOMs as well.

> To
> reduce the memory pressure, that commit keeps sk->sk_forward_alloc as
> small as possible, which will be less than 1 page size if SO_RESERVE_MEM
> is not specified.
> 
> However, with commit 4890b686f408 ("net: keep sk->sk_forward_alloc as
> small as possible"), memcg charge hot paths are observed while system is
> stressed with a large amount of connections. That is because
> sk->sk_forward_alloc is too small and it's always less than
> sk->truesize, network handlers like tcp_rcv_established() should jump to
> slow path more frequently to increase sk->sk_forward_alloc. Each memory
> allocation will trigger memcg charge, then perf top shows the following
> contention paths on the busy system.
> 
>     16.77%  [kernel]            [k] page_counter_try_charge
>     16.56%  [kernel]            [k] page_counter_cancel
>     15.65%  [kernel]            [k] try_charge_memcg
> 
> In order to avoid the memcg overhead and performance penalty,

IMO this is not the right place to fix memcg performance overhead,
specifically because it will re-introduce the memcg OOMs issue. Please
fix the memcg overhead in the memcg code.

Please share the detail profile of the memcg code. I can help in
brainstorming and reviewing the fix.

> sk->sk_forward_alloc should be kept with a proper size instead of as
> small as possible. Keep memory up to 64KB from reclaims when uncharging
> sk_buff memory, which is closer to the maximum size of sk_buff. It will
> help reduce the frequency of allocating memory during TCP connection.
> The original reclaim threshold for reserved memory per-socket is 2MB, so
> the extraneous memory reserved now is about 32 times less than before
> commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible").
> 
> Run memcached with memtier_benchamrk to verify the optimization fix. 8
> server-client pairs are created with bridge network on localhost, server
> and client of the same pair share 28 logical CPUs.
> 
> Results (Average for 5 run)
> RPS (with/without patch)	+2.07x
> 

Do you have regression data from any production workload? Please keep in
mind that many times we (MM subsystem) accepts the regressions of
microbenchmarks over complicated optimizations. So, if there is a real
production regression, please be very explicit about it.
