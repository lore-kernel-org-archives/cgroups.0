From: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC][PATCH] cpu/hotplug: wait for cpuset_hotplug_work to finish on cpu online
Date: Thu,  3 Dec 2020 17:14:31 +0000
Message-ID: <20201203171431.256675-1-aklimov@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607015681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3iwcG8+s5F+FEk/BmczMtBbT8rfaBFSaW5JqYcJIHRE=;
        b=eLsF3hDwmWhWNXBSb3hILCzFIxIFy60dPBnzlTQkaCoDmmLEN15jFD2sFO1m0J48yu3XPM
        FH7IgdvLRtR/EJEWPedZ2AYIQ++kw8ZEFYevo7szFZdt8Y7+rZJSVBbvohqYFDFh4ndVj/
        NafepwG4RsV7UVH83cU0fxbiyB5gQH4=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

When a CPU offlined and onlined via device_offline() and device_online()
the userspace gets uevent notification. If, after receiving uevent,
userspace executes sched_setaffinity() on some task trying to move it
to a recently onlined CPU, then it will fail with -EINVAL. Userspace needs
to wait around 5..30 ms before sched_setaffinity() will succeed for
recently onlined CPU after receiving uevent.

If in_mask for sched_setaffinity() has only recently onlined CPU, it
quickly fails with such flow:

  sched_setaffinity()
    cpuset_cpus_allowed()
      guarantee_online_cpus()   <-- cs->effective_cpus mask does not
                                        contain recently onlined cpu
    cpumask_and()               <-- final new_mask is empty
    __set_cpus_allowed_ptr()
      cpumask_any_and_distribute() <-- returns dest_cpu equal to nr_cpu_ids
      returns -EINVAL

Cpusets are updated using workqueue from cpuset_update_active_cpus() which
in its turn is called from cpu hotplug callback sched_cpu_activate() hence
the delay observable by sched_setaffinity().
Out of line uevent can be avoided if we will ensure that cpuset_hotplug_work
has run to completion using cpuset_wait_for_hotplug() after onlining the
cpu in cpu_up(). Unfortunately, the execution time of
echo 1 > /sys/devices/system/cpu/cpuX/online roughly doubled with this
change (on my test machine).

Co-analyzed-by: Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

The commit "cpuset: Make cpuset hotplug synchronous" would also get rid of the
early uevent but it was reverted.

The nature of this bug is also described here (with different consequences):
https://lore.kernel.org/lkml/20200211141554.24181-1-qais.yousef-5wv7dgnIgG8@public.gmane.org/

Reproducer: https://gitlab.com/0xeafffffe/xlam

It could be that I missed the correct place for cpuset synchronisation and it should
be done in cpu_device_up() instead.
I also in doubts if we need cpuset_wait_for_hotplug() in cpuhp_online_cpu_device()
since an online uevent is sent there too.
Currently with such change the reproducer code continues to work without issues.
The idea is to avoid the situation when userspace receives the event about
onlined CPU which is not ready to take tasks for a while after uevent.


 kernel/cpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6ff2578ecf17..f39a27a7f24b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,7 @@
 #include <linux/sched/smt.h>
 #include <linux/unistd.h>
 #include <linux/cpu.h>
+#include <linux/cpuset.h>
 #include <linux/oom.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
@@ -1275,6 +1276,8 @@ static int cpu_up(unsigned int cpu, enum cpuhp_state target)
 	}
 
 	err = _cpu_up(cpu, 0, target);
+	if (!err)
+		cpuset_wait_for_hotplug();
 out:
 	cpu_maps_update_done();
 	return err;
-- 
2.26.2

