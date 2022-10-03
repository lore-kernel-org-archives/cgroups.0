From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 2/3] blk-cgroup: Return -ENOMEM directly in
 blkcg_css_alloc() error path
Date: Mon, 3 Oct 2022 06:40:50 -1000
Message-ID: <YzsQkpYOeIfDSA03@slm.duckdns.org>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=UYsFd23cSQZ/m2EDH2nwy0Fjt0240/Cw81WucrFzjOo=;
        b=OpLEDrCbywNIL/ySOOKrHxYnz0Ag0oweJ1c1VjO/l8v033KF570Ve4lrOvea3d3XlR
         a5PVvvWOYInxay4tnEdqJ5EOdpjNIgyNOoYCwwimZ2GcE7fNfgIYdOr4yEv4nEUUQ8qJ
         6rjqeZNse4yyoF+uYGETD9Nt+bv6IjbYkaOapGnSKPuSxy4i5aWN4ZhafDJDaBe5oKMt
         BbavpV9VCEr1jGMNVYShhqvtAicaSQx8rKUwQYDUo4P9ZQdTv/IUvtHaq2XQcfZtfXhk
         DVCbUydYeZ/hzgzCY84Mbcd+paD7Hmy4d+js7tYYM9FFnpEDxX3FCAzy1VZC5vDIAn2/
         FFsg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221003154459.207538-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Huang Ying <ying.huang@intel.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Mon, Oct 03, 2022 at 11:44:58AM -0400, Waiman Long wrote:
> For blkcg_css_alloc(), the only error that will be returned is -ENOMEM.
> Simplify error handling code by returning this error directly instead
> of setting an intermediate "ret" variable.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
