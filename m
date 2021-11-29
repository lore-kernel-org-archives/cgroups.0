From: Tejun Heo <tj@kernel.org>
Subject: Re: Use after free with BFQ and cgroups
Date: Mon, 29 Nov 2021 07:12:42 -1000
Message-ID: <YaUKCoK39FlZK9m5@slm.duckdns.org>
References: <20211125172809.GC19572@quack2.suse.cz>
 <20211126144724.GA31093@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iqv7qLF7uITwuXt3oWFITR3Bhp8jkUr/nLRX6jeUX60=;
        b=a/KS+rJo29zRyxgYOvHGrL87E6B0Jp7PSbf4q3c/bWycMj3+nFZUi+0XhTm3kpyFAP
         HY/nHWdT2dD7ii1e97qDpyUAcc1mREhYZIZi6kVEV0R1TZ/AEQBBMfufIMjyuKRcBWr5
         v3vFEw2cS6Ste1nsNiuin6pHy1Har2CYuWKvIpDljCU5dynoRivA3fGU++i+bUZ6Ic3H
         GEx7q7zVlIZN0y2iJlnbird+UjPoe8NiH4GwzWKpd2u5paTLgj5ZhnLlbSrAe1pVSDRs
         wu7fEOpCiYOI36yu7wSAdgcMY7PhgCmJiahM3bnwhwYng1wGYDzQnX6qRPSf0qDpDAAA
         Aiww==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211126144724.GA31093@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, fvogdt@suse.de, cgroups@vger.kernel.org

On Fri, Nov 26, 2021 at 03:47:24PM +0100, Michal Koutn=FD wrote:
> The question here is how long would stay the offlined blkcgs around if
> they were directly pinned upon the IO submission. If it's unbound, then
> reparenting makes more sense.

It should be fine to pin whatever's necessary while related IOs are in
flight and percpu_ref used for css refcnting isn't gonna make any noticeable
difference in terms of overhead.

Thanks.

--=20
tejun
