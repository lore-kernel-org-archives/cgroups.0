From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup pids controller -- WARN_ON_ONCE triggering
Date: Tue, 8 Dec 2015 10:24:28 -0500
Message-ID: <20151208152428.GJ9175@mtj.duckdns.org>
References: <20151208145851.GJ9837@bark>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2Lyhf23wj9hhM0HjVZc45L/UG4TDIG2OuAKoS0EhjtM=;
        b=mHzQPfL65+9KB1wQcnRg8H1FYJBsPq1RKbuobt+dT3Ec/TmZdqlXpGLR3xjxxzmJXh
         hipEDGBhXmsgRwcaq41K+nTX4rkIlI5eotiISvRL2jw50XFK/V7Zz+WCz/i2v3z87szS
         ZE1+pkWViDunUdor4joqno7UNidEc6ZHF/wtYFEgrZejYlTep9MnMJLS0lh+PT6GqZm/
         TymrCQCB/6Lp7MjDCqIiiYfXybDpW8cTugaGaFPEnX3mKwIlZcIQkPjgrhXmSke3RaLX
         x9TZNilHxXJdxZwEncqdx41nCQy/xbR4HuLYJvwHh0+Km7gxQnoMlIGrUUByiqoEDhKE
         CAgg==
Content-Disposition: inline
In-Reply-To: <20151208145851.GJ9837@bark>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Pitt <martin.pitt-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Hello, Andy.

On Tue, Dec 08, 2015 at 02:58:51PM +0000, Andy Whitcroft wrote:
> Converting this to a printk I was able to obtain confirmation that we are
> indeed seeing this go negative in some cases.
> 
> Reverting the above commit seems to resolve the early boot issues in
> my testing.

Fix already queued in the following git branch.  Pushing it out as we
speak.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.4-fixes

Thanks.

-- 
tejun
