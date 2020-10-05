From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2] Opportunistic memory reclaim
Date: Mon, 5 Oct 2020 10:35:16 +0200
Message-ID: <20201005083516.GR4555@dhcp22.suse.cz>
References: <20201005081313.732745-1-andrea.righi@canonical.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601886918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/qp0fLfgx7dAgjinAVpQgpni2765Ce4IvEm/FFiEZc=;
        b=S4gB3z/m1iDjvIhYuT/Oo9vTHKPrQfJbETOKd/f0q+M1Gq8paxKVZyhiEMZ+d3AvilmJuh
        EjOy5bC2Yw8QLsGNk6ALURk/VXqScBH3RkkZNVfmsh8DAkfUFn+IjMfS8nbx4hKnHXI+8Z
        OFuU3MK8JEqA8XRoDkvwdjcDxq9ZDxM=
Content-Disposition: inline
In-Reply-To: <20201005081313.732745-1-andrea.righi@canonical.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrea Righi <andrea.righi@canonical.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Luigi Semenzato <semenzato@google.com>, "Rafael J . Wysocki" <rafael@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org

A similar thing has been proposed recently by Shakeel
http://lkml.kernel.org/r/20200909215752.1725525-1-shakeelb@google.com
Please have a look at the follow up discussion.
-- 
Michal Hocko
SUSE Labs
