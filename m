From: Tejun Heo <tj@kernel.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Mon, 16 Dec 2013 11:35:30 -0500
Message-ID: <20131216163530.GH32509@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pVfxkQgKr6DTLr37U0VLoXEIU8z+OWIpJRgsR8FQuKw=;
        b=MtadVIjgqpaRsTs8oTURdsgmnKUT8dLvFf7fFvICSFBHuBRbW+K7592InA6VDOm2qU
         bZQFG5LqPLRXjw8pkESMld+H4wTUMzAkH6r4Y5mU+GfaggkocANZJ9n6XKfjNowtvh6U
         GlB8mpgT68aKJat2hPpVlnkLAugJWTWZJljPdHLMe2vkwmh8MlYSI6GHy1ZKG3c+bjNa
         4sugL5vy9sla/VXpnE37wi0CIaDT+dHIT8kqCFylqxnTQO6k5cmJ/yDgHToqsMmhvJLy
         TLkVZhyx4vAB3RjPMY1u8ING4kL1/y2CM3qiW7FOOLsUA7UhKQ2Af00EIaRRRh0r240R
         UXIQ==
Content-Disposition: inline
In-Reply-To: <20131216104042.GC23582@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 11:40:42AM +0100, Michal Hocko wrote:
> > How would this work? The task which pushed the memory to the swap is
> > still alive (living in a different group) and the swap will be there
> > after the last reference to css as well.
> 
> Or did you mean to get css reference in swap_cgroup_record and release
> it in __mem_cgroup_try_charge_swapin?
> 
> That would prevent the warning (assuming idr_remove would move to
> css_free[1]) but I am not sure this is the right thing to do. memsw charges
> will be accounted to the parent already (assuming there is one) without
> anybody to uncharge them because all uncharges would fallback to the
> root memcg after css_offline.
> 
> Hugh's approach seems much better.

Hmmm... I think it's reasonable for css's to expect cgrp->id to not be
recycled before all css refs are gone.  If Hugh's patches are
something desriable independent of cgrp->id issues, great, but, if
not, let's first try to get it right from cgroup core.  Is it enough
for css_from_id() to return NULL after offline until all refs are
gone?  That should be an easy fix.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
