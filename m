From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Thu, 4 Oct 2012 07:59:30 +0900
Message-ID: <20121003225930.GF19248@localhost>
References: <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
 <20120927174605.GA2713@localhost>
 <50649EAD.2050306@parallels.com>
 <20120930075700.GE10383@mtj.dyndns.org>
 <20120930080249.GF10383@mtj.dyndns.org>
 <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com>
 <20120930103732.GK10383@mtj.dyndns.org>
 <5069584A.8090809@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=poqO2E6YGX3pNFF1KR8sjrenhGMpyre0yzUNvL/bewA=;
        b=fkcF5t+LAYLdgAiztfWqGu2O0HE18Z2/zXxO8mZuQkk31R00WqkPkVPhviRGMb/Rar
         ldiYBngJpxHv12QPYvTw74u60zN3VN45jN1dDQ5WMttYckF2fx0Wfo2ETPR4SqKlExuu
         ydr3dMpQD/0gpliquwGfQMvJmAKGCY4CVnjWA6pj1yMk5oBa4a3LmRJ+PjtdSVY7/ccV
         xWbOtTWJTD8bEmkW9HtLbSgvtOdBKxO+IpkUfjMTpb/Y1+Iap9i+2+op5Mesw1ZNuEK6
         3xvMBes+0YZBn+S0u07FBOg7aY/ZK+D8cUxTNDupC/xK+mzbPGvM18pxQGpAUOQ0EMfT
         roGA==
Content-Disposition: inline
In-Reply-To: <5069584A.8090809@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello, Glauber.

On Mon, Oct 01, 2012 at 12:46:02PM +0400, Glauber Costa wrote:
> > Yeah, it will need some hooks.  For dentry and inode, I think it would
> > be pretty well isolated tho.  Wasn't it?
> 
> We would still need something for the stack. For open files, and for
> everything that becomes a potential problem. We then end up with 35
> different knobs instead of one. One of the perceived advantages of this
> approach, is that it condenses as much data as a single knob as
> possible, reducing complexity and over flexibility.

Oh, I didn't mean to use object-specific counting for all of them.
Most resources don't have such common misaccounting problem.  I mean,
for stack, it doesn't exist by definition (other than cgroup
migration).  There's no reason to use anything other than first-use
kmem based accounting for them.  My point was that for particularly
problematic ones like dentry/inode, it might be better to treat them
differently.

Thanks.

-- 
tejun
