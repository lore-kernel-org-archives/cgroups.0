From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 14 Feb 2020 12:17:04 -0500
Message-ID: <20200214171704.GN88887@mtj.thefacebook.com>
References: <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
 <20200213154731.GE31689@dhcp22.suse.cz>
 <20200213155249.GI88887@mtj.thefacebook.com>
 <20200213163636.GH31689@dhcp22.suse.cz>
 <20200213165711.GJ88887@mtj.thefacebook.com>
 <20200214071537.GL31689@dhcp22.suse.cz>
 <20200214135728.GK88887@mtj.thefacebook.com>
 <20200214151318.GC31689@dhcp22.suse.cz>
 <20200214165311.GA253674@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IdlVcb5dgVZlXRPD8rS0Jjj+aVnIOc6gaR6g0J3FbHQ=;
        b=ODwbG+2jhyTDeEphpYnP1t0/Mb0Zzo8HZnFx1Ag/PWLSFJxk35pcALKXDL2gz9QssI
         XGpd6QU9jxYgpiAQ/1CbldrTlr0dP4TgK287aaDEyjK4Kj1Mx5ZM7hCTN6jccFtQpZMC
         h8fl0XeptvgVV+h2z5hk0vPFGUNOaKT0NE6OawTpmp+slE3nNA04K+NQZTvjz6YlxEjj
         gKSGXmQ39+QRRclyI/pipZ00ZT1svVygDCYVy8d24a8FF8aEnAJ/M5UsBpftzWN4HWlj
         mPD8Bkdfj9Edh4Xog2Rl3GtPLK1BB54JpYSIHFSD5tqtvlntmVR7NN+aegN2xFumOcCq
         /JXg==
Content-Disposition: inline
In-Reply-To: <20200214165311.GA253674@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Feb 14, 2020 at 11:53:11AM -0500, Johannes Weiner wrote:
> However, what you've really done just now is flattened the resource
> hierarchy. You configured the_workload not just more important than
> its sibling "misc", but you actually pulled it up the resource tree
> and declared it more important than what's running in other sessions,
> what users are running, and even the system software. Your cgroup tree
> still reflects process ownership, but it doesn't actually reflect the
> resource hierarchy you just configured.

Just to second this point, anything moving in this direction will be a
hard nack from me. We don't want use_hierarchy for cgroup2 and I'm
baffled that this is even being suggested seriously. If we have
learned *anything* from cgroup1's mistakes, this should be the one.

Thanks.

-- 
tejun
