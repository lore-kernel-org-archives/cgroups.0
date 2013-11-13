From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Wed, 13 Nov 2013 12:01:08 +0100
Message-ID: <20131113110108.GA22131@dhcp22.suse.cz>
References: <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131111153148.GC14497@dhcp22.suse.cz>
 <20131112145824.GC6049@dhcp22.suse.cz>
 <20131113033840.GC19394@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131113033840.GC19394-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 13-11-13 12:38:40, Tejun Heo wrote:
> Hello, Michal.
> 
> On Tue, Nov 12, 2013 at 03:58:24PM +0100, Michal Hocko wrote:
> > Hmm, there is CSS_ONLINE and it has a different meaning that we would
> > need.
> > css_alive() would be a better fit. Something like the following:
> > 
> > static inline bool percpu_ref_alive(struct percpu_ref *ref)
> > {
> > 	int ret = false;
> > 	
> > 	rcu_lockdep_assert(rcu_read_lock_held(), "percpu_ref_alive needs an RCU lock");
> > 	return REF_STATUS(pcpu_count) == PCPU_REF_PTR;
> > }
> 
> I'd really like to avoid exposing percpu-ref locking details to its
> users.  e.g. percpu_ref switched from normal RCU to sched RCU
> recently.
> 
> > static inline bool css_alive(struct cgroup_subsys_state *css)
> > {
> > 	return percpu_ref_alive(&css->refcnt);
> > }
> > 
> > and for our use we would have something like the following in
> > __mem_cgroup_try_charge_swapin:
> > 
> > 	memcg = try_get_mem_cgroup_from_page
> > 	[...]
> > 	__mem_cgroup_try_charge(...);
> > 
> > 	/*
> >          * try_get_mem_cgroup_from_page and the actual charge are not
> >          * done in the same RCU read section which means that the memcg
> >          * might get offlined before res counter is charged if the
> >          * current charger is not a memcg memeber so we have to recheck
> >          * the memcg's css status again here and revert that charge as
> >          * we cannot be sure it was accounted properly.
> > 	 */
> > 	if (!ret) {
> > 		rcu_read_lock();
> > 		if (!css_alive(&memcg->css)) {
> > 			__mem_cgroup_cancel_charge(memcg, 1);
> > 			rcu_read_unlock();
> > 			css_put(&memcg->css);
> > 			*memcgp = NULL;
> > 			goto charge_cur_mm;
> > 		}
> > 		rcu_read_unlock();
> > 	}
> 
> Without going into memcg details, the general cgroup policy now is to
> make each controller responsible for its own synchronization so that
> we don't end up entangling synchronization schemes of different
> controllers.  cgroup core invokes the appropriate callback on each
> state transition and provides certain guarantees so that controllers
> can implement proper synchronization from those callbacks.  During
> shutdown, ->css_offline() is where a css transits from life to death
> and memcg should be able to implement proper synchronization from
> there if necessary.

Fair enough. I will play with memcg specific flag.
 
Thanks.
-- 
Michal Hocko
SUSE Labs
