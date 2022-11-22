From: Yu Zhao <yuzhao@google.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 22 Nov 2022 13:05:32 -0700
Message-ID: <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zkjjvph7GSIuRbhiRbs3/9b09qAojNLtWfTKgHMBCNM=;
        b=EKHw8TY0iwnDzUIKHY+rodJJ/AkxSWo4HZVVCllcpw9GQBAjvq5Z2tW17w75DwjlKz
         TivHS5jzHlS39CGYE7qhA7a9zKY8pHRwkcvn3KHmv5jSREEprRRd9eI08TlOSM44hCAi
         ZN7/PIst4o4dBeNi5HAdOhkeMzmAERfeDkRsHXc2ooqxrx2o8ro/gyzgMFLSlDIxXopF
         Hk4YN5AdX4j+NGxDQ5NAUgA3vX3d7h+U3K0yu0URqR/j65q4WpklARZe0dkMUYiK1Ocu
         LvwIBOVwVmPWKEfmLiwEMIqaZAFHE5+hZsNwB1QxnCaNtnlJvbi2zZ6es1qu2s70dE0P
         hoOA==
In-Reply-To: <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Babrou <ivan@cloudflare.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Tue, Nov 22, 2022 at 12:46 PM Yu Zhao <yuzhao@google.com> wrote:
>
> On Mon, Nov 21, 2022 at 5:53 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> >
> > Hello,
> >
> > We have observed a negative TCP throughput behavior from the following commit:
> >
> > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> >
> > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> >
> > The crux of the issue is that in some cases with swap present the
> > workload can be unfairly throttled in terms of TCP throughput.
> >
> > I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
> > GiB of RAM with zram enabled.
> >
> > The setup is fairly simple:
> >
> > 1. Run the following go proxy in one cgroup (it has some memory
> > ballast to simulate useful memory usage):
> >
> > * https://gist.github.com/bobrik/2c1a8a19b921fefe22caac21fda1be82
> >
> > sudo systemd-run --scope -p MemoryLimit=6G go run main.go
> >
> > 2. Run the following fio config in another cgroup to simulate mmapped
> > page cache usage:
> >
> > [global]
> > size=8g
> > bs=256k
> > iodepth=256
> > direct=0
> > ioengine=mmap
> > group_reporting
> > time_based
> > runtime=86400
> > numjobs=8
> > name=randread
> > rw=randread
>
> Is it practical for your workload to apply some madvise/fadvise hint?
> For the above repro, it would be fadvise_hint=1 which is mapped into
> MADV_RANDOM automatically. The kernel also supports MADV_SEQUENTIAL,
> but not POSIX_FADV_NOREUSE at the moment.

Actually fadvise_hint already defaults to 1. At least with MGLRU, the
page cache should be thrown away without causing you any problem. It
might be mapped to POSIX_FADV_RANDOM rather than MADV_RANDOM.
POSIX_FADV_RANDOM is ignored at the moment.

Sorry for all the noise. Let me dig into this and get back to you later today.


> We actually have similar issues but unfortunately I haven't been able
> to come up with any solution beyond recommending the above flags.
> The problem is that harvesting the accessed bit from mmapped memory is
> costly, and when random accesses happen fast enough, the cost of doing
> that prevents LRU from collecting more information to make better
> decisions. In a nutshell, LRU can't tell whether there is genuine
> memory locality with your test case.
>
> It's a very difficult problem to solve from LRU's POV. I'd like to
> hear more about your workloads and see whether there are workarounds
> other than tackling the problem head-on, if applying hints is not
> practical or preferrable.
