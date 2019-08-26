From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH v2 3/3] bfq: Add per-device weight
Date: Mon, 26 Aug 2019 08:36:17 +0200
Message-ID: <C2F0BE1E-9CAA-4FBD-80D8-C18ECCE3FD4B@linaro.org>
References: <20190805063807.9494-1-zhengfeiran@bytedance.com>
 <20190805063807.9494-4-zhengfeiran@bytedance.com>
 <20190821154402.GI2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=iVlNOvcGkxOW82lX/stt8mZNXgPWFfdeCPzC+y26i1w=;
        b=Ko288HnotBth8jQ1QLLaxPiIBMWT0CGuHCphEGfWiVxL3InXCHOVU/SvqRYl+8Uk7I
         maRDjlOXSxFfzYnf7uhq9Zva9futXeSmVAMYxChtvlzzMGTZEPl2c++crWSqiz+vYzQW
         /Cp3r2Uzy2vuRJ/YpuiMHfXMNBcmbxXQqfN6vuE7WQjy7ZLKu6bWXHe1bW5va0Zpsb3+
         24VCf/amP3DuZFxAtkt45Q2mSJSfihWLPi301wjgoam+Op4sqi1ZCxEN0VxTPwmi4xhQ
         AOGPUweB+T7vdpITeG+1HnPM4JAZH4qdY5b2eJyXWsk7G5mO6LrO3oWxUD+ZKN3G51bo
         EcYA==
In-Reply-To: <20190821154402.GI2263813@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Fam Zheng <zhengfeiran@bytedance.com>, linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Fam Zheng <fam@euphon.net>, duanxiongchun@bytedance.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com

Hi Jens,
do you think this series could now be queued for 5.4?

Thanks,
Paolo

> Il giorno 21 ago 2019, alle ore 17:44, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> On Mon, Aug 05, 2019 at 02:38:07PM +0800, Fam Zheng wrote:
>> Signed-off-by: Fam Zheng <zhengfeiran@bytedance.com>
>=20
> Looks good to me.
>=20
> Acked-by: Tejun Heo <tj@kernel.org>
>=20
> Thanks.
>=20
> --=20
> tejun

