From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 2/3] blk-cgroup: Return -ENOMEM directly in
 blkcg_css_alloc() error path
Date: Thu, 2 Jun 2022 10:39:16 -1000
Message-ID: <Ypkf9N0sIZdzizL1@slm.duckdns.org>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NYkACjksTq7D5aqYKY+rKmNd5ashkIfCvgLNEkSUbY4=;
        b=VOoyvWVAcqaU05NT1mJw6gqT2XZyQl9VZosdCL3rWV7Sfb31CIedlhghvwKlyCTlgM
         4EmYtZsp0oDGXH7Sfq9OUYqx6T57oS/fqxkS6XU+BF9VG8iMEagWxwaCBeV59dwks9Ne
         +sxGEJ/V+morFEZXMOgoH98Qnf5I3+3Konysn2VkKRxS8dwpQN7ZIORUzMQmYcIcn/mO
         fHc7VZN2++Hb/wqYaHVxLILDutZdZurupx6x2KAVR1NzmA/9ttj5Ao0OePBo66dbNrpW
         B6sbZXTu632SvtkE+Y9GLIw2dJcS8mZ9L9eOGSedtmCMHTljAxs32Md+vZk2pkQZlFLS
         S/zQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220602192020.166940-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Thu, Jun 02, 2022 at 03:20:19PM -0400, Waiman Long wrote:
> For blkcg_css_alloc(), the only error that will be returned is -ENOMEM.
> Simplify error handling code by returning this error directly instead
> of setting an intermediate "ret" variable.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
