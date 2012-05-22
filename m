From: Glauber Costa <glommer@parallels.com>
Subject: [PATCH v6 0/2] fix static_key disabling problem in memcg
Date: Tue, 22 May 2012 14:25:37 +0400
Message-ID: <1337682339-21282-1-git-send-email-glommer@parallels.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>

Andrew,

This is a respin of the last fixes I sent for sock memcg problems with
the static_keys enablement. The first patch is still unchanged, and for
the second, I am using a flags field as for your suggestion.
Indeed, I found a flags field to be more elegant, while still
maintaining a fast path for the readers.

Kame, will you please take a look and see if this would work okay? 

Tejun, are you happy with the current state of the comments explaining
the scenario?

Thank you very much for your time

Glauber Costa (2):
  Always free struct memcg through schedule_work()
  decrement static keys on real destroy time

 include/linux/memcontrol.h |    5 ++++
 include/net/sock.h         |   11 +++++++++
 mm/memcontrol.c            |   53 +++++++++++++++++++++++++++++++++----------
 net/ipv4/tcp_memcontrol.c  |   34 ++++++++++++++++++++++-----
 4 files changed, 83 insertions(+), 20 deletions(-)

-- 
1.7.7.6
