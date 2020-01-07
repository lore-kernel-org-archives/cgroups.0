From: David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH] mm: thp: grab the lock before manipulation defer
 list
Date: Mon, 6 Jan 2020 18:07:29 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001061803200.55132@chino.kir.corp.google.com>
References: <20200103143407.1089-1-richardw.yang@linux.intel.com> <CAKgT0Uf+EP8yGf93=R3XK0Y=0To0KQDys0O1BkG-Odej3Rwj5A@mail.gmail.com> <20200107012624.GB15341@richard>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=FcqVbuH4BEZl+ciRs0e0B8iPKj0+hshWElohx4nDlP8=;
        b=sTFeI61tYPfuAIi6zuNSHzccw82y+IFJQZN/FOERtaSSqtpiXv2rOpO1dyPm4suK9d
         ftLYzVvf4icX0o3N0u/z5HFcxiat1L2XRuge1iX7lbBY2Md2XAs+Vxt04yEGQu7uv2l8
         B9lrwHI36DRK0JUm1QxdEBLBDZl4WkM/Ai4x6+Hqh019u9drIfYC7rQPYih72eXUlL7V
         KOFBxa2toSREPK7LfZYoSs+/8fgvnWy7jTYEu1twlyKcjKroHFNdQjabRMii/TID8Eev
         FBntvssn6jwCDIMA8zHiVazWzc611aei+IvMD9PvhSF9GrFnfsLNykTivOxhqLapB3+P
         +P0g==
In-Reply-To: <20200107012624.GB15341@richard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>

On Tue, 7 Jan 2020, Wei Yang wrote:

> >One thing you might want to do is pull the "if (compound)" check out
> >and place it outside of the spinlock check. It would then simplify
> >this signficantly so it is something like
> >if (compound) {
> >  spin_lock();
> >  list = page_deferred_list(page);
> >  if (!list_empty(list)) {
> >    list_del_init(list);
> >    from->..split_queue_len--;
> >  }
> >  spin_unlock();
> >}
> >
> >Same for the block below. I would pull the check for compound outside
> >of the spinlock call since it is a value that shouldn't change and
> >would eliminate an unnecessary lock in the non-compound case.
> 
> This is reasonable, if no objection from others, I would change this in v2.

Looks fine to me; I don't see it as a necessary improvement but there's 
also no reason to object to it.  It's definitely a patch that is needed, 
however, for the simple reason that with the existing code we can 
manipulate the deferred split queue incorrectly so either way works for 
me.  Feel free to keep my acked-by.
