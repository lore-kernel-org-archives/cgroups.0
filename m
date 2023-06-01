From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [PATCH v4 4/4] sock: Remove redundant cond of memcg pressure
Date: Thu, 1 Jun 2023 17:21:29 +0800
Message-ID: <1fb805bc-baef-ee09-fa3a-d464af94751f@bytedance.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
 <20230530114011.13368-5-wuyun.abel@bytedance.com>
 <db32243e6cb70798edcf33a9d5c82a8c7ba556e2.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685611297; x=1688203297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+SifIOg3EEC6zrsKMH+AeZTstzDtSY/mgHTMqEQiv+Y=;
        b=dPwWBIklySlVaBz8aeBqewiIOE0jlHpvIS+F8E+hS9vGXogaqy82OoWltppnH3cRu/
         cyVh89Z0tPzL4LiipOoWMj4kULvV1bjyF1ODgZcwRTHTwQP4wrdSZClAe+2yEZO5k0KG
         +xy52vL/CfNLcNbysVWiRQd2lBmFYYGdgUkRcFn06ca4weGv8vtbQLFOD98a5NvIU1h8
         3MMB9BB/QjJxePr73CbAcbJzyv86gEBsA3+TZogVj5nah9tD21ixe85Q43JaHlS5rvph
         JVLX9nxUx/CXzwXX6QAm7DNMOtv7MqwDiP8ypsAIRfUR7z3NRA2elUGaSxSyHZbcqIrK
         +lMQ==
Content-Language: en-US
In-Reply-To: <db32243e6cb70798edcf33a9d5c82a8c7ba556e2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Simon Horman <simon.horman-JqlR5BE4aJhWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/1/23 5:10 PM, Paolo Abeni wrote:
> On Tue, 2023-05-30 at 19:40 +0800, Abel Wu wrote:
>> Now with the previous patch, __sk_mem_raise_allocated() considers
>> the memory pressure of both global and the socket's memcg on a func-
>> wide level,
> 
> Since the "previous patch" (aka "sock: Consider memcg pressure when
> raising sockmem") has been dropped in this series revision, I guess
> this patch should be dropped, too?

Yes indeed, these two patches should go together. Sorry for my
carelessness.

> 
> Is this targeting the 'net-next' tree or the 'net' one? please specify
> the target tree into the subj line. I think we could consider net-next
> for this series, given the IMHO not trivial implications.

Got it, I will resend this series based on net-next.

Thanks!
	Abel
