From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: memcg swap doesn't work in mmotm-2014-07-09-17-08?
Date: Wed, 16 Jul 2014 14:10:07 -0400
Message-ID: <20140716181007.GA8524@nhori.redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Naoya Horiguchi <nao.horiguchi@gmail.com>

Hi,

It seems that when a process in some memcg tries to allocate more than
memcg.limit_in_bytes, oom happens instead of swaping out in
mmotm-2014-07-09-17-08 (memcg.memsw.limit_in_bytes is large enough).
It does work in v3.16-rc3, so I think latest patches changed something.
I'm not familiar with memcg internally, so no idea about what caused it.
Could you see the problem?

Thanks,
Naoya Horiguchi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
