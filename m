From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: make the blkcg and blkcg structures private
Date: Fri, 22 Apr 2022 06:23:18 +0200
Message-ID: <20220422042318.GA9977@lst.de>
References: <20220420042723.1010598-1-hch@lst.de> <YmHQS1pyIglK+gfS@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YmHQS1pyIglK+gfS-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 21, 2022 at 11:44:43AM -1000, Tejun Heo wrote:
> The patches look all good to me and I'm not against making things more
> private but can you elaborate on the rationale a bit more? By and large, we
> have never been shy about putting things in the headers if there's *any*
> (perceived) gain to be made from doing so, or even just as a way to pick the
> locations for different things - type defs go on header and so on. Most of
> the inlines and [un]likely's that we have are rather silly with modern
> compilers with global optimizations, so it does make sense to get tidier,
> but if that's the rationale, mentioning that in the commit message, even
> briefly, would be great - ie. it should explain the benefits of adding these
> few accessors to keep the definition private.

Mostly to help me understand the code :)  between all the moving to
and from the css struture it is a bit of a mess, and limiting the scope
that deals with the structures greatly helps with that.
