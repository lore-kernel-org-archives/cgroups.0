From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Wed, 22 Apr 2015 11:25:51 -0400
Message-ID: <20150422152551.GA10738@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ldZ9eZELHYiO/6lWNmNhbY54qvyK9TFBmY4tDlbQM/E=;
        b=eSxH3F/XpmiCpB3nPkhgHJAzbwKPaCCiakOFk7hpd2ehEtP6b0RgODq8y5/UU9u6mb
         HS/twmcecQelqQLvbWFmfI21MOMuZwgBmMjb2mVForEOMzuKmqPVHpHdghsDIsQKf+rz
         SKhRzoFGT/lrOpcvsrv5NnqWGHbdpHo3WUj9LtBNVkLTmaV5CsAOGcqEn2m0AHeyQAd8
         bc0KKut1FFDwSdTJuEGJWrc0LaDUzy3FeI0Rj1wuTbgP3wbPApzpG7qJe4hekxE9EpNS
         tOi+Qtm9ZxR70Z3FoNHRCMGvgV+sqGtf/O67Wh44pl2Z80cx8FNIV7aHO/rGGw9ni1sm
         6zmg==
Content-Disposition: inline
In-Reply-To: <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Aleksa.

On Sun, Apr 19, 2015 at 10:22:31PM +1000, Aleksa Sarai wrote:
> -static int need_forkexit_callback __read_mostly;
> +static int need_fork_callback __read_mostly;
> +static int need_exit_callback __read_mostly;

These are bitmasks now, right?  Let's make them unsigned int.

>  static struct cftype cgroup_dfl_base_files[];
> +#define for_each_subsys_which(ss_mask, ss, ssid) \
> +	for_each_subsys((ss), (ssid)) \
> +		if ((ss_mask) & (1 << (ssid)))

Maybe using for_each_set_bit() is better?

#define for_each_subsys_which(ss_mask, ss, ssid)		\
	for_each_set_bit(ssid, &(ss_mask), CGROUP_SUBSYS_COUNT)	\
		if ((ss) = group_subsys[ssid] && false)		\
			;					\
		else

> @@ -4932,7 +4947,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
>  	 * init_css_set is in the subsystem's root cgroup. */
>  	init_css_set.subsys[ss->id] = css;
>  
> -	need_forkexit_callback |= ss->fork || ss->exit;
> +	need_fork_callback |= (bool) ss->fork << ss->id;
> +	need_exit_callback |= (bool) ss->exit << ss->id;
                                    ^
			  please drop the space here

Other than the above minor points, looks good to me.

Thanks for the persistence.

-- 
tejun
