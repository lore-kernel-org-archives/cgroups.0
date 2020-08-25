From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Tue, 25 Aug 2020 12:39:10 +0100
Message-ID: <20200825113910.GM17456@casper.infradead.org>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
 <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8tGP1JPc7jordcLr9GYgEH1sQIAUBACeH7562OxDjxY=; b=jh69tqh9e33dVk1UNLhHRmhHiL
        7OpafBoQ9WlgiW0XNhW64zL1/ETCzp6H4vvEfMB0rWyBOhhR6m6y1f2K8Rm1ANxQ7MfYlSy9BRKBJ
        0w+5LDlcoKVpEjuSnMGW4tmb3C2UlWZQBKcZs8cryVhqimrR+Bo1XNrvqh8dWMIinKhxaW3hvf/9Y
        CwqVStNBSBzAiL1dc7uTBWj97LHP8X1bdfHGsABFRj2uE+jdoEwWe8k2GC7wQXV5LKDDEEPlA1adh
        /aBCHjF34Wg1fJhQNag+xJ6RKYboemMzFYE4Rot8gJswaDDR7LSF6lLLlUCrLc7JS3IZYlIeULqSn
        LhCnHHdw==;
Content-Disposition: inline
In-Reply-To: <ec62a835-f79d-2b8c-99c7-120834703b42-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, Aug 25, 2020 at 11:26:58AM +0800, Alex Shi wrote:
> I tried reusing page->prviate to store lruvec pointer, that could remove some 
> regression on this, since private is generally unused on a lru page. But the patch
> is too buggy now. 

page->private is for the use of the filesystem.  You can grep for
attach_page_private() to see how most filesystems use it.
Some still use set_page_private() for various reasons.
