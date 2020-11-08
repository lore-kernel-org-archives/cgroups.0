From: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 0/4] RFC: support for global CPU list abbreviations
Date: Sun, 8 Nov 2020 15:21:40 -0500
Message-ID: <ca462940-c81d-d968-c870-e1a991331522@windriver.com>
References: <20201108160816.896881-1-paul.gortmaker@windriver.com>
 <20201108180222.GA17637@paulmck-ThinkPad-P72>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLAK9FzJCGbK3dUFfXIe7ExR8HpHqLU6wJAyh2n3a8E=;
 b=Dx78A9ir6aY3bdQdLCnUrMBn6iCJGjt5fW7JuKAJqMkZWxnaD1Sayzc3TJRN6uwL5Jpy8sAQjINriHtWV//yYyUmmB8Tv3L8iBbx82mt5ZauBtKKaA62E+JiAB/S2ok4UF8kPn6S+oskB+9a51tuwYradc9qxBS+Wd/RlGGNM5k=
In-Reply-To: <20201108180222.GA17637@paulmck-ThinkPad-P72>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 2020-11-08 1:02 p.m., Paul E. McKenney wrote:

 > Or I can carry them if you wish.  My expected changes in response to
 > this series are shown below, and are also what I used to test it.

Thanks Paul - that would get linux-next exposure w/o me pestering sfr.
If nobody else has objections, having them in rcu-next would be great.

Paul.
