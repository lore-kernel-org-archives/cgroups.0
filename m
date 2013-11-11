From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 11 Nov 2013 16:31:48 +0100
Message-ID: <20131111153148.GC14497@dhcp22.suse.cz>
References: <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131107235301.GB1092-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 07-11-13 18:53:01, Johannes Weiner wrote:
[...]
> Unfortunately, memory cgroups don't hold the rcu_read_lock() over both
> the tryget and the res_counter charge that would make it visible to
> offline_css(), which means that there is a possible race condition
> between cgroup teardown and an ongoing charge:
> 
> #0: destroy                #1: charge
> 
>                            rcu_read_lock()
>                            css_tryget()
>                            rcu_read_unlock()
> disable tryget()
> call_rcu()
>   offline_css()
>     reparent_charges()
>                            res_counter_charge()
>                            css_put()
>                              css_free()
>                            pc->mem_cgroup = deadcg
>                            add page to lru

AFAICS this might only happen when a charge is done by a group nonmember
(the group has to be empty at the destruction path, right?) and this is
done only for the swap accounting. What we can do instead is that we
might recheck after the charge has been done and cancel + fallback to
current if we see that the group went away. Not nice either but it
shouldn't be intrusive and should work:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1fded477ef6..3d69a3fe4c55 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4006,6 +4006,24 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		goto charge_cur_mm;
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
+
+	/*
+	 * try_get_mem_cgroup_from_page and the actual charge are not
+	 * done in the same RCU read section which means that the memcg
+	 * might get offlined before res counter is charged so we have
+	 * to recheck the memcg status again here and revert that charge
+	 * as we cannot be sure it was accounted properly.
+	 */
+	if (!ret) {
+		/* XXX: can we have something like css_online() check? */
+		if (!css_tryget(&memcg->css)) {
+			__mem_cgroup_cancel_charge(memcg, 1);
+			css_put(&memcg->css);
+			*memcgp = NULL;
+			goto charge_cur_mm;
+		}
+		css_put(&memcg->css);
+	}
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		ret = 0;

What do you think? I guess, in the long term we somehow have to mark
alien charges and delay css_offlining until they are done to prevent
hacks like above.
-- 
Michal Hocko
SUSE Labs
