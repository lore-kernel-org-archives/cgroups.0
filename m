From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 13:23:57 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403061312020.25499@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com> <20140306204923.GF14033@htj.dyndns.org> <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com> <20140306205911.GG14033@htj.dyndns.org> <alpine.DEB.2.02.1403061301020.25499@chino.kir.corp.google.com>
 <20140306211136.GA17902@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=86rZsenIkdUOV/lJbdIQyY9lSK2YXixYronQwFC+1qM=;
        b=ZT3dxe65NGHGBSi32suWNbdDGEXANoIKBKEAPglAt7CcWn44+P5kAggpBg+YqDYz28
         GfSrUI0t8lAGZpe/njj3vQaKVvlx+LL22O6GyKsWz7u/tABe6xDwkpHG2pa3/euzise+
         M2Uz5VjQCCTBX0RdCf/eYcOEFdVpgIRteL97IJAyiOxM8OBCO57StPy+JwPnLivrMsi8
         78ZiVlEQoSCRpO3gScP7lFs3O7jkHPwQin2MdxGkU2haFK9n3h8NepCrhXDtgUibHkAG
         ODh5u/YktwXJNjzQm2CY+oYe2rOrmjEJTw8lK9YtnG1aaAUby/x/q7TQH12m76rqbJiT
         0A3w==
In-Reply-To: <20140306211136.GA17902@htj.dyndns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Thu, 6 Mar 2014, Tejun Heo wrote:

> > I'm not sure how you reach that conclusion: it's necessary because any 
> > process handling the oom condition will need memory to do anything useful.  
> > How else would a process that is handling a system oom condition, for 
> > example, be able to obtain a list of processes, check memory usage, issue 
> > a kill, do any logging, collect heap or smaps samples, or signal processes 
> > to throttle incoming requests without having access to memory itself?  The 
> > system is oom.
> 
> We're now just re-starting the whole discussion with all context lost.
> How is this a good idea?  We talked about all this previously.  If you
> have something to add, add there *please* so that other people can
> track it too.
> 

I'm referring to system oom handling as an example above, in case you 
missed my earlier email a few minutes ago: the previous patchset did not 
include support for system oom handling.  Nothing that I wrote above was 
possible with the first patchset.  This is the complete support.

> That's completely fine but if that's your intention please at least
> prefix the patchset with RFC and explicitly state that no consensus
> has been reached (well, it was more like negative consensus from what
> I remember) in the description so that it can't be picked up
> accidentally.
> 

This patchset provides a solution to a real-world problem that is not 
solved with any other patchset.  I expect it to be reviewed as any other 
patchset, it's not an "RFC" from my perspective: it's a proposal for 
inclusion.  Don't worry, Andrew is not going to apply anything 
accidentally.
