From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 21/26] cgroup/misc: allow misc cgroup consumers to read
 the max value
Date: Mon, 14 Nov 2022 12:33:06 -1000
Message-ID: <Y3LCIutS6JqgODFG@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-22-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RIJKU3snVyxC51xALky4cDkfvZqf0MxxVPDKQ4SpbaM=;
        b=cGgiYL1iQ3flF9qgaiwC8/imMygH4i4SkDvcr3Uv1pcmQTiZ831dBIi+RfFltRLjj4
         2eMZg/7p692+E6KZ0LD+7MJ1PRpayG6hnwOR60/cUy8SZgHdSElBkmrK3vbkJTizI65d
         nC0CQOIIWzTWQ1xd7FtWzKPvJBEscIHEtq2dUhUq4+cK1SXjUQboNqEczXgT6+fYl2kP
         n6PeSLBBoYOLvGg/8lTduzwXAFBSAkfrtC8BQWs7ZNWeftMYiei67ELaxUkuM8S6Zau5
         NSZsedzOCdZsgoEk3YMKdbUSmcX2Si6Q++vm2vArD0n7kkj8y1tBVYf26A+A4BHprIi7
         DvYw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-22-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Nov 11, 2022 at 10:35:26AM -0800, Kristen Carlson Accardi wrote:
> The SGX driver will need to be able to read the max value per cgroup
> to determine how far usage is from max. Add an api to return the
> max value of the given cgroup.

You can add these helpers in one patch and I wouldn't mind a downstream user
just reading the field directly either.

Thanks.

-- 
tejun
