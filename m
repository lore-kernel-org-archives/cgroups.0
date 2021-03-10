From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Wed, 10 Mar 2021 12:26:38 +0300
Message-ID: <e1d40d68-4ba4-8de1-ee04-c644b6f771fe@virtuozzo.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <YEfc9uCc8sfs7ooT@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWWaYVLPJdPQFobd7qBOUoO35ucTbEpZaavQEamL6yU=;
 b=NFRVRTAp2qY4bU3XD03rJ/nKFU++GkcknT2licYvsn5+04tipP5uc/mTkfDqsHxmeK1AIs80yNdS+8flExVtIlMmd90JtzrcOFvj7OQy3gRzJ2E1creE9AGgu5zwJhPtiHvH2j1fF9bG7PauuiOGT2mZwrNcSq+EZgx8nXw8m/E=
In-Reply-To: <YEfc9uCc8sfs7ooT-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 3/9/21 11:39 PM, Roman Gushchin wrote:
> On Tue, Mar 09, 2021 at 11:03:48AM +0300, Vasily Averin wrote:
>> in_interrupt() check in memcg_kmem_bypass() is incorrect because
>> it does not allow to account memory allocation called from task context
>> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
>>
>> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> 
> Good catch!
> 
> It looks like the bug was there for years: in_interrupt() was there since
> the commit 7ae1e1d0f8ac ("memcg: kmem controller infrastructure") from 2012!
> So I guess there is no point for a stable fix, but it's definitely nice to
> have it fixed.

I did not noticed that this problem affect existing allocation,
I just found that it blocked accounting of "struct fib6_node" in __ip6_ins_rt() 
added in my current patch set. So I do not think it should went to stable@.

Thank you,
	Vasily Averin
