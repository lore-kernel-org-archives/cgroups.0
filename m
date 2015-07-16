From: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Subject: Access rules for current->memcg
Date: Thu, 16 Jul 2015 16:34:08 +0300
Message-ID: <55A7B2D0.1030506@siteground.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I'd like to ask what are the locking rules when using
mem_cgroup_from_task(current)? Currently I'm doing this under
rcu_read_lock which I believe is sufficient. However, I've seen patches
where reference is obtained via mem_cgroup_from_task and then
css_tryget_online is used on the resulting cgroup?

Looking at the context of css_tryget_online it seems it will only
succeed if the cgroup isn't being terminated (cgroup_destroy_locked
isn't being invoked). Judging from this then if a css_tryget_online
succeeds this means the caller can be sure they are working with a live
cgroup, however, what happens if the process of acuiqring a reference on
css is skipped AND the caller is under RCU read lock? They are
guaranteed to succeed, but after the rcu read lock is released the
cgroup might go away ?

Essentially my use case is to obtain a reference to a memcg for the
current process and query some counter values IOW - just reading from
the memcg. Do I need to acquire a CSS reference in this case?

Regards,
Nikolay
