From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] ext4: implement cgroup
 writeback support
Date: Thu, 16 Jul 2015 15:40:58 -0400
Message-ID: <20150716194058.GZ15934@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <20150712180520.GE18734@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=q/o02peLI3a9NmfXmGQil37yX/+6sBmf6ikL+9R+mW0=;
        b=h1s4f1zehZDFIbYA9LNCMB1Isu/d8Vqu5j3gZtAiOPKNlYmIuRSQnV9dkHNb0jKy8M
         +zxyAGfRnUNsoZsaHnLQWmH7VmTJU/mIXDGKGZ1qCRhyHHUzIJ922hVc2mOVZHF+a6j+
         8jg6SiMtpZX0daa3Yjv2nDisUHBlWjUgQnrKjcXBZEQIt0t9s7CuP1cAdsPXUJUQTh8S
         TdrmIuyV/I+KqO7BuRFljtyAb+QfCpDHQAWNHTwebmVngmYvFqGcPjHwr1iLnRkWPvwk
         2K7Jf3g/tWFsP9XjgG/pcSeYw19txsSm+o7W8JEDhBBy6d/aCVuWM7pmFGE/HQiibzoh
         l30Q==
Content-Disposition: inline
In-Reply-To: <20150712180520.GE18734-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Sun, Jul 12, 2015 at 02:05:20PM -0400, Tejun Heo wrote:
> Ted, these two patches apply cleanly on top of the current mainline
> and thus can be routed either through ext4 or block tree.  What do you
> think?

ping?

Thanks.

-- 
tejun
