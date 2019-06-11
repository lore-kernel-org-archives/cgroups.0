From: Tejun Heo <tj@kernel.org>
Subject: Re: -next-20190607 kernel: oopses on bootup or shutdown
Date: Tue, 11 Jun 2019 06:25:36 -0700
Message-ID: <20190611132536.GE3341036@devbig004.ftw2.facebook.com>
References: <20190611085753.GA12364@amd>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z3SVKPRw9ZtZpo81aZhS+cQGKdAzxZJguviRIBAK0b4=;
        b=hkx2GURtFLnpgApzKLSXJXyEaJj/ziUqazQEkyPie9Mnwpy4xHumI5UUcVe5mQza0b
         lKH388U00jEmGYS0jIwaGGYpjrprh72VY+OnyINgSvTUXaYlPdxS3mj1Vjren5hcpCiD
         3j69a1dFIzq97phFF0iX9sgjkxwfs7m0o4FGmtMxhv+XGKm8J33kSmuSDw+sq+oH1w6s
         SMmnaIOnv18Yq9M2kVkkdawBKUmOD5mewX4Wtlupss724qP3FdnyRFlv27hqw6Ws5qRv
         VnLC7hoeVOXhKmqAII4wOKn1Kn7GOHXop+dfFC0bDzxYLkV4InOdMxh3fhEFg8UmkxZf
         /ITA==
Content-Disposition: inline
In-Reply-To: <20190611085753.GA12364@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Machek <pavel@ucw.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au

On Tue, Jun 11, 2019 at 10:57:53AM +0200, Pavel Machek wrote:
> Hi!
> 
> It failed to boot three times; now it booted but failed on shutdown.
> 
> Hardware is thinkpad X60 (32bit x86), and I'm copying oops by hand.

Can you please try next-20190611?  It should be fixed now.

Thanks.

-- 
tejun
