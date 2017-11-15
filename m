From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] memcg: hugetlbfs basic usage accounting
Date: Wed, 15 Nov 2017 12:23:14 +0000
Message-ID: <20171115122306.GA16468@castle>
References: <20171114172429.8916-1-guro@fb.com>
 <20171115083504.nwczf5xq6posy3bw@dhcp22.suse.cz>
 <20171115111803.GA28352@castle>
 <20171115114223.ykyfrnxvvzhiglfd@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=wjafIAI0lze60YEdDVx85wguwcuZVwRZLKFOtrIN1E4=;
 b=adq8F6YyitjsxJHURcngh3Lisy2jvOiFybbcC5LRquWNcPh+T6rZ5fz5Y6+bDtbmeznB
 6bGHcqhQdHR4/3QU9wGrXtGV6GcZYQ7UJuxN53pNBmAUD9MaOZ5Ibf52OMOYf5YBhvxF
 i61OqXPXacVerwrDf5CA6E8C6RAwDpowja4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wjafIAI0lze60YEdDVx85wguwcuZVwRZLKFOtrIN1E4=;
 b=ip3NGCGxXc4D+VFSRtNauzqBGq7F0fXK5EJQ5L70Czfs0v0VsZRAFHXP/OiuIz+8Qz6C46wWSGav+ttystUnMwT6s+dlRLC1+U4NOiXfaz08Vw88kJ2s45GY4mNXWPneD3qXag7Yc/SpEO/CKNVzctYopdFvBZHvcXHVxLqdpsA=
Content-Disposition: inline
In-Reply-To: <20171115114223.ykyfrnxvvzhiglfd@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Dave Hansen <dave.hansen@intel.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 15, 2017 at 12:42:23PM +0100, Michal Hocko wrote:
> On Wed 15-11-17 11:18:13, Roman Gushchin wrote:
> > On Wed, Nov 15, 2017 at 09:35:04AM +0100, Michal Hocko wrote:
> [...]
> > > So my primary question is, why don't you simply allow hugetlb controller
> > > rather than tweak stats for memcg? Is there any fundamental reason why
> > > hugetlb controller is not v2 compatible?
> > 
> > I really don't know if the hugetlb controller has enough users to deserve
> > full support in v2 interface: adding knobs like memory.hugetlb.current,
> > memory.hugetlb.min, memory.hugetlb.high, memory.hugetlb.max, etc.
> > 
> > I'd be rather conservative here and avoid adding a lot to the interface
> > without clear demand. Also, hugetlb pages are really special, and it's
> > at least not obvious how, say, memory.high should work for it.
> 
> But you clearly want the hugetlb accoutning and that is what hugetlb
> controller is for. You might not be interested in the limit enforcement
> but that is not strictly required. So my question remains. Why don't we
> reuse an existing infrastructure and add a new which might confuse users
> in an extreme case?

Hm, but to use a small part of hugetlb controller infrastructure I would
have to add a whole set of cgroup v2 controls.
And control knobs (like memory.hugetlb.current) are much more obligatory
than an entry in memory.stat, where we have some internal stats as well.

So, I don't really know why confusion should come from in this case?
It would be confusing, if we'd add hugetlb stats to the memory.current,
so that it could be larger then memory.max.
But as separate entry in memory.stat it should not confuse anyone,
at least not more than the existing state of things, when hugetlb pages
are a black hole.

> 
> Please note that I am not saying your patch is wrong, I just do not see
> why we should handle hugetlb pages 2 different ways to achieve a common
> infrastructure.

This is perfectly fine, and I do understand it.
My point is that it's a cheap way to solve a real problem, which is also
not binding us too much.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
