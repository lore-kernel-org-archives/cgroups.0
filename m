From: Dan Carpenter <dan.carpenter-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [bug report] cgroup: use irqsave in cgroup_rstat_flush_locked().
Date: Fri, 4 Aug 2023 10:28:28 +0300
Message-ID: <39c0d51f-eae4-4895-8913-a290bba27d78@moroto.mountain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691134113; x=1691738913;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VN2JACKxsZL/oUKnyCvyLes64DwlVzVTXFWkesuh998=;
        b=L0SSutuIButkgx7B2hwYEsoFYQRqzePnpoUcsvkEogpnk4axGu+CANlTsXct/0w7w6
         vGVPRfQI2zySJrfSq59X9Pff5QxXzsG0FRrtccAXB5K5YKxKrxosL9rOHP/24Tudi8R0
         NraKJJnd6oM0NTM64WWSGHr3Xw5MkzG4VhqWzc/tQiZsyANEu/SU6rCtArJcZN1S1no3
         0kRXdiLqpg/iO1CKxjEp1BrJO2xPElybfM6kr0ux/hte2UATKGP/bzjc3yXgdOvaS3Mm
         3RdOd3lkk/HUUhmn2YqK+BbEP1Z7hCJgKQceRGdPXwwLm/JFZcpybljD6LPtRGTpebef
         qJJg==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Sebastian Andrzej Siewior,

The patch b1e2c8df0f00: "cgroup: use irqsave in
cgroup_rstat_flush_locked()." from Mar 23, 2022 (linux-next), leads
to the following Smatch static checker warning:

	kernel/cgroup/rstat.c:212 cgroup_rstat_flush_locked()
	warn: mixing irqsave and irq

kernel/cgroup/rstat.c
    174 static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
    175         __releases(&cgroup_rstat_lock) __acquires(&cgroup_rstat_lock)
    176 {
    177         int cpu;
    178 
    179         lockdep_assert_held(&cgroup_rstat_lock);
    180 
    181         for_each_possible_cpu(cpu) {
    182                 raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock,
    183                                                        cpu);
    184                 struct cgroup *pos = NULL;
    185                 unsigned long flags;
    186 
    187                 /*
    188                  * The _irqsave() is needed because cgroup_rstat_lock is
    189                  * spinlock_t which is a sleeping lock on PREEMPT_RT. Acquiring
    190                  * this lock with the _irq() suffix only disables interrupts on
    191                  * a non-PREEMPT_RT kernel. The raw_spinlock_t below disables
    192                  * interrupts on both configurations. The _irqsave() ensures
    193                  * that interrupts are always disabled and later restored.
    194                  */
    195                 raw_spin_lock_irqsave(cpu_lock, flags);

There is obviously a giant comment explaining why irqsave is required
instead of irq.

    196                 while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu))) {
    197                         struct cgroup_subsys_state *css;
    198 
    199                         cgroup_base_stat_flush(pos, cpu);
    200                         bpf_rstat_flush(pos, cgroup_parent(pos), cpu);
    201 
    202                         rcu_read_lock();
    203                         list_for_each_entry_rcu(css, &pos->rstat_css_list,
    204                                                 rstat_css_node)
    205                                 css->ss->css_rstat_flush(css, cpu);
    206                         rcu_read_unlock();
    207                 }
    208                 raw_spin_unlock_irqrestore(cpu_lock, flags);
    209 
    210                 /* play nice and yield if necessary */
    211                 if (need_resched() || spin_needbreak(&cgroup_rstat_lock)) {
--> 212                         spin_unlock_irq(&cgroup_rstat_lock);

But it's sort of confusing that irqsave isn't used here.  It's so
weird that irq doesn't disable interrupts on some configs where _irqsave
does.  That seems like the naming is bad.

    213                         if (!cond_resched())
    214                                 cpu_relax();
    215                         spin_lock_irq(&cgroup_rstat_lock);
    216                 }
    217         }
    218 }

regards,
dan carpenter
