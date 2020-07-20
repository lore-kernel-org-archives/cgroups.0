From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 18/22] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 20 Jul 2020 13:47:09 +0800
Message-ID: <27eb389d-b5f9-fe03-2e57-15c351629efc@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-19-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0Ud+Dj-Q8Sxv8eDQhjM3fFHwnU_ZFEVG54debBennUmxAg@mail.gmail.com>
 <62dfd262-a7ac-d18e-216a-2988c690b256@linux.alibaba.com>
 <c339f46e-ae04-4e65-2713-a5c8be56051a@linux.alibaba.com>
 <CAKgT0UestD7cU+3aqg3a9JT4bTXVYQpjGbwoC2-bOBHPY5xn6A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0UestD7cU+3aqg3a9JT4bTXVYQpjGbwoC2-bOBHPY5xn6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>



在 2020/7/19 下午11:14, Alexander Duyck 写道:
>> Compare to move to tail, how about to move it to head of struct, which is
>> close to lru list? Did you have some data of the place change?
> I don't have specific data, just anecdotal evidence from the past that
> usually you want to keep locks away from read-mostly items since they
> cause obvious cache thrash. My concern was more with the other fields
> in the structure such as pgdat since it should be a static value and
> having it evicted would likely be more expensive than just leaving the
> cacheline as it is.
> 

Thanks for comments, Alex.

So, sounds like moving the lru_lock to head of struct lruvec could be better.

>> -       __mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
>> +       if (delta_munlocked)
>> +               __mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
>>         if (lruvec)
>>                 unlock_page_lruvec_irq(lruvec);
> Why not just wrap the entire thing in a check for "lruvec"? Yes you
> could theoretically be modding with a value of 0, but it avoids a
> secondary unnecessary check and branching.

Right, and the delta_munlocked value could be checked inside the accounting
func

Thanks!
