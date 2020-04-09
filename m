From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 18:56:46 +0100
Message-ID: <20200409175646.GD1040020@chrisdown.name>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
 <20200409094615.GE18386@dhcp22.suse.cz>
 <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
 <20200409103400.GF18386@dhcp22.suse.cz>
 <20200409170926.182354c3@hemera.lan.sysophe.eu>
 <20200409152417.GB1040020@chrisdown.name>
 <20200409174042.2a3389ba@hemera.lan.sysophe.eu>
 <20200409175044.GC1040020@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RE3VHE0rvREJWCVJmNBX2NQs76M9qqKu6sqBlBeuyf4=;
        b=BtsXpXg+oW5k/lZe16X3+KqOuDsPyI7Qm6wWMejyMZQuO/VQYg+545plGEu1Cc1V25
         GZNWzHCYU3sVNveqreKBmg8RIAMWW17b4w4QjsF25Zajw3P/0myBLGQaKzocj83iDYfQ
         pQuDN4LU0guMN2eu2NxN0YceZOeQ8Q9sufPYo=
Content-Disposition: inline
In-Reply-To: <20200409175044.GC1040020-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

 From my side, this looks like memory.high is working as intended and there is 
some other generic problem with reclaim happening here.

I think the data which Michal asked for would help a lot to narrow down what's 
going on.
