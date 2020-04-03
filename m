From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Date: Fri, 3 Apr 2020 10:45:05 -0400
Message-ID: <20200403144505.GZ162390@mtj.duckdns.org>
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
 <c28be8aa-d91c-3827-7e99-f92ad05ef6f1@yandex-team.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MqUKZEQW4ktugpJoN6yg32u1OINgXC5Ef9CKI/ulXcE=;
        b=qHuagVSw8AoY49GuqNt4Gyp4jl3Y5A6Zny5YowwmaLIOfUdkYqgJrdhGbLqAbimiOd
         IWVRwHVhkr5RChCnMkes71SpREXTrBmXtegDcscwc3bIqR71AJW0Lgxu+I0+Yl5TFmzy
         akUWBL5VTWVFteCSVIoQRGM8dGqqLIVdX16P+sSXDAZhNrPmnHuOc/lxMlLaIUZ05MrD
         TxkS3mAR4Kn6N3Z08aEICPf0TNg3yyw/OYdL1SLobcYzYmO3TlUCYSQiVcbyrwo2s/EV
         I558rvJoaucMCbX7w+2g7eQdntMf+OaN5JtcILeNSEJcKHCa5C3E5HuyrDSUU9MUp3Bn
         GqrA==
Content-Disposition: inline
In-Reply-To: <c28be8aa-d91c-3827-7e99-f92ad05ef6f1-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 03, 2020 at 05:37:17PM +0300, Konstantin Khlebnikov wrote:
> > How would this work with things like inetd? Would it make sense to associate the
> > socket on the first actual send/recv?
> 
> First send/recv seems too intrusive.

Intrusive in terms of?

> Setsockopt to change association to current cgroup (or by id) seems more reasonable.

I'm not sure about exposing it as an explicit interface.

Thanks.

-- 
tejun
