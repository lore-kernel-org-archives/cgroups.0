From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: avoid double charge of bio IOPS due to split
Date: Mon, 10 Jan 2022 18:51:26 +0800
Message-ID: <YdwPrsdhwX39IlDG@T590>
References: <1641803363-27550-1-git-send-email-brookxu.cn@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641811901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uep8m/hs5XUyZjO6T2O4qnfO84NUY7Xj8s7kTpYwtJo=;
        b=KhL+bAjpyDhIqqHNGPDwo8y1KSCBd5bKlgA4Z985oc4t8adVq2iUSxKxvXilyVWZuXAmN2
        QDgRlqidAgVsRYKMtk8wwuw5qIjqDiCIC/oNB4XDJN72ZCq0hmkAU2OW908drY7FVUmnj+
        qONFvYV0b7shHHCAd4OopMlQiL18NsA=
Content-Disposition: inline
In-Reply-To: <1641803363-27550-1-git-send-email-brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Chunguang,

On Mon, Jan 10, 2022 at 04:29:23PM +0800, brookxu wrote:
> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> After commit 900e08075202("block: move queue enter logic into
> blk_mq_submit_bio()"), submit_bio_checks() moved to __submit_bio_fops()
> and blk_mq_submit_bio(). The IOs go through blk_mq_submit_bio()
> may be splited before entering blk-throtl, so we need to check
> whether the BIO is throttled, and only update the io_split_cnt
> for the THROTTLED bio to avoid double charge.

Today Jens has merged the patch[1] of "block: don't protect
submit_bio_checks by q_usage_counter", so the behavior is switched
back to previous behavior: running bio check before calling
blk_mq_submit_bio() or ->submit_bio().

Then looks your patch isn't needn't any more.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-5.17/block&id=9d497e2941c30a060ba62d5485b3bc9d91ffb09e


Thanks,
Ming

