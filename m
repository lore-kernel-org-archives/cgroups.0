From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 22 Nov 2022 12:46:15 -0700
Message-ID: <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iJupukkEoGhIVTPDQgfM6MLu0R+8+aVVrcwFrJK3N0c=;
        b=M80awYn8ZIf5OKkEY2DksCS/pgDp0Vlt4QAZaq4A5dWXtc7g9jtLqRw15V+r5kecxR
         /g6Lj8CXkZVy7zj5+J/Cc/xEv8SWpgJ35wU15k/o0m8ZFMXBIER7TqbblSrplcRN65sR
         VxwfriTfukZdxbDBMuTOJFjHE2A+ElzVavRiL7FmEX7KHHkpvs3SqIsFOBqGCVKehTta
         ScsClvj3jyvRwzH4fXxNxd6i7CCG1ApRWrtTG2AOuJJGcKg+wVEXDN7llD2pWGD89ZY5
         uSk/LGsGE/YLh9rkKe4Wi/REyuTnDjbG4DfUktJJroFAofiZ6N9GbZ/mt7hhKHw+jX0V
         aPsg==
In-Reply-To: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Mon, Nov 21, 2022 at 5:53 PM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org> wrote:
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

Is it practical for your workload to apply some madvise/fadvise hint?
For the above repro, it would be fadvise_hint=1 which is mapped into
MADV_RANDOM automatically. The kernel also supports MADV_SEQUENTIAL,
but not POSIX_FADV_NOREUSE at the moment.

We actually have similar issues but unfortunately I haven't been able
to come up with any solution beyond recommending the above flags.
The problem is that harvesting the accessed bit from mmapped memory is
costly, and when random accesses happen fast enough, the cost of doing
that prevents LRU from collecting more information to make better
decisions. In a nutshell, LRU can't tell whether there is genuine
memory locality with your test case.

It's a very difficult problem to solve from LRU's POV. I'd like to
hear more about your workloads and see whether there are workarounds
other than tackling the problem head-on, if applying hints is not
practical or preferrable.
