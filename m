From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Wed, 23 Apr 2014 15:27:07 -0400
Message-ID: <20140423192707.GD4163@mtj.dyndns.org>
References: <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
 <20140423185835.GD22755@redhat.com>
 <20140423190043.GB4163@mtj.dyndns.org>
 <20140423192108.GF22755@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7UYVLEBkb2jfI787C2E6rJAttqqB+MQDN5SdrWEFC6Y=;
        b=yJlruUSX5ngcsKtvi8+IImv5eGFts7B1DwzeubOkG/KBygGEvUm5nzKQ8GY//Vx3X3
         YuhwMUnkb6WJR49M3bJym9eSF/ZN11QCUja6kiFLT1u7kI0DqfPfu0TkB1WOy9X45bmE
         TTPk2s+MpuGuQ3CO9MiRxVgI4GteXUp+JIaurDJrr+29vFaF25W1HN9AU3/Uf2ujtSv9
         f9UDDi1IgGsracDbI7DN6xvmevsz5k+tie3FhkW+/Y6gzNoxYUhmMUqn1mkNyjFyZRz/
         zOxCuei42crftMyfBC8ZkzVvJw+hIaW9bkVKKgppxNwXvV/wQA+FnpNjHarg4F7k1HKt
         lzlQ==
Content-Disposition: inline
In-Reply-To: <20140423192108.GF22755@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello,

On Wed, Apr 23, 2014 at 03:21:09PM -0400, Vivek Goyal wrote:
> In general this idea makes sense. Exporting both request and bio will
> solve the problem of io accounting. Also that should allow us to
> get rid of blkio.io_merged.

Yeah, that'd make more sense, I think.  IO submitted vs. actually
executed after merging.  Pretty clear definition.

> What about sync/async differentiation? Throttling layer seems to flag a request sync
> only if bio->bi_rw flag has REQ_SYNC set. While CFQ seems to consider
> request sync if bio is either read or bio->bi_rw has REQ_SYNC flag set.

Heh, I think we'd need to unify those no matter what.  The subtle
difference is extremely confusing.

> So we need to make this definition uniform. Or I am wondering do we
> really need to export sync/async data. (Again put in by google folks).
> How useful this info really is. 

Hmmmm... yeah, maybe that'd be the best way to go about it.

Thanks.

-- 
tejun
