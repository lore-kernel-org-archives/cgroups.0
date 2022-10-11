From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Don't increase effective low/min if no
 protection needed
Date: Tue, 11 Oct 2022 13:14:59 -0400
Message-ID: <b79d7f33-77b8-f200-5acd-1f3e5e37d00d@redhat.com>
References: <20221011143015.1152968-1-longman@redhat.com>
 <Y0WOPZxWSnUjzZ8e@dhcp22.suse.cz>
 <defdb421-342e-ebcb-d7f0-005559dd1e0d@redhat.com>
 <Y0WiIDmPPXYZuHpX@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665508504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MnvCQgz6H0YpLOGZ3RFU26i2x7EAPQhf8onHHyzectI=;
        b=OqcpOaijhtf4UMDVEYBCIrc0/XMa75pUroAcSrrVHb0rpgJnkbglmUB2Saa7hf/d2buAFX
        ttBFDhfNTX8k6S+z4nkG3ufN4BgjC7mw5AFFwJTobgBeXgUcjexx1HARe9eE5hV1sqFxe/
        KgiWzJFD68nSoI11gaa6+Gsmvp88/u8=
Content-Language: en-US
In-Reply-To: <Y0WiIDmPPXYZuHpX-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>


On 10/11/22 13:04, Tejun Heo wrote:
> On Tue, Oct 11, 2022 at 01:00:22PM -0400, Waiman Long wrote:
>> You are right about that. An alternative way to address this issue is to
>> disable memory low event when memory.low isn't set. An user who want to
>> track memory.low event has to set it to a non-zero value. Would that be
>> acceptable?
> Wouldn't it make sense to fix the test? With recursive_prot on, the cgroup
> actually is under low protection and it seems like the correct behavior is
> to report the low events accordingly.

Yes, that is another possible way of looking at that problem. Will talk 
to our QE people of doing that.

Thanks,
Longman

