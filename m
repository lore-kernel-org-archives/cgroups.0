From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Fri, 22 Mar 2013 11:06:09 +0100
Message-ID: <20130322100609.GI31457@dhcp22.suse.cz>
References: <20130321090849.GF6094@dhcp22.suse.cz>
 <20130321102257.GH6094@dhcp22.suse.cz>
 <514BB23E.70908@huawei.com>
 <20130322080749.GB31457@dhcp22.suse.cz>
 <514C1388.6090909@huawei.com>
 <514C14BF.3050009@parallels.com>
 <20130322093141.GE31457@dhcp22.suse.cz>
 <514C2754.4080701@parallels.com>
 <20130322094832.GG31457@dhcp22.suse.cz>
 <514C2C72.5090402@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <514C2C72.5090402@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Fri 22-03-13 14:03:30, Glauber Costa wrote:
> On 03/22/2013 01:48 PM, Michal Hocko wrote:
> > On Fri 22-03-13 13:41:40, Glauber Costa wrote:
> >> On 03/22/2013 01:31 PM, Michal Hocko wrote:
> >>> On Fri 22-03-13 12:22:23, Glauber Costa wrote:
> >>>> On 03/22/2013 12:17 PM, Li Zefan wrote:
> >>>>>> GFP_TEMPORARY groups short lived allocations but the mem cache is not
> >>>>>>> an ideal candidate of this type of allocations..
> >>>>>>>
> >>>>> I'm not sure I'm following you...
> >>>>>
> >>>>> char *memcg_cache_name()
> >>>>> {
> >>>>> 	char *name = alloc();
> >>>>> 	return name;
> >>>>> }
> >>>>>
> >>>>> kmem_cache_dup()
> >>>>> {
> >>>>> 	name = memcg_cache_name();
> >>>>> 	kmem_cache_create_memcg(name);
> >>>>> 	free(name);
> >>>>> }
> >>>>>
> >>>>> Isn't this a short lived allocation?
> >>>>>
> >>>>
> >>>> Hi,
> >>>>
> >>>> Thanks for identifying and fixing this.
> >>>>
> >>>> Li is right. The cache name will live long, but this is because the
> >>>> slab/slub caches will strdup it internally. So the actual memcg
> >>>> allocation is short lived.
> >>>
> >>> OK, I have totally missed that. Sorry about the confusion. Then all the
> >>> churn around the allocation is pointless, no?
> >>> What about:
> >>
> >> If we're really not concerned about stack, then yes. Even if always
> >> running from workqueues, a PAGE_SIZEd stack variable seems risky to me.
> > 
> > This is not on stack. It is static
> > 
> Ah, right, I totally missed that. And then you're taking the mutex.
> 
> But actually, you don't need to take the mutex. All calls to
> kmem_cache_dup are protected by the memcg_cache_mutex.

Yes and I am not taking that mutex. I've just added lockdep assert to
make sure that this still holds true.

> So you should be able to just use the buffer without further problems.

-- 
Michal Hocko
SUSE Labs
