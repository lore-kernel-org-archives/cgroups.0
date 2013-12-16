From: Tejun Heo <tj@kernel.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Mon, 16 Dec 2013 12:19:41 -0500
Message-ID: <20131216171941.GI32509@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216164154.GX21724@cmpxchg.org>
 <20131216171527.GF26797@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hOTCT3Dr6R7IsrSZ9Uff25Wy44iWEaQ6Lu/DnuCcrvA=;
        b=rC5ydDOV4YaQRfnZmaxGS/4DVy8/dZwPj1j/4qwobD4l8yy/83tTEB6V8JnTGzaHX+
         4ofTXfbjE/M3sHRwnqjujzXNlXhpn/Q67SKIy0/jlzUr3TJbkxThnhwPK2vugosVgrfe
         Vs9E7FRAHQZm/EFM+/EVgTocSR801EbaRNNhwOOTjBw1N5YGlBXMH+SJkA+OqLbpN4tW
         nUnAl28W3r3+P0bHTdUzPZFfnYN8l/eUXL2gm/ZhDvyt7i3y1iL0m8tOgdawPVOeCao1
         ZXUNr4PJvqgL4YhkPwf9nn/wGtLTSFCPKF4EtOG3M97Dkb53bbkph+l8GiFWKwoHl4Ry
         9qag==
Content-Disposition: inline
In-Reply-To: <20131216171527.GF26797@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Michal, Johannes.

On Mon, Dec 16, 2013 at 06:15:27PM +0100, Michal Hocko wrote:
> > We already do that, swap records hold a css reference.  We do the put
> > in mem_cgroup_uncharge_swap().
> 
> Dohh! You are right I have totally missed that the css_get is burried in
> __mem_cgroup_uncharge_common and the counterpart is in mem_cgroup_uncharge_swap
> (which is less unexpected).
> 
> > It really strikes me as odd that we recycle the cgroup ID while there
> > are still references to the cgroup in circulation.
> 
> That is true but even with this fixed I still think that the Hugh's
> approach makes a lot of sense.

I thought about this a bit and I think the id really should be per
subsystem - ie. like css_id but just a dumb id as cgrp->id.  The
reason is that cgroup's lifetime and css's lifetime will soon be
decoupled.  ie. if a css is disabled and re-enabled on the same
cgroup, there can be two css's associated with a single cgroup.
cgroup_css() and css iterators should block accesses to css's which
are being drained but it does make sense for id lookup to work until
the css is actually released.

That said, for now, whatever works is fine and if Hugh's suggested
change is desirable anyway, that should do for now.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
