From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] memcg: punt high overage reclaim to
 return-to-userland path
Date: Fri, 28 Aug 2015 18:06:32 -0400
Message-ID: <20150828220632.GF11089@htj.dyndns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-4-git-send-email-tj@kernel.org>
 <20150828163611.GI9610@esperanza>
 <20150828164819.GL26785@mtj.duckdns.org>
 <20150828203231.GL9610@esperanza>
 <20150828204432.GA11089@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kTMhZsylcSzFOnPkeWNmWY9UjSty48ruLCFfm/eoSb4=;
        b=lTACgLMBvx2uY+CWEd//HTLgP4OMGJHbuR5jakQftGnYCfwyxQxgMI3bsNKcLcWO1S
         m7yFcTLc+HnYy2eGV/FcCgEEIXRjV/UGoQAfysYhqxI7r09MEIIv3DyWysaCdHfiCZ/L
         yIBAq+C4nt4ugDB7tyMvqRPo82e847eLVsNt3+5ycepZeylJDukr8BzUEn4Tu9iGJMGL
         JI5kXcffvHCk/FjvPfiy10X3Mckl9rnCxdpCH/my9fhvBDWHDkEFDv1w0nkM27qcopmo
         8wcEqCcQZVmTnz1HV+ALL5S6ng2Bjs5INNJ+ABmLQBqjFdUsfXRjlJeBweHFTW9cLuXb
         N5ZQ==
Content-Disposition: inline
In-Reply-To: <20150828204432.GA11089@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, mhocko@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>

On Fri, Aug 28, 2015 at 04:44:32PM -0400, Tejun Heo wrote:
> Ah, cool, so it was a bug from slub.  Punting to return path still has
> some niceties but if we can't consistently get rid of stack
> consumption it's not that attractive.  Let's revisit it later together
> with hard limit reclaim.

So, I can't check right now but I'm pretty sure I was using SLAB on my
test config, so this issue may exist there too.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
