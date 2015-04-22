From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Wed, 22 Apr 2015 12:02:58 -0400
Message-ID: <20150422160258.GE10738@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
 <20150422152551.GA10738@htj.duckdns.org>
 <20150422154212.GE3007@worktop.Skamania.guest>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NopfXkz9u56CrWn8QGEx4EE2WcwxoA1t2tNRKepDFME=;
        b=xOKrVznsFLcEhW893xRGOMmcKTQ1gee6aS44GwRFf09iesygTV/17nPy5z1L9NR9a1
         O1km0HuYklQ/RXT3nuP+Dz1nOhs0WubV7pmlozFmy6Pb79sazFH2EIiwqIGfq/YzmESi
         UH8VF6/8kPCmR2dyzpiSO4SWNrUiyDisv7Lsb7UZdVcfueh9qNXkul5L0AiBXWLMTNmt
         muRk6nindYAQG24wXdLicdEL4fUuKINuHW97tjNOnEjA0uMlmIoYuE8UmBccUAqWiHk1
         yZRxy8BBRzgJwIKSvzFHu5wVVewKoF4m2x9ZOqeT/awz4z8Lqd2IhYQx8h9DgwmoAW5o
         Hvsg==
Content-Disposition: inline
In-Reply-To: <20150422154212.GE3007@worktop.Skamania.guest>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, lizefan@huawei.com, mingo@redhat.com, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hey,

On Wed, Apr 22, 2015 at 05:42:12PM +0200, Peter Zijlstra wrote:
> If, as per the below you want to use the bitmap ops; it needs be
> unsigned long.

Ah, right.

> > >  static struct cftype cgroup_dfl_base_files[];
> > > +#define for_each_subsys_which(ss_mask, ss, ssid) \
> > > +	for_each_subsys((ss), (ssid)) \
> > > +		if ((ss_mask) & (1 << (ssid)))
> > 
> > Maybe using for_each_set_bit() is better?
> > 
> > #define for_each_subsys_which(ss_mask, ss, ssid)		\
> > 	for_each_set_bit(ssid, &(ss_mask), CGROUP_SUBSYS_COUNT)	\
> > 		if ((ss) = group_subsys[ssid] && false)		\
> > 			;					\
> > 		else
> 
> Clever that ;-)

Thanks.  It kinda bothers me that for_each_set_bit() doesn't collapse
to combo of ffs() + clearing bit off of a temp mask when size is const
and <= ulong, which would be quite a bit lighter.  Right now it'd be
calling into generic find_first/next_bit() functions unconditionally.
Ah well, it can be optimized later.

-- 
tejun
