From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Fri, 22 Mar 2019 22:00:46 +0000
Message-ID: <20190322220046.GA7667@chrisdown.name>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190322131015.05edf9fac014f4cacf10dd2a@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z3kNb4x6nZaDJzrLCkv/8bMkNzuRCuubIRRX4PjKw9k=;
        b=t33VxRIuRm3bprIjzdNlkZlPsKCoiKyBSPHzogx7bBAS/0Me5ORQuRWJPkoVAb30lf
         WWGBbCUiJE/BUNBvPVoeD/FvsAqwyOPJrFQNHfPKqCwFogqxeBdfod9IT8SeXk83lwBq
         U9Nu+yf0n+hoiMALOIPPIDxC2I56pXMvLTrQs=
Content-Disposition: inline
In-Reply-To: <20190322131015.05edf9fac014f4cacf10dd2a@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Andrew Morton writes:
>Could you please provide more description of the effect this has upon 
>userspace?  Preferably in real-world cases.  What problems were being 
>observed and how does this improve things?

Sure! The previous patch's behaviour isn't so much problematic as it is just 
not as featureful as it could be.

This change doesn't change the experience for the user in the normal case too 
much. One benefit is that it replaces the (somewhat arbitrary) 100% cutoff with 
an indefinite slope, which makes it easier to ballpark a memory.low value.

As well as this, the old methodology doesn't quite apply generically to 
machines with varying amounts of physical memory. Let's say we have a top level 
cgroup, workload.slice, and another top level cgroup, system-management.slice.  
We want to roughly give 12G to system-management.slice, so on a 32GB machine we 
set memory.low to 20GB in workload.slice, and on a 64GB machine we set 
memory.low to 52GB. However, because these are relative amounts to the total 
machine size, while the amount of memory we want to generally be willing to 
yield to system.slice is absolute (12G), we end up putting more pressure on 
system.slice just because we have a larger machine and a larger workload to 
fill it, which seems fairly unintuitive. With this new behaviour, we don't end 
up with this unintended side effect.
