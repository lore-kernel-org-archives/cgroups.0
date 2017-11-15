From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] memcg: hugetlbfs basic usage accounting
Date: Wed, 15 Nov 2017 11:18:13 +0000
Message-ID: <20171115111803.GA28352@castle>
References: <20171114172429.8916-1-guro@fb.com>
 <20171115083504.nwczf5xq6posy3bw@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=jp7YZF4l2jmEhjoWNZv4u4eZWs9dmLr9dT2N/rkBTQ8=;
 b=n9htwdPQ8/6HWwR3v6N8b+GLEpxQFLASVRMWesUF25qoBodk1vkf8sVb48m1IEPESBCv
 2WTDECteNykDvCng7+1Vvy/hGl6H2DOqmpX58UdGAq3Z0XG4F4ZXCSsWYNDotIQuHK5y
 VMWrjEru3ApCIWjOwLDdZyPoo8+7J0Qdfjc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jp7YZF4l2jmEhjoWNZv4u4eZWs9dmLr9dT2N/rkBTQ8=;
 b=BXGDMUWPelJnR2flOmrTXLcB1bVv8JTiUni4Rz/h+e6DxraGJJ4FQ01lUh8Bz231bI5KJflUN9ylCdoWIKxEDRXujTjqaNZ+AFE9Gd1/xLM7RcyYYONr0ZdxKySi/PzU+ElvnX1a7PSD5LTbyOLVunXYrNsFMrRJUeGmIQfNVhQ=
Content-Disposition: inline
In-Reply-To: <20171115083504.nwczf5xq6posy3bw@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Dave Hansen <dave.hansen@intel.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 15, 2017 at 09:35:04AM +0100, Michal Hocko wrote:
> On Tue 14-11-17 17:24:29, Roman Gushchin wrote:
> > This patch implements basic accounting of memory consumption
> > by hugetlbfs pages for cgroup v2 memory controller.
> > 
> > Cgroup v2 memory controller lacks any visibility into the
> > hugetlbfs memory consumption. Cgroup v1 implemented a separate
> > hugetlbfs controller, which provided such stats, and also
> > provided some control abilities. Although porting of the
> > hugetlbfs controller to cgroup v2 is arguable a good idea and
> > is outside of scope of this patch, it's very useful to have
> > basic stats provided by memory.stat.

Hi, Michal!

> Separate hugetlb cgroup controller was really a deliberate decision.
> We didn't want to mix hugetlb with the reclaimable memory. There is no
> reasonable way to enforce memcg limits if hugetlb pages are involved.
> 
> AFAICS your patch shouldn't break the hugetlb controller because that
> one (ab)uses page[2].private to store the hstate for the accounting.
> You also do not really charge those hugetlb pages so the memcg
> accounting will work unchaged.

Yes, you are right.

> 
> So my primary question is, why don't you simply allow hugetlb controller
> rather than tweak stats for memcg? Is there any fundamental reason why
> hugetlb controller is not v2 compatible?

I really don't know if the hugetlb controller has enough users to deserve
full support in v2 interface: adding knobs like memory.hugetlb.current,
memory.hugetlb.min, memory.hugetlb.high, memory.hugetlb.max, etc.

I'd be rather conservative here and avoid adding a lot to the interface
without clear demand. Also, hugetlb pages are really special, and it's
at least not obvious how, say, memory.high should work for it.

At the same time we don't really have any accounting of hugetlb page
usage (except system-wide stats in sysfs). And providing such stats
is really useful.
In my particular case, I have some number of pre-allocated hugepages,
and I have several containerized workloads, which are potentially
using them to get performance bonuses. Having these stats allows to
attribute the memory holding by hugetlb pages to one of the workloads.

> It feels really strange to keeps stats of something the controller
> doesn't really control. I can imagine confused users claiming that
> numbers just do not add up...

This is why I do not add this number to memory.current. At the same
time numbers in memory.stat are not intended to be summed (we have
event counters there, dirty pages counter, etc), so I don't see a problem.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
