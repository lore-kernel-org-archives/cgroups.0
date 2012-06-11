From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V8 13/16] hugetlb/cgroup: add hugetlb cgroup control files
Date: Mon, 11 Jun 2012 15:13:31 +0530
Message-ID: <87bokq5gl8.fsf@skywalker.in.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611090234.GE12402@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120611090234.GE12402-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:

> On Sat 09-06-12 14:29:58, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Add the control files for hugetlb controller
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
> [...]
>> +int __init hugetlb_cgroup_file_init(int idx)
>> +{
>> +	char buf[32];
>> +	struct cftype *cft;
>> +	struct hstate *h = &hstates[idx];
>> +
>> +	/* format the size */
>> +	mem_fmt(buf, 32, huge_page_size(h));
>> +
>> +	/* Add the limit file */
>> +	cft = &h->cgroup_files[0];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.limit_in_bytes", buf);
>> +	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
>> +	cft->read = hugetlb_cgroup_read;
>> +	cft->write_string = hugetlb_cgroup_write;
>> +
>> +	/* Add the usage file */
>> +	cft = &h->cgroup_files[1];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.usage_in_bytes", buf);
>> +	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
>> +	cft->read = hugetlb_cgroup_read;
>> +
>> +	/* Add the MAX usage file */
>> +	cft = &h->cgroup_files[2];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max_usage_in_bytes", buf);
>> +	cft->private = MEMFILE_PRIVATE(idx, RES_MAX_USAGE);
>> +	cft->trigger = hugetlb_cgroup_reset;
>> +	cft->read = hugetlb_cgroup_read;
>> +
>> +	/* Add the failcntfile */
>> +	cft = &h->cgroup_files[3];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.failcnt", buf);
>> +	cft->private  = MEMFILE_PRIVATE(idx, RES_FAILCNT);
>> +	cft->trigger  = hugetlb_cgroup_reset;
>> +	cft->read = hugetlb_cgroup_read;
>> +
>> +	/* NULL terminate the last cft */
>> +	cft = &h->cgroup_files[4];
>> +	memset(cft, 0, sizeof(*cft));
>> +
>> +	WARN_ON(cgroup_add_cftypes(&hugetlb_subsys, h->cgroup_files));
>> +
>> +	return 0;
>> +}
>> +
>
> I am not so familiar with the recent changes in the generic cgroup
> infrastructure but isn't this somehow automated?

yes for most of the cgroups. But in the hugetlb case we have variable number
of control files. We have the above set of control files for each
hugetlb size supported by the architecture.

-aneesh
