From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/rstat: record the cumulative
 per-cpu time of cgroup and its descendants
Date: Wed, 2 Aug 2023 11:39:41 -1000
Message-ID: <ZMrNHf2tg8AZ2F0z@slm.duckdns.org>
References: <20230717093612.40846-1-jiahao.os@bytedance.com>
 <ZLWb-LsBD041hMvr@slm.duckdns.org>
 <2655026d-6ae4-c14c-95b0-4177eefa434f@bytedance.com>
 <ZLcJ1nH8KzWzoQWj@slm.duckdns.org>
 <b4424767-dce7-08a9-3759-43cc9dfa4273@bytedance.com>
 <3d2b68bf-9f40-c779-dcfd-4cf9939edecc@bytedance.com>
 <ZMKs_GpHEW6Pfusj@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691012384; x=1691617184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dg1csT6sQap9Rjj/9a7I+zdOC12NSKIzfI8UlxG6Z6s=;
        b=D5od+G8Q5l6okpcSGorDH8rVDi8dKCBthkqpfYBIBJlUCMIh9J5CpRVct3JKaQvA1B
         IOL7SasPOzvfL8/mSWNYFSsfFCQWNM5JxkOGVwAatzOmGjXIBKMplWnSyh0G8xhrJ2BM
         luNIHpVg2gOIh/cf9EmBsozBHMIWBgjLI8ckR675XgH16xGIs4qLRva01KuoNNRPl4kZ
         oOcthTE0Bt20SOx7bSL00SsleLB3chZI++TfTdJDvk80Z475KNWTj+/NlOOKhwdz6wo5
         yYKiBWxas6X63T8Vks8qHaljufFTCxBvS8BmXseG1AXraZZ6CUv8U3WDqygStNlRZWxa
         Z8rw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZMKs_GpHEW6Pfusj-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jul 27, 2023 at 07:44:28AM -1000, Tejun Heo wrote:
> Oh yeah, I do. I'm just thinking whether we also want to expose that in the
> cgroupfs. We are currently not showing anything per-cpu and the output
> formatting gets nasty with a huge number of CPUs, so maybe that's not going
> to work out all that well. Anyways, I'll get back to you next week.

I couldn't come up with an answer. Let's go ahead with adding the field but
can you please do the followings?

* Name it to something like subtree_bstat instead of cumul_bstat. The
  counters are all cumulative.

* Are you sure the upward propagation logic is correct? It's calculating
  global delta and then propagating to the per-cpu delta of the parent. Is
  that correct because the two delta calculations always end up the same?

* Please add a comment explaining that the field is not currently used
  outside of being read from bpf / drgn and what not and that we're still
  trying to determine how to expose that in the cgroupfs interface.

Thanks.

-- 
tejun
