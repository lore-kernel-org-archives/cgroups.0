From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] xattr: fix uninitialized out-param
Date: Thu, 9 Apr 2020 15:34:10 -0400
Message-ID: <20200409193410.GD37608@mtj.thefacebook.com>
References: <20200409062729.1658747-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xphXmyOdAyfBLtl2H1zTNHLFXlMJZDESiQgsT9iusj4=;
        b=W5YIxCIa0FvZAF5KUoz6XTBkkPe72p6kPsmIp1FEK2ApHmAHP7dt4t8yhfRktVOmFw
         rUvu3/7UVakoLakx/HXkI+WnCbKfog3Tj2N7s5s2oqDWNrxVojjSAEoqSAoo6TXcOWhr
         dEl241eyRnB0NXKudVfa/ZtxKPIUjri9v4epZIAEhGGF5pzPTqbNLlrvlkXoxyeOZIan
         0WegyTDV0l9LCCuMNm28+Wq/X/fp1RnIBRBUMlz+sGJhNB/ekRCZ334lmZINUoed0/yu
         2ZeW/2AG0dzT/U+qtiA8KnwtcE/Q75tNBew7c5AJIyEdhWZmXtEnVCqhxtLua46gS+al
         WpiA==
Content-Disposition: inline
In-Reply-To: <20200409062729.1658747-1-dxu@dxuuu.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu@dxuuu.xyz>
Cc: viro@zeniv.linux.org.uk, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

On Wed, Apr 08, 2020 at 11:27:29PM -0700, Daniel Xu wrote:
> `removed_sized` isn't correctly initialized (as the doc comment
> suggests) on memory allocation failures. Fix by moving initialization up
> a bit.
> 
> Fixes: 0c47383ba3bd ("kernfs: Add option to enable user xattrs")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>

Appiled to cgroup/for-5.7-fixes.

Thanks.

-- 
tejun
