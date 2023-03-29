From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-throttle: Fix io statistics for cgroup v1
Date: Wed, 29 Mar 2023 08:54:32 -1000
Message-ID: <ZCSJaBO8i5jQFC10@slm.duckdns.org>
References: <20230328142309.73413-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680116074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SvJI0H5Hc+fTAdKMTbT6mE44kRVz6oz6/kFJz7w8sLA=;
        b=YC5lVgwC4h2kPani96r3mkA6vwoBzUZ2d7vme5A2e7AJauPWYlwhzZTESImrRROqVc
         g4z4UkSqsrJZMiMHOfSIT0w7fc7g+oPawMX4cbot2bSCdbhHVelHRMeh1ZpmISpBcaYc
         1tdnnlkV0KxDHcgqQ8KnAECDBJo7YxjufIdr8syQtaPFlwzlY6EZzekoxmqlGnw8+BHn
         p0xiVxUtS14PDNIAv9QLz4EPr/stF6xAJZ3q+TUEL8W90LyewZTGMjOgiYyqSY/73Iea
         yGZ7v4T0swwe8GmcCLb8yb5uXhB3q1tX0vOD9hMQUot3FQKbNE4cA3HbNrKoX2pedSry
         6okw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230328142309.73413-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666@bytedance.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 28, 2023 at 10:23:09PM +0800, Jinke Han wrote:
> From: Jinke Han <hanjinke.666@bytedance.com>
> 
> Now the io statistics of cgroup v1 are no longer accurate. Although
> in the long run it's best that rstat is a good implementation of
> cgroup v1 io statistics. But before that, we'd better fix this issue.

Can you please expand on how the stats are wrong on v1 and how the patch
fixes it?

Thanks.

-- 
tejun
