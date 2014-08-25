From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Enable controllers for default hierarchy by
 default.
Date: Mon, 25 Aug 2014 10:40:09 -0400
Message-ID: <20140825144009.GB31066@mtj.dyndns.org>
References: <1408966052-2076-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IPG/tfIf/txbhOOmIKQe8QuIZsIV3lopwSKdosxxctU=;
        b=qsvxt4LcpTJqc1X3Q9cN5wjk7Uj98FeR7pEHJkLqeIzZRwhRXW04y6X12iGn7DcnvY
         98kpP7CNNFd/1ht6SjGhD6/hANIIr6W6aZfLPVs+0B8gOGNt5TlK4/Yi5IJZMK2Zd+fH
         pISpuwgIFeTklzDuTONBW041bIOMguqHSNuRSSAKpgwYkQn6DubdG/My+H4AflvPjiLA
         J8ZMP0f58CpoHg7VLDhmDMmZtgJZzmMBkvZu1UvIQeOmx+FjxEK1aVEp8NYZRvEcEwPw
         NKg1YGRLCt6t8PIF2qIWdZ/YMXJYCuR++0toHH3wQHcY1VuOFAdDPewtpZ5JuGXFKyWC
         Tg+g==
Content-Disposition: inline
In-Reply-To: <1408966052-2076-1-git-send-email-yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Dongsheng.

On Mon, Aug 25, 2014 at 07:27:32PM +0800, Dongsheng Yang wrote:
> When we create a cgroup in unified hierarchy, we have to enable
> controllers in cgrp_dfl_root.subtree_control manually. From
> my practice, I did not find the benefit we disable controllers
> in cgrp_dfl_root by default.

Hehe, I actually enjoyed the frankness.  No fudging around, basically
just "I used it for a bit and it didn't feel useful to me".

> As I am a newbie to cgroup, please correct me if I am wrong.

I don't think being new to cgroup is important here.  Regardless of
the specific area, you should be able to build and argue the
rationales for the changes you propose.  This is important because not
only the changes need to be justified but also the process will help
you actually think about and analyze the changes that you're
proposing.  If you can't build strong enough rationales for a given
change, it probably shouldn't be proposed.

Here, your rationale is nothing more than "I played with it 5 mins and
it seemed weird to me".  There was no effort in understanding the
overall design, use cases or implications.  You're just driving by
shooting random patches expecting other people to do what you should
have done before submitting the patches.  If you want to change the
behavior, please first study and think about it and ask specific
questions when unsure.  Submitting basically random patches expecting
others to argue for or against it is one of the worst ways to learn
about a subsystem.  Please don't ever do this regardless of the
subsystem in question.

Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
