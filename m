From: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: fix device private memcg accounting
Date: Fri, 9 Oct 2020 17:00:37 -0700
Message-ID: <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
References: <20201009215952.2726-1-rcampbell@nvidia.com>
 <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201009155055.f87de51ea04d4ea879e3981a-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602287990; bh=Us6utgoPebZq88AOhUuXmDuRmb+E4XSLkLaXZoYTNTE=;
        h=Subject:To:CC:References:From:X-Nvconfidentiality:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=iROueIQaQrO/x4pGQ5v6OqqoOKyMi9Es4tkR4HMVEI8xMT6oLWIWP6iq1upLtberH
         +6V4+BWrvHQyJK4yHkyI38Siwr1tQ9/smCkCqt5I2UKBXN4YDAF+qPxgMGkqOll4YM
         nhbaUlawwEgU59fLkN0y2u6KbDSicb5L5uOgIfvdZiIQBffNQzex1c5VkVSRaz4Rdy
         5eXSRS2/vAiMTd2L9aFXo3yM+4RCKevyPDwWuiNCrxl/pHo4+VAav6wyPgMQXMA1o6
         wTC2BxUgt6rkx4TpHUfXS15vpEkdJFr1JVNPAHHo8h/r6ZBaT6SjCJWgDGNv2wUq5R
         9LLlkYSx66hqQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 10/9/20 3:50 PM, Andrew Morton wrote:
> On Fri, 9 Oct 2020 14:59:52 -0700 Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
>> NULL before checking is_device_private_entry() so device private pages
>> are never handled.
>> Fix this by checking for non_swap_entry() after handling device private
>> swap PTEs.
>>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> I was going to ask "what are the end-user visible effects of the bug".
> This is important information with a cc:stable.
> 
>>
>> I'm not sure exactly how to test this. I ran the HMM self tests but
>> that is a minimal sanity check. I think moving the self test from one
>> memory cgroup to another while it is running would exercise this patch.
>> I'm looking at how the test could move itself to another group after
>> migrating some anonymous memory to the test driver.
>>
> 
> But this makes me suspect the answer is "there aren't any that we know
> of".  Are you sure a cc:stable is warranted?
> 

I assume the memory cgroup accounting would be off somehow when moving
a process to another memory cgroup.
Currently, the device private page is charged like a normal anonymous page
when allocated and is uncharged when the page is freed so I think that path is OK.
Maybe someone who knows more about memory cgroup accounting can comment?
