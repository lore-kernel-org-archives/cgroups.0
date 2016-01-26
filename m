From: Andreas Ziegler <andreas.ziegler@fau.de>
Subject: Re: [PATCH] cgroup: Fix misspelling of CONFIG_SOCK_CGROUP_DATA in
 comments
Date: Tue, 26 Jan 2016 16:14:30 +0100
Message-ID: <56A78D56.2030902@fau.de>
References: <1453819158-25380-1-git-send-email-andreas.ziegler@fau.de>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CB53E91@HASMSX110.ger.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fau.de; s=fau-2013;
	t=1453821271; bh=g+q0z+thNEvhqCMSNg3ClVc4wc70DJeZRtvM1zWyfn4=;
	h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
	b=E/090m/lKO7BEwoJ/kqet91pr+HVfcAadJxDN2o1eepdeQol5eBb0LxobDkarSDlc
	 AEjPWIOe6wTtkca+Psb+PKnzY4deVVuCO7DmC6ZWH54XWc78iNboF+FFqQbgguLnYj
	 En1l8/PoI8rxG12Sp7a99mYRH+yUoRNKB9rJmm1SVxIKKRnkBVi4eYxm7sWeinbz3w
	 ggZmUiLnvcp9YUfjFQAToHwXnQS3Sm86zkR4+zi59FXb4LyhDxP7mq9HZ9yuCOOWJv
	 GhRYBuvXgILtepwmpbReNwNAIgB7suARSUidfIhJ9TRzBfG+5IMEl3X8q2pcb3junC
	 h0R9KtDYWA9Xw==
In-Reply-To: <9B0331B6EBBD0E4684FBFAEDA55776F92CB53E91@HASMSX110.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Rosen, Rami" <rami.rosen@intel.com>, Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 01/26/2016 16:08, Rosen, Rami wrote:
> Hi, 
> 
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -604,11 +604,11 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
>  #endif
>  }
> 
> In this occasion, seems that maybe something else is also missing:
> Shouldn't it be hereafter : +#else /* !CONFIG_SOCK_CGROUP_DATA */ 
> instead ? 
>    
> -#else	/* CONFIG_CGROUP_DATA */
> +#else	/* CONFIG_SOCK_CGROUP_DATA */

It seems that there is no real consensus among the developers for that
particular case:

ziegler@box:~/linux$ git grep "#else \/\* \!CONFIG_" | wc -l
327
ziegler@box:~/linux$ git grep "#else \/\* CONFIG_" | wc -l
564

I don't mind changing it, I'm just not sure if that's what we want.

Regards,

Andreas
