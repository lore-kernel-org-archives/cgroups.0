From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Fri, 22 Mar 2019 22:49:46 +0000
Message-ID: <20190322224946.GA12527@chrisdown.name>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190322222907.GA17496@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y9aDRaeIImkqbs3RD6gMjzp9RFeZ93eNkXfZogPMzV4=;
        b=dzOycvFR3LXcdAJzc1cZuTdB5YuJ4celv5OXmLq76bC6fhuIRBXXymUZ2X1e4X3GPz
         g+RHtQxVTPHKrMHRvLhSlNJtytCLr+c/sSTjz6Ejtz9K6fAOuiJqD90x+aTB17NOUbU2
         C2jzjifh8zT6akDauo5+bFHj33WXlPFIZB7+0=
Content-Disposition: inline
In-Reply-To: <20190322222907.GA17496@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

Roman Gushchin writes:
>I've noticed that the old version is just wrong: if cgroup_size is way smaller
>than max(min, low), scan will be set to -lruvec_size.
>Given that it's unsigned long, we'll end up with scanning the whole list
>(due to clamp() below).

Are you certain? If so, I don't see what you mean. This is how the code looks 
in Linus' tree after the fixups:

    unsigned long cgroup_size = mem_cgroup_size(memcg);
    unsigned long baseline = 0;

    if (!sc->memcg_low_reclaim)
            baseline = lruvec_size;
    scan = lruvec_size * cgroup_size / protection - baseline;

This works correctly as far as I can tell:

low reclaim case:

    In [1]: cgroup_size=50; lruvec_size=10; protection=2000; baseline=0; lruvec_size * cgroup_size // protection - baseline
    Out[1]: 0

normal case:

    In [2]: cgroup_size=3000; lruvec_size=10; protection=2000; baseline=lruvec_size; lruvec_size * cgroup_size // protection - baseline
    Out[2]: 5
