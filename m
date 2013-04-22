From: Tejun Heo <tj@kernel.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Mon, 22 Apr 2013 08:46:20 -0700
Message-ID: <20130422154620.GB12543@htj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420031611.GA4695@dhcp22.suse.cz>
 <20130421022321.GE19097@mtj.dyndns.org>
 <CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com>
 <20130422042445.GA25089@mtj.dyndns.org>
 <20130422153730.GG18286@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=29DoT7pP0kmJ1s1yIC7AoK046tze9Sd7yemGzuKlix4=;
        b=hherZdzV6+P5TUGfZtote7tb0yfYElv+Y4kbuASsJ7nZH2STLkkWhljxJwDoo4DRiT
         4++2zVN3ZpemgD/1Zq/Hcccfqsmm12lH8HegE5Q9lNpolAmHw6jTVR5FX6eETiiP65mi
         UOkBgzan0PYGlcd7O77xxHotXrmY0Z5sU0IKz2yEN3GJA8uW9IpW9uvOwOsy3GvzLsDj
         23RuWBOyP9H6072tC8kLBGuTbwNtRn9F31kjHNdlpPPQ1tBTRXlfH+6U/rrTfPcg3sZU
         KDcbZSGIJMdFnelj/TCb1mYT+XoorGGDlVZ3Y0PKwrrVvXFny/+zqD+snINKslVa3p0j
         SmFQ==
Content-Disposition: inline
In-Reply-To: <20130422153730.GG18286@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Michel Lespinasse <walken@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>, Glauber Costa <glommer@parallels.com>, Greg Thelen <gthelen@google.com>

Hey, Michal.

On Mon, Apr 22, 2013 at 05:37:30PM +0200, Michal Hocko wrote:
> > In fact, I'm planning to disallow changing ownership of cgroup files
> > when "sane_behavior" is specified. 
> 
> I would be wildly oposing this. Enabling user to play on its own ground
> while above levels of the groups enforce the reasonable behavior is very
> important use case.

We can continue this discussion on the original thread and I'm not too
firm on this not because it's a sane use case but because it is an
extra measure preventing root from shooting its feet which we
traditionally allow.  That said, really, no good can come from
delegating hierarchy to different security domains.  It's already
discouraged by the userland best practices doc.  Just don't do it.

> Tejun, stop this, finally! Current soft limit same as the reworked
> version follow the basic nesting rule we use for the hard limit which
> says that parent setting is always more strict than its children.
> So if you parent says you are hitting the hardlimit (resp. over soft
> limit) then children are reclaimed regardless their hard/soft limit
> setting.

Okay, thanks for making it clear.  Then, apparently, the fine folks at
google are hopelessly confused because at least Greg and Ying told me
something which is the completely opposite of what you're saying.  You
guys need to sort it out.

> It is you being confused and refuse to open the damn documentation and
> read what the hack is soft limit and what it is used for. Read the patch
> series I was talking about and you will hardly find anything regarding
> _guarantee_.

Oh, if so, I'm happy.  Sorry about being brash on the thread; however,
please talk with google memcg people.  They have very different
interpretation of what "softlimit" is and are using it according to
that interpretation.  If it *is* an actual soft limit, there is no
inherent isolation coming from it and that should be clear to
everyone.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
