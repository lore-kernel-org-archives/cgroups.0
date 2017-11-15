From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/7] blkcg: associate a request with its blkcg_gq
 instead of request_list
Date: Wed, 15 Nov 2017 09:11:18 -0800
Message-ID: <20171115171118.GV983427@devbig577.frc2.facebook.com>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-4-tj@kernel.org>
 <20171113201523.GM983427@devbig577.frc2.facebook.com>
 <20171114231743.2eprnbfmgesqc42c@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/D7LGQSybI6fN121tU3DOug1/f1vla2spf/fszajG78=;
        b=NkUyW1sOGfKs27FpBe60f62iIycStBlR8U9KZQs4dQn9LpQrtFi0EDu7b64iGmJkZN
         UUpwPU9u7v4kJziV4DhQrrcHgFuMhOXD+eS444vUSdi1s/xKuRkzoN7SzdRzhRNpzTnY
         IO3k9VxtroxdeIdpTgHqyv0q7+xeq/B8VC/v0t67JEq+35gQWqj2J24f1+DKZRCIYgUA
         UxLWkp78NlGrog7ZAD2SlrpkSnYQ4REWfOQsj3d2ZcAQASUcT4iwopd5jY0wgbfS32S7
         5LI+Re94NJ7mw/FSVGOTOnoOR83oOfs6iFTTYo5Yu0fWdwIDlG4ZsLOdJEt7q39p1Dxq
         109w==
Content-Disposition: inline
In-Reply-To: <20171114231743.2eprnbfmgesqc42c@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shaohua Li <shli@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kernel-team@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, guro@fb.com

Hello,

On Tue, Nov 14, 2017 at 03:17:43PM -0800, Shaohua Li wrote:
> After patch 5, we don't really need the blk_put_rl, blk_get_rl, blk_rq_set_rl
> functions. I'd like to delete them and only keep blk_rq_rl. The name
> blk_rq_set_rl is confusing too.

Yeah, we can switch the legacy rq to switch to direct blkg pinning
too.  If that cleans up the code, great.

Thanks.

-- 
tejun
