From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 3/8] cgroup: implement cgroup_from_id()
Date: Mon, 29 Jul 2013 14:31:39 -0400
Message-ID: <20130729183139.GE26076@mtj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614DF.9010508@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JNZU38BCsT50WoxvDbfs+il+7RniBs7ALv0dg4BPKns=;
        b=TmXfiT4SaAXLrcAYw7IC/bZjYB4qz1d20qKcGHMrQmQmBjFCI76K4XyGp+5T1lhWAW
         xYOjMSapBc6WzZdGMXJe7RCVrDdn8PSpPpMbIHZYJ3HiLLSotIciE58DRhwtJrO05LoC
         glFtytNsGhih7mh9HwsBwaasPo42o1c33GxSzJ8VcWNFOlVqILkDFqEsISZQ/AgjUn6h
         QxkcXq/IfdjtX30OtT5gJ3E+5Qb1sbxIRIYkKs960lO+PHIn8vCAEx51ZUPs5hI4Gpu5
         FKOTGZcRNOyeTj+RrNu79UiK+mS/YTshCQprnJMj2z7UVgK02ciHMTMn/FknpYUB7t7E
         9WPQ==
Content-Disposition: inline
In-Reply-To: <51F614DF.9010508@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Mon, Jul 29, 2013 at 03:08:15PM +0800, Li Zefan wrote:
> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
> +{
> +	rcu_lockdep_assert(rcu_read_lock_held(),
> +			   "cgroup_from_id() needs rcu_read_lock()"
> +			   " protection");

Maybe we want to add notation for &cgroup_mutex for completeness?

> +	return idr_find(&ss->root->cgroup_idr, id);
> +}

And maybe inline it?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
