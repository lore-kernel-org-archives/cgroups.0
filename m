From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 4/7] cgroup: cgroup v2 freezer
Date: Tue, 20 Nov 2018 10:05:20 -0800
Message-ID: <20181120180520.GZ2509588@devbig004.ftw2.facebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-5-guro@fb.com>
 <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
 <20181120163304.GA21462@tower.DHCP.thefacebook.com>
 <20181120163604.GX2509588@devbig004.ftw2.facebook.com>
 <20181120164349.GB21462@tower.DHCP.thefacebook.com>
 <20181120164859.GY2509588@devbig004.ftw2.facebook.com>
 <20181120173858.GC21462@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P3GqPkO2lYkTGily+voGd+zaChSnpbMaoctm3VXIpgk=;
        b=causubHdPnUhSDv/ISzoaFvFGS46PBzlZpf976UTnSjl3c2LhMmWXr2T7skAJuNC8B
         dsjOPJIntx4v7/K1noE5BjSIQXZrDIqzGoXX09Y5btaEV/QPm3DzWqTLtuUj8pSuMwds
         D6L0JQ6OrD2z3JZwHeGSvPqGiZMPBj/1hbABPFg5azkIZKGbVUuv/zbLowf3c7KiG+ZX
         BuKBO4JES74/LhLG4VgWiohPd4lPbS2ftDD7vgiMHpNdj+TSUpRc8sjKDTj35RS6THpB
         q50lTuBCn4/2yRxdbk5s3q4gN0bTXxCx53vcw41YpW25ocKH4mGES1pTL4lSowgU5eIz
         GLvg==
Content-Disposition: inline
In-Reply-To: <20181120173858.GC21462@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

Hello,

On Tue, Nov 20, 2018 at 05:39:03PM +0000, Roman Gushchin wrote:
> Yeah, it's a good point. I've thought about it mostly in the fork() context,
> where if freezing of a cgroup races with fork(), it makes no sense to
> switch the cgroup state back and forth. But that case is different, as
> the child will be trapped just on the return path from fork() call.

I think it'd be best to tie the task counter transitions to cgroup
state update and propagation so that the state is always reflective of
the task states.

Thanks.

-- 
tejun
