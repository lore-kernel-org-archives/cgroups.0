From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] memcg: fix memcg resource limit overflow issues
Date: Fri, 2 Aug 2013 11:25:29 +0800
Message-ID: <1375413933-10732-1-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This issue is first discussed in:
http://marc.info/?l=linux-mm&m=136574878704295&w=2

Then a second version sent to:
http://marc.info/?l=linux-mm&m=136776855928310&w=2

We contacted Sha a month ago, she seems have no time to deal with it 
recently, but we quite need this patch. So I modified and resent it.

Changes from v1:
* Added From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
  (Sorry for the omission in the first version)
* Added Acked-by and Reviewed-by from Michal

Sha Zhengju (4):
  memcg: correct RESOURCE_MAX to ULLONG_MAX
  memcg: rename RESOURCE_MAX to RES_COUNTER_MAX
  memcg: avoid overflow caused by PAGE_ALIGN
  memcg: reduce function dereference

 include/linux/res_counter.h |  2 +-
 kernel/res_counter.c        | 25 ++++++++++++++++---------
 mm/memcontrol.c             |  4 ++--
 net/ipv4/tcp_memcontrol.c   | 10 +++++-----
 4 files changed, 24 insertions(+), 17 deletions(-)

-- 
1.8.3

