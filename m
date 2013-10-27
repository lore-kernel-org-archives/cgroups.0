From: Greg Thelen <gthelen@google.com>
Subject: [PATCH 0/3] fix unsigned pcp adjustments
Date: Sun, 27 Oct 2013 00:44:33 -0700
Message-ID: <1382859876-28196-1-git-send-email-gthelen@google.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=z4DtxdrZS8sG5AdTbvjxdqJ5Nt1WyZ4YKk8IP5Gj2n4=;
        b=ovh/OEeJpu33UNxvZNoU99Tuxo3Xbk9LUES5i1AKFcqyZMJCfj6YKRyjsp/qrqFikj
         hom6OiNAaYImokIrjtUHFQm+5uoGjePe6BC13bj2tuRuSJ02N2CjOjkPkjUvEdVXXWvq
         BRmEP9Pdu2tBtXHDQrDVYYnkFbR3nHCMWN7uhimjOX6Bp5BrpjwUbC5UmZicD7WJjy6r
         pGODpqPbJkgeGzkk21sIJOY3+YCfMVZLDxoueD+ENGBuvnzTXVYAtnNnezhThRYD+D2e
         eD3ehaSOlAeOQoj+1UWXI/epyKDHBlnHmoct0wrjvzi+1ExOlCCyv8vJsdD7SIl27JsR
         p50Q==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, handai.szj@taobao.com, Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Greg Thelen <gthelen@google.com>

As of v3.11-9444-g3ea67d0 "memcg: add per cgroup writeback pages accounting"
memcg use of __this_cpu_add(counter, -nr_pages) leads to incorrect statistic
values because the negated nr_pages is not sign extended (counter is long,
nr_pages is unsigned int).  The memcg fix is __this_cpu_sub(counter, nr_pages).
But that doesn't simply work because __this_cpu_sub(counter, nr_pages) was
implemented as __this_cpu_add(counter, -nr_pages) which suffers the same
problem.  Example:
  unsigned int delta = 1
  preempt_disable()
  this_cpu_write(long_counter, 0)
  this_cpu_sub(long_counter, delta)
  preempt_enable()
    
Before this change long_counter on a 64 bit machine ends with value 0xffffffff,
rather than 0xffffffffffffffff.  This is because this_cpu_sub(pcp, delta) boils
down to:
  long_counter = 0 + 0xffffffff

Patch 1 creates a test module for percpu counters operations which demonstrates
the __this_cpu_sub() problems.  This patch is independent can be discarded if
there is no interest.

Patch 2 fixes __this_cpu_sub() to work with unsigned adjustments.

Patch 3 uses __this_cpu_sub() in memcg.

An alternative smaller solution is for memcg to use:
  __this_cpu_add(counter, -(int)nr_pages)
admitting that __this_cpu_add/sub() doesn't work with unsigned adjustments.  But
I felt like fixing the core services to prevent this in the future.

Greg Thelen (3):
  percpu counter: test module
  percpu counter: cast this_cpu_sub() adjustment
  memcg: use __this_cpu_sub to decrement stats

 arch/x86/include/asm/percpu.h |   3 +-
 include/linux/percpu.h        |   8 +--
 lib/Kconfig.debug             |   9 +++
 lib/Makefile                  |   2 +
 lib/percpu_test.c             | 138 ++++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c               |   2 +-
 6 files changed, 156 insertions(+), 6 deletions(-)
 create mode 100644 lib/percpu_test.c

-- 
1.8.4.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
