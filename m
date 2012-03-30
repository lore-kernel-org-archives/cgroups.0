From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
Date: Fri, 30 Mar 2012 12:46:50 +0200
Message-ID: <20120330104650.GB15375@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120328131706.GF20949@tiehlicka.suse.cz>
 <87sjgs1v6x.fsf@skywalker.in.ibm.com>
 <20120329081003.GC30465@tiehlicka.suse.cz>
 <871uoamkxr.fsf@skywalker.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <871uoamkxr.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 30-03-12 16:10:00, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
> 
> > On Wed 28-03-12 23:09:34, Aneesh Kumar K.V wrote:
> >> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
> >> 
> >> > On Fri 16-03-12 23:09:25, Aneesh Kumar K.V wrote:
> >> >> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >> >> 
> >> >> This adds necessary charge/uncharge calls in the HugeTLB code
> >> >
> >> > This begs for more description...
> >> > Other than that it looks correct.
> >> >
> >> 
> >> Updated as below
> >> 
> >>     hugetlb: add charge/uncharge calls for HugeTLB alloc/free
> >>     
> >>     This adds necessary charge/uncharge calls in the HugeTLB code. We do
> >>     memcg charge in page alloc and uncharge in compound page destructor.
> >>     We also need to ignore HugeTLB pages in __mem_cgroup_uncharge_common
> >>     because that get called from delete_from_page_cache
> >
> > and from mem_cgroup_end_migration used during soft_offline_page.
> >
> > Btw., while looking at mem_cgroup_end_migration, I have noticed that you
> > need to take care of mem_cgroup_prepare_migration as well otherwise the
> > page would get charged as a normal (shmem) page.
> >
> 
> Won't we skip HugeTLB pages in migrate ?

Yes but we still migrate for memory failure (see soft_offline_page).

> check_range do check for is_vm_hugetlb_page.
> 
> -aneesh
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
