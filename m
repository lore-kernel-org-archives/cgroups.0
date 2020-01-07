From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [RFC PATCH] mm: thp: grab the lock before manipulation defer list
Date: Tue, 7 Jan 2020 10:33:57 +0800
Message-ID: <20200107023357.GD15341@richard>
References: <20200103143407.1089-1-richardw.yang@linux.intel.com>
 <CAKgT0Uf+EP8yGf93=R3XK0Y=0To0KQDys0O1BkG-Odej3Rwj5A@mail.gmail.com>
 <20200107012624.GB15341@richard>
 <alpine.DEB.2.21.2001061803200.55132@chino.kir.corp.google.com>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001061803200.55132@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>

On Mon, Jan 06, 2020 at 06:07:29PM -0800, David Rientjes wrote:
>On Tue, 7 Jan 2020, Wei Yang wrote:
>
>> >One thing you might want to do is pull the "if (compound)" check out
>> >and place it outside of the spinlock check. It would then simplify
>> >this signficantly so it is something like
>> >if (compound) {
>> >  spin_lock();
>> >  list = page_deferred_list(page);
>> >  if (!list_empty(list)) {
>> >    list_del_init(list);
>> >    from->..split_queue_len--;
>> >  }
>> >  spin_unlock();
>> >}
>> >
>> >Same for the block below. I would pull the check for compound outside
>> >of the spinlock call since it is a value that shouldn't change and
>> >would eliminate an unnecessary lock in the non-compound case.
>> 
>> This is reasonable, if no objection from others, I would change this in v2.
>
>Looks fine to me; I don't see it as a necessary improvement but there's 
>also no reason to object to it.  It's definitely a patch that is needed, 
>however, for the simple reason that with the existing code we can 
>manipulate the deferred split queue incorrectly so either way works for 
>me.  Feel free to keep my acked-by.

Ah, thanks David. You are so supportive.

-- 
Wei Yang
Help you, Help me
