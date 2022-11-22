From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Tue, 22 Nov 2022 11:10:28 -1000
Message-ID: <Y306xJV6aNXd94kb@slm.duckdns.org>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
 <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C+KEqUPpt9nBZhy2l32eLRwk2q2Rg4+1eaxUkvjjhgg=;
        b=hC1R8VpRUm1vtCVrxmHeI+RFvGrfUTgxzJDsTjqJnYDMfgLrcdlSQuqYhPvY/Ngiq8
         YsJqRaFeRDIFWRDrW9MQKFf+YhGpvvEE5JQp6I7LE/fbFPycigIFZVC50Mn7T81Rc0ip
         SpacCnKP0Cv8PWm/lx6EslA0e0XeGhuBFY1S80wuP3an5Ehy7+Du23j1TktTHFLf3g/X
         xqpe587AjbUhmVWzf7e8zF8uXlCPo3vftSKmyF+LypLxS97o0nf1yo/ZCnmc70DYJF2C
         xCNElSexSwgXjaNE3Ig8aTcZB/CYj0DlUtMBK+bALBMYuDlHh711uqPYnLmKjKocyIR5
         DyOQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On Thu, Nov 17, 2022 at 07:28:50PM +0800, Yu Kuai wrote:
> Hi, Tejun!
> 
> 在 2022/11/15 6:07, Tejun Heo 写道:
> 
> > 
> > Any chance I can persuade you into updating match_NUMBER() helpers to not
> > use match_strdup()? They can easily disable irq/preemption and use percpu
> > buffers and we won't need most of this patchset.
> 
> Does the following patch match your proposal?
> 
> diff --git a/lib/parser.c b/lib/parser.c
> index bcb23484100e..ded652471919 100644
> --- a/lib/parser.c
> +++ b/lib/parser.c
> @@ -11,6 +11,24 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
> 
> +#define U64_MAX_SIZE 20
> +
> +static DEFINE_PER_CPU(char, buffer[U64_MAX_SIZE]);
> +
> +static char *get_buffer(void)
> +{
> +       preempt_disable();
> +       local_irq_disable();
> +
> +       return this_cpu_ptr(buffer);
> +}
> +
> +static void put_buffer(void)
> +{
> +       local_irq_enable();
> +       preempt_enable();
> +}
> +
> 
> Then match_strdup() and kfree() in match_NUMBER() can be replaced with
> get_buffer() and put_buffer().

Sorry about the late reply. Yeah, something like this.

Thanks.

-- 
tejun
