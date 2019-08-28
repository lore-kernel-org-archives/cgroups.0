From: Fam Zheng <fam@euphon.net>
Subject: Re: [PATCH v2 3/3] bfq: Add per-device weight
Date: Wed, 28 Aug 2019 11:50:55 +0800
Message-ID: <20190828035055.GA16893@magic>
References: <20190805063807.9494-1-zhengfeiran@bytedance.com>
 <20190805063807.9494-4-zhengfeiran@bytedance.com>
 <20190821154402.GI2263813@devbig004.ftw2.facebook.com>
 <C2F0BE1E-9CAA-4FBD-80D8-C18ECCE3FD4B@linaro.org>
 <fff76a58-65e7-7060-0329-aef15c422639@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1566964261;
        s=zoho; d=euphon.net; i=fam@euphon.net;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=522; bh=kZZ0SaUSYboCypvlsV1KXUwzNEviRw5SwLxgGnE8zzY=;
        b=gKntHUbpwtEPWYsG8RAFSvgvTifHJiZkg0vZjQvPumRN9CB0yaXDLVlxxcTjfXxU
        ZsYBpyud35mPITI8gubkdPsc6N8m82VpRlujPxbqsV6jFCGarVssE8zSEnomCZmJ2gE
        M0vRNjeXrf8TtvD1IZdzdga5MoM4tn2JwiI/IadU=
Content-Disposition: inline
In-Reply-To: <fff76a58-65e7-7060-0329-aef15c422639@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>, Fam Zheng <zhengfeiran@bytedance.com>, linux-kernel <linux-kernel@vger.kernel.org>, duanxiongchun@bytedance.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com

On Mon, 08/26 07:59, Jens Axboe wrote:
> On 8/26/19 12:36 AM, Paolo Valente wrote:
> > Hi Jens,
> > do you think this series could now be queued for 5.4?
> 
> The most glaring oversight in this series, is that the meat of it,
> patch #3, doesn't even have a commit message. The cover letter
> essentially looks like it should have been the commit message for
> that patch.
> 
> Please resend with acks/reviews collected, and ensure that all
> patches have a reasonable commit message.

Will do. Thanks!

Fam

