From: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH] memcg: implement low limits
Date: Wed, 27 Feb 2013 14:39:36 +0400
Message-ID: <17521361961576@webcorp1g.yandex-team.ru>
References: <8121361952156@webcorp1g.yandex-team.ru> <20130227094054.GC16719@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1361961576;
	bh=hQUZYxKzfay3hyVwdCL3emFf4OVi/BI0FF/IqwHZgZE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ACCra2BuWWF7OD8QBiSaATku+oYz0vW87+rl/TqfaSli8J26i01rlxfiOIMMQrNIv
	 Ci4Yxl8+uCfGazAYas1wsuBPr52jqjhRJl58I2/ibX1pGZfn6+3wSthtb212m/mXGq
	 HukSzQ4vQpsDffAss6NTg2BDRZbmTzKQ0xJUxxEY=
In-Reply-To: <20130227094054.GC16719-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner-Arquette <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org" <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

27.02.2013, 13:41, "Michal Hocko" <mhocko-AlSwsSmVLrQ@public.gmane.org>:
> Let me restate what I have already mentioned in the private
> communication.
>
> We already have soft limit which can be implemented to achieve the
> same/similar functionality and in fact this is a long term objective (at
> least for me). I hope I will be able to post my code soon. The last post
> by Ying Hand (cc-ing her) was here:
> http://comments.gmane.org/gmane.linux.kernel.mm/83499
>
> To be honest I do not like introduction of a new limit because we have
> two already and the situation would get over complicated.

I think, there are three different tasks:
1) keeping cgroups below theirs hard limit to avoid direct reclaim (for performance reasons),
2) cgroup's prioritization during global reclaim,
3) granting some amount of memory to a selected cgroup (and protecting it from reclaim without significant reasons)

IMHO, combining them all in one limit will simplify a kernel code, but will also make a user's (or administrator's) 
life much more complicated. Introducing low limits can make the situation simpler.

>
> More comments on the code bellow.

Thank you very much!
I'll address them in an other letter.

--
Regards,
Roman
