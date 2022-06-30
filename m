From: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Subject: [Bug] race condition at rebind_subsystems()
Date: Thu, 30 Jun 2022 18:52:10 +0800
Message-ID: <1978e209e71905d89651e61abd07285912d412a1.camel@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Matthias Brugger <matthias.bgg@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Shakeel Butt <shakeelb@google.com>, wsd_upstream@mediatek.com, lixiong.liu@mediatek.com, wenju.xu@mediatek.com, jonathan.jmchen@mediatek.com

Hi Johannes



We find the KE(kernel exception) happened when test the reboot test
case in T SW version with kernel-5.15.
The issue is unable to handle kernel paging request at virtual address.

Root cause:
The rebind_subsystems() is no lock held when move css object from A
list to B list,then let B's head be treated as css node at
list_for_each_entry_rcu().
Use the wrong css to get css->ss->css_rstat_flush should get a wrong
address.

The call stack as following:
kthread
-> worker_thread
-> process_one_work
-> flush_memcg_stats_dwork
-> __mem_cgroup_flush_stats
-> cgroup_rstat_flush_irqsafe
-> cgroup_rstat_flush_locked

Detail:
static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool
may_sleep)
{
...
   rcu_read_lock();
   list_for_each_entry_rcu(css, &pos->rstat_css_list,
                             rstat_css_node)
        css->ss->css_rstat_flush(css, cpu);
   rcu_read_unlock();
...
}

Because the content of css->ss is not a function address,
once the css_rstat_flush is called, kernel exception will happen.
When the issue happened, the list of pos->rstat_css_list at group A is
empty.
There must be racing conditions.

From reviewing code, we find rebind_subsystems() is no lock held when
move css object to other list.

int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
{
...
   if (ss->css_rstat_flush) {
         list_del_rcu(&css->rstat_css_node);
         list_add_rcu(&css->rstat_css_node,
                      &dcgrp->rstat_css_list);
   }
...
}

If we held a css object from A group list, at same time this css object
was moved to B group list.
Because current pos is in B’s list, link list was link the pos->next to
B’s head, so the pos->member will never equal A’s head, then the B’s
head(cgroup_root->cgroup->rstat_css_list) will be treated as css
node(css->rstat_css_node).
list_for_each_entry_rcu() use the container_of() to get css address,
and it treated the address of [cgroup_root->cgroup->rstat_css_list -
rstat_css_node] to be a css address.
cgroup_rstat_flush_locked() use the wrong css address to do css->ss-
>css_rstat_flush, then the wrong function address will be jump.

#define list_for_each_entry_rcu(pos, head, member,
cond...)             \
   for (__list_check_rcu(dummy, ## cond, 0), \
     pos = list_entry_rcu((head)->next, typeof(*pos), member); \
        &pos->member != (head);                                \
        pos = list_entry_rcu(pos->member.next, typeof(*pos), member))


We look the patch of move css object from A list to B list is merged by
following link:

https://android.googlesource.com/kernel/common/+/a7df69b81aac5bdeb5c5aef9addd680ce22feebf%5E%21/#F0


Do you have any suggestion for this issue?
Thank you.



Best Regards,
Jing-Ting Wu


