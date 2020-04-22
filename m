From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 15/18] mm: memcontrol: make swap tracking an integral part
 of memory control
Date: Wed, 22 Apr 2020 21:43:13 +0800
Message-ID: <9fc87212-fb75-7512-41a3-79ee13fb7909@linux.alibaba.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-16-hannes@cmpxchg.org>
 <e9d58c82-d746-dcd0-d9e3-6322014a3b03@linux.alibaba.com>
 <20200421143923.GC341682@cmpxchg.org>
 <2721c508-9b32-d0e7-454d-386129bfda1b@linux.alibaba.com>
 <20200422133001.GE358439@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200422133001.GE358439@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com



在 2020/4/22 下午9:30, Johannes Weiner 写道:
>> Also as to the RSS account name change, I don't know if it's good to polish
>> them in docs.
> I didn't actually change anything user-visible, just the internal name
> of the counters:
> 
> static const unsigned int memcg1_stats[] = {
> 	NR_FILE_PAGES,		/* was MEMCG_CACHE */
> 	NR_ANON_MAPPED,		/* was MEMCG_RSS */
> 	NR_ANON_THPS,		/* was MEMCG_RSS_HUGE */
> 	NR_SHMEM,
> 	NR_FILE_MAPPED,
> 	NR_FILE_DIRTY,
> 	NR_WRITEBACK,
> 	MEMCG_SWAP,
> };
> 
> static const char *const memcg1_stat_names[] = {
> 	"cache",
> 	"rss",
> 	"rss_huge",
> 	"shmem",
> 	"mapped_file",
> 	"dirty",
> 	"writeback",
> 	"swap",
> };
> 
> Or did you refer to something else?

With about 'was MEMCG_RSS' etc. I believe curious user would know where
the concept from. :)

Thanks for this comments!
Aelx
