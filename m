From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-next] blk-cgroup: cgroup_rstat_updated()
 shouldn't be called on cgroup1
Date: Mon, 18 Nov 2019 08:41:14 -0700
Message-ID: <091022e8-e6a1-178d-80cd-b2a070d3519f@kernel.dk>
References: <20191107191804.3735303-1-tj@kernel.org>
 <20191107191804.3735303-6-tj@kernel.org>
 <cd3ebcee-6819-a09b-aeba-de6817f32cde@ti.com>
 <20191113163501.GI4163745@devbig004.ftw2.facebook.com>
 <20191114223128.GM4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LDK9yK9BoIJXiRshGH8S+ARb//vvA/0NHK9tQB/EqPk=;
        b=JaQ3lkdxJbg8bC1c3jS+KwvIPC4OYHwwfxOOr83yS4U4QDzFNnWNlZ/p8PuJ96np2E
         fSAKxEDc8Nlw46j0x8sDTkmy8rEIthr/WFem2d8bAl0iNj18msLAPp9+Qqw8SvjrYFOj
         3EJP2rizmnWjpUQ81QDQLHav2Tp5HVA4u81MwCU4l9mmA08xnqINakg2qQ0Qqif/jPDU
         cj76eJwfOZnRj3nWeBGiV/PEuiL0fSFQfPs36u/4sn+YKAJg5MIM0MMYKTeugndAPPka
         ajIMC8PlwEyo22uO2Ji9NNlBpygJnk5UjX4ca26Yx50OfsMWk84dbtjiEcKRS6BQEBNE
         yt5g==
In-Reply-To: <20191114223128.GM4163745@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Faiz Abbas <faiz_abbas@ti.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com, Dan Schatzberg <dschatzberg@fb.com>, Daniel Xu <dlxu@fb.com>

On 11/14/19 3:31 PM, Tejun Heo wrote:
> Currently, cgroup rstat is supported only on cgroup2 hierarchy and
> rstat functions shouldn't be called on cgroup1 cgroups.  While
> converting blk-cgroup core statistics to rstat, f73316482977
> ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
> accidentally ended up calling cgroup_rstat_updated() on cgroup1
> cgroups causing crashes.
> 
> Longer term, we probably should add cgroup1 support to rstat but for
> now let's mask the call directly.

Applied, thanks.

-- 
Jens Axboe

