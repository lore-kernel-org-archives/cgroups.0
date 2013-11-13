From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC] memcg: fix race between css_offline and async charge (was:
 Re: Possible regression with cgroups in 3.11)
Date: Wed, 13 Nov 2013 09:54:27 -0500
Message-ID: <20131113145427.GG707@cmpxchg.org>
References: <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131111153148.GC14497@dhcp22.suse.cz>
 <20131112145824.GC6049@dhcp22.suse.cz>
 <20131113033840.GC19394@mtj.dyndns.org>
 <20131113110108.GA22131@dhcp22.suse.cz>
 <20131113132337.GB22131@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=t87IoKHJAvT5Wks47KWkW9Tz6/nKy7GIbzubgRtScqg=;
	b=t7cD86Jr5v1WMnOKYeAAlLF7tBr7p2xbCPgHJ4NBUz3qyYI+CbO1MBlzz3XqKbOTOI3qYu3XpMrebs2bSR1QVclVgJTPgA0hqqAjXSJWcTOidLRiErbFh73zF6fSrEfiGaJEX06b1IBo7/3oBqHbWk/uzMuXgNEO163K7VkWzAc=;
Content-Disposition: inline
In-Reply-To: <20131113132337.GB22131-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 13, 2013 at 02:23:37PM +0100, Michal Hocko wrote:
> Johannes, what do you think about something like this?
> I have just compile tested it.
> --- 
> >From 73042adc905847bfe401ae12073d1c479db8fdab Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Wed, 13 Nov 2013 13:53:54 +0100
> Subject: [PATCH] memcg: fix race between css_offline and async charge
> 
> As correctly pointed out by Johannes, charges done on behalf of a group
> where the current task is not its member (swap accounting currently) are
> racy wrt. memcg offlining (mem_cgroup_css_offline).
> 
> This might lead to a charge leak as follows:
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
> 
> If a group has a parent then the parent's res_counter would have a
> charge which doesn't have any corresponding page on any reachable LRUs
> under its hierarchy and so it won't be able to free/reparent its own
> charges when going away and end up looping in reparent_charges for ever.
> 
> This patch fixes the issue by introducing memcg->offline flag which is
> set when memcg is offlined (and the memcg is not reachable anymore).
> 
> The only async charger we have currently (swapin accounting path) checks
> the offline status after successful charge and uncharges and falls back
> to charge the current task if the group is offline now.
> 
> Spotted-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Ultimately, we want to have the tryget and the res_counter charge in
the same rcu readlock region because cgroup already provides rcu
protection.  We need a quick fix until then.

So I'm not sure why you are sending more patches, I already provided a
one-liner change that should take care of this and you didn't say why
it wouldn't work.
