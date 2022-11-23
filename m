From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/11] blk-throttle: remove repeat check of elapsed time
 from last upgrade in throtl_hierarchy_can_downgrade
Date: Wed, 23 Nov 2022 08:28:47 -1000
Message-ID: <Y35mXymUTC1lx50j@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-9-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HeXP11t/+0yLhKm0StolEpyltEEHuq6W+e1tTErqQaI=;
        b=OO3acBF/AxFG9PvE3FfXDejXXULUCcDhFYGrWXM8f02v5B58SoZCg5HBB98r+jNnwD
         Qz+NUoxIxl/Eg7QNIfdgGeIxRVNwSO7xs37P/+J6Vi4UyN2jfq5LHnbwJM4Sydqvam6+
         heP0Lvyl2RfOftV00QuromUhSzPtd2zQ4rz3TNfcJv2gDAJolfN/yK53qd+/WJtf0LB4
         94BQOHf5IMg90I6b27Rrs7dm5xiYAlfbCOhh/CfGrNBFmnOTCbxiXZCessgimQYKesXZ
         EZ0yCCF3X2lypZ7NwzHg1vBIPBTriuuMqWkNfg4dfCh758tkmQhHw/QX58nbKy8HelQm
         uIMw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-9-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:03:58PM +0800, Kemeng Shi wrote:
>  static bool throtl_hierarchy_can_downgrade(struct throtl_grp *tg)
>  {
> +	if (time_before(now, tg->td->low_upgrade_time + td->throtl_slice))
> +		return false;

Does this even build? Where is td defined?

-- 
tejun
