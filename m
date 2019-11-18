From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 2/7] mm/lruvec: add irqsave flags into lruvec struct
Date: Mon, 18 Nov 2019 10:52:40 +0800
Message-ID: <de24def3-3593-a2f7-ab73-5ac379c1e5ca@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-3-git-send-email-alex.shi@linux.alibaba.com>
 <CALvZod5xuetOb8Vunhgjp69-HcrnHgGHZKKyjVBo3tmoc3WqaA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALvZod5xuetOb8Vunhgjp69-HcrnHgGHZKKyjVBo3tmoc3WqaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Wei Yang <richard.weiyang@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Arun KS <arunks@codeaurora.org>, Rong Chen <rong.a.chen@intel.com>



在 2019/11/16 下午2:31, Shakeel Butt 写道:
> On Fri, Nov 15, 2019 at 7:15 PM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>> We need a irqflags vaiable to save state when do irqsave action, declare
>> it here would make code more clear/clean.
>>
>> Rong Chen <rong.a.chen@intel.com> reported the 'irqflags' variable need
>> move to the tail of lruvec struct otherwise it causes 18% regressions of
>> vm-scalability testing on his machine. So add the flags and lru_lock to
>> both near struct tail, even I have no clue of this perf losing.
> Regressions compared to what? Also no need to have a separate patch.
> 

Thanks for question, Shakeel, 
I will change the commit log and mention the original place: the head of lruvec struct.
As to the folding, the 3rd is already toooo long. May I leave it here to relief a littel bit burden on reading?

Thanks
Alex
