From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] memcg: fix memcg resource limit overflow issues
Date: Wed, 31 Jul 2013 16:23:50 +0800
Message-ID: <CAFj3OHX4WLaecyE_zFbnFKs9wrCWTq2eDAUDMxqPg8=TYt18gg@mail.gmail.com>
References: <1375255885-10648-1-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=VPKhN6JJ0BKYdaZAK9sDTDLLOf0o1WIOCr4w//4qHfM=;
        b=pIHlp9WS61/s0Sc/GR6mKsVLIl7XmHSYTHpdFY6AtC5Y9/iYRmbiRg2MbpIPw8+BEO
         kJqv9YbJJ3JENrdldeQNm24oyXUAszcPZUF/4SS7ZAZkjIQNLtY2Oas5aRscv5GnJczO
         iditrrEodTFxo2tF+lUzUDYZf+k+QpXx2PykXF0I2fIsh5dahuxV1y6F5n+Yg9/+YcDN
         wZSD2Uc2JH6h3vPln0ilD/t/adPvQSX7HYzpypGZauS91sZjKN0vu9iJQhG8OF17NRBC
         yvhczKiPTbnfVzkv4JJ5gii4tJ6vPnDT3zBfN5LUp9IcuczOMJ0w1EWECMZzvknMPhW4
         FbEg==
In-Reply-To: <1375255885-10648-1-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hi list,

On Wed, Jul 31, 2013 at 3:31 PM, Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> This issue is first discussed in:
> http://marc.info/?l=linux-mm&m=136574878704295&w=2
>
> Then a second version sent to:
> http://marc.info/?l=linux-mm&m=136776855928310&w=2
>
> We contacted Sha a month ago, she seems have no time to deal with it
> recently, but we quite need this patch. So I modified and resent it.


No, I didn't receive any of YOUR message, only a engineer named Libo
Chen from Huawei connected me recently. I don't approve you to resent
them on behalf of me, and just before you send this you even don't
send me a mail. Besides, after a rough look, I do not see any
innovative ideas from yourself but just rework patches from my last
version.
So I'm strong against this patchset.
