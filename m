From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Thu, 24 Jan 2019 11:00:10 -0500
Message-ID: <20190124160009.GA12436@cmpxchg.org>
References: <20190123223144.GA10798@chrisdown.name>
 <20190124082252.GD4087@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hCxh8cKbdjdveceYE2dpaNIbo3dOi85oEdfOpSI1M70=;
        b=aOZLgnWFCiEp/DgAqJ0ZNWqNTjzcc5vJt9MAo9H/VK+bDPLL728DCs/dQTYumayW9b
         hwEBKayaUcXB/Sm2wVblmZUXpmcYCgw5srU72fEnOiwv6GvjLFt7QQLCA15lf/iLKQTe
         I2LZ9iXuNZVAc9x6w0w1nXX6r3sUSWtCQcX4vldjXpJSKymA1bOwkAdtqaA3BVwhK1pi
         6XP/Xvmi4a2Fkd60WeR1k85nxSzSrbRmyv8/HOAf2fs9EJyFHmoNqroNwCqPIdMxMz4e
         dNaWR2UqiCiGbVN1MaIK7kUOEqQUqWZbXjT6WX1XVcLMZ5aPHFeN5L19jQqp84gLGZ8p
         iglw==
Content-Disposition: inline
In-Reply-To: <20190124082252.GD4087@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu, Jan 24, 2019 at 09:22:52AM +0100, Michal Hocko wrote:
> On Wed 23-01-19 17:31:44, Chris Down wrote:
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> btw. I do not see this patch posted anywhere yet it already comes with
> an ack. Have I just missed a previous version?

I reviewed it offline before Chris sent it out.

I agree with the sentiment that the non-hierarchical behavior was an
oversight, not a design decision.

The arguments against the change don't convince me: the added
difficulty of finding out local values is true for all other cgroup
files as well. This is traded off with being able to detect any
subtree state from the first level cgroups and drill down on-demand,
without having to scan the entire tree on each monitoring interval.
That's a trade-off we've made everywhere else, so this is simply an
inconsistency, not a legitimate exception to the rule.

We cannot fully eliminate a risk for regression, but it strikes me as
highly unlikely, given the extremely young age of cgroup2-based system
management and surrounding tooling.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
