From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/2] mm: Working Set Reporting
Date: Wed, 10 May 2023 02:54:17 +0800
Message-ID: <20230509185419.1088297-1-yuanchu@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683658468; x=1686250468;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LC0FZWUPJYiXz+9KGOyu/I1FWoZ4PhU7nKNGRM1Iaac=;
        b=TTnbX0GbPjgGnUxeFZbJhVt40KHXVqzLdKBcEG1Sj3G8/Z9B8pPzcMJ7p+ChJplsOd
         XLyQzACiqEkaJ235bBMCEJDVAcDx+Y/YoH5WLaCYvGtxsacpUmgLjfK6JcHsyS7FMYjX
         OfYwk92ad2NbG+fLNfYEQF/SZ08s5hVRZPBsE2m1PKigbGJnoJoTyAXGhje2YjU2+uZr
         lOooSO6NIaLUIuZ646NpI1tECL47TPUkH/YLMYIdSqEt1fgbm2a4lNULND6Lvp6rG3Kp
         nx+JcQV4ToY4ye0ao+Mt3jPk3WQMYDYQLkqeKXee/tb5baMwrd9ITix6hNaPZ0kbiI4p
         5+Cg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sudarshan Rajagopalan (QUIC)" <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jon-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org
Cc: SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, talumbau <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm967fi48ZQAG@public.gmane.org

Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
For both clients and servers, workloads can be containerized with virtual m=
achines, kubernetes containers, or memcgs. The workloads differ between ser=
vers and clients.
Server jobs have more predictable memory footprints, and are concerned abou=
t stability and performance. One technique is proactive reclaim, which recl=
aims memory ahead of memory pressure, and makes apparent the amount of actu=
ally free memory on a machine.
Client applications are more bursty and unpredictable since they react to u=
ser interactions. The system needs to respond quickly to interesting events=
, and be aware of energy usage.
An overcommitted machine can scale the containers' footprint through memory=
.max/high, virtio-balloon, etc.
The balloon device is a typical mechanism for sharing memory between a gues=
t VM and host. It is particularly useful in multi-VM scenarios where memory=
 is overcommitted and dynamic changes to VM memory size are required as wor=
kloads change on the system. The balloon device now has a number of feature=
s to assist in judiciously sharing memory resources amongst the guests and =
host (e.g free page hinting, stats, free page reporting). For a host contro=
ller program tasked with optimizing memory resources in a multi-VM environm=
ent, it must use these tools to answer two concrete questions:
    1. When is the right time to modify the balloon?
    2. How much should the balloon be changed by?
An early project to develop such an "auto-balloon" capability was done in 2=
013 [1]. More recently, additional VIRTIO devices have been created (virtio=
-mem, virtio-pmem) that offer more tools for a number of use cases, each wi=
th advantages and disadvantages (see [2] for a recent overview by RedHat of=
 this space). A previous proposal to extend MGLRU with working set interfac=
es [3] focuses on the server use cases but does not work for clients.

Proposal
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
A unified Working Set reporting structure that works for both servers and c=
lients. It involves per-node histograms on the host, per-memcg histograms, =
and a virtio-balloon driver extension.
There are two ways of working with Working Set reporting: event-driven and =
querying. The host controller can receive notifications from reclaim, which=
 produces a report, or the controller can query for the histogram directly.
    Patch 1 introduces the Working Set reporting mechanism and the host int=
erfaces. See the Details section for
    Patch 2 extends the virtio-balloon driver with Working Set reporting.
The initial RFC builds on MGLRU and is intended to be a Proof of Concept fo=
r discussion and refinements. T.J. and I aim to support the active/inactive=
 LRU and working set estimation from the userspace. We are working on demo =
scripts and getting some numbers as well. The RFC is a bit hacky and should=
 be built with the these configs:
CONFIG_LRU_GEN=3Dy
CONFIG_LRU_GEN_ENABLED=3Dy
CONFIG_VIRTIO_BALLOON=3Dy
CONFIG_WSS=3Dy

Host
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
On the host side, a few sysfs files are added to monitor the working set of=
 the host.
On a CONFIG_NUMA system, they live under "/sys/devices/system/node/nodeX/ws=
s/", otherwise they are under "/sys/kernel/mm/wss/". They are mostly read/w=
rite tuneables except for the histogram. The files work as follows:

report_ms:
    Read-write, specifies report threshold in milliseconds, min value 0 max=
 value LONG_MAX. 0 disables working set reporting
    A rate-limiting factor that prevents frequent aging from generating rep=
orts too fast. For example, with a report threshold of 500ms, suppose aging=
 happens 3 times within 500ms, the first one generates a wss report, and th=
e rest are ignored.
    Example:
    $ echo 1000 > report_ms

refresh_ms:
    Read-write, specifies refresh threshold in milliseconds, min value 0 ma=
x value LONG_MAX. 0 ensures that every histogram read produces a new report=
.
    A rate-limiting factor that prevents working set histogram reads from t=
riggering aging too frequently. For example, with a refresh threshold of 10=
,000ms, if a WSS report is generated within the past 10,000ms, reading the =
wss/histogram does not perform aging, otherwise, aging occurs, a new wss re=
port is generated and read. Generating a report can block for the period of=
 time that it takes to complete aging.
    Example:
    $ echo 10000 > refresh_ms

intervals_ms:
    Read-write, specifies bin intervals in milliseconds, min value 1, max v=
alue LONG_MAX.
    Example:
    $ echo 1000,2000,3000,4000 > intervals_ms

histogram:
    Read-only, prints wss report for this node in the format of:
        <interval in ms> anon=3D<nr_pages> file=3D<nr_pages>
        <...>
    Reading it may trigger aging if the refresh threshold has passed.
    On poll, it waits until kswapd performs aging on this node, and notifie=
s subject to the rate limiting threshold set by report_ms
    A per-node histogram that captures the number of bytes of user memory i=
n each working set bin. It reports the anon and file pages separately for e=
ach bin. It does not track other types of memory, e.g. hugetlb or kernel me=
mory.
    Example, note that the last bin is a catch-all bin that comes after all=
 the intervals_ms bins:
    $ cat histogram
    1000 anon=3D618 file=3D10
    2000 anon=3D0 file=3D0
    3000 anon=3D72 file=3D0
    4000 anon=3D83 file=3D0
    9223372036854775807 anon=3D1004 file=3D182

A per-memcg interface is also included, to enable the use cases where one m=
ay use memcgs to manage applications on the host, along with VMs.
The files are:
    memory.wss.report_ms
    memory.wss.refresh_ms
    memory.wss.intervals_ms
    memory.wss.histogram
They support per-node configurations by requiring the node to be specified =
(one node at a time), e.g.
    $ echo N0=3D1000 > memory.wss.report_ms
    $ echo N1=3D3000 > memory.wss.report_ms
    $ echo N0=3D1000,2000,3000,4000 > memory.wss.intervals_ms
    $ cat memory.wss.intervals_ms
    N0=3D1000,2000,4000,9223372036854775807 N1=3D9223372036854775807
    $ cat memory.wss.histogram
    N0
    1000 anon=3D6330 file=3D0
    2000 anon=3D72 file=3D0
    4000 anon=3D0 file=3D0
    9223372036854775807 anon=3D0 file=3D0
    N1
    9223372036854775807 anon=3D0 file=3D0

A reaccess histogram is also implemented for memcgs.
The files are:
    memory.reaccess.intervals_ms
    memory.reaccess.histogram
The interface formats are identical to the memory.wss.*. Writing to memory.=
reaccess.intervals_ms clears the histogram for the corresponding node.
The reaccess histogram is a per-node histogram of page counters. When a pag=
e is discovered to be reaccessed during scanning, the counter for the bin t=
he page is previously in is incremented. For server use cases, the workload=
 memory access pattern is fairly predictable. A proactive reclaimer can use=
 the reaccess information to determine the right bin to reclaim.
    Example, where 72 instances of reaccess were discovered where for pages=
 idle for 1000ms-2000ms during scanning:
    $ cat memory.reaccess.histogram
    N0
    1000 anon=3D6330 file=3D0
    2000 anon=3D72 file=3D0
    4000 anon=3D0 file=3D0
    9223372036854775807 anon=3D0 file=3D0
    N1
    9223372036854775807 anon=3D0 file=3D0

virtio-balloon
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The Working Set reporting mechanism presented in the first patch in this se=
ries provides a mechanism to assist a controller in making such balloon adj=
ustments. There are two components in this patch:
- The virtio-balloon driver has a new feature (VIRTIO_F_WS_REPORTING) to st=
andardize the configuration and communication of Working Set reports to the=
 device.
- A stand-in interface for connecting MM activities (here, only background =
reclaim) to a client (here, just the balloon driver) so that the driver can=
 be notified at appropriate times when a new Working Set report is availabl=
e (and would be useful to share).
By providing a "hook" into reclaim activities, we can provide a mechanism f=
or timely updates (i.e. when the guest is under memory pressure). By provid=
ing a uniform reporting structure in both the host and all guests, a global=
 picture of memory utilization can be reconstructed in the controller, thus=
 helping to answer the question of how much to adjust the balloon.
The reporting mechanism can be combined with a domain-specific balloon poli=
cy in an overcommitted multi-vm scenario, providing balloon adjustments to =
drive the separate reclaim activities in a coordinated fashion.
TODO:
 - Specify a proper interface for clients to register for Working Set repor=
ts, using the shrinker interface as a guide.

References:
[1] https://www.linux-kvm.org/page/Projects/auto-ballooning
[2] https://kvmforum2020.sched.com/event/eE4U/virtio-balloonpmemmem-managin=
g-guest-memory-david-hildenbrand-michael-s-tsirkin-red-hat
[3] https://lore.kernel.org/linux-mm/20221214225123.2770216-1-yuanchu@googl=
e.com/

talumbau (2):
  mm: multigen-LRU: working set reporting
  virtio-balloon: Add Working Set reporting

 drivers/base/node.c                 |   2 +
 drivers/virtio/virtio_balloon.c     | 243 +++++++++++-
 include/linux/balloon_compaction.h  |   6 +
 include/linux/memcontrol.h          |   6 +
 include/linux/mmzone.h              |  14 +-
 include/linux/wss.h                 |  57 +++
 include/uapi/linux/virtio_balloon.h |  21 +
 mm/Kconfig                          |   7 +
 mm/Makefile                         |   1 +
 mm/memcontrol.c                     | 349 ++++++++++++++++-
 mm/mmzone.c                         |   2 +
 mm/vmscan.c                         | 581 +++++++++++++++++++++++++++-
 mm/wss.c                            |  56 +++
 13 files changed, 1341 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/wss.h
 create mode 100644 mm/wss.c

--=20
2.40.1.521.gf1e218fcd8-goog

