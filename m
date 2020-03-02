From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v9 00/21] per lruvec lru_lock for memcg
Date: Mon, 2 Mar 2020 14:12:02 -0800
Message-ID: <20200302141202.91d88e8b730b194a8bd8fa7d@linux-foundation.org>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583187123;
        bh=u00owx5AeCvb4Q/OakL2XqFZQBlbOD3X9KlvMyZ6N/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g/RKQreadIbBaR77IOPoErtcimfL0iyJfsZUocHcMLCEY4S5MOvpM6dIKJ8P5bcJc
         LueHo/4by5fhWowdKPvagGgYH/8DV3KR6B9Nr0oVZf8sHcKAbyInhLkyD7bswHtkGk
         7Hgt9ic26m0ALwoXf49r1dkSLRGJyBUY5dAZTR5k=
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Mon,  2 Mar 2020 19:00:10 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:

> Hi all,
> 
> This patchset mainly includes 3 parts:
> 1, some code cleanup and minimum optimization as a preparation.
> 2, use TestCleanPageLRU as page isolation's precondition
> 3, replace per node lru_lock with per memcg per node lru_lock
> 
> The keypoint of this patchset is moving lru_lock into lruvec, give a 
> lru_lock for each of lruvec, thus bring a lru_lock for each of memcg 
> per node. So on a large node machine, each of memcg don't suffer from
> per node pgdat->lru_lock waiting. They could go fast with their self
> lru_lock now.
> 
> Since lruvec belongs to each memcg, the critical point is to keep
> page's memcg stable, so we take PageLRU as its isolation's precondition.
> Thanks for Johannes Weiner help and suggestion!
> 
> Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
> containers on a 2s * 26cores * HT box with a modefied case:
>   https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
> 
> With this patchset, the readtwice performance increased about 80%
> in concurrent containers.
> 
> Thanks Hugh Dickins and Konstantin Khlebnikov, they both brought this
> idea 8 years ago, and others who give comments as well: Daniel Jordan, 
> Mel Gorman, Shakeel Butt, Matthew Wilcox etc.
> 
> Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
> and Yun Wang.

I'm not seeing a lot of evidence of review and test activity yet.  But
I think I'll grab patches 01-06 as they look like fairly
straightforward improvements.
