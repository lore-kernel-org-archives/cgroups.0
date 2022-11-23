From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/11] blk-throttle: Limit whole system if root group is
 configured when on the default hierarchy
Date: Wed, 23 Nov 2022 07:11:49 -1000
Message-ID: <Y35UVRg0tTfsTdrB@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-2-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NwhqRAJvGavoaGuqSrfgQhHpNiR8ljuOsT2sziprE50=;
        b=kR4KehW+/5RtfQodotENKJN9+dUBrQYSP1Drnr1ELPapshjSBc05FeCs5WKFwRYhPF
         5/evnW19Z3/WuKviaZQkBgYmYVsWl54dhOH3YawdfFrVbiz2wuB0KlNo28H3ATQVCRRj
         gHOjfUzqr58hJitHQP3GkzeZasRkD9Cj71Pzok8i3r4muU/UqM93A+54CXeCmatNkCTc
         VVwar/ZCrszc0IepuyjwUKg1EopF2V0JjDJSy82HO2WVCWX/zuXTY8vHKCzL/J50PqEu
         o83KfGYbocXqlMkcuW3cugTYUWCoznHe9HubGFCHzhJRIq/KqnA/eNfF0C/L1x59QrhS
         H27Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-2-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 23, 2022 at 02:03:51PM +0800, Kemeng Shi wrote:
> Quoted from comment in throtl_pd_init: "If on the default hierarchy, we
> switch to properly hierarchical behavior where limits on a given
> throtl_grp are applied to the whole subtree rather than just the group
> itself. e.g. If 16M read_bps limit is set on the root group, the whole
> system can' exceed 16M for the device."

On the default hierarchy (cgroup2), the throttle interface files don't exist
in the root cgroup. In general, cgroup doesn't wanna be in the business of
restricting resources at the system level.

Thanks.

-- 
tejun
