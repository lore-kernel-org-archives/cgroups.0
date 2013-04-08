From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/8] cgroup: implement cgroup_from_id()
Date: Mon, 8 Apr 2013 08:43:19 -0700
Message-ID: <20130408154319.GD3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627DEB.4090104@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=82b7ixgxT5qx46K/5FLDHJdWDIBD4FoIlGi1D5xswnQ=;
        b=UwmLkteT4CUR8DLKF2RKzaWNSFHy5XNuNKuhS1p0daLKVjS/C+7JiBqJFBSHE+bvfR
         WWrY9CEm9ImsnFflaHPBDYlLZENP078Y4QMQ5VU/pS7nen8nnfNLXJ8ZJIHnCAGtTb3h
         IDy0T+DdNr5n2hmAi+Rf2PjuJ1KtY3YJagmb14A6abld68WHi5WYY8FsVy9+Ng+29TgX
         Fc/c/Fxok/hP32posnX+kaC2hy3ubuPxBObnp8hUSIxaMJtXOaXcuk4BmBstLD0OH/Vc
         efmveyOQ6Tt/cFA93wcAt1TN+X212pUPuADIW6LyBNpTHenvBpooHFLCsmm2np4rMWNx
         97kA==
Content-Disposition: inline
In-Reply-To: <51627DEB.4090104@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Mon, Apr 08, 2013 at 04:20:59PM +0800, Li Zefan wrote:
> +/**
> + * cgroup_from_id - lookup cgroup by id
> + * @ss: cgroup subsys to be looked into.
> + * @id: the id
> + *
> + * Returns pointer to cgroup if there is valid one with id.
> + * NULL if not. Should be called under rcu_read_lock()
> + */
> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
> +{

	rcu_lockdep_assert(rcu_read_lock_held(), ...);

> +	return idr_find(&ss->root->cgroup_idr, id);

Thanks.

-- 
tejun
