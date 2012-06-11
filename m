From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V8 12/16] hugetlb/cgroup: Add support for cgroup removal
Date: Mon, 11 Jun 2012 21:04:43 +0530
Message-ID: <87bokpvp4c.fsf@skywalker.in.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611085258.GD12402@tiehlicka.suse.cz> <87fwa25gqj.fsf@skywalker.in.ibm.com> <20120611131411.GN12402@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120611131411.GN12402@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Mon 11-06-12 15:10:20, Aneesh Kumar K.V wrote:
>> Michal Hocko <mhocko@suse.cz> writes:
> [...]
>> >> +static int hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
>> >> +				      struct page *page)
>> >
>> > deserves a comment about the locking (needs to be called with
>> > hugetlb_lock).
>> 
>> will do
>> 
>> >
>> >> +{
>> >> +	int csize;
>> >> +	struct res_counter *counter;
>> >> +	struct res_counter *fail_res;
>> >> +	struct hugetlb_cgroup *page_hcg;
>> >> +	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
>> >> +	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
>> >> +
>> >> +	if (!get_page_unless_zero(page))
>> >> +		goto out;
>> >> +
>> >> +	page_hcg = hugetlb_cgroup_from_page(page);
>> >> +	/*
>> >> +	 * We can have pages in active list without any cgroup
>> >> +	 * ie, hugepage with less than 3 pages. We can safely
>> >> +	 * ignore those pages.
>> >> +	 */
>> >> +	if (!page_hcg || page_hcg != h_cg)
>> >> +		goto err_out;
>> >
>> > How can we have page_hcg != NULL && page_hcg != h_cg?
>> 
>> pages belonging to other cgroup ?
>
> OK, I've forgot that you are iterating over all active huge pages in
> hugetlb_cgroup_pre_destroy. What prevents you from doing the filtering
> in the caller? 
> I am also wondering why you need to play with the page reference
> counting here. You are under hugetlb_lock so the page cannot disappear
> in the meantime or am I missing something?

That is correct. Updated the patch and also added the below comment to
the function.
+
+/*
+ * Should be called with hugetlb_lock held.
+ * Since we are holding hugetlb_lock, pages cannot get moved from
+ * active list or uncharged from the cgroup, So no need to get
+ * page reference and test for page active here.
+ */

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
