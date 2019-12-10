From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v2] mm: cleanup some useless code
Date: Tue, 10 Dec 2019 21:04:03 +0000
Message-ID: <20191210210403.GA455280@chrisdown.name>
References: <20191210160450.3395-1-pilgrimtao@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t5wRb0HVinMm6EfDaWAnO/a1Sj3+z3DX/7PLYloGfXc=;
        b=OjVkow0SpbjcoF1OWjpltk1vI3YxAw2jQt8Cq6d1x/Btjj1F3u4QeDCqIVyZYELWWn
         lXo4Q8crVZNDfrrurZiFUJUCwelB3pjClmCwC1fxlalGIcZiAwo5pMgLil3e2tONS9X5
         v7g3C9cMkECg6NxNdXCychqgWcQNo1wWAF9mk=
Content-Disposition: inline
In-Reply-To: <20191210160450.3395-1-pilgrimtao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: chengkaitao <pilgrimtao@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, smuchun@gmail.com, Michal Hocko <mhocko@suse.com>

chengkaitao writes:
>Subject: Re: [PATCH v2] mm: cleanup some useless code

Can you please write a more descriptive commit title? Seeing this in the commit 
history tells the reader nothing, "code" could mean anything from a state 
machine to a boolean, and "cleanup" could mean anything from some complex 
refactoring to something trivial like this, and right now I have to look and 
see the individual commit. This patch is really just deduplication of effort.

Perhaps:

     mm, memcg: Don't check PageTransHuge before calling hpage_nr_pages

>It is much simpler to just use hpage_nr_pages for nr_pages and replace
>the local variable by PageTransHuge check directly

Heh, calling it "much" simpler seems a bit excessive. I mean, the code is just 
as readable in both cases, but if it's going to go in, then that's fine. Any 
merge conflict should be trivial enough to fix.

>Signed-off-by: Kaitao Cheng <pilgrimtao@gmail.com>
>Acked-by: Michal Hocko <mhocko@suse.com>

I'm indifferent to this patch, but after the title change:

Acked-by: Chris Down <chris@chrisdown.name>
