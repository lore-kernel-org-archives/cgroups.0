From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 11:01:24 -0700
Message-ID: <20120926180124.GA12544@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
 <20120926163648.GO16296@google.com>
 <50633D24.6020002@parallels.com>
 <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
 <50634105.8060302@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PzzudjHcYDYwSQeWAzjtywHI4R9pD13kslWW4Dvr2Zg=;
        b=LxMr2dNzmUtmF91mWEtvbTlEn7AFXIMhk4jYQ6YUZcKIvwnNimE2+4AUB+VmVCMTEB
         r5Kl/ZWSpuwPlOLx9rL24v7svtxZkm0Skpgv5+5MjfuD9q+KjhrERdkFKPel5xzUkubd
         tyDKFk3FWrJZMC8q6w1mk9wP2NsfhHWqO0sIvku5AJ1GrMv50PumNeiDRuZlW/84LiMO
         ENzyZ7kI9IUgIBXjfAjVrsvPNx7nQP/Ecy4J0AvzMKItMNCpLah6qSD21bhXjg5v0Spy
         8pLQQDcUH7Vlc1sxoVWanR8BtTFBeFykInKmMM0MeWP/gu17HhffC1/N4Vt6rBDsPkZT
         ChDQ==
Content-Disposition: inline
In-Reply-To: <50634105.8060302@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello,

On Wed, Sep 26, 2012 at 09:53:09PM +0400, Glauber Costa wrote:
> I understand your trauma about over flexibility, and you know I share of
> it. But I don't think there is any need to cap it here. Given kmem
> accounted is perfectly hierarchical, and there seem to be plenty of
> people who only care about user memory, I see no reason to disallow a
> mixed use case here.
> 
> I must say that for my particular use case, enabling it unconditionally
> would just work, so it is not that what I have in mind.

So, I'm not gonna go as far as pushing for enabling it unconditionally
but would really like to hear why it's necessary to make it per node
instead of one global switch.  Maybe it has already been discussed to
hell and back.  Care to summarize / point me to it?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
