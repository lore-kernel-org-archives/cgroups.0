From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: make the blkcg and blkcg structures private
Date: Fri, 22 Apr 2022 05:42:31 -1000
Message-ID: <YmLM5/1+VH5mdQ/o@slm.duckdns.org>
References: <20220420042723.1010598-1-hch@lst.de>
 <YmHQS1pyIglK+gfS@slm.duckdns.org>
 <20220422042318.GA9977@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/2bXBH57zZDvmeIOYDk/m7NyaBAKN+vWWjfrVhEZ7T4=;
        b=XYZOLh+Jv2kL2sx884zx4C5eFWyZUuKY38ML9XvAYhNcR9BREu4ndvKecAC8kiH8Wl
         2v8yd4kPP2gu4bBvSJJYHpMRWaZdWMCPawASUwvIYLt/36hDOsoQF6/PRGnoA/fP3+Iy
         OdYf/Am/17PxHTlnZSv3KbSRM9TsczBeb1wQS6jyeQwBOuRzRhaolF58FR4l9A1SPpSs
         HkM3GxADfbMO/Zvs8ImLLAeCMjyTOUQSJdFg27FdWbQ+EuDUKbiREIqdpGpAdH81y42c
         dVVAZmsCS7qchIwgGY0c3HnDxcg2FfvolA13AyZ8voskHxh/DdCWa9uIdpnjrvxytLup
         fQpg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220422042318.GA9977-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

On Fri, Apr 22, 2022 at 06:23:18AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 21, 2022 at 11:44:43AM -1000, Tejun Heo wrote:
> > The patches look all good to me and I'm not against making things more
> > private but can you elaborate on the rationale a bit more? By and large, we
> > have never been shy about putting things in the headers if there's *any*
> > (perceived) gain to be made from doing so, or even just as a way to pick the
> > locations for different things - type defs go on header and so on. Most of
> > the inlines and [un]likely's that we have are rather silly with modern
> > compilers with global optimizations, so it does make sense to get tidier,
> > but if that's the rationale, mentioning that in the commit message, even
> > briefly, would be great - ie. it should explain the benefits of adding these
> > few accessors to keep the definition private.
> 
> Mostly to help me understand the code :)  between all the moving to
> and from the css struture it is a bit of a mess, and limiting the scope
> that deals with the structures greatly helps with that.

Hahaha, yeah, fair enough. I don't see a reason to not apply the patchset
given that the code is better organized and easier to follow afterewards.
For the series,

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
