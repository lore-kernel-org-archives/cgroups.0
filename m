From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: make the blkcg and blkcg structures private
Date: Thu, 21 Apr 2022 11:44:43 -1000
Message-ID: <YmHQS1pyIglK+gfS@slm.duckdns.org>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GIkmPRn6aXIFTLXMDEzU8Z7cPf9kdXdPCyaOczwE6x0=;
        b=Y+ot/N7E3NqtwNRkxxSQvG8RLexpxttLfKY4X2H753dGZgDytqswn3fJSKyb3cJFbH
         li+mL9j7bJx2hlPee+M4Olu2UZNUV2GxkQAjVde+z8e/75fQjDwi9Fnvqbrk3yHU/RBZ
         9NE7UFSIwy6xkhNy7ODaqcifxQ58kzt+nyKjzpBJ2xVhIXHf8KY3VVOt4PiYl+cSzeKY
         Nu0bQZioVPXHgcvVihXVQDPHhnx9ZdX1+d0UPvh5V2OMKUv0qIIc9T9OoQcyq78QovKw
         z43U2HpqbNvSPKATYbDIhMdIrOfXUdMI4W5mQynu/1WEcGaLs4vVOgTTz5l8xUcx1a32
         Vrtw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220420042723.1010598-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello,

On Wed, Apr 20, 2022 at 06:27:08AM +0200, Christoph Hellwig wrote:
> this series cleans up various lose end in the blk-cgroup code to make it
> easier to follow in preparation of reworking the blkcg assignment for
> bios.  The biggest change is that most of <linux/blk-cgroup.h> is now
> taken private into block/.

The patches look all good to me and I'm not against making things more
private but can you elaborate on the rationale a bit more? By and large, we
have never been shy about putting things in the headers if there's *any*
(perceived) gain to be made from doing so, or even just as a way to pick the
locations for different things - type defs go on header and so on. Most of
the inlines and [un]likely's that we have are rather silly with modern
compilers with global optimizations, so it does make sense to get tidier,
but if that's the rationale, mentioning that in the commit message, even
briefly, would be great - ie. it should explain the benefits of adding these
few accessors to keep the definition private.

Thanks.

-- 
tejun
