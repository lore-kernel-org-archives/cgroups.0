From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Thu, 9 Apr 2020 09:44:06 +0800
Message-ID: <20200409014406.GA370295@localhost.localdomain>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586396662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b2mtGi6r3BCSmkwLZaqpFPxWzlxVwSz47AyFQhgeBuQ=;
        b=VtrovxK9+cVDxE2MN9fbQDQK2V2NC2jU/fZIjflRbmbsdqoGxOfiwirANw1xVQqWiM4+GD
        FrP1JX47nfWgycTJ236pBnphcwiyKDCoMWM8mNG82jy14Lmh468qAcPwJZAjEFN5ppwtRB
        t7Zb0FDged5LTOJXuTr+RAzxdYBvxBE=
Content-Disposition: inline
In-Reply-To: <20200408201450.3959560-3-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com

Hi Tejun,

On Wed, Apr 08, 2020 at 04:14:47PM -0400, Tejun Heo wrote:
> Currently, at the time of completeion, there's no way of knowing how big a
> request was. blk-iocost will need this information to account for IO size when
> calculating expected latencies.
> 
> This patch adds rq->io_data_len which remembers blk_rq_bytes() at the time the
> request gets issued. The field is enabled iff CONFIG_BLK_IO_DATA_LEN is set and
> doesn't increase the size of the struct even when enabled.

Almost all __blk_mq_end_request() follow blk_update_request(), so the
completed bytes can be passed to __blk_mq_end_request(), then we can
avoid to introduce this field.

Also there is just 20 callers of __blk_mq_end_request(), looks this kind
of change shouldn't be too big.


Thanks, 
Ming

