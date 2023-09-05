From: Waiman Long <longman@redhat.com>
Subject: Re: [PATH] cgroup: add cgroup_favordynmods= command-line option
Date: Tue, 5 Sep 2023 15:06:05 -0400
Message-ID: <7ae52eec-0df3-9bef-e4f6-e33a1873c464@redhat.com>
References: <20230831142046.37177-1-luizcap@amazon.com>
 <20230905170318.GA16629@dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com>
 <af394f53-224d-baff-5c7d-87eff7fcaad2@redhat.com>
 <664019c3-c4b1-6603-7a3d-f44a81737178@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <664019c3-c4b1-6603-7a3d-f44a81737178@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Luiz Capitulino <luizcap@amazon.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lcapitulino@gmail.com


On 9/5/23 15:03, Waiman Long wrote:
>
> On 9/5/23 14:59, Waiman Long wrote:
>>
>> On 9/5/23 13:03, Luiz Capitulino wrote:
>>> On Thu, Aug 31, 2023 at 10:20:46AM -0400, Luiz Capitulino wrote:
>>>> We have a need of using favordynmods with cgroup v1, which doesn't 
>>>> support
>>>> changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
>>>> build-time is not an option because we want to be able to selectively
>>>> enable it for certain systems.
>>>>
>>>> This commit addresses this by introducing the cgroup_favordynmods=
>>>> command-line option. This option works for both cgroup v1 and v2 and
>>>> also allows for disabling favorynmods when the kernel built with
>>>> CONFIG_FAVOR_DYNMODS=y.
>>>>
>>>> Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
>>> Hi,
>>>
>>> Would somebody take a look at this patch please?
>>>
>>> Thanks,
>>>
>>> - Luiz
>>
>> The patch looks good to me. I do have a minor comment that it may be 
>> better to use the relatively new __ro_after_init qualifier instead of 
>> __read_mostly.
>>
> With this patch, CGROUP_FAVOR_DYNMODS kconfig option will have no 
> user. So this config option should be removed as well.

My bad. That is not true. Please ignore this comment.

Regards,
Longman

