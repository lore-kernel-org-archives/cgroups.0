From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V4 07/10] hugetlbfs: Add memcg control files for hugetlbfs
Date: Mon, 19 Mar 2012 12:44:11 +0530
Message-ID: <87wr6hjc58.fsf@linux.vnet.ibm.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F66A059.20801@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F66A059.20801-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 19 Mar 2012 11:56:25 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > 
> > This add control files for hugetlbfs in memcg
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> 
> I have a question. When a user does
> 
> 	1. create memory cgroup as
> 		/cgroup/A
> 	2. insmod hugetlb.ko
> 	3. ls /cgroup/A
> 
> and then, files can be shown ? Don't we have any problem at rmdir A ?
> 
> I'm sorry if hugetlb never be used as module.

HUGETLBFS cannot be build as kernel module


> 
> a comment below.
> 
> > ---
> >  include/linux/hugetlb.h    |   17 +++++++++++++++
> >  include/linux/memcontrol.h |    7 ++++++
> >  mm/hugetlb.c               |   25 ++++++++++++++++++++++-
> >  mm/memcontrol.c            |   48 ++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 96 insertions(+), 1 deletions(-)


......

> > 
> > +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> > +static char *mem_fmt(char *buf, unsigned long n)
> > +{
> > +	if (n >= (1UL << 30))
> > +		sprintf(buf, "%luGB", n >> 30);
> > +	else if (n >= (1UL << 20))
> > +		sprintf(buf, "%luMB", n >> 20);
> > +	else
> > +		sprintf(buf, "%luKB", n >> 10);
> > +	return buf;
> > +}
> > +
> > +int mem_cgroup_hugetlb_file_init(int idx)
> > +{
> 
> 
> __init ? 

Added .

>And... do we have guarantee that this function is called before
> creating root mem cgroup even if CONFIG_HUGETLBFS=y ?
> 

Yes. This should be called before creating root mem cgroup.

-aneesh
