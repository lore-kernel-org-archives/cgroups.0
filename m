From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm, memcg: unify reclaim retry limits with page
 allocator
Date: Wed, 20 May 2020 16:42:43 -0700
Message-ID: <20200520164243.56133fa135f65cc708e70ec0@linux-foundation.org>
References: <20200520163142.GA808793@chrisdown.name>
        <20200520164037.e3598bc902e39415f4c263e7@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590018164;
        bh=l2mS/FNkusn6YLF9oQ03x6lf0x9xSKXhbjmtXuuKOEU=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=qJ+3eof3hck1Gh1nBa2/+j6vwmtmoQW2xYQ0eTC853DIb8H/4+cHCLfaXLzznyRd6
         ZFvs8b1FX05UdabsiW4zNAhkt+Oi8JMbHMFNUnude+cklLBNZvcgSEyR+fU9qXbBDa
         2AkRUBPbAjt3JLK7Wd6YJ3db43kp8TzLxIItbyQo=
In-Reply-To: <20200520164037.e3598bc902e39415f4c263e7@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, 20 May 2020 16:40:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > -/* The number of times we should retry reclaim failures before giving up. */
> 
> hm, what tree is this against?

Ah, my habit of working in reverse time order sometimes does this ;)

I suggest that "mm, memcg: reclaim more aggressively before high
allocator throttling" and this patch become a two-patch series?

