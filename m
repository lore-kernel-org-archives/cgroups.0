From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] blk-throttle: Set BIO_THROTTLED when bio has been
 throttled
Date: Thu, 6 Jan 2022 09:52:33 -1000
Message-ID: <YddIgWU73LabYICc@slm.duckdns.org>
References: <20211118131551.810931-1-qiulaibin@huawei.com>
 <YaUZExR6v8IdZUeM@slm.duckdns.org>
 <03964258-10ff-7f19-10cb-ca4eccf72848@huawei.com>
 <YbepLpyMPqP2ao3J@slm.duckdns.org>
 <8c87a712-93fb-d794-6d08-cadf6452efc3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FMCYSxfBHDKrU2xtUn5iYVpLMUW2H/Uaai2PBAbWbI4=;
        b=kLnEU6mmNacpPREArN2iOC4bExYQSNan1xlnuUEIUu/f9MIY1GKKH0ycKAdCknNg8f
         Mj/AbvEndlEgJczppSeUzmbnj9r41HfyP7xYrXkiU5bhD2L5rYHxHLFYJIGBNLVS7Gj2
         IpEDW8GEOZ2YYJccx9M8lwjJj7Z1sBygpt6vdoFdPSMa86ImKFX9pic6sOOhsj8t/OiO
         J4gWFEzgUTdwygFjwUdI5h0l+aQ/Cu+0+ks7b6t063dHaOeJBk5LcXHt+9W6//uNTqTp
         i6nqtBtF4xN8OHzTDmv6KggQCobF31b72TpRAcV1yCO6erR8ZjH4PABoPbBO0pE8IZ4C
         pwSg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <8c87a712-93fb-d794-6d08-cadf6452efc3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: QiuLaibin <qiulaibin@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 14, 2021 at 05:12:48PM +0800, QiuLaibin wrote:
> I am thinking of adding a new bio tag (like BIO_THROTTLE_BYPASS) to avoid
> those requests which do not need to be throttled to enter the throttle
> multiple times.

Sorry about the long delay. Was off for several weeks, so my recommendation
would be separating the two issues. It'd make a lot of sense to fix the
immediate bug in a minimal way first.

Thanks.

-- 
tejun
