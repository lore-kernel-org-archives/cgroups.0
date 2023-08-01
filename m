From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor cleanup for cgroup_local_stat_show()
Date: Tue, 1 Aug 2023 15:48:09 +0800
Message-ID: <3ec1f5d9-4887-4583-a973-92298a9bc924@huawei.com>
References: <20230723031932.3152951-1-linmiaohe@huawei.com>
 <ZMBERCXR27X_gRAt@slm.duckdns.org>
 <ec3df402-7681-3d0c-b9ce-d50eb7383b1e@huawei.com>
 <719a19c4-3be5-2260-7349-b3f1bb774f4f@huawei.com>
 <ZMhIFUsxEtA_B781@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ZMhIFUsxEtA_B781-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/8/1 7:47, Tejun Heo wrote:
> On Thu, Jul 27, 2023 at 07:50:11PM +0800, Miaohe Lin wrote:
>> On 2023/7/26 9:06, Miaohe Lin wrote:
>>> On 2023/7/26 5:53, Tejun Heo wrote:
>>>> On Sun, Jul 23, 2023 at 11:19:32AM +0800, Miaohe Lin wrote:
>>>>> Make it under CONFIG_CGROUP_SCHED to rid of __maybe_unused annotation.
>>>>> Also put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED as it's only
>>>>> called when CONFIG_CGROUP_SCHED. No functional change intended.
>>>>>
>>>>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>
>>>> Patch doesn't apply to cgroup/for-6.6. Can you please respin?
>>>
>>> Sure. Will resend the patch based on cgroup/for-6.6.
>>
>> The commit "sched: add throttled time stat for throttled children" is still in the linux-next tree. So I think I have
>> to wait for it to be merged into cgroup tree first.
> 
> You can just send the patch against cgroup/for-6.6 branch. We can sort out
> the merge conflicts later.

Do you mean send the patch against cgroup/for-6.6 branch assuming commit "sched: add throttled time stat for throttled children"
has been merged into cgroup/for-6.6 branch? It seems the current code in that branch is fine itself.

Thanks for your advice.


