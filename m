From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 4/4] mm/docs: describe memory.low refinements
Date: Thu, 5 Apr 2018 15:46:15 -0400
Message-ID: <20180405194615.GD27918@cmpxchg.org>
References: <20180405185921.4942-1-guro@fb.com>
 <20180405185921.4942-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZBVDmx24pWehOly/7pumcXjHi/MGPfvW6fhZhtriMhI=; b=ga91hfp9YLQs57VJa4ylVg28F+
        7VcWJGDQKeD+3ovLFzgDDNnLKJGKB8DBlKvndwZP6EA516lpjxk6KWaxR0usW4xg3GuBO05MN/+Hx
        +5k1Pf3U5vxwqly27tQAlrZm6laDvjnhwoN4h7sfHPO4EmLf0tE1cjA7xP031dhPhE5g=;
Content-Disposition: inline
In-Reply-To: <20180405185921.4942-4-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org

On Thu, Apr 05, 2018 at 07:59:21PM +0100, Roman Gushchin wrote:
> Refine cgroup v2 docs after latest memory.low changes.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: kernel-team@fb.com
> Cc: linux-mm@kvack.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-doc@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
