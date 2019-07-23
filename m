From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Replace a seq_printf() call by seq_puts() in
 cgroup_print_ss_mask()
Date: Tue, 23 Jul 2019 15:44:36 -0700
Message-ID: <20190723224436.GG696309@devbig004.ftw2.facebook.com>
References: <d465ca81-a870-b88c-0ea2-5e8bfbefb79d@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=4y1txJPMDw45nI3k4swrjOtBVNsEnY/B83k42eCghwU=;
        b=ayaeacXt13mio966+juaFXXczu3VBG1Rqen8FWx+n6jXBQZqZG1lbGDSZD0nxOhhCI
         bBk1aEM3rtKuKZJJPJCjCkJFRV/Wp0P7FjxQGhmOneFd5q+MlCIxEtF7gyOJ1kbVar9J
         X5L+u4AxAcUiWY1TP4XBMl3P7VQdXWTD4PrN4lEysoAIqE+9yfG+c/L51ltiJFmbNHA1
         CK7y1Dlx+kPIGOhW2Td3kuEoCcmTdkstji8dP/tlUw/7RrcGcfEj2oUYGwbnn+FO0iYo
         ub99Dh+LURMxFPRkFBUcqufndeVEJ5UD6JcJHLvDM0okPnIQ3M8FTCxg0mE/vjgfRLZB
         f3bQ==
Content-Disposition: inline
In-Reply-To: <d465ca81-a870-b88c-0ea2-5e8bfbefb79d@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Markus Elfring <Markus.Elfring@web.de>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Tue, Jul 02, 2019 at 07:33:08PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 2 Jul 2019 19:26:59 +0200
> 
> A string which did not contain a data format specification should be put
> into a sequence. Thus use the corresponding function “seq_puts”.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied to cgroup/for-5.4.

Thanks.

-- 
tejun
