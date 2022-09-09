From: Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH] mm/memcontrol: use kstrtobool for swapaccount param
 parsing
Date: Fri, 9 Sep 2022 16:15:04 +0800
Message-ID: <ee96ad93-e40b-6614-6cf7-b64bbc78ebc2@huawei.com>
References: <20220908083452.2844125-1-liushixin2@huawei.com>
 <20220908150248.85fff32bf275844f0927a856@linux-foundation.org>
 <YxrtODqHhdEkW2Lx@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <YxrtODqHhdEkW2Lx@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Kefeng Wang <wangkefeng.wang@huawei.com>



On 2022/9/9 15:37, Michal Hocko wrote:
> On Thu 08-09-22 15:02:48, Andrew Morton wrote:
>> On Thu, 8 Sep 2022 16:34:52 +0800 Liu Shixin <liushixin2@huawei.com> wrote:
>>
>>> --- a/mm/swap_cgroup.c
>>> +++ b/mm/swap_cgroup.c
>>> @@ -194,7 +194,7 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
>>>  	return 0;
>>>  nomem:
>>>  	pr_info("couldn't allocate enough memory for swap_cgroup\n");
>>> -	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
>>> +	pr_info("swap_cgroup can be disabled by swapaccount=[oO][Ff]/N/n/0 boot option\n");
>> I'm not sure this really needed changing.  "=0" was OK and the message
>> now looks rather silly.
> Agreed. While swapaccount=0 is clear the extended form, even if correct,
> might just confuse some admins.
Thanks, the previous info is more appropriate, I will update the patch.

