From: David Rientjes <rientjes@google.com>
Subject: [patch 08/11] mm, memcg: add memcg oom reserve documentation
Date: Tue, 4 Mar 2014 19:59:32 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403041956250.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=Q1IK/5397Xwi+viHAZc1trtnF4nPxrqIuPZ9M3FzDyY=;
        b=XzqxnAl9MBj3SBTmIa5tg+l6D8M6vf/hKRL0xIF6ebQTBPg+SU7tzFKtcJhwG+bFM8
         anhIaJrwxzjl2yoSZEALnv4p1TeMTq1Js4aOhOz2vzvTa7G+aHd/XoXqvjg4PSFMlJLS
         iMm6EPYawWyABYJInmSQAtg6ANUmVGpeMuZLQlPWWmzkTSf/KORFik3QLl2IrL0nbmhv
         G0QY/c/v4FJqllUu0Blq9dumOy8Ger985lJu1i9ryEZuTkOI15jGK2xPBtJtHdbW5KQ6
         F+NIrb5aTv7MpaP7x5AuR82rpIY0Y/oQVF+CPdD7AcQfUfy8eSDjE+F8r1Xs7gotvynP
         NxRw==
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Add documentation on memcg oom reserves to
Documentation/cgroups/memory.txt and give an example of its usage and
recommended best practices.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroups/memory.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -71,6 +71,7 @@ Brief summary of control files.
 				 (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate # set/show controls of moving charges
  memory.oom_control		 # set/show oom controls.
+ memory.oom_reserve_in_bytes	 # set/show limit of oom memory reserves
  memory.numa_stat		 # show the number of memory usage per numa node
 
  memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
@@ -772,6 +773,31 @@ At reading, current status of OOM is shown.
 	under_oom	 0 or 1 (if 1, the memory cgroup is under OOM, tasks may
 				 be stopped.)
 
+Processes that handle oom conditions in their own memcgs or their child
+memcgs may need to allocate memory themselves to do anything useful,
+including pagefaulting its text or allocating kernel memory to read the
+memcg "tasks" file.  For this reason, memory.oom_reserve_in_bytes is
+provided that specifies how much memory that processes waiting on
+memory.oom_control can allocate above the memcg limit.
+
+The memcg that the oom handler is attached to is charged for the memory
+that it allocates against its own memory.oom_reserve_in_bytes.  This
+memory is therefore only available to processes that are waiting for
+a notification.
+
+For example, if you do
+
+	# echo 2m > memory.oom_reserve_in_bytes
+
+then any process attached to this memcg that is waiting on memcg oom
+notifications anywhere on the system can allocate an additional 2MB
+above memory.limit_in_bytes.
+
+You may still consider doing mlockall(MCL_FUTURE) for processes that
+are waiting on oom notifications to keep this vaue as minimal as
+possible, or allow it to be large enough so that its text can still
+be pagefaulted in under oom conditions when the value is known.
+
 11. Memory Pressure
 
 The pressure level notifications can be used to monitor the memory

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
