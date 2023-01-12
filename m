From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Thu, 12 Jan 2023 11:26:42 +0800
Message-ID: <0e03867e-54ea-fb10-1f8a-f098c9dbb026@bytedance.com>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3> <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
 <c839ba6c-80ac-6d92-af64-5c0e1956ae93@bytedance.com>
 <20230111123532.GB3673@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsH0mjnH0SeMzrOGfLla9s5TybpBmyzM+PHEYBJpLrQ=;
        b=8NifJggs/yh5SMPhQK1Rns2F/N9YHJzl2Ypi9i9jYMCq8JvNLfeXx0wDvwNbHAEYZS
         aiNsnWSqgv0g2jFpnl9MK1Y2zgFOOtY1/Cr1ukz7V2f3c//7jqoojUzeAWiPtkAkNsu3
         y5NrTN9VglZvUCli+KS+Fuep2brgdFlSuTBp++iYWwI3HI8Urzjnp02w/NY3kipmZii8
         UqqCazVNBK5ELchNv1pdLGUa9DDY77/ME9StIercWWbZEJGmjbAcWyWNj+BuzivqdALs
         /zWjgQfVGjobtikFVWg83AqJJYWvGhvXR0D+XrKxLiyTjTVPhVt3cnyakg9mR7p1e29N
         I3Sg==
In-Reply-To: <20230111123532.GB3673-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org



在 2023/1/11 下午8:35, Michal Koutný 写道:
> Hello.
> 
> Thanks all for sharing ideas and more details (in time-previous messages).
> 
> On Sat, Jan 07, 2023 at 02:07:38AM +0800, hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>> But for some specific scenarios with old kernel versions, blk-throtl
>> is alose needed. The scenario described in my email is in the early stage of
>> research and extensive testing for it. During this period，some priority
>> inversion issues amoug cgroups or within one cgroup have been observed. So I
>> send this patch to try to fix or mitigate some of these issues.
> 
> Jinke, do you combine blk-throtl with memory limits? (As that could in theory
> indirectly reduce async requests as dirtier would be slowed down.)
> 

Hi

In fact, some of those tests above are done in vm with only total 16g 
memory.

Agree with what you said, if we further tighten the memory usage, things 
will get better because this will indirectly reduces writeback pages in
blk-throtl queue.

Thanks.
