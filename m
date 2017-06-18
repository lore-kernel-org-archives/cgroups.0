From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/31] cgroup-v2.txt: standardize document format
Date: Sun, 18 Jun 2017 06:46:02 -0400
Message-ID: <20170618104602.GD28042@htj.duckdns.org>
References: <cover.1495156488.git.mchehab@s-opensource.com>
 <1f0804f2263073287d2a106c12f88f295a30cec5.1495156488.git.mchehab@s-opensource.com>
 <20170519145921.GB7174@wtj.duckdns.org>
 <20170617121831.541ebb18@vento.lan>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F1I0ImJ8WUsK9roQ3KpS9EvQeua09X99TX5Vki/Gl6k=;
        b=lQXFukB/naHMHHeeE6Szrc8Y3eyFYAvGwC2w80wnAR8CpmIRZU+39bSz2hhDZ+vTQz
         6T2VzE+KdkGLYPlR6DijBGeusd8E0/C0FA+KKFc2lq9kc4CYWXC85+icQOehDogBZsFj
         6QB4/utDBxjW91aHpIsRkWzvgRZ71vLn3Ux2+L0x132f1g341DmzyLORiskMJ2ZNly7x
         83KbM5eANjLAIMx1k4DkG/wFiB7ubQRdS0VHPsylQ5G+Pmgjb1itHDXUZiyym9Y7oM1M
         ndpnAU1YfSjrJ/G9dZxmhxS/fIW23lhjGqHm88uxdfb/lcFheC+SGIUb1m9A0P3fLOXV
         b/cQ==
Content-Disposition: inline
In-Reply-To: <20170617121831.541ebb18@vento.lan>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Richard Weinberger <richard@nod.at>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, linux-mtd@lists.infradead.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Mauro Carvalho Chehab <mchehab@s-opensource.com>

Hello, Andrew.

Can you please apply Mauro's doc format update patch for
cgroup-v2.txt?  The mm part causes conflicts, so I think it'd be
easier to route it through -mm.

The patch to apply is in the following message.

 https://marc.info/?l=linux-cgroups&m=149771274105674&q=raw

Thanks.

-- 
tejun
