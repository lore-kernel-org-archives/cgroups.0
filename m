From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: clean up MAINTAINERS entries
Date: Mon, 19 May 2014 16:33:39 -0400
Message-ID: <20140519203339.GE27506@mtj.dyndns.org>
References: <20140513194958.GD28815@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KsVXT+OL16+YGGyL9NlmMCII9VYF9WO2RjmQC+LN48g=;
        b=jDdiqsY1Rcc+wjiI+ixGHU/Qxi3PtJzwBs9NIJog9YkHg+tFkbCfyA5nz/vjs734wG
         IHbfonc366fAZO4RzaSqQm3UEoT6UiXGh1SnG4PyOa4z/wvHgdKpyMiCHkUq5GP8lxIs
         ier9ICav6BGpx6uZ15gdD898/2w4y1dnqHPdMAVRvNNL36g47G2jJh6C//zqkFMPKYSq
         R75Qb82XJxvgEBj5jFareCkwWanmm9IhYz/zlW8tdW2pQYcTFb5LUfqeqPdFfvn7wZ1n
         LMt3O9DhSWsfBKcWfs3OTW/wCpHo327uw5kPD0hrxM5A86XjgOkNy6UNA0k0Oo42j16k
         lR1g==
Content-Disposition: inline
In-Reply-To: <20140513194958.GD28815-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Tue, May 13, 2014 at 03:49:58PM -0400, Tejun Heo wrote:
> There are currently three cgroup related entries in MAINTAINERS.  Make
> the following updates.
> 
> * Make the names - both cgroup and cpuset - singular.  We're mixing
>   singular and plural all over the place for no good reason.
> 
> * Drop containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org from CGROUP.  That list
>   doesn't have much to do with cgroup per-se.
> 
> * Add Documentation field to CGROUP.
> 
> * Drop mm/*cgroup* from CGROUP.  memcg has separate maintainers.
> 
> * Prefix the controller-specific ones with "CONTROL CGROUP -" and
>   collect cgroup related entries under the core one.
> 
> * Add (MEMCG) abbreviation to MEMCG entry.
> 
> * Drop Balbir Singh and KAMEZAWA Hiroyuki from memcg maintainers.  It
>   has been quite a while since both actually worked on memcg.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
