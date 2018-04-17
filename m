From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 3/4] mm: treat memory.low value inclusive
Date: Tue, 17 Apr 2018 20:00:56 +0100
Message-ID: <20180417190049.GA3752@castle.DHCP.thefacebook.com>
References: <20180405185921.4942-1-guro@fb.com>
 <20180405185921.4942-3-guro@fb.com>
 <20180405194526.GC27918@cmpxchg.org>
 <20180406122132.GA7185@castle>
 <20180406163802.GA16383@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Dbl6vBcBcHac9ZZG+yqba2PVB4gpKqWjtKneb7VH6qo=;
 b=m4Zg+yGBcxM5PZ+XYxjiPY5U+FS3rlyRbFgxhDP3etSNTKVOGr/uWyTvnXyROu8m3IOe
 Kq2uef+Xywxdlhw7jIe2DJnUnJF5Kgy/nx7MSJm8ipRlA1u3yILfEhA35wTUd4ox+MM4
 xC9hKx2tyeUeIE5Ccai3E5UBbvNqagZu27o= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Dbl6vBcBcHac9ZZG+yqba2PVB4gpKqWjtKneb7VH6qo=;
 b=kHQtofZtoNeTXDLrWiwPVSdU0P3AYso2pjkGOGLKqvUZbJ+ikXqUN9OMzj1UggX5t9p7SJmdk+gsHKodhHr8lzOD9ao2wzK6Cc+IaDLYpA9Ob2ku1jfza3/vBlh0Gz0A8ikxwEHEt1Uc5vMnMOKjp7XGUk/Odg3NO1ocQnnvT+Y=
Content-Disposition: inline
In-Reply-To: <20180406163802.GA16383@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Andrew!

Can you, please, pull this patchset?

Thanks!

Roman

On Fri, Apr 06, 2018 at 12:38:02PM -0400, Johannes Weiner wrote:
> On Fri, Apr 06, 2018 at 01:21:38PM +0100, Roman Gushchin wrote:
> >
> > From 466c35c36cae392cfee5e54a2884792972e789ee Mon Sep 17 00:00:00 2001
> > From: Roman Gushchin <guro@fb.com>
> > Date: Thu, 5 Apr 2018 19:31:35 +0100
> > Subject: [PATCH v4 3/4] mm: treat memory.low value inclusive
> > 
> > If memcg's usage is equal to the memory.low value, avoid reclaiming
> > from this cgroup while there is a surplus of reclaimable memory.
> > 
> > This sounds more logical and also matches memory.high and memory.max
> > behavior: both are inclusive.
> > 
> > Empty cgroups are not considered protected, so MEMCG_LOW events
> > are not emitted for empty cgroups, if there is no more reclaimable
> > memory in the system.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: kernel-team@fb.com
> > Cc: linux-mm@kvack.org
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> 
> Looks good, thanks!
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
