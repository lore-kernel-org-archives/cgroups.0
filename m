From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET 2/3 v2 block/for-4.1/core] writeback: cgroup writeback
 backpressure propagation
Date: Mon, 6 Apr 2015 16:07:34 -0400
Message-ID: <20150406200734.GI10582@htj.duckdns.org>
References: <1428350674-8303-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0V57KWCrNsSmzRlENfx5NKTctgIuDVBROFaql/KU8so=;
        b=qaUZXiaPOGMAkVMx+9gSwJP3eqfdFAbX5sH8JdjyJimYa/QRkmE0RyT0+v3WlYjmiM
         iPyi1Q0VjM05ZIeie/EoYELxuol/3Q67m//MywvnHysoUZeB1w7iYY2rvY6dwtLt4Qyh
         c3WEs2HCW+nFdiRjrqhQXaMynwrbTR/3OfFKEWTpOWhvse/elgCX/czEU231NhsUCyUq
         k6S0ShQ0Xqs/qzUq+P/7PrJy6nIisCzC5/+7NVP6sdBlw5KoOAadNpiLKt5KH3ChAGSB
         mpKx0ChmY95BS4chqIm9HleWm5cpSzXNRkrL/4P1EthjN3fHVO6XU+/AsJ9Qri4/Tk2/
         sPcA==
Content-Disposition: inline
In-Reply-To: <1428350674-8303-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

On Mon, Apr 06, 2015 at 04:04:15PM -0400, Tejun Heo wrote:
> [L] http://lkml.kernel.org/g/
> [1] http://lkml.kernel.org/g/20150323041848.GA8991@htj.duckdns.org
> [2] http://lkml.kernel.org/g/

Oops, forgot to update the links.

[L] http://lkml.kernel.org/g/1428350674-8303-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/20150323041848.GA8991@htj.duckdns.org
[2] http://lkml.kernel.org/g/1428350318-8215-1-git-send-email-tj@kernel.org

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
