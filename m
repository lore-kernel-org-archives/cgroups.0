From: Tejun Heo <tj@kernel.org>
Subject: Re: memcg/cgroup: do not fail fail on pre_destroy callbacks
Date: Mon, 29 Oct 2012 16:26:02 -0700
Message-ID: <20121029232602.GF4066@htj.dyndns.org>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FiqSyIXiPwbDGT4wzNBvgujJevB3jr0FmQOcuIcg/Ek=;
        b=WObyup9uppXz8vNDzxwTgoRB+rKbq72e2eYbF8Zg+7GEK5zCCFxU1QFO9HoVCOQmH7
         dVuCPnZ+/oYRLwbrrlyadlcsNhN5BL/g8jSbwPaxCsIejwAZHQ4UAo6lWihQDfFZqPHR
         in/9i8ASKFF7EMq7TCZ86v2cXA0QJoQv4BzVfFX7R5WxFNWTbqaKEXP8fhArVBf1SF8Z
         5zgVeEaznfNAt4Uey4J0Ump4MJ+fgwq4OtG6ppSqTsd5flp4Jce0+XVVh0+DmUwMFYTB
         +LFjB2t95beD50OPOxsNe6/Oer++x6K9KwIErfyvcQF83/nv0tMqfo9qFnKdnM6TypNI
         PyRg==
Content-Disposition: inline
In-Reply-To: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Glauber Costa <glommer@parallels.com>

Hello, Michal.

> Tejun is planning to build on top of that and make some more cleanups
> in the cgroup core (namely get rid of of the whole retry code in
> cgroup_rmdir).

I applied 1-3 to the following branch which is based on top of v3.6.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-destroy-updates

I'll follow up with updates to the destroy path which will replace #4.
#5 and #6 should be stackable on top.  So, Andrew, there's likely be a
conflict in the near future.  Just dropping #4-#6 till Michal and I
sort it out should be enough.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
