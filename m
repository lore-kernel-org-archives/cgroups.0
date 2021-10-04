From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Question] io cgroup subsystem threaded support
Date: Mon, 4 Oct 2021 06:40:13 -1000
Message-ID: <YVsubc0I4tBmnudM@slm.duckdns.org>
References: <20211001110645.uzw2w5t4rknwqhma@T580.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=augfsTXb1EqvWcbD8kMG8Mmo1E+4/qJhNfszNseO99c=;
        b=hsSNN+UJ6NnGshSkpom3FjtmdE+DbH8x9DAgnM1PuqqlMQrpzGIdTtoIPKr940w9Nr
         PcEtV+ka2MnEV19RdJ4Hhn4xvp4EI1ggXEKh0vKP/V48uTCf4Ybg6OcsE3Jad5ViaBQw
         7Zpdw7pd+PrAIct7CcloJQnlX4sE9JMGM3Th1ZdhDNqdxXkxUgbHY2pTWHI/HB56GpeE
         sUg0X0NwLREDGoaflyojm8yN6hrwpmzOWsX8HvKK9QEvhOy9PCQgNDFw79mFbLaCaBlB
         fSeUWa6jYdveegPdcucCE9C2YoWT6cExHjsq4czsR40QDqO3sJxXYzkxj3UYMDH1ip5Q
         7V5g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211001110645.uzw2w5t4rknwqhma-3Hjs5a4P6Kh82hYKe6nXyg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Hultgren van der Horst <odin-KgRVb285F3Y0FkRhN5fn+A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 01, 2021 at 01:06:45PM +0200, Odin Hultgren van der Horst wrote:
> Posted to both cgroups and linux-block
> 
> Hi i read though some of the source code for cgroups, and from my understanding
> the io cgroup subsystem does not support threaded cgroups. So i had some questions
> regarding this.
> 
>  - Is there any future plans for supporting threaded?

Not at the moment.

>  - What are the main hurdles in adding threaded support to the io cgroup subsystem?

The biggest is the fact that page cache pagse are owned by processes not
threads. A related issue is that writeback tracks ownership per inode with a
mechanism for transferring ownership when majority writer changes. Splitting
IO control per-thread would increase friction there. So, the summary is that
the kernel doesn't track related resource consumptions at thread
granularity.

Thanks.

-- 
tejun
