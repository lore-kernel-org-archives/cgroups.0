From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] cgroup: Make debug controller useful for debugging
Date: Wed, 14 Jun 2017 16:08:35 -0400
Message-ID: <20170614200842.15174-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=0tGrShKj0H8ewTWTjkx+Fetd40GY3M2vvFIFYYW+Zkc=;
        b=eOwjkUfYDQoMC/5kG7l4kkeVf0hX1M3RDonx+XLOZmnEd7UcitY15PCmkCEn0mZTx8
         kowaidDgtVyo6TvRM/f8VnA20J1Ozk3JpRWuSvbiIix1mJ6LwgnasGVqiu9pYH8oI/GD
         osgo9Gls++U9Le4YG9FkV05WIw0dUbfRklL/PXwgAIGalxCwsROBO6OTs7MOSpujK+Mm
         wd0NRaBUrX2oN/uBXkcYrbeICzaUnI1H2Q668jq7ueYK2EXefnaMloXXcSK/meRRPwfn
         QIqB6GmIkDIag164ura6mAvhVNs98z06FAloBFAUciTLBkSs6H8Q77bWPqvGFI4H4ia8
         hVAA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Waiman.

I dropped the thread mode part of the patches so that these aren't
blocked on thread mode, made the debug controller an implicit one on
cgroup2 which is enabled by "cgroup_debug" boot param (we can't mask
it on cgroup1 with the boot param at this point), and fixed the
lockdep warnings.

I applied the updated patches + follow up changes to cgroup/for-4.13.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.13

I'd really appreciate if you can go over the patches and check that I
didn't do anything stupid.

Thanks.

--
tejun
