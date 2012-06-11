From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V8 12/16] hugetlb/cgroup: Add support for cgroup removal
Date: Mon, 11 Jun 2012 15:10:20 +0530
Message-ID: <87fwa25gqj.fsf@skywalker.in.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611085258.GD12402@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120611085258.GD12402-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:

> On Sat 09-06-12 14:29:57, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> This patch add support for cgroup removal. If we don't have parent
>> cgroup, the charges are moved to root cgroup.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>  mm/hugetlb_cgroup.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 79 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>> index 48efd5a..9458fe3 100644
>> --- a/mm/hugetlb_cgroup.c
>> +++ b/mm/hugetlb_cgroup.c
>> @@ -99,10 +99,87 @@ static void hugetlb_cgroup_destroy(struct cgroup *cgroup)
>>  	kfree(h_cgroup);
>>  }
>>  
>> +
>> +static int hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
>> +				      struct page *page)
>
> deserves a comment about the locking (needs to be called with
> hugetlb_lock).

will do

>
>> +{
>> +	int csize;
>> +	struct res_counter *counter;
>> +	struct res_counter *fail_res;
>> +	struct hugetlb_cgroup *page_hcg;
>> +	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
>> +	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
>> +
>> +	if (!get_page_unless_zero(page))
>> +		goto out;
>> +
>> +	page_hcg = hugetlb_cgroup_from_page(page);
>> +	/*
>> +	 * We can have pages in active list without any cgroup
>> +	 * ie, hugepage with less than 3 pages. We can safely
>> +	 * ignore those pages.
>> +	 */
>> +	if (!page_hcg || page_hcg != h_cg)
>> +		goto err_out;
>
> How can we have page_hcg != NULL && page_hcg != h_cg?

pages belonging to other cgroup ?

-aneesh
