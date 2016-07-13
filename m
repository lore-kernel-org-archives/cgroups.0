From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CGroups: idr_remove called for id=65536 which is not allocated.
Date: Wed, 13 Jul 2016 16:14:17 -0400
Message-ID: <20160713201417.GA29670@mtj.duckdns.org>
References: <CAO2SnQ92vK2nn_8De_yq0vud=a+5k0WUGcx7jk3yHCRJ0MAsGQ@mail.gmail.com>
 <20160713152226.GC4065@mtj.duckdns.org>
 <CAO2SnQ-fEXH3xpAV3x61h1ewp8j8EYGPQTuhviE6=4Z2=KHvcA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UuRAPWgIfWNdUfGEIsDqBC6I8kMiKNeb1qys01EfkgY=;
        b=RaxqV7aWcmJK+/BJ6tWAkH1bUz7fL2/U20pl5zOj/iNzaWdAh4m/AlEbNMQ3j4p2I9
         dofU4sA8oclHAwMGu6zZDaJChIBVaPKJ2F+xKFonRos9G2IZc5sflqVR5Qeg4x+Jb1DO
         I+l0a5u2eAORketL/Oo9XcyfpE1K5vJBwS96YJzGxxJCMTHXrVG5H1MzmkhKtydVrUfU
         smPQdARs8jZTZqSePNQEnQvxl6wGzW1osC+MhByUxo8v4/IBSfj4nAHEp+XDvrAl8L5e
         NiMMlaDVWwnTcDerNCowbSO248TYf/0mOcjw8qA4TJMz9ONlFwV/4I4oWx74ailAL502
         6bbw==
Content-Disposition: inline
In-Reply-To: <CAO2SnQ-fEXH3xpAV3x61h1ewp8j8EYGPQTuhviE6=4Z2=KHvcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Garcia <john.garcia-+FQPb40bacfW/loQ7rKezA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed, Jul 13, 2016 at 01:10:05PM -0700, John Garcia wrote:
> Hi Tejun, thanks for the response!
> 
> It sounds like everything is good then, is it likely this will get
> backported to the next LTS 4.4 kernel?

Yeah, it should.

Thanks!

-- 
tejun
