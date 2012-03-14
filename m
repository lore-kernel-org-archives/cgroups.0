From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V3 5/8] hugetlbfs: Add memcg control files for hugetlbfs
Date: Wed, 14 Mar 2012 21:27:57 +0530
Message-ID: <87d38f89a2.fsf@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120313144233.49026e6a.akpm@linux-foundation.org> <87lin38mkd.fsf@linux.vnet.ibm.com> <20120314043530.d6f3d424.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120314043530.d6f3d424.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 14 Mar 2012 04:35:30 -0700, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, 14 Mar 2012 16:40:58 +0530 "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
> > > 
> > > > +int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx);
> > > 
> > > 
> > > No, please put it in a header file.  Always.  Where both callers and
> > > the implementation see the same propotype.
> > > 
> > > > +#else
> > > > +static int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > > +#endif
> > > 
> > > So this will go into the same header file.
> > > 
> > 
> > I was not sure whether i want to put mem_cgroup_hugetlb_file_init in
> > linux/memcontrol.h .
> 
> The above is a declaration, not the definition (implementation).
> 
> > Ideally i want to have that in mm/hugetlb.c and in
> > linux/hugetlb.h. That would require me to make mem_cgroup_read and
> > others non static and move few #defines to memcontrol.h. That would
> > involve larger code movement which i didn't want to do. ? What do you
> > suggest ? Just move mem_cgroup_hugetlb_file_init to memcontrol.h ?
> 
> In memcontrol.h:
> 
> #ifdef CONFIG_FOO
> extern int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx);
> #else
> static inline int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx)
> {
> 	return 0;
> }
> #endif
> 

Will do that in the next iteration.

-aneesh
