From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V9 09/15] mm/hugetlb: Add new HugeTLB cgroup
Date: Fri, 15 Jun 2012 11:50:52 +0530
Message-ID: <87mx45m6yj.fsf@skywalker.in.ibm.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD9A6B6.50503@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FD9A6B6.50503-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> writes:

>> +static inline
>
>> +struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
>> +{
>> +	if (s)
>
>
> Neither cgroup_subsys_state() or task_subsys_state() will ever return NULL,
> so here 's' won't be NULL.
>

That is a change that didn't get updated when i dropped page_cgroup
changes. I had a series that tracked in page_cgroup
cgroup_subsys_state. I will send an fix on top.

Thanks for the review.
-aneesh
