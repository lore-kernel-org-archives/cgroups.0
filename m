From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v3] cgroup: net_cls: traffic counter based on classification
 control cgroup
Date: Mon, 14 Jan 2013 14:37:09 +0800
Message-ID: <50F3A795.7050102@huawei.com>
References: <50F04502.9090902@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F04502.9090902-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexey Perevalov <a.perevalov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On 2013/1/12 0:59, Alexey Perevalov wrote:
> Hello
> 
> I'm sorry for previous email with attachments.
> 
> I would like to represent next version of patch I sent before
> cgroup: "net_cls: traffic counter based on classification control cgroup"
> 
> The main idea is the same as was. It keeping counter in control groups, but now uses atomic instead resource_counters.
> 
> I have a performance measurement for this patch. It was done by lmbench on physical machine.
> Results are not so representative for 20 tests and some numbers are real weird.
> 
> Daniel Wagner wrote what he is doing something similar, but using namespaces.
> 
> Proposed by me approach is used in upcoming Tizen release, but little bit different version.
> 
> 
> Signed-off-by: Alexey Perevalov <a.perevalov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  include/net/cls_cgroup.h         |  200 ++++++++++++++++++++++++++++++++++----
>  include/net/cls_counter_holder.h |   26 +++++
>  init/Kconfig                     |   25 +++++
>  kernel/cgroup.c                  |    2 +
>  kernel/res_counter.c             |    4 +
>  net/core/dev.c                   |    6 ++
>  net/ipv4/tcp.c                   |   29 +++++-
>  net/ipv4/udp.c                   |    6 ++
>  net/sched/Kconfig                |   11 ---
>  net/sched/Makefile               |    1 +
>  net/sched/cls_cgroup.c           |  193 +++++++++++++++++++++++++++++++++++-
>  net/sched/cls_counter_holder.c   |  144 +++++++++++++++++++++++++++
>  12 files changed, 612 insertions(+), 35 deletions(-)
>  create mode 100644 include/net/cls_counter_holder.h
>  create mode 100644 net/sched/cls_counter_holder.c

You should cc netdev mailing list.
