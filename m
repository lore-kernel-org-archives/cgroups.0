From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 3/3] loop: Charge i/o to mem and blk cg
Date: Thu, 20 Feb 2020 17:02:38 -0500
Message-ID: <20200220220238.GB68937@cmpxchg.org>
References: <cover.1582216294.git.schatzberg.dan@gmail.com>
 <78060dcbf6578b4da6081f9f48b24b33726c5083.1582216295.git.schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qs+LhNiBMIj9A7PLEkqadpwwdn4t7ZJVTcZjDGn03PM=;
        b=1sM+flAalAjdf9H+ABF4RBpnc7mgf/EB1PkQ3GIvPhatEPuYG/+kZZYytUx2breYo9
         oBS4Cz3/NHUDHKrF1wClmlsU2wMQWRh9jUeUVFlKDnYU1XDy2DbPjMAN6/dFKk+WparC
         n2mnFSbEJsFPwZS1Vkfj9gnphTLnT9mqRYcdYb3mcnuK5c108UQ0b24WLrAoGSNFpyha
         iPLMyEc4PN5W+kfi2o4BOepzuEVVQ0MwF8HwWATiYKm8p4b2uSETdNaNTVOHwu7ULX5K
         9cl6gc557oQYGhjYLQyYi1BtFt0PWyzSVcxVJSRFwVQAzbgf64CESMf7EXkdNMTvkNc/
         T1Tw==
Content-Disposition: inline
In-Reply-To: <78060dcbf6578b4da6081f9f48b24b33726c5083.1582216295.git.schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Thu, Feb 20, 2020 at 11:51:53AM -0500, Dan Schatzberg wrote:
> The current code only associates with the existing blkcg when aio is
> used to access the backing file. This patch covers all types of i/o to
> the backing file and also associates the memcg so if the backing file is
> on tmpfs, memory is charged appropriately.
> 
> This patch also exports cgroup_get_e_css so it can be used by the loop
> module.
> 
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>

The cgroup bits look good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
