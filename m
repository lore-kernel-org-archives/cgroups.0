From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 1/7] mm/lru: add per lruvec lock for memcg
Date: Mon, 18 Nov 2019 20:37:46 +0800
Message-ID: <512d72e0-7b1d-4424-7cc4-7b963b9cbc7f@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-2-git-send-email-alex.shi@linux.alibaba.com>
 <CALvZod77568+TozRXpERDDap__jbj+oJBY8zD=UBd40XNJC2zg@mail.gmail.com>
 <e707fd66-16c2-8523-dd8b-860b5b6bb11d@linux.alibaba.com>
 <20191118120815.GF20752@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191118120815.GF20752@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Arun KS <arunks@codeaurora.org>



在 2019/11/18 下午8:08, Matthew Wilcox 写道:
>>> Merge this patch with actual usage. No need to have a separate patch.
>> Thanks for comment, Shakeel!
>>
>> Yes, but considering the 3rd, huge and un-splitable patch of actully replacing, I'd rather to pull sth out from 
>> it. Ty to make patches a bit more readable, Do you think so?
> This method of splitting the patches doesn't help with the reviewability of
> the patch series.

Hi Matthew,

Thanks for comments!
I will fold them into the 3rd patch as you are all insist on this. :)

Thanks
Alex
