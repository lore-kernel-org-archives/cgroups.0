From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Wed, 13 Nov 2013 12:38:40 +0900
Message-ID: <20131113033840.GC19394@mtj.dyndns.org>
References: <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131111153148.GC14497@dhcp22.suse.cz>
 <20131112145824.GC6049@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1E8DJ61zCVxVE3jKjzYunm7KlAoAlkgD0Hf20lv560s=;
        b=JvssD7fRBfkJIL2Ft+UN2838GrVzuFYCqx2NVCpq7X/Rhrpv3NxJqRu0DjshzkJiuh
         1lkPOk7KwTMnaCskOXPamMVzvjqQLevEgTkQ118/ZQ/AOTPxBpND9jAYkFTTKwN2TZwb
         Dzv5U9CtoYdOSAgJbAGHhtXqMux3UCNF0whXDvFXvh4ojLU2DSLpcNtCeri8PYrrdxjb
         veP0P/ybMqWyKrxvbq+S5j2zYl/VYthdWRIJiuLfV0Z1/PCr+R8sQCIdNBzvi8ongHT2
         riWTnGeDkIndFctBD8QKuVpqp9MjHbqTSQ/jY0ajjEFBdvGzyWVKQajciLwmx4XAdkeJ
         xkkQ==
Content-Disposition: inline
In-Reply-To: <20131112145824.GC6049-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Tue, Nov 12, 2013 at 03:58:24PM +0100, Michal Hocko wrote:
> Hmm, there is CSS_ONLINE and it has a different meaning that we would
> need.
> css_alive() would be a better fit. Something like the following:
> 
> static inline bool percpu_ref_alive(struct percpu_ref *ref)
> {
> 	int ret = false;
> 	
> 	rcu_lockdep_assert(rcu_read_lock_held(), "percpu_ref_alive needs an RCU lock");
> 	return REF_STATUS(pcpu_count) == PCPU_REF_PTR;
> }

I'd really like to avoid exposing percpu-ref locking details to its
users.  e.g. percpu_ref switched from normal RCU to sched RCU
recently.

> static inline bool css_alive(struct cgroup_subsys_state *css)
> {
> 	return percpu_ref_alive(&css->refcnt);
> }
> 
> and for our use we would have something like the following in
> __mem_cgroup_try_charge_swapin:
> 
> 	memcg = try_get_mem_cgroup_from_page
> 	[...]
> 	__mem_cgroup_try_charge(...);
> 
> 	/*
>          * try_get_mem_cgroup_from_page and the actual charge are not
>          * done in the same RCU read section which means that the memcg
>          * might get offlined before res counter is charged if the
>          * current charger is not a memcg memeber so we have to recheck
>          * the memcg's css status again here and revert that charge as
>          * we cannot be sure it was accounted properly.
> 	 */
> 	if (!ret) {
> 		rcu_read_lock();
> 		if (!css_alive(&memcg->css)) {
> 			__mem_cgroup_cancel_charge(memcg, 1);
> 			rcu_read_unlock();
> 			css_put(&memcg->css);
> 			*memcgp = NULL;
> 			goto charge_cur_mm;
> 		}
> 		rcu_read_unlock();
> 	}

Without going into memcg details, the general cgroup policy now is to
make each controller responsible for its own synchronization so that
we don't end up entangling synchronization schemes of different
controllers.  cgroup core invokes the appropriate callback on each
state transition and provides certain guarantees so that controllers
can implement proper synchronization from those callbacks.  During
shutdown, ->css_offline() is where a css transits from life to death
and memcg should be able to implement proper synchronization from
there if necessary.

Thanks.

-- 
tejun
