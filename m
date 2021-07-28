From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Wed, 28 Jul 2021 05:38:39 -1000
Message-ID: <YQF5/8Zb/iY5DS7f@mtj.duckdns.org>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
 <YP8ovYqISzKC43mt@mtj.duckdns.org>
 <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18@gmail.com>
 <YQA1D1GRiF9+px/s@mtj.duckdns.org>
 <ca2bdc60-f117-e917-85b1-8c9ec0c6942f@gmail.com>
 <YQEKNPrrOuyxTarN@mtj.duckdns.org>
 <ed8824d5-0557-7d38-97bd-18d6795faa55@gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DHb1viiq/M1erLr2X07zcQ77mhbJoJfUhPFzGDRbbgk=;
        b=eCuSx67rfqyMOyriSQb1ffa/WuN7WKoJYkCifLb4icEiL3Na9lr1lgBva/EV3IsW1j
         SC9BTzDRtxiJrFSJabc9C2jIqi0Mtyl42GPLBULan6SY56jK364YbFbOJwS4pR5ae3Ts
         azWrICO+Ts7LoJwkmgYNcXI6IS6OqjD5CA9ohdhhq3ob/kql5wHVkXBi5alr5MqT4tg+
         NWm0++pZ/XJbL04cDL4YZR6SS/6TqRu82e98h8+C6Q9DdnxJNxiK73ypXVpVYAmrCnko
         GgOoPUP/0ncWvxHFncNrSuribzkOrjsWtplELgnujfG+9iWLyn1es1Q6WMNsem+f7lWO
         X0tQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ed8824d5-0557-7d38-97bd-18d6795faa55@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: viro@zeniv.linux.org.uk, lizefan.x@bytedance.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Wed, Jul 28, 2021 at 05:47:05PM +0800, brookxu wrote:
> But considering stability issues(k8s), There are still many production environments use
> cgroup v1 without kmem. If kmem is enabled, due to the relatively large granularity
> of kmem, this feature can also prevent the abnormal open behavior from making the entire
> container unavailable? but I currently do not have this scenario.

Now we are repeating the same points. This simply doesn't justify adding a
user-facing feature that we have to maintain for eternity.

Thanks.

-- 
tejun
