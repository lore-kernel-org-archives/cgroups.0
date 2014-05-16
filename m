From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-3.16] cgroup: introduce CSS_NO_REF and skip
 refcnting on normal root csses
Date: Fri, 16 May 2014 13:23:56 -0400
Message-ID: <20140516172356.GH5379@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
 <1399670015-23463-10-git-send-email-tj@kernel.org>
 <53751062.2050401@wwwdotorg.org>
 <53753823.2090402@wwwdotorg.org>
 <20140516143718.GA5379@htj.dyndns.org>
 <20140516154330.GB5379@htj.dyndns.org>
 <537643F9.1030303@wwwdotorg.org>
 <20140516170959.GG5379@htj.dyndns.org>
 <5376489C.9010902@wwwdotorg.org>
Mime-Version: 1.0
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nAiBD2HATxoGlEswxrl24qznQkd0fuL2T6+K2c1Q8Rc=;
        b=McSYG3iOtxzP7sN4A0R02BYii7vGNyeOzU1vX4fWRJj+a4PYXgR0dlZZwXsH2I5EtY
         9xUDBi18/OZMdz1WBLu9MrZGpfl9YN3x7bww3OVgVkOq0nt3cWxVodxvf9MqehIcz9/B
         f+WQdTzhEtsbrqi2zQcM0Duw4LBb/ZDiL+9w5S9jkYcUZbiemgxm8kKAv4/DgDSxZfFo
         p2O6As/h+1U9dIzv/hD/JghrH+k3VyVxeGmm56ELuyeALTTNZ9Huz0lymQCJFnwFO5hT
         EuYh4Sp7A71ruAftAHGFWq5z2/VdbFU41b7ktVUYUxV66GOQbTN9iJemC9AIsXhGsGmq
         vI3Q==
Content-Disposition: inline
In-Reply-To: <5376489C.9010902-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ARM kernel mailing list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

On Fri, May 16, 2014 at 11:19:24AM -0600, Stephen Warren wrote:
> On 05/16/2014 11:09 AM, Tejun Heo wrote:
> > Can you try this one instead?
> 
> Yes, this one works great, thanks.
> Tested-by: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Thanks, I reverted the original one and applied the updated one w/
your Tested-by tag added.

-- 
tejun
