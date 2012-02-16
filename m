From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: use vm_swappiness from current memcg
Date: Thu, 16 Feb 2012 11:02:43 +0400
Message-ID: <4F3CAA13.1090906@openvz.org>
References: <20120215162830.13902.60256.stgit@zurg>	<20120215162834.13902.37262.stgit@zurg> <20120216091511.350882a7.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=IcvEyQbINbPfs9Dvo+1i4lNeNeUB1BrTiqDlR45ylVY=;
        b=r3ZXQV+ltgE7CWdr1yqDNRTGTd+QDtY8Zh/tuph84wZCsmrLhStrVM6ngxcuXPa7sP
         nASn0+vh7QYFoxhoRlebAMrYUzbRmn2ylK6shmyTmV7YzCDVzgjIyQPHBYPn/vsR8MsI
         bfAGLvsbKa/Kdgum2fLts8q/k9Ec+YEzImkuU=
In-Reply-To: <20120216091511.350882a7.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

KAMEZAWA Hiroyuki wrote:
> On Wed, 15 Feb 2012 20:28:34 +0400
> Konstantin Khlebnikov<khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>  wrote:
>
>> At this point this is always the same cgroup, but it allows to drop one argument.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>
> Do you mean "no logic change but clean up, dropping an argument" ?
>
> I'm not sure using complicated sc->  is easier than passing an argument..

It also was cleanup-preparation for "memory book keeping",
there I replace struct mem_cgroup_zone *mz with struct book *book,
struct book doesn't know anything about memory-cgroups.

>
> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org">  email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org</a>
