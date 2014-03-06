From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 16:11:36 -0500
Message-ID: <20140306211136.GA17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <20140306204923.GF14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
 <20140306205911.GG14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061301020.25499@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ldnPmQUtgUngwk40NGg1rcpecNRSYfjN3qSbV2MRLfg=;
        b=os5yic2//Idgsi6bRCh02abQaNj4fVojjHPvtSK8gSv+0Ud7Ireih2HLmLxDkcFmyU
         HET2R3t46XOz+oBqCimarg/jCmViwk0faQJW3ITMDoLs8UD9ADZJwuXyYYI3hhI//XQF
         e8Bse3kz6dLqzsKAgFIbxSXxklkjQNU67y8esJn6hT/6hkf1iyRLtR1z0Mp27urY+qJc
         whBaFVVLXEpwjQOztJWNN9FMhaFeQXPnb2pTIWoDLXyrto97wVZAfsfNnSF6ylPDiGdx
         N7iU+f88o+D8vDvct5ySUV5Nn8pTNCQeaIGKqjh6fpwh21fBvnl1Hdfl/vUJ40PqoVs2
         IDdw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403061301020.25499@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Hello, David.

On Thu, Mar 06, 2014 at 01:08:10PM -0800, David Rientjes wrote:
> I'm not sure how you reach that conclusion: it's necessary because any 
> process handling the oom condition will need memory to do anything useful.  
> How else would a process that is handling a system oom condition, for 
> example, be able to obtain a list of processes, check memory usage, issue 
> a kill, do any logging, collect heap or smaps samples, or signal processes 
> to throttle incoming requests without having access to memory itself?  The 
> system is oom.

We're now just re-starting the whole discussion with all context lost.
How is this a good idea?  We talked about all this previously.  If you
have something to add, add there *please* so that other people can
track it too.

> This is going to be discussed at the LSF/mm conference, I believe it would 
> be helpful to have an actual complete patchset proposed so that it can be 
> discussed properly.  I feel no need to refer to an older patchset that 
> would not apply and did not include all the support necessary for handling 
> oom conditions.

That's completely fine but if that's your intention please at least
prefix the patchset with RFC and explicitly state that no consensus
has been reached (well, it was more like negative consensus from what
I remember) in the description so that it can't be picked up
accidentally.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
