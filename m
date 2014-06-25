From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Date: Wed, 25 Jun 2014 11:00:53 -0400
Message-ID: <20140625150053.GE26883@htj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
 <20140620193521.GB28324@mtj.dyndns.org>
 <53A8D2B8.4080107@huawei.com>
 <20140624210119.GC14909@htj.dyndns.org>
 <53AA2C4F.30808@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=E/W7V+Vd1YBNX8bv+mGyV+e7TWJ8W/h9h3rd6NTq4kg=;
        b=k9nqTZDoUyRaPtuqKp0y4NpeEc3Ed7c50IU+RyfydsKm3N0JQeMQ/S53pyZ5j2S02w
         P3zKs2agNZ15MSvYIL4F2aafaX7ozmLHwDG2aaWlETbETLMy0aGjh5u64gmYcZsLTCHJ
         xG3ohI6aUEurSb3zNBZO0Bdv4lvjv6OzCgV6spq4sF37Yn3wHde0cZNytTmmqsxWe1Ov
         KJX6pqxMe+G5aC7tOK+eZD+6eXSCMRldn9bwE9lCt4PmLLA+RoagzBKGE8x1M31PzVz6
         mAX10zQN1KZHSMZ+qTC+PKY3NKpRu/MnzyjhFF4WuBByY2VG20URth4SiRA6BONiA+G6
         TifQ==
Content-Disposition: inline
In-Reply-To: <53AA2C4F.30808@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hey,

On Wed, Jun 25, 2014 at 09:56:31AM +0800, Li Zefan wrote:
> > Hmmm?  Why does that matter?  The only region in cgroup_mount() which
> > needs to be put inside such mutex would be root lookup, no?
> 
> unfortunately that won't help. I think what you suggest is:
> 
> cgroup_mount()
> {
> 	mutex_lock();
> 	lookup_cgroup_root();
> 	mutex_unlock();
> 	kernfs_mount();
> }
> 
> cgroup_kill_sb()
> {
> 	mutex_lock();
> 	percpu_ref_kill();
> 	mutex_Unlock();
> 	kernfs_kill_sb();
> }
> 
> See, we may still be destroying the superblock after we've succeeded
> in getting the refcnt of cgroup root.

Sure, but now the decision to kill is synchronized so the other side
can interlock with it.  e.g.

cgroup_mount()
{
	mutex_lock();
	lookup_cgroup_root();
	if (root isn't killed yet)
		root->this_better_stay_alive++;
	mutex_unlock();
	kernfs_mount();
}

cgroup_kill_sb()
{
	mutex_lock();
	if (check whether root can be killed)
		percpu_ref_kill();
	mutex_unlock();
	if (the above condition was true)
		kernfs_kill_sb();
}

-- 
tejun
