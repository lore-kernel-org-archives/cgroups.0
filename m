From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/6] Revert "kernfs: do not account ino_ida
 allocations to memcg"
Date: Thu, 19 Nov 2015 13:56:56 -0500
Message-ID: <20151119185656.GA3941@cmpxchg.org>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <c468a2d2b39d755de2383c6ae49be6a53360a22b.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c468a2d2b39d755de2383c6ae49be6a53360a22b.1447172835.git.vdavydov@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 10, 2015 at 09:34:02PM +0300, Vladimir Davydov wrote:
> This reverts commit 499611ed451508a42d1d7d1faff10177827755d5.
> 
> Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
> fragile and difficult to maintain, because there seem to be many more
> allocations that should not be accounted than those that should be.
> Besides, false accounting an allocation might result in much worse
> consequences than not accounting at all, namely increased memory
> consumption due to pinned dead kmem caches.
> 
> So it was decided to switch to the white-list policy. This patch reverts
> bits introducing the black-list policy. The white-list policy will be
> introduced later in the series.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
