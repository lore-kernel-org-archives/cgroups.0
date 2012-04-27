From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7 v2] memcg: prevent failure in pre_destroy()
Date: Fri, 27 Apr 2012 11:16:42 -0700
Message-ID: <20120427181642.GG26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JzlwyUi7ThudR+T0wi6wZClBGXkAMc4KB6a0hRWnCKA=;
        b=ElIRBLfCZzzAiN67DsnNPDgy3WwQQ/ciXpNN6TUcJXRjPa8VI+5uGvjNgdtgrpiQEx
         RqCvIYq0tiOXFZQleADppmPcqUbCu08H7P0pJoIgcgnXTwLnO2fIw5e9V+pBqIR945/V
         2i+oEZguK62qXNeAYPqwl245ZyFjX+w1nEfuhUNWNNmINt2yXuXwubYfQExErw1ZZcGh
         einU+qAxA3ysvByE4tyYHCI0gCqjusOsC/HpzKwqCEQBiMpWh4OU6K42NxJ2kWVnQGO8
         36uMocJGo6Rx+82+PzEh1SHoCu6qWtKBd1IsGHcwn+JwYZSLgfxl2MK911kR46uE7yQ+
         JFIA==
Content-Disposition: inline
In-Reply-To: <4F9A327A.6050409-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

On Fri, Apr 27, 2012 at 02:45:30PM +0900, KAMEZAWA Hiroyuki wrote:
> This is a v2 patch for preventing failure in memcg->pre_destroy().
> With this patch, ->pre_destroy() will never return error code and
> users will not see warning at rmdir(). And this work will simplify
> memcg->pre_destroy(), largely.
> 
> This patch is based on linux-next + hugetlb memory control patches.

Ergh... can you please set up a git branch somewhere for review
purposes?

Thanks.

-- 
tejun
