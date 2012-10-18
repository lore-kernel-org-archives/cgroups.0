From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] memcg: split mem_cgroup_force_empty into
 reclaiming and reparenting parts
Date: Thu, 18 Oct 2012 14:56:07 -0700
Message-ID: <20121018215607.GN13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-2-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KVzf7wBisjE7iRHoRaXKH5tr4hkk9PEtf3LpDPF9UDA=;
        b=sU+nHDpu3OzGiCxfV6gW1nLEqOcALkcblXNWsvDrjIdWnR5bP0BMGGI5EoKwOzy2Ok
         BqAJ1O8zzhgRAe1EiN2V3euaWt+L7Rxvp58BAEOyWX3m3Pe3tOZBN+8Im/SmPLWMoGFE
         CmMazxGCzD5Ek4dwuHCg6oCPIVKhVOWzhM7k4OTO2QZA4c1Reotm1AiNve6zxtY82QB3
         LMohX6tYl4v3ftKAgfPEcjp7O+H6VgSLT46Ljc88qM5dggKS4rh+H1wqBHXry2gcFVhY
         o/cvJcem1N5giQGu461QqCXAjXgnz3vcVTbL+nncmcsfMijSLFv+nsXU9Fm+TAcLHiNf
         BD9A==
Content-Disposition: inline
In-Reply-To: <1350480648-10905-2-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

On Wed, Oct 17, 2012 at 03:30:43PM +0200, Michal Hocko wrote:
> mem_cgroup_force_empty did two separate things depending on free_all
> parameter from the very beginning. It either reclaimed as many pages as
> possible and moved the rest to the parent or just moved charges to the
> parent. The first variant is used as memory.force_empty callback while
> the later is used from the mem_cgroup_pre_destroy.
> 
> The whole games around gotos are far from being nice and there is no
> reason to keep those two functions inside one. Let's split them and
> also move the responsibility for css reference counting to their callers
> to make to code easier.
> 
> This patch doesn't have any functional changes.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
