From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 00/12] mm: memcontrol: naturalize charge lifetime v3
Date: Tue, 17 Jun 2014 18:36:15 +0200
Message-ID: <20140617163615.GD9572@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qKYI6iFXJm9sNKLRNoabbXsWiaFHaVJOAoRkFAH10FE=;
        b=ThKnzQsOJuUiyTrS7fGbtZaZN9BO/sRBQ9lPczi6avDQZ3pYnaoocCHSK+PlS0FODm
         gCh1MXInPUP6OlkGXJlxtb/L/prwNWeTTBoQ0cucss/pRK1vuZKPFEPVj98vMuTK2e0j
         +wpJ5Nas+0feJuoOb+aytbmTQS4zHdU8cOs4bSQNWT5m1Eb5fX8x7FUeIeeDBzlSdgMa
         BSMULN5vXMlRL/DPKqFhembVTdWjyPZlfFUGkBhje52jPEhfhUVA6afs2vsj0vAg6YFJ
         BI/XngTaqn3nqykelC8XZiHyRcU1QxUQrunP0xioGTBGk5wvXYN46HHY8sm2rk/hyDSr
         URCw==
Content-Disposition: inline
In-Reply-To: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon 16-06-14 15:54:20, Johannes Weiner wrote:
> Hi,
> 
> this is v3 of the memcg charge naturalization series.  Changes since
> v2 include:
> 
> o make THP charges use __GFP_NORETRY to prevent excessive reclaim (Michal)
> o simplify move precharging while in the area
> o add acks & rebase to v3.16-rc1

I still didn't get to the last two patches and they need a more
throughout review. The rest is good and nice on its own and maybe it
would be easier if those go in first.

I would like to get to the last two ASAP but this is heavier and I am
quite swamped by other small tasks last weeks so I do not want to delay
the whole series.

What do you think?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
