From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 3/3] bfq: Add per-device weight
Date: Mon, 26 Aug 2019 07:59:15 -0600
Message-ID: <fff76a58-65e7-7060-0329-aef15c422639@kernel.dk>
References: <20190805063807.9494-1-zhengfeiran@bytedance.com>
 <20190805063807.9494-4-zhengfeiran@bytedance.com>
 <20190821154402.GI2263813@devbig004.ftw2.facebook.com>
 <C2F0BE1E-9CAA-4FBD-80D8-C18ECCE3FD4B@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HZ5+cm8oDGl9y7yBYTWMqRdFKjeGGqeRgHWdEMhzSsw=;
        b=c80aseIwaJV0ASqHmXiAVw59RoXvUUaEsL1tMrAmSu40HsButu6rq2Gj0CwjrLkiMF
         +0T4yP2gwaA0QMWgjR3idAX51delKj08+kYC7eyvr454TqC7/v6EALIni538EYlR45fW
         BMsOhTnHEhGN4YNraEjCsWTqyNZeAlkqCkQdB7dWPBaUuowqyn7om1itPED5NsWl9waj
         dYULOL86V6uykIjjS4DhBEqQk0Ujdp/DEk+t2m33F9Ipg6yN/MVmbvr3RcuorJOK0MbP
         HOdAQSuk8iW/4ro/6N6j+21PJhEINl0t4b6HunVmSNCIEpQsaI2c2TusbzERoooLWRyf
         xhtw==
In-Reply-To: <C2F0BE1E-9CAA-4FBD-80D8-C18ECCE3FD4B@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>
Cc: Fam Zheng <zhengfeiran@bytedance.com>, linux-kernel <linux-kernel@vger.kernel.org>, Fam Zheng <fam@euphon.net>, duanxiongchun@bytedance.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com

On 8/26/19 12:36 AM, Paolo Valente wrote:
> Hi Jens,
> do you think this series could now be queued for 5.4?

The most glaring oversight in this series, is that the meat of it,
patch #3, doesn't even have a commit message. The cover letter
essentially looks like it should have been the commit message for
that patch.

Please resend with acks/reviews collected, and ensure that all
patches have a reasonable commit message.

-- 
Jens Axboe

