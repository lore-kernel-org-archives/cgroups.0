From: "Haitao Huang" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 15:19:38 -0500
Message-ID: <op.178te0tbwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230717184719.85523-1-haitao.huang@linux.intel.com>
 <CU4OCLEHU1S5.359W394902648@seitikki> <ZLWPN_xyGFrqqJkV@slm.duckdns.org>
 <op.178pr1qewjvjmi@hhuan26-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689625182; x=1721161182;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=S09jmTQ/NZNijcZ2es5DpthxzTjKbOVrCRQMBqh1UUk=;
  b=f5GI2ChHAsI/eYh7FM8FcMTumP5BAQHfsXWe1dQdv56XNEZlJnpeS2RT
   Rpgwbuv9op9jUrpox/BATorW/AX++GGElA+ApM7StOjgNTtCcZsQwrkfp
   XN3k8NgEeB00/+iPy7sivFJP6D7Lt56EHd/coOyv2OIWZuTLvyG52Kk4U
   wLkRDN5Q3iZ224BmZMn52QCA3CHUA2ZESfWnvhr32CtlNOOcZC2hO/Hj7
   e6NQVq4GCOwHcIpsq8i9M8k09Mx+JG8y+p6LI7HLHgVOYARxw1F/7DW94
   mQh79C0SZ4yr+r/Z65eq5xn+FRnNL4ZK3mCJ/KPh+aQqP+57tNEKPBvIg
   A==;
In-Reply-To: <op.178pr1qewjvjmi-yDQzE4XY+yVaPPhiJ6yCxLKMmGWinSIL2HeeBUIffwg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

On Mon, 17 Jul 2023 14:01:03 -0500, Haitao Huang  
<haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> On Mon, 17 Jul 2023 13:57:59 -0500, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>> On Mon, Jul 17, 2023 at 06:55:32PM +0000, Jarkko Sakkinen wrote:
>>> On Mon Jul 17, 2023 at 6:47 PM UTC, Haitao Huang wrote:
>>> > The variable 'new_usage' in misc_cg_try_charge() may overflow if it
>>> > becomes above INT_MAX. This was observed when I implement the new SGX
>>> > EPC cgroup[1] as a misc cgroup and test on a platform with large SGX  
>>> EPC
>>> > sizes.
>>> >
>>> > Change type of new_usage to long from int and check overflow.
>>> >
>>> > Fixes: a72232eabdfcf ("cgroup: Add misc cgroup controller")
>>> > Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>> >
>>> > [1]  
>>> https://lore.kernel.org/linux-sgx/20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
>>> > ---
>>> >  kernel/cgroup/misc.c | 6 +++---
>>> >  1 file changed, 3 insertions(+), 3 deletions(-)
>>> >
>>> > diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
>>> > index fe3e8a0eb7ed..ff9f900981a3 100644
>>> > --- a/kernel/cgroup/misc.c
>>> > +++ b/kernel/cgroup/misc.c
>>> > @@ -143,7 +143,7 @@ int misc_cg_try_charge(enum misc_res_type type,  
>>> struct misc_cg *cg,
>>> >  	struct misc_cg *i, *j;
>>> >  	int ret;
>>> >  	struct misc_res *res;
>>> > -	int new_usage;
>>> > +	long new_usage;
>>> >
>>> >  	if (!(valid_type(type) && cg &&  
>>> READ_ONCE(misc_res_capacity[type])))
>>> >  		return -EINVAL;
>>> > @@ -153,10 +153,10 @@ int misc_cg_try_charge(enum misc_res_type  
>>> type, struct misc_cg *cg,
>>> >
>>> >  	for (i = cg; i; i = parent_misc(i)) {
>>> >  		res = &i->res[type];
>>> > -
>>>
>>> This is extra noise in the patch, please remove the change.
>>
>> Lemme just revert it. Haitao, can you instead make the resource  
>> counters and
>> all related variables explicit 64bit instead?
>>
>
> Will do.

Actually, we are using atomic_long_t for 'current' which is the same width  
as long defined by arch/compiler. So new_usage should be long to be  
consistent?

ditto for event counter. Only max is plain unsigned long but I think it is  
also OK as it only compared with 'current' without any arithmetic ops  
involved.
Did I miss something here?
Thanks
Haitao
