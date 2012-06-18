From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
Date: Mon, 18 Jun 2012 21:19:32 +0800
Message-ID: <20120618131918.GA2600@kernel>
References: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com>
 <4FDF2890.3020004@parallels.com>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Du3IetLJWMGuJ5DPbobAzizL4fsqTJl7Ea5cZC/CW1k=;
        b=sQ1pENiNcRzVAdiDTVFnXQI+NCo+8d0U3gvfRHqWK77wXLRMbWMUzY10OnciV+YumF
         tGw0P6ABygZjrwjrkxgY+leoxygEGFB1uo4uvR6pseVbaPeMAVyXeW2+7NpThNCgY/VR
         b6hRYhOa/6lCo5e/obozmOJRNfp6k6X/KmdTl6aRiypmB6pfbRcao/pkhqa5Z+6NqzMZ
         6buBX+ndVTYIgiyftG2GgZEZ1sgI5HoG1j16FRxweIOc8l925amri/yeegnQb3EuOkK1
         AslrGDbYkHyVU9Yze4KMXteCaE4mem7jeexwiFeQg35ed9Udf6zh9CbgUn4a0bO0EsDh
         EpFA==
Content-Disposition: inline
In-Reply-To: <4FDF2890.3020004-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jun 18, 2012 at 05:09:36PM +0400, Glauber Costa wrote:
>On 06/18/2012 05:10 PM, Wanpeng Li wrote:
>>From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>
>>move_charge_at_immigrate feature is disabled by default. Charges
>>are moved only when you move mm->owner and it also add additional
>>overhead.
>
>How big is this overhead?
>
>That's hardly a fast path. And if it happens to matter, it will be
>just bigger when you enable it, and the compiler start giving the
>wrong hints to the code.

Thank you for your quick response.

Oh, Maybe I should just write comments "move_charge_at_immigrate feature
is disabled by default. So add "unlikely", in order to compiler can optimize."

Best Regards,
Wanpeng Li

>--
>To unsubscribe from this list: send the line "unsubscribe cgroups" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
