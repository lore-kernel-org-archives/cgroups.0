From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.14] cgroup: consolidate file handling
Date: Thu, 5 Dec 2013 12:26:14 -0500
Message-ID: <20131205172614.GC24062@mtj.dyndns.org>
References: <1385595759-17656-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=upy8gRhMuWvFCvNLZl2gO7cwY1BZefME79dfNJGKFAA=;
        b=0qeFb18eebRshkmKj1xafeGP+0kYdc93VQ931/g/alX4uQafVkHUyO3Rsrr5rcUqC5
         sTbvjw0ng+ZCsX7aDddZXMvhY9p9U9vr0lHqnczsFs4Boz4b3laKGpkeLzqak1xBkaCe
         YEHTr1mlUDfpg290/u1i83YF1hrhvJ0w5qDV/8rY7UmRN7wprGhS6aGo49NNUihsOkuG
         aVEzAP+SZAJTIKGqMbObhmamNrIcCvlpXFt9w0ZFUAb4A0tCpSyH6ZCHE1tzdQEXiF88
         8zLPQlgxT1x29IrYwTFL7DDQl/S+EVB5FVWeKcjVyoNBuwsEp/hXGYWeKFesrIfohnWw
         o6RQ==
Content-Disposition: inline
In-Reply-To: <1385595759-17656-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Applying to cgroup/for-3.14.

Thanks.

-- 
tejun
