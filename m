From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: cgroup_subsys[ssid] is never NULL
Date: Tue, 30 Nov 2021 00:33:41 +0000
Message-ID: <20211130003341.kbakqtpjffvprxxm@master>
References: <20211127145919.31159-1-richard.weiyang@gmail.com>
 <YaUPej4QUZoFAuOM@slm.duckdns.org>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HAWGRtmFkA3dGuVLOofW70iShXqEXTjub0/LjbjNnFs=;
        b=IQRCFvgoknPXI0N4anxUO98CR3D/fjWKhTqrhYTYwOKYZsKOEniugBe0rkgFDw+pEU
         DYclfBs3n0AJ5fN2vus+UgQSerhKFugGcb6Mgd7kxRc1vYsU/DHjCV9fFtV/ymONFo4U
         LA1VGMzsfHSyWs5RXIv3SdFR/hzBwbKXS0WGdTu38+8JoJD0maFQIsPL+h6/Jq44ezcT
         p+X1xcJLRcr82Ge3gKfMSIAFbmwPKjBxN5AaNadC6jgyqyIgRnGfQ7RITSQPRobf5+Y8
         gk2GMJdFxz8lfROwCzTbf45184nSX0StWPKlVXexB1B778+GjEdlyaC/+NcBi5arD68v
         E12g==
Content-Disposition: inline
In-Reply-To: <YaUPej4QUZoFAuOM-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 29, 2021 at 07:35:54AM -1000, Tejun Heo wrote:
>On Sat, Nov 27, 2021 at 02:59:18PM +0000, Wei Yang wrote:
>> When the check, (ssid) < CGROUP_SUBSYS_COUNT, passed, it means
>> cgroup_subsys[ssid] is defined to its proper value. It is not
>> necessary to use a true to enter the loop.
>...
>>  #define for_each_subsys(ss, ssid)					\
>>  	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
>> -	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
>> +	     ((ss) = cgroup_subsys[ssid]); (ssid)++)
>
>So, now the compiler has to test whether ss is NULL or not before each
>iteration even though we know that it's never NULL. The whole point of that
>"|| true" is telling the compiler that the pointer is never NULL.
>

That's interesting. Thanks.

>Thanks.
>
>-- 
>tejun

-- 
Wei Yang
Help you, Help me
