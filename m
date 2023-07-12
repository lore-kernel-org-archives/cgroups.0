From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unneeded return value of
 cgroup_rm_cftypes_locked()
Date: Wed, 12 Jul 2023 10:02:41 +0800
Message-ID: <b197a86c-93bb-879e-34dc-f03c4e4f824c@huawei.com>
References: <20230701073856.2095425-1-linmiaohe@huawei.com>
 <ZKxeke6SfBe37Jso@slm.duckdns.org>
 <27428e7d-e280-2f78-7856-056d4e174057@huawei.com>
 <ZK3MR5liSMSrlKVm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ZK3MR5liSMSrlKVm-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/7/12 5:40, Tejun Heo wrote:
> On Tue, Jul 11, 2023 at 11:00:58AM +0800, Miaohe Lin wrote:
>> On 2023/7/11 3:40, Tejun Heo wrote:
>>> On Sat, Jul 01, 2023 at 03:38:56PM +0800, Miaohe Lin wrote:
>>>> The return value of cgroup_rm_cftypes_locked() is always 0. So remove
>>>> it to simplify the code. No functional change intended.
>>>>
>>>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>
>>> Applied to cgroup/for-6.6. Please feel free to follow up with the comment
>>> addition Michal suggested.
>>
>> Should I send a v2 patch or a separate patch? Both is fine to me.
> 
> Please send a separate patch.

I see. But since Michal is meant adding the reasoning to the commit message, it seems
a v2 patch is required. Or could you help modify the commit message? It should looks
like:

"
The return value of cgroup_rm_cftypes_locked() is always 0 and swallowing
errors on removal is fine because cgroup_addrm_files() won't fail at
removal. So remove return value to simplify the code. No functional
change intended.
"

Thanks a lot.



