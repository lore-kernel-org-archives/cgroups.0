From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Thu, 20 Feb 2020 16:41:21 -0800
Message-ID: <0cdd654b-a1f6-fea2-e448-209fbbe14b5c@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
 <CAHS8izPUFQWq3PzhhRzp7u11173_-cmRkNuQWEswS51Xz6ZM0Q@mail.gmail.com>
 <20200219130648.83e6810848774c6fd649c445@linux-foundation.org>
 <CAHS8izN_FJektipBwiLsCO8ysMTM7k=CR_k3OV7+_y0ZbrGw+A@mail.gmail.com>
 <20200220162813.aea8a14fe050473b73440323@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8UF7TnpDrogK96GK/v9GR0EULypgZZOqVd00Gzxcx2g=;
 b=Kqdfpqf6nhyy75vO7hhM1Vjoqo3tKVUKImo42gDEp8MsD2AhfTKY+04p/JTeQJrqsJJy
 lq+fKYoaEmEeH1xYK3IeSV7GRNo/+VWCvDKUYaxnWVYWEoFj2SsW7hELlojWZe66vHPW
 uYzDPfOCgODK+goPQLGPLw6BIkENnOStx74jU8f/pSrRiC/bsGSyaS6YuvWlYrLNssVS
 AkRGApqDJgDgO1XXsjdwKFK+QpLstrVh/K8ypUixojwuwdkaiSe7Q9JwtEwwhofXvQe+
 GMjcpYm+pXhxhu1qrpS5ne5oReqegqTyjXo5pZJi2Q5sOPln90lHKnN6SnCCJmHQM/NL Ww== 
In-Reply-To: <20200220162813.aea8a14fe050473b73440323-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/20/20 4:28 PM, Andrew Morton wrote:
> It all looks pretty good and I expect we can get everything into
> 5.7-rc1, unless some issues pop up.
> 
> It's unclear to me whether
> http://lkml.kernel.org/r/CAHS8izOTipknnYaKz=FdzL-7yW-Z61ck1yPnYWixyMSJuTUYLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> was going to result in an update?

Yes there was,

https://lore.kernel.org/linux-mm/20200219233610.13808-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

BTW, I've been through the selftest code at a high level.  Not at the level
of detail Shuah may provide.  I am just happy that Mina provided a relatively
comprehensive test for this new functionality.  Will give it an ACK shortly.
-- 
Mike Kravetz
