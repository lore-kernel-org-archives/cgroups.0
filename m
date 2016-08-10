From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Blkio not providing performance relative to the weights
Date: Tue, 9 Aug 2016 23:42:04 -0400
Message-ID: <20160810034204.GC25053@mtj.duckdns.org>
References: <CAKpF0T4sLmp=U-RQTeOk6miLG9daarJnRk2v=gL6MvCaS+a4Kw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vHk1o4lfaZORV2Zo9rs2it/QGrY3louHMevGZKyl/qo=;
        b=aq76OpG8nytI7hH0MEWEbRz4sSS1nCSAnZFLE+rMjLnEY+OFZo4UPEQz7eZ2AZJwji
         rVAb+4E9CGvqjOURpFyFWESmQpOUWDvdVTOFm7Ci2D1Jof7NG6mGcpNewtd0g5bC/ZNa
         Vm3UNyj8K524rw4gAQgS6aYHZh4dCbsZXjDKB2eIN2u0yGTEzgOEiB8ZyBLXzF0oYbIY
         Y+OBPIOIdIe55ObL69cc++XKUYUNTtptLwDhV8Fs8ZpDMyML7SQojjsluOf/4Jd4l3sh
         3XBXN1g6y3QrXQdE1mEr74Lib7PZZ4qPlAVkAogGmHU5Ek6nGB/yGNUR5sqAurghtFqu
         pWKA==
Content-Disposition: inline
In-Reply-To: <CAKpF0T4sLmp=U-RQTeOk6miLG9daarJnRk2v=gL6MvCaS+a4Kw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ankur Khurana <ankur.kkhurana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Ankur.

On Thu, Jul 28, 2016 at 02:55:39PM +0530, Ankur Khurana wrote:
> My question is : Given that the bytes read were not in ratio of the
> weights provided, Is this expected behavior ? if not, is it something
> that I am possibly over looking while performing the experiments?

Unfortunately, cfq's behavior isn't all that deterministic when it
comes to proportional control.  The weights and actual sequential
bandwidth do form postive correlation but that's about it and it
doesn't look like cfq will get a lot better on this front.

Thanks.

-- 
tejun
