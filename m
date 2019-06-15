From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] mm: memcontrol: add cgroup v2 interface to read
 memory watermark
Date: Sat, 15 Jun 2019 09:20:04 -0700
Message-ID: <20190615162004.GG657710@devbig004.ftw2.facebook.com>
References: <0f1be041f8de95603753ffe989bd25069efa13bb.camel@mengyan1223.wang>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eX2SsF5NLCHpL5vWayCPj5W8iQ02n38k3DDKs0RQPsc=;
        b=r+pPrVqAooiurT+r/1q1YOmCwatUD8JpCV7NTTno22ito/5zCfh0NLhl4iMS76Apur
         od3597crTGgH49Iea/iv0Hn+0dlF/nDVBakGN4yUlzBbBCV7oNn3R/Bmj4uooW+AvzSq
         CoDrMHiPzNMxHFiIA2AVcMJEvoDu3Sre8J0jWQfHXmstDyO/JzqBUfsw3itDzLJSBcrs
         ygygJfj+TtVYs+wlFzjkcpQDIS/nIKFEb6axYc6x/QK0djwkF2fCJNAc/y61BV3vka5B
         8mAN5LXYOY+ViRwZe6TnrbIBxANgmaxXVVIjq7dZoY1LghPPCg6/kI93rpDyZAqEeGiF
         eErw==
Content-Disposition: inline
In-Reply-To: <0f1be041f8de95603753ffe989bd25069efa13bb.camel@mengyan1223.wang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xi Ruoyao <xry111@mengyan1223.wang>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dschatzberg@fb.com

On Sat, Jun 15, 2019 at 04:20:04PM +0800, Xi Ruoyao wrote:
> Introduce a control file memory.watermark showing the watermark
> consumption of the cgroup and its descendants, in bytes.
> 
> Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>

Memory usage w/o pressure metric isn't all that useful and reporting
just the historical maximum of memory.current can be outright
misleading.  The use case of determining maximum amount of required
memory is legit but it needs to maintain sustained positive pressure
while taking measurements.  There are efforts on this front, so let's
not merge this one for now.

Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
