From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] cgroup: revert fa06235b8eb0 ("cgroup: reset css on
 destruction")
Date: Thu, 27 Jul 2017 10:36:17 -0400
Message-ID: <20170727143617.GC19738@cmpxchg.org>
References: <20170726083017.3yzeucmi7lcj46qd@esperanza>
 <20170727130428.28856-1-guro@fb.com>
 <20170727130428.28856-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UL9cMO6qoPaqG66LJm6fvdiGIm31EYZfcMr64BhepC8=; b=DB/qPXH/5DhovFyB0yD/ergccP
        wuY1Qiiiku3TyNIzxNgkSfI2EG1e/IttwXUO+wLfsPxxFNIwKl43ftHmHHJtl9hdu9XdVpnLB9lmt
        qkKLwHU3lNntscFezg/n5q8J9mSYgi5M7k97endA8YBgykxXBKcAXquy3ImN2bTwrjYk=;
Content-Disposition: inline
In-Reply-To: <20170727130428.28856-2-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jul 27, 2017 at 02:04:28PM +0100, Roman Gushchin wrote:
> Commit fa06235b8eb0 ("cgroup: reset css on destruction") caused
> css_reset callback to be called from the offlining path. Although
> it solves the problem mentioned in the commit description
> ("For instance, memory cgroup needs to reset memory.low, otherwise
> pages charged to a dead cgroup might never get reclaimed."),
> generally speaking, it's not correct.
> 
> An offline cgroup can still be a resource domain, and we shouldn't
> grant it more resources than it had before deletion.
> 
> For instance, if an offline memory cgroup has dirty pages, we should
> still imply i/o limits during writeback.
> 
> The css_reset callback is designed to return the cgroup state
> into the original state, that means reset all limits and counters.
> It's spomething different from the offlining, and we shouldn't use
> it from the offlining path. Instead, we should adjust necessary
> settings from the per-controller css_offline callbacks (e.g. reset
> memory.low).
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
