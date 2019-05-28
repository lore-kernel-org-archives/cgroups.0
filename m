From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 6/7] mm: reparent slab memory on cgroup removal
Date: Tue, 28 May 2019 23:11:02 +0300
Message-ID: <20190528201102.63t6rtsrpq7yac44@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-7-guro@fb.com>
 <20190528183302.zv75bsxxblc6v4dt@esperanza>
 <20190528195808.GA27847@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IhQcOeMQDDyAontCK40/Nbm1mljx7ySDbK1mzDX9hII=;
        b=Xi1rvf82R+sAQrYfabSK06Oc3zrxz8A4e+xmdG9AUs3GEvmrywT07vu1Cdbwq/n+xC
         dhTgk/se4eR4Ig+rHsTTHDJlcN63ODXw271T4KGgt4YkjXCyvu8qSH0f0fXf/g6urI3y
         c4yPQrnqmATMPqTEAeV8o+YdaFcJEC9ZveudH3c2ybsmgtfwNbKhVpH3jMiM2DCCRFZF
         Rl7v4N5R1yF+cGs9dD20FId6Cm/FCykxQSf4SR4+8tIu8TYJULxXWzwkhGQ8yvwSl9sx
         gENvr/QOA/o9+vwBi3YD8jXXztGw2Fmzgx0nKc79w9lc5uejD1VHiOJ/QV41g+10ChlG
         +K/g==
Content-Disposition: inline
In-Reply-To: <20190528195808.GA27847@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Tue, May 28, 2019 at 07:58:17PM +0000, Roman Gushchin wrote:
> It looks like outstanding questions are:
> 1) synchronization around the dying flag
> 2) removing CONFIG_SLOB in 2/7
> 3) early sysfs_slab_remove()
> 4) mem_cgroup_from_kmem in 7/7
> 
> Please, let me know if I missed anything.

Also, I think that it might be possible to get rid of RCU call in kmem
cache destructor, because the cgroup subsystem already handles it and
we could probably piggyback - see my comment to 5/7. Not sure if it's
really necessary, since we already have RCU in SLUB, but worth looking
into, I guess, as it might simplify the code a bit.
