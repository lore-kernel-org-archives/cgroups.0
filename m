From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
Date: Sun, 30 Sep 2012 17:25:42 +0900
Message-ID: <20120930082542.GH10383@mtj.dyndns.org>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-7-git-send-email-glommer@parallels.com>
 <20120926155108.GE15801@dhcp22.suse.cz>
 <5064392D.5040707@parallels.com>
 <20120927134432.GE29104@dhcp22.suse.cz>
 <50658B3B.9020303@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WXHnzzMJ0YFR4eSGlwxMgAU5hJ5SkpdcLVeDvK7fqK0=;
        b=URm6M37LJLP2gI9J0zDDD+Y0JvFRNEQnjsUTO+o7EElVkP/tUT+6HD755jG84ASAPC
         39xVpUQ0Fj11wOprP216hVJGG6gt7vpHY+dBjylLt3tkeUYP1kbbkp0VdAetHPpEHh5+
         T+Djz03AQzftMR+11ZzdzdkvEbDJhzp7S5Zj3psJBn778qxcZAjsTW3s4tJpddyuQ2Yq
         /FTs9hRbPrjLxBSPzCl0I/6DV9E4T1X4POnJHLgX0MojnMkvSXA2dFNTT4oVCDJQmPyn
         KRlFW9kY5SEpXwEZNzKT4S85SUdSr/PYgrvFvoNYQRZFq2XVdNjz8IPkEfHdK1Jnthg6
         MfaA==
Content-Disposition: inline
In-Reply-To: <50658B3B.9020303@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Johannes Weiner <hannes@cmpxchg.org>

On Fri, Sep 28, 2012 at 03:34:19PM +0400, Glauber Costa wrote:
> On 09/27/2012 05:44 PM, Michal Hocko wrote:
> > Anyway, I have just noticed that __mem_cgroup_try_charge does
> > VM_BUG_ON(css_is_removed(&memcg->css)) on a given memcg so you should
> > keep css ref count up as well.
> 
> IIRC, css_get will prevent the cgroup directory from being removed.
> Because some allocations are expected to outlive the cgroup, we
> specifically don't want that.

That synchronous ref draining is going away.  Maybe we can do that
before kmemcg?  Michal, do you have some timeframe on mind?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
