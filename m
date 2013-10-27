From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/3] fix unsigned pcp adjustments
Date: Sun, 27 Oct 2013 10:30:14 -0700
Message-ID: <1382895017-19067-1-git-send-email-gthelen@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=99RCyMirEksVTTa2wv4rtFdSsxYqBDz401E3g9YnEFY=;
        b=gjmL3i1taTqretWTBBqnkymK9ppYAoBhACBxKCHHoCFpXiLl857BWMZvacrkY5zgGT
         4AkSQmgzHp9HhIdTa48MOWY0jqA+pKFxoIEip2+7jy0KqUvqPQJg83fOUEo+Ix7YHy5W
         ZE3OyOYmhp2sirkISXx/8R1hJwJ0fZdtdiyiZMMk9PAt2aYXeaeaLokQJoFoDL/31Ef1
         LgKY/eniM1NMWcupsZns6nGCAUMGaCeec4Lx2/otQ5dwQ5AU4G15Fw2ArVM5kIpVdnK6
         B8OfB8b8ioLJpRcUB+FmsET/QyewBewYuhruXZHKxK+gEFBwFC+KgOljt0a4be+yJp4O
         emrw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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

v3.12-rc6 shows that only new memcg code is affected by this problem - the new
mem_cgroup_move_account_page_stat() is the only place where an unsigned
adjustment is used.  All other callers (e.g. shrink_dcache_sb) already use a
signed adjustment, so no problems before v3.12.  Though I did not audit the
stable kernel trees, so there could be something hiding in there.

Patch 1 creates a test module for percpu operations which demonstrates the
__this_cpu_sub() problems.  This patch is independent can be discarded if there
is no interest.

Patch 2 fixes __this_cpu_sub() to work with unsigned adjustments.

Patch 3 uses __this_cpu_sub() in memcg.

An alternative smaller solution is for memcg to use:
  __this_cpu_add(counter, -(int)nr_pages)
admitting that __this_cpu_add/sub() doesn't work with unsigned adjustments.  But
I felt like fixing the core services to prevent this in the future.

Changes from V1:
- more accurate patch titles, patch logs, and test module description now
  referring to per cpu operations rather than per cpu counters.
- move small test code update from patch 2 to patch 1 (where the test is
  introduced).

Greg Thelen (3):
  percpu: add test module for various percpu operations
  percpu: fix this_cpu_sub() subtrahend casting for unsigneds
  memcg: use __this_cpu_sub() to dec stats to avoid incorrect subtrahend
    casting

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
