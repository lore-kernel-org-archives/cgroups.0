From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH] memcg: make it work on sparse non-0-node systems
Date: Fri, 17 May 2019 11:00:44 +0300
Message-ID: <20190517080044.tnwhbeyxcccsymgf@esperanza>
References: <359d98e6-044a-7686-8522-bdd2489e9456@suse.cz>
 <20190429105939.11962-1-jslaby@suse.cz>
 <20190509122526.ck25wscwanooxa3t@esperanza>
 <20190516135923.GV16651@dhcp22.suse.cz>
 <68075828-8fd7-adbb-c1d9-5eb39fbf18cb@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E30ZwXceSLrrdqkhZETQJSrFB4D6w8xtvQQj0QSh1bk=;
        b=bdwPkfc51sJvmJvEEnbkjJeee5dDIVMrgrBcQbEWcuq3Gu7xg4Drx7Sxhgj0S7ifcX
         MHKOMyvUXD9qL1hCSXPCieoxHNgARijo9pvrnOH2EzfYZqXH5Lz7TJtcVndAOVHo4XZw
         rUwn3YonVOZFmAV/YnXpExobHSwnuBBeUq0GSrlLVM4UVA1/PVAvsvs3x6QuHTGJ4yyD
         kKNvUUksj1K0U1tcX4QimvxzelNTM+STaUm5uKCtcO3E7D+UqMhcG3yO+T91qZWg5dD+
         Es9SUG2SdeE2D42NKKLasOMtjhLIsUYe12Is80QapjF0rNGGNHdoPyzrhlywFra9vN0d
         DceA==
Content-Disposition: inline
In-Reply-To: <68075828-8fd7-adbb-c1d9-5eb39fbf18cb@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

On Fri, May 17, 2019 at 06:48:37AM +0200, Jiri Slaby wrote:
> On 16. 05. 19, 15:59, Michal Hocko wrote:
> >> However, I tend to agree with Michal that (ab)using node[0].memcg_lrus
> >> to check if a list_lru is memcg aware looks confusing. I guess we could
> >> simply add a bool flag to list_lru instead. Something like this, may be:
> > 
> > Yes, this makes much more sense to me!
> 
> I am not sure if I should send a patch with this solution or Vladimir
> will (given he is an author and has a diff already)?

I didn't even try to compile it, let alone test it. I'd appreciate if
you could wrap it up and send it out using your authorship. Feel free
to add my acked-by.
