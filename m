From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Low TCP throughput due to vmpressure with swap enabled
Date: Mon, 21 Nov 2022 16:53:43 -0800
Message-ID: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O6WUOw9T0DV19s/c2TGTrCQrdf4F5EyxA3HYag+nfl0=;
        b=K7uGD5oz/aX87z0dSzQiMLPSWToAYxYdnapsn443FHnDX0Zpnyu7ogdz44QyeZYtkh
         N2soQOhA7Uf54WmfPwkNv8Wh6ohKOfa1RV33ck4avR0Fos+V9s17/WKxkSUAxC5H1lPj
         MHaYxnD5euM+lAJWHkrzN/9sC9BjhZNqYWqqs=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

Hello,

We have observed a negative TCP throughput behavior from the following commit:

* 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure

It landed back in 2016 in v4.5, so it's not exactly a new issue.

The crux of the issue is that in some cases with swap present the
workload can be unfairly throttled in terms of TCP throughput.

I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
GiB of RAM with zram enabled.

The setup is fairly simple:

1. Run the following go proxy in one cgroup (it has some memory
ballast to simulate useful memory usage):

* https://gist.github.com/bobrik/2c1a8a19b921fefe22caac21fda1be82

sudo systemd-run --scope -p MemoryLimit=6G go run main.go

2. Run the following fio config in another cgroup to simulate mmapped
page cache usage:

[global]
size=8g
bs=256k
iodepth=256
direct=0
ioengine=mmap
group_reporting
time_based
runtime=86400
numjobs=8
name=randread
rw=randread

[job1]
filename=derp

sudo systemd-run --scope fio randread.fio

3. Run curl to request a large file via proxy:

curl -o /dev/null http://localhost:4444

4. Observe low throughput. The numbers here are dependent on your
location, but in my VM the throughput drops from 60MB/s to 10MB/s
depending on whether fio is running or not.

I can see that this happens because of the commit I mentioned with
some perf tracing:

sudo perf probe --add 'vmpressure:48 memcg->css.cgroup->kn->id scanned
vmpr_scanned=vmpr->scanned reclaimed vmpr_reclaimed=vmpr->reclaimed'
sudo perf probe --add 'vmpressure:72 memcg->css.cgroup->kn->id'

I can record the probes above during curl runtime:

sudo perf record -a -e probe:vmpressure_L48,probe:vmpressure_L72 -- sleep 5

Line 48 allows me to observe scanned and reclaimed page counters, line
72 is the actual throttling.

Here's an example trace showing my go proxy cgroup:

kswapd0 89 [002] 2351.221995: probe:vmpressure_L48: (ffffffed2639dd90)
id=0xf23 scanned=0x140 vmpr_scanned=0x0 reclaimed=0x0
vmpr_reclaimed=0x0
kswapd0 89 [007] 2351.333407: probe:vmpressure_L48: (ffffffed2639dd90)
id=0xf23 scanned=0x2b3 vmpr_scanned=0x140 reclaimed=0x0
vmpr_reclaimed=0x0
kswapd0 89 [007] 2351.333408: probe:vmpressure_L72: (ffffffed2639de2c) id=0xf23

We scanned lots of pages, but weren't able to reclaim anything.

When throttling happens, it's in tcp_prune_queue, where rcv_ssthresh
(TCP window clamp) is set to 4 x advmss:

* https://elixir.bootlin.com/linux/v5.15.76/source/net/ipv4/tcp_input.c#L5373

else if (tcp_under_memory_pressure(sk))
tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);

I can see plenty of memory available in both my go proxy cgroup and in
the system in general:

$ free -h
total used free shared buff/cache available
Mem: 7.8Gi 4.3Gi 104Mi 0.0Ki 3.3Gi 3.3Gi
Swap: 11Gi 242Mi 11Gi

It just so happens that all of the memory is hot and is not eligible
to be reclaimed. Since swap is enabled, the memory is still eligible
to be scanned. If swap is disabled, then my go proxy is not eligible
for scanning anymore (all memory is anonymous, nowhere to reclaim it),
so the whole issue goes away.

Punishing well behaving programs like that doesn't seem fair. We saw
production metals with 200GB page cache out of 384GB of RAM, where a
well behaved proxy with 60GB of RAM + 15GB of swap is throttled like
that. The fact that it only happens with swap makes it extra weird.

I'm not really sure what to do with this. From our end we'll probably
just pass cgroup.memory=nosocket in cmdline to disable this behavior
altogether, since it's not like we're running out of TCP memory (and
we can deal with that better if it ever comes to that). There should
probably be a better general case solution.

I don't know how widespread this issue can be. You need a fair amount
of page cache pressure to try to go to anonymous memory for reclaim to
trigger this.

Either way, this seems like a bit of a landmine.
