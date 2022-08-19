From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 4/9] blk-throttle: fix io hung due to configuration
 updates
Date: Fri, 19 Aug 2022 07:33:22 -1000
Message-ID: <Yv/JYrqLygLAX56N@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-5-yukuai1@huaweicloud.com>
 <Yvv3jcycOguuEbA3@slm.duckdns.org>
 <215b4842-c09f-d622-7127-c8b1d9ce3aa9@huaweicloud.com>
 <Yv0q7T5Eg6MzOIuU@slm.duckdns.org>
 <d82305ef-1672-a648-f0b6-882bef1659f1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=fqadMmXWI3FPz7mWQ1shnlAoTXiP9jnMsgjYOJuOFoo=;
        b=XLoC5u3RQueoGHx7vAILKwaXo9QAjQrU4TwhNNPQBOd1CnzLc6TQpxCmCFhiADzo2M
         vVzngvi3WWgBQbHqiBk3ZDLCAUuPjsOGvq+AGpzzL5J1EfxslGp6P0d16cIryfiH4y/n
         xkTma1UrGwx13EnmFlj+t92DXI+pb/J7lFFi07Y6kiEK594GfromCsbC9ArT89I/NTo9
         arjB8kANy2CdiyZSmvdv0vmifeMOLkJ7YYPu32SOgSPlcSb/X+g3dYWd/lAAaArmjvvn
         mSD19RWLbvEOBRRoOKBhYlBNuq2YnHIzJg8JAJEyfRCobB7OkDORfs/qQOxdqjBkUUAH
         mGKQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d82305ef-1672-a648-f0b6-882bef1659f1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org >> yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Thu, Aug 18, 2022 at 09:16:28AM +0800, Yu Kuai wrote:
> 在 2022/08/18 1:52, Tejun Heo 写道:
> > On Wed, Aug 17, 2022 at 09:30:30AM +0800, Yu Kuai wrote:
> > > > Would it be easier if the fields were signed? It's fragile and odd to
> > > > explain "these are unsigned but if they underflow they behave just like
> > > > signed when added" when they can just be signed. Also, I have a hard time
> > > > understand what "preempt" means above.
> > > 
> > > I think preempt shound never happen based on current FIFO
> > > implementation, perhaps
> > 
> > Can you elaborate what "preempt" is?
> 
> Here preempt means that the bio that is throttled later somehow get
> dispatched earlier, Michal thinks it's better to comment that the code
> still works fine in this particular scenario.

You'd have to spell it out. It's not clear "preempt" means the above.

> > How about carryover_{ios|bytes}?
> 
> Yes, that sounds good.
> 
> By the way, should I use 'ios' here instead of 'io'? I was confused
> because there are many places that is using 'io' currently.

Yeah, blk-throttle.c is kinda inconsistent about that. It uses bytes/ios in
some places and bytes/io in others. I'd prefer ios here.

Thanks.

-- 
tejun
