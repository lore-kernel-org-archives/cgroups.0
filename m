From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blkio-controller.txt: Remove references to CFQ
Date: Fri, 14 Jun 2019 10:28:47 -0700
Message-ID: <20190614172847.GH538958@devbig004.ftw2.facebook.com>
References: <20190612061732.GA3711@suselix>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dg+yr2j8TD2tOeWN+mTqClvlcOIVqj1KKksx271TJrk=;
        b=ssS6y8VmviRvlot/CRTLA7KZx5V0/s+D+0Hre7ySB8N+URNzknGbw4VlsYvDQltOKt
         BahmS/KfDl8aupY+2UBCfbtStKZZv3IyoX8auZC5qcHSi/h5QAJoSVca2IU2S+P+rlfq
         /RBhJ/oyAXWgsxnLFeXpQb8aCmzIxpRiEwC35j7vrJhacDhru/lTQGZEd0nQxK+Ggm0r
         V844cjDWQtntAqSVghm6uxBwITfGUNMGEaFMpTl1UohUnlIlsTDGO2rUJBoUlxbqHgsY
         lpErarwErjDgQE5K7GBrka9JBWSI945Dk+HceNbUXILc/FfQp16VOyBwqginzLPlybio
         Ifew==
Content-Disposition: inline
In-Reply-To: <20190612061732.GA3711@suselix>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Herrmann <aherrmann@suse.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Jun 12, 2019 at 08:17:32AM +0200, Andreas Herrmann wrote:
> CFQ is gone. No need anymore to document its "proportional weight time
> based division of disk policy".

BFQ might provide a compat interface.  Let's wait a bit.

Thanks.

-- 
tejun
