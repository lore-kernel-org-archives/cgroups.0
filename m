From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 13:08:10 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403061301020.25499@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com> <20140306204923.GF14033@htj.dyndns.org> <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com> <20140306205911.GG14033@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=/ROpf2U7bFUYlnfDsjzlRvEdg9/knoOP75xwMhw/Ckc=;
        b=Qy2bkKEWfbUpMAHelPpPpzmlAgo4Ms2fmT5uxI6DIawwKiBfe3zhHcJ/+zW87+LKFn
         vdFI65dU1LxWKnVWS5xUwD1nBXUW5Nqv4NfipR7Nec1/iNXwiqQZGDjoKvmuEb7I87g6
         0nIXXNLssE3wBufeGqcAJkD/J57T8raE3SCOi7bkGQ5YAdfv42wRRZNlDEyMI5rtDOUb
         K8HHuI1kfRhC3v1Pq8ikH3lPn69BGAmd/SYsVM/e7R7F+xHjWPkfsd4XeNDDXv5UZXir
         LOuV6qsLjuiC0mOZlIvujtDuCqaw7tfH8aJLgYeqrNUSxOwkDWULbdFkBVLuMGd2odrm
         Qzgw==
In-Reply-To: <20140306205911.GG14033@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Thu, 6 Mar 2014, Tejun Heo wrote:

> > This includes system oom handling alongside memcg oom handling.  If you 
> > have specific objections, please let us know, thanks!
> 
> Umm, that wasn't the bulk of objection, was it?  We were discussion
> the whole premise of userland oom handling and the conclusion, at
> best, was that you couldn't show that it was actually necessary and
> most other people disliked the idea.

I'm not sure how you reach that conclusion: it's necessary because any 
process handling the oom condition will need memory to do anything useful.  
How else would a process that is handling a system oom condition, for 
example, be able to obtain a list of processes, check memory usage, issue 
a kill, do any logging, collect heap or smaps samples, or signal processes 
to throttle incoming requests without having access to memory itself?  The 
system is oom.

> Just changing a part of it and
> resubmitting doesn't really change the whole situation.  If you want
> to continue the discussion on the basic approach, please do continue
> that on the original thread so that we don't lose the context.  I'm
> gonna nack the respective patches so that they don't get picked up by
> accident for now.
> 

This is going to be discussed at the LSF/mm conference, I believe it would 
be helpful to have an actual complete patchset proposed so that it can be 
discussed properly.  I feel no need to refer to an older patchset that 
would not apply and did not include all the support necessary for handling 
oom conditions.
