From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Date: Tue, 7 Feb 2023 10:05:35 -0700
Message-ID: <53816439-6473-1c4f-2134-02cd1c46cfe8@kernel.dk>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk> <87k00unusm.fsf@nvidia.com>
 <eff3cc48-7279-2fbf-fdbd-f35eff2124d0@kernel.dk>
 <Y+JmdMJhPEGN0Zw+@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVqRghfkJYuM2PO4hknX+k72h52RQ4rzy+E+T+6Adgk=;
        b=NrJ1K2UoJ7Rjni9tW6A0bOtgmmUrFQgp/gxeUvvugNQ779Tmwsvw5KYFn9fyaEzNI2
         /5G3kPoaS3H1IpYLMjHsrXUlf/64rBtMzO6PBpX5X0DGSV02+wINR6dB4vVaXy45K41f
         XNWxuGObC9U+oBPPi4D9GjlGrfjBdbY/vkPRO8HuBhCuU5uC8S5SDH27CWFzuysxygw7
         RNXTxobeIhbufFscikOA/5TWQSQPVjJfvpiqfsSdwBcBNivb7pG1aclHAeZw9s/OSTFB
         nydAWL8A6IzFP+jEPVNi8grdst9njJIFvsLR2YuL8FPMKspueF6CAze9GhUwyc6+9ZeH
         zprQ==
Content-Language: en-US
In-Reply-To: <Y+JmdMJhPEGN0Zw+-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/7/23 7:55?AM, Jason Gunthorpe wrote:
> On Tue, Feb 07, 2023 at 07:28:56AM -0700, Jens Axboe wrote:
> 
>> Outside of that, we're now doubling the amount of memory associated with
>> tracking this. That isn't necessarily a showstopper, but it is not
>> ideal. I didn't take a look at the other conversions (again, because
>> they were not sent to me), but seems like the task_struct and flags
>> could just be passed in as they may very well be known to many/most
>> callers?
> 
> For places doing the mm accounting type it cannot use the task struct
> as the underlying mm can be replaced and keep the task, IIRC.
> 
> We just had a bug in VFIO related to this..
> 
> If we could go back from the mm to the task (even a from a destroyed
> mm though) that might work to reduce storage?

Then maybe just nest them:

struct small_one {
	struct mm_struct *mm;
	struct user_struct *user;
};

struct big_one {
	struct small_one foo;
	struct task_struct *task;
	enum vm_account_flags flags;
};

and have the real helpers deal with small_one, and wrappers around that
taking big_one that just passes in the missing bits. Then users that
don't need the extra bits can just use the right API.

-- 
Jens Axboe

