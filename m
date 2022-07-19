From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v3] block: don't allow the same type rq_qos add more than
 once
Date: Tue, 19 Jul 2022 10:56:04 -0600
Message-ID: <036e5ae0-4908-d4ab-c2e5-56e9ca85e26d@kernel.dk>
References: <20220719165313.51887-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=poCk2apV+LMtrh3G4K7hLOMkOXCZ0THBzF1nOrkzCWo=;
        b=yCSlWK6U1YnSRZkOtdp6YyqCJDH4MsE8HBxrY8JvGdpdPaMtrz37Oqf/H1V0B7iGxs
         is98EmpmeqH+jtesAGr3TMA6YnmWpfiOfAAVxJaPgyNum25MdK4GELkT2jb84Lkhbg/K
         nZGhmS3edZueAXgeiXSEmbbMdWtuB+7l7EkmuTATvZTVLW0V2s4BbZ6mHlsAnayzvxO7
         qAprW1eUYDgLCGri4mpZnaMOaDooIpl2T7WIDqoLruD/vTFO/hvuvDTZkNo9jZJLOz56
         tdjrRBNaSKadnB4a8amgh8GS8GcHBcPhM/NZ+rBRSuT5MPNT+s6Un9Q6hQOS/YN5SLLy
         fQpg==
Content-Language: en-US
In-Reply-To: <20220719165313.51887-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/19/22 10:53 AM, Jinke Han wrote:
> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> In our test of iocost, we encounttered some list add/del corrutions of
> inner_walk list in ioc_timer_fn.

This still fails for 5.20 and you didn't correct any of the spelling
mistakes I identified.

Please take your time to get this right rather than attempt to rush it
and needing to send new versions all of the time.

-- 
Jens Axboe

