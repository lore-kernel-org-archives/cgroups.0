From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 15:17:23 -0700
Message-ID: <20120626221723.GB15811@google.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
 <20120626180451.GP3869@google.com>
 <20120626220809.GA4653@tiehlicka.suse.cz>
 <20120626221452.GA15811@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qIgrTadV2nOaeOekRY82Rbmbt6uq5AKP5eSSvSm+LIk=;
        b=aycQwuUPELHW9Xcs+rDRf3HowajauWME66uM882H3psQ1mqeafTveVDV5SUTXTnhEh
         in5kj3UoMtsnXOHSMnP6QEnqW5i6HLmW6xGYkgebJhZtK7UMdcEgP1GhiW/xaJ1OWyal
         RAdBCoQh3Bo0fvmmJA1AvKhFf79jNZ3BpIiQ4ujycTD4/lyWQaN+O78/QbW+KOFfDE8F
         MxnqaWgcImG0g+96KhCjDECfnlc1rS2SmMuJXO4W6Lgw7hOgLeVo7L4+X72ROBPok2UV
         nSjf+8pQRozZgBmoSknVgaCR8DsmDwx5y/6TFsC9l3E07Lb8JD2QTHmbgAx/+n3vbBuG
         7u1g==
Content-Disposition: inline
In-Reply-To: <20120626221452.GA15811@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Jun 26, 2012 at 03:14:52PM -0700, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Jun 27, 2012 at 12:08:09AM +0200, Michal Hocko wrote:
> > According to my experience, people usually create deeper subtrees
> > just because they want to have memcg hierarchy together with other
> > controller(s) and the other controller requires a different topology
> > but then they do not care about memory.* attributes in parents.
> > Those cases are not affected by this change because parents are
> > unlimited by default.
> > Deeper subtrees without hierarchy and independent limits are usually
> > mis-configurations, and we would like to hear about those to help to fix
> > them, or they are unfixable usecases which we want to know about as well
> > (because then we have a blocker for the unified cgroup hierarchy, don't
> > we).
> 
> Yeah, this is something I'm seriously considering doing from cgroup
> core.  ie. generating a warning message if the user nests cgroups w/
> controllers which don't support full hierarchy.

BTW, this is another reason I'm suggesting mount time option so that
cgroup core can be told that the specific controller is
hierarchy-aware.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
