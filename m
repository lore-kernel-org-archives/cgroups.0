From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3] mm: memcontrol: Remove lruvec_stat
Date: Wed, 4 Apr 2018 10:13:55 -0400
Message-ID: <20180404141355.GB28966@cmpxchg.org>
References: <20180324160901.512135-1-tj@kernel.org>
 <20180324160901.512135-4-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IttidaFAVlvP34nBy+asPSIp4V4VU7scBQIUPC7UiOY=; b=uJUC6Mmb/r5k2nEe1VBID0LL95
        jhlfLuWPlGeBQ6zMvQ8Yum7iZxikYsP5IimTkXuCb3g4YiHkrM42atdcd5FDWK1af3pGrA3oOrlv0
        lEWHW6clcC//0HmbpEq94LSB3QNi3NUCP9j0JfFr+ElMTBq0APIc+AKXmzfrQeWeExUI=;
Content-Disposition: inline
In-Reply-To: <20180324160901.512135-4-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org, Josef Bacik <josef@toxicpanda.com>

On Sat, Mar 24, 2018 at 09:09:01AM -0700, Tejun Heo wrote:
> lruvec_stat doesn't have any consumer.  Remove it.

This tracks counters at the node-memcg intersection, which is a
requirement for Josef's shrinker rework.

I don't know what happened to that patch series. Josef, Andrew?
