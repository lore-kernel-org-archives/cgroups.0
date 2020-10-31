From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v20 04/20] mm/thp: use head for head page in
 lru_add_page_tail
Date: Sat, 31 Oct 2020 09:14:05 +0800
Message-ID: <8fcf24fc-30ed-1e95-2c50-4034404ab416@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-5-git-send-email-alex.shi@linux.alibaba.com>
 <20201029135047.GE599825@cmpxchg.org>
 <06a5b7d8-bbf2-51b7-1352-2b630186e15f@linux.alibaba.com>
 <20201030135218.GA666074@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20201030135218.GA666074@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com



在 2020/10/30 下午9:52, Johannes Weiner 写道:
> 
>> From a9ee63a213f40eb4d5a69b52fbb348ff9cd7cf6c Mon Sep 17 00:00:00 2001
>> From: Alex Shi <alex.shi@linux.alibaba.com>
>> Date: Tue, 26 May 2020 16:49:22 +0800
>> Subject: [PATCH v21 04/20] mm/thp: use head for head page in lru_add_page_tail
>>
>> Since the first parameter is only used by head page, it's better to make
>> it explicit.
>>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Acked-by: Hugh Dickins <hughd@google.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>


Thanks a lot!
Alex
