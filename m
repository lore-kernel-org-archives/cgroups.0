From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Thu, 17 Sep 2020 10:35:19 -0400
Message-ID: <20200917143519.lhdfnoc47qrmbhaz@ca-dmjordan1.us.oracle.com>
References: <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils>
 <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com>
 <alpine.LSU.2.11.2009091524260.10087@eggly.anvils>
 <855ad6ee-dba4-9729-78bd-23e392905cf6@linux.alibaba.com>
 <alpine.LSU.2.11.2009111634020.22739@eggly.anvils>
 <5cfc6142-752d-26e6-0108-38d13009268b@linux.alibaba.com>
 <alpine.LSU.2.11.2009150112130.1550@eggly.anvils>
 <20200915165807.kpp7uhiw7l3loofu@ca-dmjordan1.us.oracle.com>
 <c3362c0a-3707-3a3d-9955-960d95f3ad8c@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=kWMuOkBEzKmqnR4JA7GRFSVM89Mf8rcx6R9OK0t1o8o=;
 b=UxnoQld7c9iVJG+UWxCx8mzgw5093d2eAhT6slS9zZ9BOBcdTxqSrKXeSN7AZWpWxSSI
 DwuIP3mCnlVBi3NLzV57fDZiE/05TvYbuGWj4t9mcHd2PQfZLY3JrdnvthH2jirfby0T
 vipAmmtEyRoPQw1PoVrfdIKAJhrrBAFk/9/MSMpw0emMIjRWVZWre4042wPaDqW4u+wR
 uumXy8iVLJUra4z91dyam5tS7SvAQMycWLp1BZ4iq4NePorhpH7plhEtvEYAOQx1OHuG
 3QWQKherkVgBYwt3vreL9JdQGE1sR/EchO86PjffxRP7+tSNfz1pKQjpQijBKEXWBGu9 Gg== 
Content-Disposition: inline
In-Reply-To: <c3362c0a-3707-3a3d-9955-960d95f3ad8c-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cai-J5quhbR+WMc@public.gmane.org

On Thu, Sep 17, 2020 at 10:37:45AM +0800, Alex Shi wrote:
> 在 2020/9/16 上午12:58, Daniel Jordan 写道:
> > On Tue, Sep 15, 2020 at 01:21:56AM -0700, Hugh Dickins wrote:
> >> On Sun, 13 Sep 2020, Alex Shi wrote:
> >>> Uh, I updated the testing with some new results here:
> >>> https://lkml.org/lkml/2020/8/26/212
> >> Right, I missed that, that's better, thanks.  Any other test results?
> > Alex, you were doing some will-it-scale runs earlier.  Are you planning to do
> > more of those?  Otherwise I can add them in.
> 
> Hi Daniel,
> 
> Does compaction perf scalable, like thpscale, I except they could get some benefit.

Yep, I plan to stress compaction.  Reclaim as well.

I should have said which Alex I meant.  I was asking Alex Duyck since he'd done
some will-it-scale runs.
