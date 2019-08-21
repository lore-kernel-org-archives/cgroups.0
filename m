From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Wed, 21 Aug 2019 10:00:33 +0800
Message-ID: <e9ac9c8c-15c1-8365-5c39-285c6d7b07a6@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <20190820104532.GP3111@dhcp22.suse.cz>
 <CALvZod7-dL90jwd2pywpaD8NfUByVU9Y809+RfvJABGdRASYUg@mail.gmail.com>
 <alpine.LSU.2.11.1908201038260.1286@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.11.1908201038260.1286@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeelb@google.com>, Yu Zhao <yuzhao@google.com>, Daniel Jordan <daniel.m.jordan@oracle.com>



在 2019/8/21 上午2:24, Hugh Dickins 写道:
> I'll set aside what I'm doing, and switch to rebasing ours to v5.3-rc
> and/or mmotm.  Then compare with what Alex has, to see if there's any
> good reason to prefer one to the other: if no good reason to prefer ours,
> I doubt we shall bother to repost, but just use it as basis for helping
> to review or improve Alex's.

For your review, my patchset are pretty straight and simple. It just use per lruvec lru_lock to replace necessary pgdat lru_lock. just this. 
We could talk more after I back to work. :)

Thanks alot!
Alex
