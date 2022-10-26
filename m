From: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Wed, 26 Oct 2022 13:19:48 +0530
Message-ID: <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
References: <20221026074343.6517-1-feng.tang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pQJixVHnlAul0yFSM31Yvmc1HRdeg37EuUqq5B4xUPM=;
 b=GQYEuDNQIv8Lujd9toSQ/YuG+1uJiI1etr3dbEemHsirIHqfQoYLUM+pIIy268TijR72
 EC9+nX5knhijqlrD7U1RDJXM8X0R2pb7mwqlxSy8x0oSPyLlxuE2KPeyhSoNT7CP8sAg
 mGKOEAIlpJ1h4kiC1j2EuXqY1T9HQIRawX8Z9Eh7mio1WY6A1GCGBlyCJTna0kR+SzAM
 ocsdLdypbrKb9xQDhYXI05h2sFek3poR1c4WQcjt99mWQktdOqN632YrtlyeDGliC8pW
 0e/RVqgZm4ham6jAMf1ACkfCq/B3zWjuElOJEB6WDntv7TQ0eQWpAc941ZHxfcTHfKqA YA== 
Content-Language: en-US
In-Reply-To: <20221026074343.6517-1-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On 10/26/22 1:13 PM, Feng Tang wrote:
> In page reclaim path, memory could be demoted from faster memory tier
> to slower memory tier. Currently, there is no check about cpuset's
> memory policy, that even if the target demotion node is not allowd
> by cpuset, the demotion will still happen, which breaks the cpuset
> semantics.
> 
> So add cpuset policy check in the demotion path and skip demotion
> if the demotion targets are not allowed by cpuset.
> 

What about the vma policy or the task memory policy? Shouldn't we respect
those memory policy restrictions while demoting the page? 

-aneesh
