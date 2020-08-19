From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [RFC PATCH v2 1/5] mm: Identify compound pages sooner in
 isolate_migratepages_block
Date: Wed, 19 Aug 2020 15:48:41 +0800
Message-ID: <660b71b7-7e4f-758d-70c8-d938dded5837@linux.alibaba.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042705.23414.84098.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200819042705.23414.84098.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: yang.shi@linux.alibaba.com, lkp@intel.com, rong.a.chen@intel.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, hughd@google.com, linux-kernel@vger.kernel.org, daniel.m.jordan@oracle.com, linux-mm@kvack.org, shakeelb@google.com, willy@infradead.org, hannes@cmpxchg.org, tj@kernel.org, cgroups@vger.kernel.org, akpm@linux-foundation.org, richard.weiyang@gmail.com, mgorman@techsingularity.net, iamjoonsoo.kim@lge.com



在 2020/8/19 下午12:27, Alexander Duyck 写道:
> In addition by testing for PageCompound sooner we can avoid having the LRU
> flag cleared and then reset in the exception case. As a result this should
> prevent possible races where another thread might be attempting to pull the
> LRU pages from the list.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
