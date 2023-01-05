From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Thu, 5 Jan 2023 20:22:47 +0100
Message-ID: <20230105192247.GB16920@blackbody.suse.cz>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <Y7cKf7IH+FJ/6IyV@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672946568; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mg38u8VDBZl2kUeOIq51W5k4gswYU2BaFcdprzVD4ho=;
        b=Pl5Grl6tSEVdgCpRGyl9PaXajNlIjlsYnWLjdUuBJ9XyAdWiXq6MEejzoZsxIUDGG6j+fT
        lc67hk77bkVQlX0KMffLrClAfSEboithD4tgcYWrNKrRvGSfxo21bcE0CZXZWhS7vnheSM
        E7b9KRVkcC/0SIePI5VNChHJAIe2xCE=
Content-Disposition: inline
In-Reply-To: <Y7cKf7IH+FJ/6IyV-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2023 at 07:35:59AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hard limits tend to make this sort of problems a lot more pronounced because
> the existing mechanisms tend to break down for the users which are severely
> throttled down even while the device as a whole is fairly idle. cpu.max
> often triggers severe priority inversions too, so it isn't too surprising
> that people hit severe priority inversion issues w/ io.max.

To be on the same page:
1) severe PI == priority inversion across cgroups (progated e.g. via
   global locks (as with cpu.max) or FS journal (as with io.max)),
2) ordinary PI == priority inversion contained within a single cgroup,
   i.e. no different from an under-provisioned system.

The reported issue sounds like 2) but even with the separated queues 1)
is still possible :-/

> Another problem with blk-throttle is that it doesn't prioritize shared IOs
> identified by bio_issue_as_root_blkg() like iolatency and iocost do, so
> there can be very severe priority inversions when e.g. journal commit gets
> trapped in a low priority cgroup further exacerbating issues like this.

Thanks for the broader view. So the separated queues are certainly an
improvement but ultimately a mechanism based on bio_issue_as_root_blkg()
predicate and deferred throttling would be better? Or is permanent limit
enforcement more important?

Thanks,
Michal

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY7cjfQAKCRAkDQmsBEOq
uXQsAP99LZP7f/n8ygASlLevHgj9Zm/D5kI8jlxOD2LanjzNzQD+JY4fvNFnGQmI
edy1iZb/lxGcHMME7EZPqkuZJbXbcw4=
=w2/G
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
