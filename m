From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: fix the comment format for recently added
 functions
Date: Sun, 4 May 2014 15:19:41 -0400
Message-ID: <20140504191941.GC26279@htj.dyndns.org>
References: <20140424193321.GS29214@redhat.com>
 <20140502153028.GG10204@htj.dyndns.org>
 <20140502154959.GH29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+qroNQSV2318rDXaJbtXWRPHf0npV9zI0MEzyrwTlEM=;
        b=EIFVqz+dEinKb3DP62eywYfiRVoi++qDgUp6T0MSKM86T4o6llsB7oiD72bJXuhoru
         QKoBwObecAnv8xagFO5vOIaGLkugoWQCwfKKqaCw9nqM/lQk+xc4/SqeoE68RO7KtBd2
         lHUg/xVrvlkeWeAcb/fBaZ/5YVCRrrmXEa/KNWCcD9y4CrQ4il/N8WtFlldp/FJsqWez
         RYfzKOaYFYFa41pCbUghefoUk/IBm6F80ntpLojsfndjnVK39TIMjKYxj5lNF7BwcrEk
         DYXKrTjTEpPAEbr9aKmpf3pOzv0eYcF1DFkvTaHM12DV6q4jvfqCMCvksCVP1CuHn0Nk
         1MoA==
Content-Disposition: inline
In-Reply-To: <20140502154959.GH29214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Fri, May 02, 2014 at 11:49:59AM -0400, Aristeu Rozanski wrote:
> > Can you just merge "Return: " section into the paragraph?  Just go
> > "Returns true blah blah".
> 
> That goes against Documentation/kernel-doc-nano-HOWTO.txt.

Hah, I haven't seen many "Return:" descriptions in the kernel.  Ah
well...

Thanks.

-- 
tejun
