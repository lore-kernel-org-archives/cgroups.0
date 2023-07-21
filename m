From: "Haitao Huang" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/misc: Change counters to be explicit 64bit
 types
Date: Thu, 20 Jul 2023 21:48:39 -0500
Message-ID: <op.18evfdcdwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <ZLWmdBfcuPUBtk1K@slm.duckdns.org>
 <20230718010845.35197-1-haitao.huang@linux.intel.com>
 <20230718010845.35197-2-haitao.huang@linux.intel.com>
 <ZLcXmvDKheCRYOjG@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689907722; x=1721443722;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=XKjWZfAaaEnKwxsr5tOMCJ5LqOzSg2spiv8E+t92fOw=;
  b=TS/CyM6o0KCtj7nPPsuesZzwRP1czDuKGKv5Awn3uUuk57lh0ZPVHxqD
   m92P1it0v+MIyh6jAfkXPz/WBu6C80NjWAxNFb/3TTC7waUyT+JxKd+N5
   xnbNH7LieWUs+uXgC0B0fRdL7Zs3zUwvEd2Te3crFBsjDbJOuOY0BDdnY
   83ThfpgeGfX5E+qlWkIjchq6gtjAojNN4zZNjUi9MnbhRtcdYffznDRAF
   4HMcOn1cuB2G/M9LoLr0rmzaG5KF/huZhftoLH9Ez4czrCt6GXpOgvTyo
   yPKt7TZ3Vqa6wJYw9qgdNJqirzSK68Q7MOVmnu1FUf9of/rPlecXRFied
   w==;
In-Reply-To: <ZLcXmvDKheCRYOjG-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

Hi
On Tue, 18 Jul 2023 17:52:10 -0500, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Mon, Jul 17, 2023 at 06:08:45PM -0700, Haitao Huang wrote:
>> So the variables can account for resources of huge quantities even on
>> 32-bit machines.
>>
>> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> Applied to cgroup/for-6.6 with some whitespace adjustments. I think the  
> code
> is broken when we cross the signed boundary but that's not a new problem
> caused by your patch. I think what we should do is to treat atomic64_t  
> reads
> as u64 instead of putting it in s64.
>

Thanks. I think you meant the 'new_usage' in try_charge.
I'll send a patch.
BR
Haitao
