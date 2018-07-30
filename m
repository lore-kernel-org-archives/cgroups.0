From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Mon, 30 Jul 2018 11:05:20 -0700
Message-ID: <20180730180520.GL1206094@devbig004.ftw2.facebook.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180727220123.GB18879@amd>
 <20180730154035.GC4567@cmpxchg.org>
 <20180730173940.GB881@amd>
 <20180730175120.GJ1206094@devbig004.ftw2.facebook.com>
 <dfc3c810-8918-add4-b818-8b9c294f5ea4@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GgK//fN5K8KVly14+EBhnGFTl0s8rnz4fQJVuWZKBdY=;
        b=U8kDbCbtPtd8uooUMCXy8CmMVmC+9f72lmj1zGK2b30yb5DBN6N8NBtCfNLzmFfCp+
         ioksGX5gCWcaeoCk3ezzkgWBmaPiae64PVP2vHRPs58PIbLiULWeWc74ENtIkfVg22KQ
         0vxiDYOlOzVczwiT9aezYvs9Amhiy+1WyZZvEUUU2NQn9cg/k7vlDFeTFFyezvUjfOhs
         43ahGT/kR7oS9p6ZeYRunGzC80vyvTNpMy1NZgccWPmxmiOlTw1IdmFa0wnRGrd0ocNq
         SqmKwr55kiczEJDAUlAnEZ38UzlbseL1nzCyhIOFF7Nzg1h2hryVK5lyH3RPRUeEDTMe
         gtdA==
Content-Disposition: inline
In-Reply-To: <dfc3c810-8918-add4-b818-8b9c294f5ea4@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Mon, Jul 30, 2018 at 10:54:05AM -0700, Randy Dunlap wrote:
> I'd say he's trying to make something that is readable and easier to
> understand for users.

Sure, it's perfectly fine to make those suggestions and discuss but
the counter points have already been discussed (e.g. PSI is a known
acronym associated with pressure and internal symbols all use them for
brevity and uniqueness).  There's no clear technically winning choice
here and it's a decision of a relatively low importance given that
it's confined to kernel config.  I can't see any merit in turning it
into a last-word match.

Thanks.

-- 
tejun
