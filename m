From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v2] mm: fix race between kmem_cache destroy, create and
 deactivate
Date: Tue, 29 May 2018 13:58:11 +0000
Message-ID: <01000163ac3122e8-e705287a-17f4-4ff6-8eae-1ad310676096-000000@email.amazonses.com>
References: <20180522201336.196994-1-shakeelb@google.com> <20180526185837.k5ztrillokpi65qj@esperanza>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ug7nbtf4gccmlpwj322ax3p6ow6yfsug; d=amazonses.com; t=1527602291;
        h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:Feedback-ID;
        bh=19oo3gG5lG8wN38hSlrbrK52MYBgNHDHWTGnS8d/bhg=;
        b=AXBRIcFN5TWP7bXiXIKvSuQFo4pZ/mwo3aVgz6jfVx94djmov714y6+/x2KGIamN
        x9QlEzJ3/HDV9Epip1MLKwsQ0VMPKE+p8ffPHzJPk+hZckZLViBHKfZ+7klaAQnHsTU
        9O/1lXL8+/Cfgk5wsGwsV+mCh7xjOCa9VeGZ4LeQ=
In-Reply-To: <20180526185837.k5ztrillokpi65qj@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Linux MM <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Sat, 26 May 2018, Vladimir Davydov wrote:

> > The reference counting is only implemented for root kmem_caches for
> > simplicity. The reference of a root kmem_cache is elevated on sharing or
> > while its memcg kmem_cache creation or deactivation request is in the
> > fly and thus it is made sure that the root kmem_cache is not destroyed
> > in the middle. As the reference of kmem_cache is elevated on sharing,
> > the 'shared_count' does not need any locking protection as at worst it
> > can be out-dated for a small window which is tolerable.
>
> I wonder if we could fix this problem without introducing reference
> counting for kmem caches (which seems a bit of an overkill to me TBO),
> e.g. by flushing memcg_kmem_cache_wq before root cache destruction?

Would prefer that too but the whole memcg handling is something of a
mystery to me.

