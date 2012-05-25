From: Glauber Costa <glommer@parallels.com>
Subject: [PATCH v7 0/2] fixes for sock memcg static branch disablement
Date: Fri, 25 May 2012 13:32:06 +0400
Message-ID: <1337938328-11537-1-git-send-email-glommer@parallels.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, David Miller <davem@davemloft.net>

Hi Andrew,

I believe this one addresses all of your previous comments.

Besides merging your patch, I tried to improve the comments so they would
be more informative. 

The first patch, I believe, is already merged at your tree. But I am including
it here for completeness. I had no changes since last submission, so feel free
to pick the second - or if there are still missing changes you'd like to see,
point me to them.

Thanks

Glauber Costa (2):
  Always free struct memcg through schedule_work()
  decrement static keys on real destroy time

 include/net/sock.h        |   22 ++++++++++++++++++
 mm/memcontrol.c           |   55 ++++++++++++++++++++++++++++++++++----------
 net/ipv4/tcp_memcontrol.c |   34 ++++++++++++++++++++++-----
 3 files changed, 91 insertions(+), 20 deletions(-)

-- 
1.7.7.6
