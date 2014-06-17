From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 04/12] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Date: Tue, 17 Jun 2014 18:30:48 +0200
Message-ID: <20140617163048.GC9572@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-5-git-send-email-hannes@cmpxchg.org>
 <20140617135344.GC19886@dhcp22.suse.cz>
 <20140617154527.GC7331@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=esN2AfsBLZCBDpri4Dqgi+KETHgXSGSx7fth5SXYzG0=;
        b=hPeF/xxBiC7kDcQ8Ix+An5QWVfbxIIs8oRtKYLtMLJdW6FNxCYXFLkGAmAl7hsOmCZ
         GSNOdBbr+sPVJHg66OoUIfVjE8xq2FVtBhlG758fqesLQf4iHmBdYiMqY70HVa1/2dxL
         3sgU7M8ti+dsoxNuiUjjZuA2OLCueRqftbPBH3QWuvNTcfxvPZ46vt81yj8cDhRgOCBq
         WS3bRlW+zDhPTHfJw35Lrpvl/PXe4RlPsEmUz4Wo8UKCV7PMs21RJ/pMkZZeVjqVGV3K
         K6G/bfgDtATsttQd2bWHoXa1nJpGW2RI/Cp2vp+rEidt+xnN1lgYA2lO05WWGczID1UN
         TdkQ==
Content-Disposition: inline
In-Reply-To: <20140617154527.GC7331@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 17-06-14 11:45:27, Johannes Weiner wrote:
> On Tue, Jun 17, 2014 at 03:53:44PM +0200, Michal Hocko wrote:
> > On Mon 16-06-14 15:54:24, Johannes Weiner wrote:
> > > There is no reason why oom-disabled and __GFP_NOFAIL charges should
> > > try to reclaim only once when every other charge tries several times
> > > before giving up.  Make them all retry the same number of times.
> > 
> > OK, this makes sense for oom-disabled and __GFP_NOFAIL but does it make
> > sense to do additional reclaim for tasks with fatal_signal_pending?
> > 
> > It is little bit unexpected, because we bypass if the condition happens
> > before the reclaim but then we ignore it.
> 
> "mm: memcontrol: rearrange charging fast path", moves the pending
> signal check inside the retry block, right before reclaim.

Right you are.

Acked-by: Michal Hocko <mhocko@suse.cz>

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
