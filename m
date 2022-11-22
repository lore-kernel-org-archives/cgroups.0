From: Eric Dumazet <edumazet@google.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 22 Nov 2022 10:01:16 -0800
Message-ID: <CANn89iLzARPp6jW1xS0rf+-wS_RnwK-Kfgs9uQFYan2AHPRQFA@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6B0NrMvYa9h30nShzcOWnnoLa9VhsXqCL7iaXLlPHUo=;
        b=iWPChtAoKFdKhqcc/DN3txXed0Dwlsv6aeY/kU0GIAptMe3AhWO8wNTMkP814+mpot
         Lw+8OhB61MCpzcW/qHOQt9y0qCwc2TeVUQZL6D4AaTgJnk4brkjJmPWHb9ErENo8EMPV
         vNAw2U5rYK5vDLFMMjyG/YPN8oDJszHjXswrS7dU4RuyirXZUZn3LSiKEZH67u0ITTlB
         vm7GHgRSaPuARILnXSmyQdd3uOb1udK3X9qB19+nwQzHalBvF2/CKdn9VUtUr2dTyGfD
         Ub/JVtM14HO5rq2oN6TgFpsme/nE5KtZ05qtTeNRWANWEX7Ghk/R9QA5RRdfaycx8rvi
         csrA==
In-Reply-To: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Babrou <ivan@cloudflare.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Mon, Nov 21, 2022 at 4:53 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> Hello,
>
> We have observed a negative TCP throughput behavior from the following commit:
>
> * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
>
> It landed back in 2016 in v4.5, so it's not exactly a new issue.
>
> The crux of the issue is that in some cases with swap present the
> workload can be unfairly throttled in terms of TCP throughput.

I guess defining 'fairness' in such a scenario is nearly impossible.

Have you tried changing /proc/sys/net/ipv4/tcp_rmem  (and/or tcp_wmem) ?
Defaults are quite conservative.
If for your workload you want to ensure a minimum amount of memory per
TCP socket,
that might be good enough.

Of course, if your proxy has to deal with millions of concurrent TCP
sockets, I fear this is not an option.

>
> I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
> GiB of RAM with zram enabled.
>
> The setup is fairly simple:
>
> 1. Run the following go proxy in one cgroup (it has some memory
> ballast to simulate useful memory usage):
>
> * https://gist.github.com/bobrik/2c1a8a19b921fefe22caac21fda1be82
>
> sudo systemd-run --scope -p MemoryLimit=6G go run main.go
>
> 2. Run the following fio config in another cgroup to simulate mmapped
> page cache usage:
>
> [global]
> size=8g
> bs=256k
> iodepth=256
> direct=0
> ioengine=mmap
> group_reporting
> time_based
> runtime=86400
> numjobs=8
> name=randread
> rw=randread
>
> [job1]
> filename=derp
>
> sudo systemd-run --scope fio randread.fio
>
> 3. Run curl to request a large file via proxy:
>
> curl -o /dev/null http://localhost:4444
>
> 4. Observe low throughput. The numbers here are dependent on your
> location, but in my VM the throughput drops from 60MB/s to 10MB/s
> depending on whether fio is running or not.
>
> I can see that this happens because of the commit I mentioned with
> some perf tracing:
>
> sudo perf probe --add 'vmpressure:48 memcg->css.cgroup->kn->id scanned
> vmpr_scanned=vmpr->scanned reclaimed vmpr_reclaimed=vmpr->reclaimed'
> sudo perf probe --add 'vmpressure:72 memcg->css.cgroup->kn->id'
>
> I can record the probes above during curl runtime:
>
> sudo perf record -a -e probe:vmpressure_L48,probe:vmpressure_L72 -- sleep 5
>
> Line 48 allows me to observe scanned and reclaimed page counters, line
> 72 is the actual throttling.
>
> Here's an example trace showing my go proxy cgroup:
>
> kswapd0 89 [002] 2351.221995: probe:vmpressure_L48: (ffffffed2639dd90)
> id=0xf23 scanned=0x140 vmpr_scanned=0x0 reclaimed=0x0
> vmpr_reclaimed=0x0
> kswapd0 89 [007] 2351.333407: probe:vmpressure_L48: (ffffffed2639dd90)
> id=0xf23 scanned=0x2b3 vmpr_scanned=0x140 reclaimed=0x0
> vmpr_reclaimed=0x0
> kswapd0 89 [007] 2351.333408: probe:vmpressure_L72: (ffffffed2639de2c) id=0xf23
>
> We scanned lots of pages, but weren't able to reclaim anything.
>
> When throttling happens, it's in tcp_prune_queue, where rcv_ssthresh
> (TCP window clamp) is set to 4 x advmss:
>
> * https://elixir.bootlin.com/linux/v5.15.76/source/net/ipv4/tcp_input.c#L5373
>
> else if (tcp_under_memory_pressure(sk))
> tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);
>
> I can see plenty of memory available in both my go proxy cgroup and in
> the system in general:
>
> $ free -h
> total used free shared buff/cache available
> Mem: 7.8Gi 4.3Gi 104Mi 0.0Ki 3.3Gi 3.3Gi
> Swap: 11Gi 242Mi 11Gi
>
> It just so happens that all of the memory is hot and is not eligible
> to be reclaimed. Since swap is enabled, the memory is still eligible
> to be scanned. If swap is disabled, then my go proxy is not eligible
> for scanning anymore (all memory is anonymous, nowhere to reclaim it),
> so the whole issue goes away.
>
> Punishing well behaving programs like that doesn't seem fair. We saw
> production metals with 200GB page cache out of 384GB of RAM, where a
> well behaved proxy with 60GB of RAM + 15GB of swap is throttled like
> that. The fact that it only happens with swap makes it extra weird.
>
> I'm not really sure what to do with this. From our end we'll probably
> just pass cgroup.memory=nosocket in cmdline to disable this behavior
> altogether, since it's not like we're running out of TCP memory (and
> we can deal with that better if it ever comes to that). There should
> probably be a better general case solution.

Probably :)

>
> I don't know how widespread this issue can be. You need a fair amount
> of page cache pressure to try to go to anonymous memory for reclaim to
> trigger this.
>
> Either way, this seems like a bit of a landmine.
