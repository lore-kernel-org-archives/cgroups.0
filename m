From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file
 handling
Date: Mon, 2 Apr 2012 13:02:33 -0700
Message-ID: <20120402200233.GB17175@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <4F741AED.6090901@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wv91NWIyNXdqVrz/CkqmKUsW4ANEGiVNVI7XJH2jaJc=;
        b=x8hqjPnYbRvGGiqikBghrhWa5HJgQHsHWHgKzydCZoweaOYSZBb3lsVTC60bquG4d2
         jJW0H1qze1bnGpEmKPYOT92ZSJRsyQG3c1opk/GnxSvJuci6Y4djUM6DikKWI9sA2m2P
         9CBzw8imH5Saq+zPIb78EIgoqSLQW4l76D/cwY66f9CCzQQKDYfVtzdmRWON3+fFH8Os
         tRf+uL6NhbDrQK0NmMpUGKKUvlNsgYkJf0ZXIXQp2GlQFg//3iGb75JFp1WI6XonRtxC
         4fQYnNwBrfXTwUzrPmQO/J9YdIbpt/aT+ZiDW1YdC3CdaIVq+jIuQYK9MuOC7jOOyG1l
         264w==
Content-Disposition: inline
In-Reply-To: <4F741AED.6090901-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hey, Jens.

On Thu, Mar 29, 2012 at 10:18:53AM +0200, Jens Axboe wrote:
> The diffstat is very tasty... I'll leave this on out until the cgroup
> merge mess is settled, though.

The following branch contains this patchset on top of the current
block/for-3.5/core 959d851caa "Merge branch 'for-3.5' of ../cgroup
into block/for-3.5/core-merged".

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-files

Other than $SUBJ update on the eigth patch from "blkcg:
blkg_conf_prep()" to "blkcg: simplify blkg_conf_prep()", the patchset
can be applied as-is on top of the current block/for-3.5/core.

Thanks.

-- 
tejun
