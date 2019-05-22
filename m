From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/7] mm: reparent slab memory on cgroup removal
Date: Wed, 22 May 2019 14:59:06 -0700
Message-ID: <20190522145906.60c9e70ac0ed7ee3918a124c@linux-foundation.org>
References: <20190521200735.2603003-1-guro@fb.com>
        <20190522214347.GA10082@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558562348;
        bh=R6YcL8U8yochP+E8Zmsq6kuoz61IzyX5bMmtEWQzZLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zr8gMdggwmhhfTmcy+QmNgZLg2PfZ0TLrnp3IRFmnindd1nPaBjrlLwXUHhcFcytS
         S3fMlA75Nma6WNodFnANzU6+BozwhoGgdbcFd35fq7GZgrJZGvmrImtVwo3Ov4aZDg
         yyUMoyBBA3v49PwKKRYZio8kePJ/lBN6j6NRI9zQ=
In-Reply-To: <20190522214347.GA10082@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Wed, 22 May 2019 21:43:54 +0000 Roman Gushchin <guro@fb.com> wrote:

> Is this patchset good to go? Or do you have any remaining concerns?
> 
> It has been carefully reviewed by Shakeel; and also Christoph and Waiman
> gave some attention to it.
> 
> Since commit 172b06c32b94 ("mm: slowly shrink slabs with a relatively")
> has been reverted, the memcg "leak" problem is open again, and I've heard
> from several independent people and companies that it's a real problem
> for them. So it will be nice to close it asap.
> 
> I suspect that the fix is too heavy for stable, unfortunately.
> 
> Please, let me know if you have any issues that preventing you
> from pulling it into the tree.

I looked, and put it on ice for a while, hoping to hear from
mhocko/hannes.  Did they look at the earlier versions?
