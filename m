From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm, memcg: Optionally disable memcg by default using
 Kconfig
Date: Tue, 19 May 2015 16:53:40 +0200
Message-ID: <20150519145340.GI6203@dhcp22.suse.cz>
References: <20150519104057.GC2462@suse.de>
 <20150519141807.GA9788@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xOzr3M+BTqgMD2XI2tCibbbCMdcBKXWr4EThxFPRL54=;
        b=zBIKmZSIPbF3eMnUy8YwzlJFTRP3dVAK8964qU429ZfCm8IDQrrRDtUNbu180FJ5uP
         cj7LMTRUXKDc+xgmxxh3ysMWrllSoxRolU1+74f4EGRhVCpsSWinbo5jwYQ7+BHY03CV
         EdBhzoSUUiVvSS+REK/FnEbh3rhfHYhtrG2Ge0js3XuyxsA/XHemlGS3GpchxEBAFbdZ
         TsszJMyG+Sn7gswyn4Jf8IUBuggKxJYCnCYpCTNHV90g/QNg8RXRLuTefTQif/PWEP8f
         GqK2XdzzCKqEePtNWv/Nfw1vrUNawhyOJmrgZikODLpAvLMWAT+p93vvLKkIsm9GZuy5
         7FQA==
Content-Disposition: inline
In-Reply-To: <20150519141807.GA9788@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On Tue 19-05-15 10:18:07, Johannes Weiner wrote:
> CC'ing Tejun and cgroups for the generic cgroup interface part
> 
> On Tue, May 19, 2015 at 11:40:57AM +0100, Mel Gorman wrote:
[...]
> > /usr/src/linux-4.0-vanilla/mm/memcontrol.c                           6.6441   395842
> >   mem_cgroup_try_charge                                                        2.950%   175781
> 
> Ouch.  Do you have a way to get the per-instruction breakdown of this?
> This function really isn't doing much.  I'll try to reproduce it here
> too, I haven't seen such high costs with pft in the past.
> 
> >   try_charge                                                                   0.150%     8928
> >   get_mem_cgroup_from_mm                                                       0.121%     7184

Indeed! try_charge + get_mem_cgroup_from_mm which I would expect to be
the biggest consumers here are below 10% of the mem_cgroup_try_charge.
Other than that the function doesn't do much else than some flags
queries and css_put...

Do you have the full trace? Sorry for a stupid question but do inlines
from other header files get accounted to memcontrol.c?

[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
