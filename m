From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Date: Mon, 3 Dec 2012 08:53:38 -0800
Message-ID: <20121203165338.GF19802@htj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <20121203152205.GB17093@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ko3n59VEHSCUHHl5vJB0050vxB0oQfiLCeiWF0a1kgc=;
        b=Gm+H1kBpNoCMvAmeycM8J7GWjSCctwLiXtkBS64JkqNzts7/qotUfLxIM9OU9bCcYS
         wyj2rsHO6B0MT+s0RRZDl7MwkftVRHVDaIBC3w5iYWC9XX8OJQ6vo1cYMbIFmPEZwgPJ
         jVpv+x6CB8rUW91MvRXx7Y28DWHfv8T2z7TRvaCLQe699mWXUTw3hNIRApg6L8zeeQUW
         2wA17RA5WAJj+ttqjjEPCGXA/TnVqTcxHwr4DsTcaYJRxVHoEEyswpfKUpTuAgU/ahuS
         zk0c+kksZC4pUNPCHVUYtENhGuKw0N9uHGDe7EUWDucCBACF2nJvubTmuEGOxNLBw5D6
         HFPQ==
Content-Disposition: inline
In-Reply-To: <20121203152205.GB17093@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, peterz@infradead.org, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hello, Michal.

On Mon, Dec 03, 2012 at 04:22:05PM +0100, Michal Hocko wrote:
> I have glanced through the series and spotten nothing obviously wrong. I
> do not feel I could give my r-b because I am not familiar with cpusets
> internals enough and some patches looks quite scary (like #8).
> Anyway the resulting outcome seems nice.

Thanks a lot for looking at it and, yeah, it's a bit scary.  Li, Paul,
can you guys please review the series?

Thanks!

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
