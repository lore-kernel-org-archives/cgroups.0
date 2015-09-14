From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg: ratify and consolidate over-charge handling
Date: Mon, 14 Sep 2015 15:44:20 +0300
Message-ID: <20150914124420.GE30743@esperanza>
References: <20150913201416.GC25369@htj.duckdns.org>
 <20150913201442.GD25369@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150913201442.GD25369-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Sep 13, 2015 at 04:14:42PM -0400, Tejun Heo wrote:
> try_charge() is the main charging logic of memcg.  When it hits the
> limit but either can't fail the allocation due to __GFP_NOFAIL or the
> task is likely to free memory very soon, being OOM killed, has SIGKILL
> pending or exiting, it "bypasses" the charge to the root memcg and
> returns -EINTR.  While this is one approach which can be taken for
> these situations, it has several issues.
> 
> * It unnecessarily lies about the reality.  The number itself doesn't
>   go over the limit but the actual usage does.  memcg is either forced
>   to or actively chooses to go over the limit because that is the
>   right behavior under the circumstances, which is completely fine,
>   but, if at all avoidable, it shouldn't be misrepresenting what's
>   happening by sneaking the charges into the root memcg.
> 
> * Despite trying, we already do over-charge.  kmemcg can't deal with
>   switching over to the root memcg by the point try_charge() returns
>   -EINTR, so it open-codes over-charing.
> 
> * It complicates the callers.  Each try_charge() user has to handle
>   the weird -EINTR exception.  memcg_charge_kmem() does the manual
>   over-charging.  mem_cgroup_do_precharge() performs unnecessary
>   uncharging of root memcg, which BTW is inconsistent with what

Hmm, cancel_charge(root_mem_cgroup) is a no-op. Looks like this is a
leftover from the times when we did charge root_mem_cgroup.

Anyway, the rationale makes sense to me, and the patch looks good.

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

>   memcg_charge_kmem() does.  mem_cgroup_try_charge() needs to switch
>   the returned cgroup to the root one.
> 
> The reality is that in memcg there are cases where we are forced
> and/or willing to go over the limit.  Each such case needs to be
> scrutinized and justified but there definitely are situations where
> that is the right thing to do.  We alredy do this but with a
> superficial and inconsistent disguise which leads to unnecessary
> complications.
> 
> This patch updates try_charge() so that it over-charges and returns 0
> when deemed necessary.  -EINTR return is removed along with all
> special case handling in the callers.
> 
> While at it, remove the local variable @ret, which was initialized to
> zero and never changed, along with done: label which just returned the
> always zero @ret.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
...
