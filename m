From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH -V3 2/8] memcg: Add HugeTLB extension
Date: Tue, 13 Mar 2012 17:42:36 +0400
Message-ID: <4F5F4ECC.6030509@parallels.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F5F4B69.806@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F5F4B69.806@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 03/13/2012 05:28 PM, Glauber Costa wrote:
> On 03/13/2012 11:07 AM, Aneesh Kumar K.V wrote:
>> @@ -4951,6 +5083,12 @@ static int mem_cgroup_pre_destroy(struct
>> cgroup_subsys *ss,
>> struct cgroup *cont)
>> {
>> struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>> + /*
>> + * Don't allow memcg removal if we have HugeTLB resource
>> + * usage.
>> + */
>> + if (mem_cgroup_hugetlb_usage(memcg)> 0)
>> + return -EBUSY;
>>
>> return mem_cgroup_force_empty(memcg, false);
>
> Why can't you move the charges like everyone else?
>

Nevermind, just saw your last patch.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
