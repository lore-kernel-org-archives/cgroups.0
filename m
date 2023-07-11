From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unneeded return value of
 cgroup_rm_cftypes_locked()
Date: Tue, 11 Jul 2023 11:00:58 +0800
Message-ID: <27428e7d-e280-2f78-7856-056d4e174057@huawei.com>
References: <20230701073856.2095425-1-linmiaohe@huawei.com>
 <ZKxeke6SfBe37Jso@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ZKxeke6SfBe37Jso-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/7/11 3:40, Tejun Heo wrote:
> On Sat, Jul 01, 2023 at 03:38:56PM +0800, Miaohe Lin wrote:
>> The return value of cgroup_rm_cftypes_locked() is always 0. So remove
>> it to simplify the code. No functional change intended.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Applied to cgroup/for-6.6. Please feel free to follow up with the comment
> addition Michal suggested.

Should I send a v2 patch or a separate patch? Both is fine to me.

Thanks for your work.


