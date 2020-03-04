From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v9 07/20] mm/lru: introduce TestClearPageLRU
Date: Wed, 4 Mar 2020 15:06:48 +0800
Message-ID: <6d155f79-8ba2-b322-4e92-311e7be98f79@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
 <1583146830-169516-8-git-send-email-alex.shi@linux.alibaba.com>
 <20200302141144.b30abe0d89306fd387e13a92@linux-foundation.org>
 <9cacdc21-9c1f-2a17-05cb-e9cf2959cef5@linux.alibaba.com>
 <20200303164659.b3a30ab9d68c9ed82299a29c@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200303164659.b3a30ab9d68c9ed82299a29c-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>



在 2020/3/4 上午8:46, Andrew Morton 写道:
> 
> Well, any difference would be small and the numbers did get a bit
> lower, albeit probably within the margin of error.
> 
> But you know, if someone were to send a patch which micro-optimized
> some code by replacing 'TestClearXXX()' with `if PageXXX()
> ClearPageXXX()', I would happily merge it!
> 
> Is this change essential to the overall patchset?  If not, I'd be
> inclined to skip it?
> 

Hi Andrew,

Thanks a lot for comments!
Yes, this patch is essential for all next.

Consider the normal memory testing would focus on user page, that probabably with PageLRU. 

Fengguang's vm-scalibicase-small-allocs which used a lots vm_area_struct slab, which may
got some impact. 0day/Cheng Rong is working on the test. In my roughly testing, it may drop 5% on my
96threads/394GB machine.

Thanks
Alex
