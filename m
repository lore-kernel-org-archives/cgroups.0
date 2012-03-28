From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V4 02/10] hugetlbfs: don't use ERR_PTR with VM_FAULT* values
Date: Wed, 28 Mar 2012 17:05:49 +0530
Message-ID: <87vclpyn3e.fsf@skywalker.in.ibm.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120328092547.GC20949@tiehlicka.suse.cz>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120328092547.GC20949-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:

> On Fri 16-03-12 23:09:22, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Using VM_FAULT_* codes with ERR_PTR will require us to make sure
>> VM_FAULT_* values will not exceed MAX_ERRNO value.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>  mm/hugetlb.c |   18 +++++++++++++-----
>>  1 files changed, 13 insertions(+), 5 deletions(-)
>> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index d623e71..3782da8 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
> [...]
>> @@ -1047,7 +1047,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>>  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
>>  		if (!page) {
>>  			hugetlb_put_quota(inode->i_mapping, chg);
>> -			return ERR_PTR(-VM_FAULT_SIGBUS);
>> +			return ERR_PTR(-ENOSPC);
>
> Hmm, so one error code abuse replaced by another?
> I know that ENOMEM would revert 4a6018f7 which would be unfortunate but
> ENOSPC doesn't feel right as well.
>

File systems do map ENOSPC to SIGBUS. block_page_mkwrite_return() does
that.

-aneesh
