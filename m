From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Thu, 4 Oct 2012 07:54:58 +0900
Message-ID: <20121003225458.GE19248@localhost>
References: <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
 <20120927144307.GH3429@suse.de>
 <20120927145802.GC4251@mtj.dyndns.org>
 <50649B4C.8000208@parallels.com>
 <20120930082358.GG10383@mtj.dyndns.org>
 <50695817.2030201@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=i8IzF9iZTYCap5Qm8AU+Glv/85Sul2rfIRWsRYaUUeY=;
        b=VahsVm3LWnV0Ap0ZN3WaoYeiwLS5MMQC+CPLows3tNg+uAyJG5Ny3C0NyeWYgj2DZP
         TtnLgmgq+cTKpE+ZDIzNWxc5ge0XLLsYU4n1ESxVNFb4pNkEA6ZD3RehRpnK2X6y4PNv
         de8A074qUUJe17QhUArCz9TFvTidDmnVRUiSNBkKsetl0i6vxXdSdAfa6V3RjdO/MNxd
         I02++ZA8jqc6jCjxcTCbG3Pl9Lbh5d1WwsavgAWwTtyuW92lkxDiHGVGoej2osD7l2DK
         r3ZuQYrFMqqG5ESzQOHQtsIT5NQ+6EnFTEpECrzifyoF2I11lmElUYj9mggguYKCPgGY
         27xA==
Content-Disposition: inline
In-Reply-To: <50695817.2030201@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello, Glauber.

On Mon, Oct 01, 2012 at 12:45:11PM +0400, Glauber Costa wrote:
> > where kmemcg_slab_idx is updated from sched notifier (or maybe add and
> > use current->kmemcg_slab_idx?).  You would still need __GFP_* and
> > in_interrupt() tests but current->mm and PF_KTHREAD tests can be
> > rolled into index selection.
> 
> How big would this array be? there can be a lot more kmem_caches than
> there are memcgs. That is why it is done from memcg side.

The total number of memcgs are pretty limited due to the ID thing,
right?  And kmemcg is only applied to subset of caches.  I don't think
the array size would be a problem in terms of memory overhead, would
it?  If so, RCU synchronize and dynamically grow them?

Thanks.

-- 
tejun
