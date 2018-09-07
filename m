From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH 09/12] blkcg: remove additional reference to the css
Date: Fri, 7 Sep 2018 16:24:30 -0400
Message-ID: <20180907202429.GA97913@dennisz-mbp.dhcp.thefacebook.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
 <20180906211045.29055-10-dennisszhou@gmail.com>
 <20180907175446.GC1100574@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9Be7dN/R3NmgXTLGeqjDknniy0VbvWrwupfeyuN8MtY=;
        b=Fi5BZCbD/RuA31kGNB5SuFrZOqg1t4x5mPxOMSGiCliq2q5gQSK71QKHHPCtSTuYGO
         VfNXsPt6cK2rZr4yx5miWrREB+I8ddjTCOYKoZoWHLMr5KxocUsQUSELbUP30mciOKJC
         t4W1ASAmwKr5+J+5kH/IqfWjyzXjA3dcG4YF5tx716jnhcrm2xDonaSiiT2ZKERX9wo0
         DXAqmGui/VuKX6AO9Wei4913hBQtD2Vgy2KKzVEN1YYxVlOVKyDLxjY1dpiasgzqBP2H
         gA84orufmobC7NqJd/Qxs4EE+WO6bBVpGErstfR3aTb8642HVDTUrpHCiWdMubiRbbNO
         4rdg==
Content-Disposition: inline
In-Reply-To: <20180907175446.GC1100574@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 07, 2018 at 10:54:46AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 06, 2018 at 05:10:42PM -0400, Dennis Zhou wrote:
> > +struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
> > +					 struct cgroup_subsys *ss)
> > +{
> > +	struct cgroup_subsys_state *css;
> > +
> > +	rcu_read_lock();
> > +
> > +	do {
> > +		css = cgroup_css(cgrp, ss);
> > +
> > +		if (css)
> > +			goto out_unlock;
> > +		cgrp = cgroup_parent(cgrp);
> > +	} while (cgrp);
> > +
> > +	css = init_css_set.subsys[ss->id];
> > +out_unlock:
> > +	rcu_read_unlock();
> 
> Nothing protects @css here tho.  It can be released before the caller
> is done with it.  The caller must ensure that it's holding rcu read
> lock to protect the lookup and the subsequent uses.  cgroup_css()
> already checks for rcu locking, so if you just drop
> rcu_read_lock/unlock(), everything should work fine.
> 

Ah yes, that's my bad. I've removed it and the unnecessary goto now.

Thanks,
Dennis
