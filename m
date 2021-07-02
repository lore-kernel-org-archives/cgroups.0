From: Krzysztof Kozlowski <krzysztof.kozlowski-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Process memory accounting (cgroups) accuracy
Date: Fri, 2 Jul 2021 09:50:11 +0200
Message-ID: <69ffd3a0-2cb7-8baa-17d0-ae45a52595af@canonical.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Since some time I am trying to fix Linux Test Project tests around
memory cgroups:
https://lists.linux.it/pipermail/ltp/2021-June/023259.html

The trouble I have, for example with memcg_max_usage_in_bytes_test.sh is
that on recent kernels (v4.15+) on x86_64, the memory group reports max
usage as higher than process' anonymous mapping.

The test works like this:
1. Fork a process, signal it to mmap 4 MB (PROT_WRITE | PROT_READ,
AP_PRIVATE | MAP_ANONYMOUS) and touch the memory.
2. Add the process to control group.
3. Signal it to munmap the region and immediately mmap again the same 4
MB (with touching the memory).
4. Check the counters and reset them.
5. munmap
6. Check the counters

Mentioned memcg_max_usage_in_bytes_test.sh checks the counters of
memory.memsw.max_usage_in_bytes which are:
a. early kernels: 4 MB (so only the mmap)
b. v4.15, v5.4 kernel: 4 MB + 32 pages
c. v5.11 kernel: 4 MB + 32 pages + 2 pages

I tweaked the mmap() size to smaller values and then the accounting is
even different. For example mmap of 1 up to 32 pages the
memory.memsw.max_usage_in_bytes is always 131072.

After final munmap (point 5 above), the test expects the
memcg_max_usage_in_bytes to be =0, however it is usually 8 or 132 kB.
Which kind of points that process is charged for something not related
to that memory map directly.

The questions: How accurate are now the cgroup counters?
I understood they should charge only pages allocated by the process, so
why mmap(4 kB) causes max_usage_in_bytes=132 kB?
Why mmap(4 MB) causes max_usage_in_bytes=4 MB + 34 pages?
What is being accounted there (stack guards?)?

Or maybe the entire LTP test checking so carefully memcg limits is useless?

The v5.4 kernel config is here:
https://kernel.ubuntu.com/~kernel-ppa/config/focal/linux-azure/5.4.0-1039.41/amd64-config.flavour.azure

Best regards,
Krzysztof
