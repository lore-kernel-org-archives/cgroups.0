From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH -next 00/11] support concurrent sync io for bfq on a
 specail occasion
Date: Tue, 26 Apr 2022 16:24:51 +0200
Message-ID: <7C91FB1F-0690-4D1C-A631-98236F6DC55F@linaro.org>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220413111216.npgrdzaubsvjsmy3@quack3.lan>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vGi2xWo0glztPoHlb3pGflxD9oTprLjQ3hPK/vMNf9g=;
        b=hQ7W0BWcpUkQc/T8HXofDKebFeuGCBNPA5SZVDUfqR/Wgw7Qois8SYRnyk9WOoAHeu
         F/9jI9kUIifVKMlpQKopUdI/JZsUhYq/vQcqeQK4/nxr9MspWekGKFdgaWjZZsQVqxhu
         tmS+2B+y3iD7cVRg0aBWsQnviwtyJcRl60tsNuO09pmmr2LGiuSl+b9edYTc8nrargte
         ufPok664AcZ7cV+an88gvuWIEVSJMo3IR31ozD8FfRbz1dZEA5V21oxe1GZ9V7jSg/cU
         hgKUeLqYaG8JBRTtZFaqg06j5HFctbBkAB4mjjXcEmG4ci7ClXQz0YfqeQxhVk0uUDy0
         5fKQ==
In-Reply-To: <20220413111216.npgrdzaubsvjsmy3@quack3.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack@suse.cz>
Cc: Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com



> Il giorno 13 apr 2022, alle ore 13:12, Jan Kara <jack@suse.cz> ha scritto:
> 
> On Sat 05-03-22 17:11:54, Yu Kuai wrote:
>> Currently, bfq can't handle sync io concurrently as long as they
>> are not issued from root group. This is because
>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>> bfq_asymmetric_scenario().
>> 
>> This patchset tries to support concurrent sync io if all the sync ios
>> are issued from the same cgroup:
>> 
>> 1) Count root_group into 'num_groups_with_pending_reqs', patch 1-5;
> 
> Seeing the complications and special casing for root_group I wonder: Won't
> we be better off to create fake bfq_sched_data in bfq_data and point
> root_group->sched_data there? AFAICS it would simplify the code
> considerably as root_group would be just another bfq_group, no need to
> special case it in various places, no games with bfqg->my_entity, etc.
> Paolo, do you see any problem with that?
> 

I do see the benefits.  My only concern is that then we also need to
check/change the places that rely on the assumption that we would
change.

Thanks,
Paolo

> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

