From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 5/5] cgroup: remove cgroup_rstat_flush_atomic()
Date: Fri, 5 May 2023 05:20:29 -1000
Message-ID: <ZFUevQbT8hHzH_vv@slm.duckdns.org>
References: <20230421174020.2994750-1-yosryahmed@google.com>
 <20230421174020.2994750-6-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683300032; x=1685892032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5OJUkhoBJrhHGknGMZO9ShmJQsdgZCKjJXfQhDAMN9c=;
        b=nEnlw9VAAUV8WgNAPYNTJj+JJukKpNz9rlfLjajzDo6oLzt6bHdqqDW5kzTegJra9t
         YqgXUrOaWZYSbauy+qZCYXAKyO+affH/D9ml3yqEBsVOLLOEBPQ3nYAn4dkw3vK+/DeC
         Q63TYrhELFF6DNiKVS6VKEE9s2CHECurVK5fOrZVdgFLiP45O3UHeJOZ//0aAuMBFWvy
         DpMm5h6yWQ0upjA4XKHgPhhoBnog4D3w86QQWL10kQT0pjKBhd//u61QvieuJIqOzMHM
         MIlzjYtFjK5kUih5O8FC8AbfvKALBY/0N0VZapRB3VULwuR2jEK5REd4Dva5t3YEK2pA
         pyVA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230421174020.2994750-6-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri, Apr 21, 2023 at 05:40:20PM +0000, Yosry Ahmed wrote:
> Previous patches removed the only caller of cgroup_rstat_flush_atomic().
> Remove the function and simplify the code.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
