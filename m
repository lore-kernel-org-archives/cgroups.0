From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v20 02/20] mm/memcg: bail early from swap accounting if
 memcg disabled
Date: Sat, 31 Oct 2020 09:13:26 +0800
Message-ID: <8f288275-da78-335d-e83d-7e073fcd3b88@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-3-git-send-email-alex.shi@linux.alibaba.com>
 <20201029134648.GC599825@cmpxchg.org>
 <96b6d122-df0e-dfb0-368c-6bd714fab116@linux.alibaba.com>
 <20201030140420.GB666074@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201030140420.GB666074-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>



在 2020/10/30 下午10:04, Johannes Weiner 写道:
>>> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>>>
>>> This should go in before the previous patch that adds the WARN for it.
>> Right, but than the long ops may not weird. Should I remove the ops and resend the whole patchset?
> You mean the warning in the changelog? I think that's alright. You can
> just say that you're about to remove the !page->memcg check in the
> next patch because the original reasons for having it are gone, and
> memcg being disabled is the only remaining exception, so this patch
> makes that check explicit in preparation for the next.
> 
> Sorry, it's all a bit of a hassle, I just wouldn't want to introduce a
> known warning into the kernel between those two patches (could confuse
> bisection runs, complicates partial reverts etc.)

H Johannes,

I see, I will exchange the 1st and 2nd patch place with above comments in commit log.
I guess you could give more comments on other patches, so I am going to wait you for
more comments and send v21 as a whole. :)

Many thanks!
Alex 
